//
//  ViewController.swift
//  BrandsInTown
//
//  Created by Mikhail Lyapich on 7/15/17.
//  Copyright © 2017 Mikhail Lyapich. All rights reserved.
//

import UIKit

extension String {
    var isBlank: Bool {
        return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

class SearchViewController: UIViewController {

    @IBOutlet var spinner: UIActivityIndicatorView!
    
    let dataProvider = DataProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createSearchBar()
    }
    
    private func createSearchBar() {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Search for artists"
        navigationItem.titleView = searchBar
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isBlank else { return }
        UIView.animate(withDuration: 0.5) {
            searchBar.resignFirstResponder()
        }
        spinner.startAnimating()
        dataProvider.getArtist(withName: text) { artist in
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
            }
            guard let artist = artist else { return }
            
        }
    }
}

