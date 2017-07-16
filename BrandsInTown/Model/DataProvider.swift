//
//  DataProvider.swift
//  BrandsInTown
//
//  Created by Mikhail Lyapich on 7/15/17.
//  Copyright © 2017 Mikhail Lyapich. All rights reserved.
//

import Foundation
import UIKit

class DataProvider {
    private let fetcher = BrandsInTownFetcher()
    
    func getArtist(withName name: String, completion: @escaping (Artist?) -> ()) {
        fetcher.fetchArtist(withName: name, completion: completion)
    }
    
    func getEvents(for artist: Artist, completion: @escaping ([Event]?) -> ()) {
        guard let name = artist.name else {
            completion(nil)
            return
        }
        fetcher.fetchEvents(forArtistName: name, completion: completion)
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
}
