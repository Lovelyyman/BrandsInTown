//
//  ArtistTableViewCell.swift
//  BrandsInTown
//
//  Created by Mikhail Lyapich on 7/15/17.
//  Copyright © 2017 Mikhail Lyapich. All rights reserved.
//

import Foundation
import UIKit

class ArtistTableViewCell: UITableViewCell {

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= 0 {
            containerView.clipsToBounds = true
            topConstraint.constant = scrollView.contentOffset.y / 2
            bottomConstraint.constant = -scrollView.contentOffset.y / 2
        } else {
            topConstraint.constant = scrollView.contentOffset.y
            containerView.clipsToBounds = false
        }
    }
    
}
