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
    let latitude: Double?
    let longitude: Double?
    let city: String?
    let region: String?
    let country: String?
    
    init?(json: JSON) {
        name = "name" <~~ json
        latitude = "latitude" <~~ json
        longitude = "longitude" <~~ json
        city = "city" <~~ json
        region = "region" <~~ json
        country = "country" <~~ json
    }
}
