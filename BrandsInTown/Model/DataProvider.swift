//
//  DataProvider.swift
//  BrandsInTown
//
//  Created by Mikhail Lyapich on 7/15/17.
//  Copyright © 2017 Mikhail Lyapich. All rights reserved.
//

import Foundation

class DataProvider {
    private let fetcher = BrandsInTownFetcher()
    
    func getArtist(withName name: String, completion: @escaping (Artist?) -> ()) {
        fetcher.fetchArtist(withName: name, completion: completion)
    }
    
    func getEvents(forArtistName name: String, completion: @escaping ([Event]) -> ()) {
        fetcher.fetchEvents(forArtistName: name, completion: completion)
    }
}
