//
//  Event.swift
//  BrandsInTown
//
//  Created by Mikhail Lyapich on 7/15/17.
//  Copyright © 2017 Mikhail Lyapich. All rights reserved.
//

import Foundation
import Gloss

struct Event: Decodable {
    let id: String
    let artistID: String
    let dateTime: String?
    let venue: Venue?
    
    init?(json: JSON) {
        guard let id: String = "id" <~~ json, let artistID: String = "artist_id" <~~ json else { return nil }
        self.id = id
        self.artistID = artistID
        dateTime = "datetime" <~~ json
        venue = "venue" <~~ json
    }
}
