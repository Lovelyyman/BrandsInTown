//
//  EventTableViewCell.swift
//  BrandsInTown
//
//  Created by Mikhail Lyapich on 7/15/17.
//  Copyright © 2017 Mikhail Lyapich. All rights reserved.
//

import Foundation
import UIKit

class EventTableViewCell: UITableViewCell {
    
    @IBOutlet var eventDate: UILabel!
    @IBOutlet var eventVenueName: UILabel!
    @IBOutlet var eventPlace: UILabel!
    
    func configure(withEvent event: Event) {
        self.eventDate.text = event.dateTime
        self.eventVenueName.text = event.venue?.name
        let place = [event.venue?.city, event.venue?.country].flatMap { $0 }.joined(separator: ", ")
        self.eventPlace.text = place
    }
}
