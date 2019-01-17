//
//  Network.swift
//  ChuckN
//
//  Created by Konstantin Tsistjakov on 16/01/2019.
//  Copyright © 2019 Chipp Studio. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift

class Network: NSObject {
    
    // MARK: - Init
    override init() {
        super.init()
        self.getAllCategories(completion: nil)
    }
    
    // MARK: - Public Actions
    func getAllCategories(completion: (() -> Void)?) {
        Alamofire.request("https://api.chucknorris.io/jokes/categories").responseJSON { (response) in
            if response.result.error != nil {
                print("GET Categories - \(response.result.error!.localizedDescription)")
                return
            }
            
            let json = JSON(response.result.value!)
            
            // Cache all categories
            try! Realm().write {
                for (_, c) in json {
                    let category = Category()
                    category.title = c.stringValue
                    try Realm().add(category, update: true)
                }
            }
        }
    }
    
    func getFactIn(_ category: String, completion: ((_ fact: Fact) -> Void)?) {
        
        let params = ["category": category]
        
        Alamofire.request("https://api.chucknorris.io/jokes/random", method: .get, parameters: params).responseJSON { (response) in
            if response.result.error != nil {
                print("GET Categories - \(response.result.error!.localizedDescription)")
                return
            }
            
            let json = JSON(response.result.value!)
            
            // Cache result in database
            let fact = Fact()
            fact.id = json["id"].stringValue
            fact.url = json["url"].stringValue
            fact.value = json["value"].stringValue
            if let categoryArray = json["category"].arrayObject?.first {
                if let categoryString = categoryArray as? String {
                    fact.category = categoryString
                }
            }
            
            try! Realm().write {
                try Realm().add(fact, update: true)
            }
            
            completion?(fact)
        }
    }
}
