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
    private let numberOfSections = 2
    private let eventCellHeight: CGFloat = 60
    private let artistCellHeight: CGFloat = 250
    private let artistCellCount = 1
    var artist: Artist?
    var image: UIImage?
    var events: [Event] = [Event]() {
        didSet {
            let eventsSectionIndex = IndexSet(integer: Section.events.rawValue)
            tableView.reloadSections(eventsSectionIndex, with: .automatic)
        }
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func closeViewController() {
        dismiss(animated: true)
    }
    
    func configure(withArtist artist: Artist, dataProvider: DataProvider) {
        self.artist = artist
        dataProvider.getEvents(for: artist) { events in
            guard let events = events else { return }
            DispatchQueue.main.async { self.events = events }
        }
        
        dataProvider.getImage(for: artist) { image in
            DispatchQueue.main.async {
                let artistCell = self.tableView.cellForRow(at: IndexPath(item: 0, section: Section.artist.rawValue)) as? ArtistTableViewCell
                artistCell?.artistImage.image = image
                self.image = image
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == Section.artist.rawValue ? artistCellCount : events.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == Section.artist.rawValue, let artist = artist {
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
        return indexPath.section == Section.artist.rawValue ? UITableViewAutomaticDimension : eventCellHeight
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == Section.artist.rawValue ? artistCellHeight : eventCellHeight
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let firstCell = tableView.cellForRow(at: IndexPath(item: 0, section: Section.artist.rawValue))
        guard let artistCell = firstCell as? ArtistTableViewCell else { return }
        artistCell.scrollViewDidScroll(scrollView)
    }
}
