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

extension DateFormatter {
    static func BrandsInTownDateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd-HH:mm:ss"
        return formatter
    }
}

struct DecomposedDate {
    let month: String
    let dayOfMonth: String
    let dayOfWeek: String
    
    func representation() -> NSMutableAttributedString {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        paragraph.lineSpacing = 0
        let dayOfWeek = NSMutableAttributedString(string: self.dayOfWeek,attributes: [NSFontAttributeName: UIFont(name: "AvenirNext-HeavyItalic", size: 12),
                                                                                      NSParagraphStyleAttributeName: paragraph,
                                                                                      NSForegroundColorAttributeName: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)])
        
        let dayOfMonth = NSMutableAttributedString(string: self.dayOfMonth, attributes: [NSFontAttributeName: UIFont(name: "AvenirNext-HeavyItalic", size: 15),
                                                                                         NSParagraphStyleAttributeName: paragraph,
                                                                                         NSForegroundColorAttributeName: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
                                                                                         ])
        
        let month = NSMutableAttributedString(string: self.month, attributes: [NSFontAttributeName: UIFont(name: "AvenirNext-HeavyItalic", size: 12),
                                                                               NSParagraphStyleAttributeName: paragraph,
                                                                               NSForegroundColorAttributeName: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)])
        let dateRepresentation = NSMutableAttributedString()
        dateRepresentation.append(dayOfWeek)
        dateRepresentation.append(dayOfMonth)
        dateRepresentation.append(month)
        return dateRepresentation
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
