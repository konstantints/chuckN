//
//  Extensions.swift
//  ChuckN
//
//  Created by Konstantin Tsistjakov on 17/01/2019.
//  Copyright © 2019 Chipp Studio. All rights reserved.
//

import Foundation

// MARK: - Int
extension Int {
    var random: Int {
        get {
            let randomNum: UInt32 = arc4random_uniform(UInt32(self))
            return Int(randomNum)
        }
    }
}
