//
//  DecomposedDate.swift
//  BrandsInTown
//
//  Created by Mikhail Lyapich on 7/18/17.
//  Copyright © 2017 Mikhail Lyapich. All rights reserved.
//

import Foundation
import UIKit

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
        let dayOfWeek = NSMutableAttributedString(string: self.dayOfWeek,attributes: [NSFontAttributeName: UIFont.smallDateFont(),
                                                                                      NSParagraphStyleAttributeName: paragraph,
                                                                                      NSForegroundColorAttributeName: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)])
        
        let dayOfMonth = NSMutableAttributedString(string: self.dayOfMonth, attributes: [NSFontAttributeName: UIFont.mediumDateFont(),
                                                                                         NSParagraphStyleAttributeName: paragraph,
                                                                                         NSForegroundColorAttributeName: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            ])
        
        let month = NSMutableAttributedString(string: self.month, attributes: [NSFontAttributeName: UIFont.smallDateFont(),
                                                                               NSParagraphStyleAttributeName: paragraph,
                                                                               NSForegroundColorAttributeName: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)])
        let dateRepresentation = NSMutableAttributedString()
        dateRepresentation.append(dayOfWeek)
        dateRepresentation.append(dayOfMonth)
        dateRepresentation.append(month)
        return dateRepresentation
    }
}
