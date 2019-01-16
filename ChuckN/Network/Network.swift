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
        
        self.getAllCategories()
    }
    // MARK: - Private
    private func getAllCategories() {
        Alamofire.request("https://api.chucknorris.io/jokes/categories").responseJSON { (response) in
            if response.result.error != nil {
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
}
