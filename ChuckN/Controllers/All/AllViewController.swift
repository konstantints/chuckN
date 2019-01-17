//
//  AllViewController.swift
//  ChuckN
//
//  Created by Konstantin Tsistjakov on 17/01/2019.
//  Copyright © 2019 Chipp Studio. All rights reserved.
//

import UIKit
import RealmSwift
import SafariServices

class AllViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UIViewControllerPreviewingDelegate {
    
    // MARK: - UI
    @IBOutlet weak var tableView: UITableView!
    var searchController: UISearchController!
    
    // MARK: - Private Variables
    private let factCell = "factCell"
    private var facts: Results<Fact>!
    private var searchText = ""
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation items
        self.navigationItem.title = Localizations.General.all
        self.navigationItem.largeTitleDisplayMode = .automatic
        
        // Set search controller
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.navigationItem.searchController = self.searchController
        
        // Load initial facts
        self.facts = try! Realm().objects(Fact.self)
        
        // Force Touch
        if self.traitCollection.forceTouchCapability == .available {
            self.registerForPreviewing(with: self, sourceView: self.tableView)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateAppearance(animated: false)
    }
    
    override func updateAppearance(animated: Bool) {
        super.updateAppearance(animated: animated)
        
        let duration: TimeInterval = animated ? 0.2 : 0
        UIView.animate(withDuration: duration) {
            //set NavigationBar
            self.navigationController?.view.backgroundColor = UIColor.background
            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.tintColor = UIColor.main
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.title]
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.title]
            
            // Set search controller
            self.searchController.searchBar.tintColor = UIColor.title
            
            // Backgrounds
            self.view.backgroundColor = UIColor.background
            
            // TableView
            self.tableView.backgroundColor = UIColor.background
            self.tableView.reloadData()
        }
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.facts.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.facts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: factCell, for: indexPath) as! AllFatcTableViewCell
        
        // Style cell
        cell.backgroundColor = UIColor.background
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.title
        selectedView.alpha = 0.5
        
        cell.selectedBackgroundView = selectedView
        
        let valueString = NSMutableAttributedString(string: item.value, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body), NSAttributedString.Key.foregroundColor: UIColor.text])
        let categoryString = NSMutableAttributedString(string: item.category, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1), NSAttributedString.Key.foregroundColor: UIColor.main])
        
        if !self.searchText.isEmpty {
            valueString.addAttributes([NSAttributedString.Key.backgroundColor: UIColor.title], range: (item.value as NSString).range(of: self.searchText))
            categoryString.addAttributes([NSAttributedString.Key.backgroundColor: UIColor.title], range: (item.category as NSString).range(of: self.searchText))
        }
        cell.valueLabel.attributedText = valueString
        cell.categoryLabel.attributedText = categoryString
        
        if item.isFavorite {
            cell.favoriteMark.image = Images.favorite.image
        } else {
            cell.favoriteMark.image = nil
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item: Fact = self.facts[indexPath.row]
        
        try! Realm().write {
            item.isFavorite = !item.isFavorite
        }
        
        let cell = self.tableView.cellForRow(at: indexPath) as! AllFatcTableViewCell
        if item.isFavorite {
            cell.favoriteMark.image = Images.favorite.image
        } else {
            cell.favoriteMark.image = nil
        }
    }
    
    // MARK: - UIViewControllerPreviewingDelegate
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = self.tableView.indexPathForRow(at: location) else {
            return nil
        }
        
        let item = self.facts[indexPath.row]
        let safari = SFSafariViewController(url: URL(string: item.url)!)
        return safari
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        self.present(viewControllerToCommit, animated: false, completion: nil)
    }
    
    // MARK: - UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            self.searchText = searchText
            if searchText.isEmpty {
                self.facts = try! Realm().objects(Fact.self)
                self.tableView.reloadData()
                return
            }
            
            self.facts = try! Realm().objects(Fact.self).filter("(value CONTAINS %@) OR (category CONTAINS %@)", searchText, searchText)
            self.tableView.reloadData()
        } else {
            self.facts = try! Realm().objects(Fact.self)
            self.tableView.reloadData()
        }
    }
}
