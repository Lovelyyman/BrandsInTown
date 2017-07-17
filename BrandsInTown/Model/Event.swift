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
    let dateTime: String?
    let venue: Venue?
    
    init?(json: JSON) {
        dateTime = "datetime" <~~ json
        venue = "venue" <~~ json
    }
    
    init?(eventModel: EventModel) {
        dateTime = eventModel.date
        if let venueModel = eventModel.venue {
            venue = Venue(venueModel: venueModel)
        } else {
            venue = nil
        }
    }
}
