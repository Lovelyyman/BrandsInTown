//
//  Venue.swift
//  BrandsInTown
//
//  Created by Mikhail Lyapich on 7/15/17.
//  Copyright © 2017 Mikhail Lyapich. All rights reserved.
//

import Foundation
import Gloss

struct Venue: Decodable {
    let name: String?
    let city: String?
    let region: String?
    let country: String?
    
    init?(json: JSON) {
        name = "name" <~~ json
        city = "city" <~~ json
        region = "region" <~~ json
        country = "country" <~~ json
    }
    
    init(venueModel: VenueModel) {
        name = venueModel.name
        country = venueModel.country
        city = venueModel.country
        region = nil
    }
}
