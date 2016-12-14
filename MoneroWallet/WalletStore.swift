//
//  WalletStore.swift
//  MoneroWallet
//
//  Created by Ugo on 2016/11/06.
//  Copyright © 2016 Ugo Bataillard. All rights reserved.
//

import Foundation

class WalletStore {

    static let daemonURL: String = "http://kiki:18081"
    static let walletManager: WalletManager = WalletManager.getInstance()
    static let testNet = false

    static let defaultFilename = "wallet.dat"

    static func walletFile(filename: String = defaultFilename) -> String? {

        if let dir = NSSearchPathForDirectoriesInDomains(
            FileManager.SearchPathDirectory.documentDirectory,
            FileManager.SearchPathDomainMask.allDomainsMask,
            true).first {
            return "\(dir)/\(filename)"
        } else {
            return nil
        }
    }

    static var wallet: Wallet? = nil

    static func initWallet(recovering: Bool = false) {
        DispatchQueue.global(qos: .background).async {
            self.wallet?.initWalletAsync(withDaemonAddress: daemonURL,
                                    andUpperTransactionLimit: 0,
                                    andIsRecovering: recovering,
                                    andRestoreHeight: 0)
        }
    }

}
