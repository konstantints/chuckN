//
//  Fact.swift
//  ChuckN
//
//  Created by Konstantin Tsistjakov on 16/01/2019.
//  Copyright © 2019 Chipp Studio. All rights reserved.
//

import UIKit
import RealmSwift

class Fact: Object {
    @objc dynamic var id = ""
    @objc dynamic var category = ""
    @objc dynamic var url = ""
    @objc dynamic var value = ""
    
    @objc dynamic var isFavorite: Bool = false
    @objc dynamic var created: Date = Date()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
