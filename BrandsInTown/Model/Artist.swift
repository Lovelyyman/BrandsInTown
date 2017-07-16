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
    let id: String
    let name: String?
    let url: String?
    let imageURL: String?
    let thumbURL: String?
    let facebookPageURL: String?
    
    init?(json: JSON) {
        guard let id: String = "name" <~~ json else { return nil }
        self.id = id
        name = "name" <~~ json
        url = "url" <~~ json
        imageURL = "image_url" <~~ json
        thumbURL = "thumb_url" <~~ json
        facebookPageURL = "facebook_page_url" <~~ json
    }
}
