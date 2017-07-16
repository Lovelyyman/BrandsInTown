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
    @IBOutlet var artistName: UILabel!
    @IBOutlet var artistDates: UILabel!
    @IBOutlet var artistImage: UIImageView!
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= 0 {
            containerView.clipsToBounds = true
            topConstraint.constant = scrollView.contentOffset.y / 2
            bottomConstraint.constant = -scrollView.contentOffset.y / 2
        } else {
            containerView.clipsToBounds = false
            topConstraint.constant = scrollView.contentOffset.y
        }
    }
    
    func configure(withArtist artist: Artist) {      
        artistName.text = artist.name
        if let upcomingEventCount = artist.upcomingEventCount {
            artistDates.text = ("\(upcomingEventCount)")
        }
    }
}
