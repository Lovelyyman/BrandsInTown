//
//  ArtistsFetcher.swift
//  BrandsInTown
//
//  Created by Mikhail Lyapich on 7/15/17.
//  Copyright © 2017 Mikhail Lyapich. All rights reserved.
//
import Foundation
import Alamofire
import Alamofire_Gloss
import Gloss

class BrandsInTownFetcher {
    
    private struct URLs {
        static let baseURL = URL(string: "https://rest.bandsintown.com/")!
        static let artistsURL = baseURL.appendingPathComponent("artists")
    }
    private let query = Parameters(dictionaryLiteral: ("app_id", "lovelyyman"))
    
    func fetchArtist(withName name: String, completion: @escaping (Artist?) -> ()) {
        let specificArtistURL = URLs.artistsURL.appendingPathComponent(name)
        Alamofire.request(specificArtistURL, parameters: query).responseJSON { response in
            switch response.result {
            case .success(let value):
                completion(Artist(json: value as! JSON))
            case .failure(let error):
                print(error)
                completion(nil)
            }
        }
    }
    
    func fetchEvents(forArtistName name: String, completion: @escaping ([Event]) -> ()) {
        let eventsURL = URLs.artistsURL.appendingPathComponent(name).appendingPathComponent("events")
        Alamofire.request(eventsURL, parameters: query).responseArray(Event.self) { response in
            switch response.result {
            case .success(let value):
                completion(value)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchImageData(forURL imageURL: URL, completion: @escaping (Data?) -> ()) {
        Alamofire.request(imageURL).responseData { response in
            completion(response.result.value)
        }
    }
}
