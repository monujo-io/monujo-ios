//
//  WalletStore.swift
//  MoneroWallet
//
//  Created by Ugo on 2016/11/06.
//  Copyright © 2016 Ugo Bataillard. All rights reserved.
//

import Foundation
import KeychainAccess

class WalletStore {

    static let daemonURL: String = "http://kiki:18081"
    static let walletManager: WalletManager = WalletManager.getInstance()
    static let testNet = false

    static let defaultFilename = "wallet.dat"

    static let walletFileKey = "walletFile"
    static let isRecoveringKey = "isRecovering"
    static let restoreHeightKey = "restoreHeight"

    static let keychain = Keychain(service: "io.monujo.app")
    
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

    static let walletInittedNotification = Notification.Name("WalletInitted")

    static var wallet: Wallet? = nil {
        didSet {
            NotificationCenter.default.post(name: walletInittedNotification, object: wallet)
        }
    }

    static func createWallet(_ walletFile: String, password: String, language: String) -> Wallet? {
        let walletPath = WalletStore.walletFile(filename: walletFile)
        guard let wallet =  walletManager.createWallet(withPath: walletPath,
                                                 andPassword: password,
                                                 andLanguage: language,
                                                 inTestNet: WalletStore.testNet) else {
            return nil
        }

        keychain["password"] = password
        
        initWallet(wallet, walletFile: walletFile)
        return wallet
    }

    static func openWallet(_ walletFile: String,
                           password: String = "",
                           isRecovering: Bool = false,
                           restoreHeight: UInt64 = 0) -> Wallet? {
        let walletPath = WalletStore.walletFile(filename: walletFile)
        guard let wallet =  walletManager.openWallet(withPath: walletPath,
                                               andPassword: password,
                                               inTestNet: WalletStore.testNet) else {
            return nil
        }

        keychain["password"] = password

        initWallet(wallet,
                   walletFile: walletFile,
                   recovering: isRecovering,
                   restoreHeight: restoreHeight)
        return wallet
    }

    static func recoverWallet(_ walletFile: String,
                           memo: String = "",
                           restoreHeight: UInt64 = 0) -> Wallet? {

        let walletPath = WalletStore.walletFile(filename: walletFile)
        guard let wallet =  walletManager.recoveryWallet(withPath: walletPath,
                                                   andMemo: memo,
                                                   andRestoreHeight: restoreHeight,
                                                   inTestNet: WalletStore.testNet) else {
            return nil
        }

        initWallet(wallet, walletFile: walletFile, recovering: true, restoreHeight: restoreHeight)
        return wallet
    }

    static func savedWalletExists() -> Bool {
        let fileManager = FileManager.default
        let defaults = UserDefaults.standard
        guard let walletFile = defaults.string(forKey: walletFileKey),
            let walletPath = WalletStore.walletFile(filename: walletFile),
            fileManager.fileExists(atPath: walletPath) else {
            return false
        }
        return true
    }

    static func openSavedWallet() -> Wallet? {
        let defaults = UserDefaults.standard
        guard let walletFile = defaults.string(forKey: walletFileKey) else {
            return nil
        }

        guard savedWalletExists() else {
            return nil
        }        
        
        guard let password = keychain["password"] else {
            return nil
        }
        
        let isRecovering = defaults.bool(forKey: isRecoveringKey)
        let restoreHeight = defaults.object(forKey: restoreHeightKey) as? NSNumber

        return openWallet(walletFile, password: password,
                          isRecovering: isRecovering,
                          restoreHeight: restoreHeight?.uint64Value ?? 0)
    }

    static func save() {
        guard let wallet = wallet else { return }
        Swift.debugPrint("Saving wallet...")
        let defaults = UserDefaults.standard
        defaults.set(NSNumber(value: wallet.blockChainHeight()), forKey: restoreHeightKey)
        wallet.store()
    }

    static func initWallet(_ wallet: Wallet,
                           walletFile: String,
                           recovering: Bool = false,
                           restoreHeight: UInt64 = 0) {
        let defaults = UserDefaults.standard
        defaults.set(walletFile, forKey: walletFileKey)
        defaults.set(recovering, forKey: isRecoveringKey)
        defaults.set(NSNumber(value: restoreHeight), forKey: restoreHeightKey)

        self.wallet = wallet

        DispatchQueue.global(qos: .background).async {
            self.wallet?.initWalletAsync(withDaemonAddress: daemonURL,
                                    andUpperTransactionLimit: 0,
                                    andIsRecovering: recovering,
                                    andRestoreHeight: restoreHeight)
        }
    }

}
