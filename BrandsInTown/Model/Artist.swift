//
//  Artist.swift
//  BrandsInTown
//
//  Created by Mikhail Lyapich on 7/15/17.
//  Copyright © 2017 Mikhail Lyapich. All rights reserved.
//

import Foundation
import Gloss

struct Artist: Decodable {
    let name: String
//    let url: String?
    let imageURL: String?
//    let thumbURL: String?
//    let facebookPageURL: String?
    let upcomingEventCount: Int
    
    init?(json: JSON) {
        guard let name: String = "name" <~~ json else { return nil }
        self.name = name
//        url = "url" <~~ json
        imageURL = "image_url" <~~ json
//        thumbURL = "thumb_url" <~~ json
//        facebookPageURL = "facebook_page_url" <~~ json
        upcomingEventCount = ("upcoming_event_count" <~~ json) ?? 0
    }
    
    init?(model: ArtistModel?) {
        guard let artistModel = model else { return nil }
        name = artistModel.name ?? ""
        upcomingEventCount = Int(artistModel.upcomingEventCount)
        imageURL = nil
    }
}
