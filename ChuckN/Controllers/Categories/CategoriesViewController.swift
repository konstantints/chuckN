//
//  CategoriesViewController.swift
//  ChuckN
//
//  Created by Konstantin Tsistjakov on 16/01/2019.
//  Copyright © 2019 Chipp Studio. All rights reserved.
//

import UIKit
import RealmSwift

class CategoriesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - UI
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variables
    var categories: Results<Category>!
    
    // MARK: - Private Variables
    private let categoryCell = "categoryCell"
    private var categoriesToken: NotificationToken!
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation items
        self.navigationItem.title = Localizations.General.categories
        self.navigationItem.largeTitleDisplayMode = .automatic
        
        // Get all categories
        self.categories = try! Realm().objects(Category.self).sorted(byKeyPath: "title")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateAppearance(animated: false)
        self.categoriesToken = self.categories.observe({ (c) in
            switch c {
            case .initial(_): ()
            case .update(_, deletions: _, insertions: _, modifications: _):
                self.tableView.reloadData()
            case .error(_):()
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.categoriesToken.invalidate()
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
            
            // Backgrounds
            self.view.backgroundColor = UIColor.background
            
            // TableView
            self.tableView.backgroundColor = UIColor.background
            self.tableView.reloadData()
        }
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return self.categories.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: categoryCell, for: indexPath)
        // Style cell
        cell.backgroundColor = UIColor.background
        cell.textLabel?.textColor = UIColor.text
        cell.detailTextLabel?.textColor = UIColor.main
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.title
        selectedView.alpha = 0.5
        
        cell.selectedBackgroundView = selectedView
        
        if indexPath.section == 0 {
            cell.textLabel?.text = Localizations.General.all
            cell.detailTextLabel?.text = nil
            
            return cell
        }
        
        // Set information on cell
        cell.textLabel?.text = self.categories[indexPath.row].title.capitalized
        cell.detailTextLabel?.text = "\(self.categories[indexPath.row].favorites)"
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            let controller = UIStoryboard(name: Storyboards.all.rawValue, bundle: nil).instantiateInitialViewController()!
            self.navigationController?.pushViewController(controller, animated: true)
        } else {
            let controller = UIStoryboard(name: Storyboards.facts.rawValue, bundle: nil).instantiateInitialViewController() as! FactsViewController
            controller.category = self.categories[indexPath.row]
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
