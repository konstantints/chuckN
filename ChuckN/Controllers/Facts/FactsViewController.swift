//
//  FactsViewController.swift
//  ChuckN
//
//  Created by Konstantin Tsistjakov on 16/01/2019.
//  Copyright © 2019 Chipp Studio. All rights reserved.
//

import UIKit
import RealmSwift
import SafariServices

class FactsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIViewControllerPreviewingDelegate {

    // MARK: - UI
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variables
    var category: Category!
    
    // MARK: - Private Variables
    private var factsToShow = [Fact]() {
        didSet {
            self.tableView.reloadSections([0], with: .automatic)
        }
    }
    private var needFactsToShow = 3
    private var tempFactsToShow = [Fact]()
    private var allFacts: Results<Fact>!
    private let factCell = "factCell"
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = Localizations.General.facts(self.category.title)
        
        // Set facts
        let network = (UIApplication.shared.delegate as! AppDelegate).network!
        
        // Get new three facts from source
        for _ in 0..<needFactsToShow {
            network.getFactIn(self.category.title) { (fact) in
                self.setNewFacts(fact: fact)
            }
        }
        
        // Set three unique facts from cache
        self.allFacts = try! Realm().objects(Fact.self).filter("category=%@", self.category.title)
        if self.allFacts.count >= needFactsToShow {
            while self.factsToShow.count < needFactsToShow {
                let item = self.allFacts[self.allFacts.count.random]
                if !self.factsToShow.contains(item) {
                    self.factsToShow.append(item)
                }
            }
        }
        
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
            
            // Backgrounds
            self.view.backgroundColor = UIColor.background
            
            // TableView
            self.tableView.reloadData()
            self.tableView.backgroundColor = UIColor.background
        }
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.factsToShow.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item: Fact = self.factsToShow[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: factCell, for: indexPath) as! FactTableViewCell
        
        // Style cell
        cell.backgroundColor = UIColor.background
        cell.valueLabel?.textColor = UIColor.text
        cell.categoryLabel?.textColor = UIColor.main
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.title
        selectedView.alpha = 0.5
        
        cell.selectedBackgroundView = selectedView
        
        cell.valueLabel.text = item.value
        cell.categoryLabel.text = item.category
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
        
        let item: Fact = self.factsToShow[indexPath.row]
        
        try! Realm().write {
            item.isFavorite = !item.isFavorite
        }
        
        let cell = self.tableView.cellForRow(at: indexPath) as! FactTableViewCell
        if item.isFavorite {
            cell.favoriteMark.image = Images.favorite.image
        } else {
            cell.favoriteMark.image = nil
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.factsToShow.count == 0 {
            return nil
        }
        
        return Localizations.General.new
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = UIColor.text
        header.textLabel!.font = UIFont.preferredFont(forTextStyle: .headline)
    }
    
    // MARK: - UIViewControllerPreviewingDelegate
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = self.tableView.indexPathForRow(at: location) else {
            return nil
        }
        
        let item = self.factsToShow[indexPath.row]
        let safari = SFSafariViewController(url: URL(string: item.url)!)
        return safari
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        self.present(viewControllerToCommit, animated: false, completion: nil)
    }
    
    // MARK: - Private Actions
    private func setNewFacts(fact: Fact) {
        if self.factsToShow.count < needFactsToShow {
            self.tempFactsToShow.append(fact)
            if self.tempFactsToShow.count == self.needFactsToShow {
                self.factsToShow = self.tempFactsToShow
            }
        }
    }
}
