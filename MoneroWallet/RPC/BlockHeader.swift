//
//  BlockHeader.swift
//  MoneroWallet
//
//  Created by Ugo on 7/14/16.
//  Copyright © 2016 Ugo Bataillard. All rights reserved.
//

import Foundation

class BlockHeader: NSObject {

    var depth: Int = 0
    var difficulty: Int = 0
    var bHash: String = ""

    var height: Int = 0
    var majorVersion: Int = 0
    var minorVersion: Int = 0
    var nonce: Int = 0
    var orphanStatus: Bool = true
    var prevHash: String = ""
    var reward: Int = 0
    var timestamp: Int = 0
}
