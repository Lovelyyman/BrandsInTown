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

enum Storyboard: String {
    case main = "Main"
    
    var instance: UIStoryboard {
        return UIStoryboard(name: rawValue, bundle: nil)
    }
    
    func instanceOf<T: UIViewController>(viewController: T.Type, identifier viewControllerIdentifier: String? = nil) -> T? {
        if let identifier = viewControllerIdentifier {
            return instance.instantiateViewController(withIdentifier: identifier) as? T
        }
        return instance.instantiateInitialViewController() as? T
    }
}

class SearchViewController: UIViewController {

    @IBOutlet var spinner: UIActivityIndicatorView!
    @IBOutlet var searchBar: UISearchBar!
    let dataProvider = DataProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
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
                guard let artist = artist else { return }
                guard let controller = Storyboard.main.instanceOf(viewController: EventTableViewController.self, identifier: "EventTableViewController") else { return }
                controller.configure(withArtist: artist, dataProvider: self.dataProvider)
                self.present(controller, animated: true)
            }
        }
    }
}

