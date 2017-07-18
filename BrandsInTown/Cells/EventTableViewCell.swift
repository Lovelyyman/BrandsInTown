//
//  EventTableViewCell.swift
//  BrandsInTown
//
//  Created by Mikhail Lyapich on 7/15/17.
//  Copyright © 2017 Mikhail Lyapich. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func decompose(with formatter: DateFormatter) -> DecomposedDate? {
        guard let date = formatter.date(from: self) else { return nil }
        
        formatter.dateFormat = "MMM\n"
        let month = formatter.string(from: date)
        
        formatter.dateFormat = "dd\n"
        let dayOfMonth = formatter.string(from: date)
        
        formatter.dateFormat = "EEE\n"
        let dayOfWeek = formatter.string(from: date)
        return DecomposedDate(month: month, dayOfMonth: dayOfMonth, dayOfWeek: dayOfWeek)
    }
}

class EventTableViewCell: UITableViewCell {
    
    @IBOutlet var eventDate: UILabel!
    @IBOutlet var eventVenueName: UILabel!
    @IBOutlet var eventPlace: UILabel!
    
    private let placeSeparator = ", "
    
    func configure(withEvent event: Event) {
        self.eventVenueName.text = event.venue?.name
        let place = [event.venue?.city, event.venue?.country].flatMap { $0 }.joined(separator: placeSeparator)
        self.eventPlace.text = place
        
        if let dateText = event.dateTime {
            let dateFormatter = DateFormatter.BrandsInTownDateFormatter()
            // Date that come from server has symbol "T" that standart date formatter cannot handle, so we change it to "-"
            let decomposedDate = dateText.replacingOccurrences(of: "T", with: "-").decompose(with: dateFormatter)
            self.eventDate.attributedText = decomposedDate?.representation()
        }
    }
}
