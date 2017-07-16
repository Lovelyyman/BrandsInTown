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
            guard let artistModel = getArtistModelFromLocalStore(name: name) else {
                completion(nil)
                return
            }
            let artist = Artist(model: artistModel)
            completion(artist)
        }
    }
    
    func getEvents(for artist: Artist, completion: @escaping ([Event]?) -> ()) {
        fetcher.fetchEvents(forArtistName: artist.name, completion: completion)
    }
    
    func getImage(for artist: Artist, completion: @escaping (UIImage?) -> () ) {
        guard let urlString = artist.imageURL, let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        fetcher.fetchImageData(forURL: url) { data in
            guard let data = data else {
                completion(nil)
                return
            }
            completion(UIImage(data: data))
        }
    }
    
    private func save(artist: Artist?) {
        guard let artist = artist else { return }
        let artistModel = getArtistModelFromLocalStore(name: artist.name) ?? ArtistModel(context: managedContext)
        artistModel.fill(with: artist)
        do {
            try managedContext.save()
        } catch let error {
            print(error)
        }
    }
    
    private func getArtistModelFromLocalStore(name: String) -> ArtistModel? {
        let fetchRequest: NSFetchRequest<ArtistModel> = ArtistModel.fetchRequest()
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "name = %@", name)
        
        guard let models = try? managedContext.fetch(fetchRequest), let artistModel = models.first  else { return nil }
        return artistModel
    }
}

extension ArtistModel {
    func fill(with artist: Artist) {
        name = artist.name
        upcomingEventCount = Int64(artist.upcomingEventCount ?? 0)
    }
}
