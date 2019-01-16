//
//  Category.swift
//  ChuckN
//
//  Created by Konstantin Tsistjakov on 16/01/2019.
//  Copyright © 2019 Chipp Studio. All rights reserved.
//

import UIKit
import RealmSwift

class Category: Object {
    @objc dynamic var title = ""
    
    override static func primaryKey() -> String? {
        return "title"
    }
    
    var favorites: Int {
        get {
            let facts = try! Realm().objects(Fact.self).filter("category=%@ and isFavorite=%@", self.title, true)
            return facts.count
        }
    }
}
