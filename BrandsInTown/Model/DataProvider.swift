//
//  DataProvider.swift
//  BrandsInTown
//
//  Created by Mikhail Lyapich on 7/15/17.
//  Copyright © 2017 Mikhail Lyapich. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension ArtistModel {
    func fill(with artist: Artist) {
        name = artist.name
        upcomingEventCount = Int64(artist.upcomingEventCount)
    }
}

extension EventModel {
    func fill(with event: Event, artist: Artist) {
        artistName = artist.name
        date = event.dateTime
    }
}

extension VenueModel {
    func fill(with venue: Venue?) {
        city = venue?.city
        country = venue?.country
        name = venue?.name
    }
}

class DataProvider {
    private let fetcher = BrandsInTownFetcher()
    private let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func getArtist(withName name: String, completion: @escaping (Artist?) -> ()) {
        if ConnectivityChecker.isConnectedToNetwork() {
            fetcher.fetchArtist(withName: name) { artist in
                self.save(artist: artist)
                completion(artist)
            }
        } else {
            let artistModel = getArtistModelFromLocalStore(artistName: name)
            completion(Artist(model: artistModel))
        }
    }
    
    func getEvents(for artist: Artist, completion: @escaping ([Event]?) -> ()) {
        if ConnectivityChecker.isConnectedToNetwork() {
            fetcher.fetchEvents(forArtistName: artist.name) { events in
                self.replaceEvents(of: artist, with: events)
                completion(events)
            }
        } else {
            completion(eventsFromLocalStore(for: artist))
        }
    }
    
    
    func getImage(for artist: Artist, completion: @escaping (UIImage?) -> () ) {
        if ConnectivityChecker.isConnectedToNetwork() {
            guard let urlString = artist.imageURL, let url = URL(string: urlString) else {
                completion(nil)
                return
            }
            fetchImage(url: url, artist: artist, completion: completion)
        } else {
            completion(getImageFromLocalStore(for: artist))
        }
    }
    
    private func fetchImage(url: URL, artist: Artist, completion: @escaping (UIImage?) -> ()) {
        fetcher.fetchImageData(forURL: url) { data in
            guard let data = data else {
                completion(nil)
                return
            }
            self.save(imageData: data, to: artist)
            completion(UIImage(data: data))
        }
    }
    
    private func save(artist: Artist?) {
        guard let artist = artist else { return }
        let artistModel = getArtistModelFromLocalStore(artistName: artist.name) ?? ArtistModel(context: managedContext)
        artistModel.fill(with: artist)
        do {
            try managedContext.save()
        } catch let error {
            print(error)
        }
    }
    
    //MARK: All logic with database should go to separate class
    private func replaceEvents(of artist: Artist, with events: [Event]) {
        let artistModel = getArtistModelFromLocalStore(artistName: artist.name)
        clearEvents(of: artist)
        
        for event in events {
            let venueModel = VenueModel(context: managedContext)
            venueModel.fill(with: event.venue)
            let eventModel = EventModel(context: managedContext)
            eventModel.fill(with: event, artist: artist)
            eventModel.venue = venueModel
            artistModel?.addToEvents(eventModel)
        }
    }
    
    private func eventsFromLocalStore(for artist: Artist) -> [Event]? {
        let artistModel = getArtistModelFromLocalStore(artistName: artist.name)
        return artistModel?.events?.allObjects.lazy.flatMap { event in
            let eventModel = event as! EventModel
            return Event(eventModel: eventModel)
        }
    }
    
    private func clearEvents(of artist: Artist) {
        let predicate = NSPredicate(format: "artistName == %@", "\(artist.name)")
        
        let fetchRequest: NSFetchRequest<EventModel> = EventModel.fetchRequest()
        fetchRequest.predicate = predicate
        
        if let fetchedEntities = try? managedContext.fetch(fetchRequest) {
            for entity in fetchedEntities {
                managedContext.delete(entity)
            }
            try? managedContext.save()
        }
    }
    
    private func save(imageData: Data, to artist: Artist) {
        let artistModel = getArtistModelFromLocalStore(artistName: artist.name)
        artistModel?.image = imageData as NSData?
        try? managedContext.save()
    }
    
    private func getArtistModelFromLocalStore(artistName: String) -> ArtistModel? {
        let fetchRequest: NSFetchRequest<ArtistModel> = ArtistModel.fetchRequest()
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "name = %@", artistName)
        
        guard let models = try? managedContext.fetch(fetchRequest), let artistModel = models.first  else { return nil }
        return artistModel
    }
    
    private func getImageFromLocalStore(for artist: Artist) -> UIImage? {
        let artistModel = getArtistModelFromLocalStore(artistName: artist.name)
        guard let imageData = artistModel?.image else { return nil }
        return UIImage(data: imageData as Data)
    }
}
