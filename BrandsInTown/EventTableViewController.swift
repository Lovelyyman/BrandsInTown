//
//  EventTableViewController.swift
//  BrandsInTown
//
//  Created by Mikhail Lyapich on 7/15/17.
//  Copyright © 2017 Mikhail Lyapich. All rights reserved.
//

import Foundation
import UIKit

enum Section: Int {
    case artist = 0
    case events = 1
}

class EventTableViewController: UITableViewController {
    let numberOfSections = 2
    var artist: Artist!
    var events: [Event] = [Event]() {
        didSet {
            let eventsSectionIndex = IndexSet(integer: Section.events.rawValue)
            tableView.reloadSections(eventsSectionIndex, with: .automatic)
        }
    }
    var image: UIImage?
    
    func configure(withArtist artist: Artist, dataProvider: DataProvider) {
        self.artist = artist
        dataProvider.getEvents(for: artist) { events in
            guard let events = events else { return }
            DispatchQueue.main.async { self.events = events }
        }
        
        dataProvider.getImage(for: artist) { image in
            DispatchQueue.main.async {
                let artistCell = self.tableView.cellForRow(at: IndexPath(item: 0, section: 0)) as? ArtistTableViewCell
                artistCell?.artistImage.image = image
                self.image = image
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == Section.artist.rawValue ? 1 : events.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == Section.artist.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistTableViewCell", for: indexPath) as! ArtistTableViewCell
            cell.configure(withArtist: artist)
            cell.artistImage.image = image
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventTableViewCell") as! EventTableViewCell
            cell.configure(withEvent: events[indexPath.row])
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return indexPath.section == Section.artist.rawValue ? UITableViewAutomaticDimension : 50
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == Section.artist.rawValue ? 250 : 50
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let firstCell = tableView.cellForRow(at: IndexPath(item: 0, section: 0))
        guard let artistCell = firstCell as? ArtistTableViewCell else { return }
        artistCell.scrollViewDidScroll(scrollView)
    }
}
