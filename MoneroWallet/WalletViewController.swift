//
//  WalletViewController.swift
//  MoneroWallet
//
//  Created by Ugo on 2016/11/06.
//  Copyright © 2016 Ugo Bataillard. All rights reserved.
//

import UIKit

class WalletViewController: UIViewController {

    var wallet: Wallet? = nil
    var lastTimeRefreshed = CFAbsoluteTimeGetCurrent()

    @IBOutlet weak var addressLabel: UITextView!
    @IBOutlet weak var mnemonicLabel: UITextView!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var blockHeightsLabel: UILabel!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetWallet()
        NotificationCenter.default.addObserver(self, selector: #selector(WalletViewController.resetWallet), name: WalletStore.walletInittedNotification, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: WalletStore.walletInittedNotification, object: nil);
    }

    func resetWallet() {
        self.wallet = WalletStore.wallet
        guard let wallet = self.wallet else {
            return
        }
        wallet.delegate = self
        addressLabel.text = wallet.address()
        mnemonicLabel.text = wallet.getSeed()
        refreshBalance()
        refreshBlockHeights()
    }

    func refreshBalance() {
        balanceLabel.text = String(wallet?.balance() ?? 0)
    }

    func refreshBlockHeights() {
        if let w = self.wallet {
            let blockHeightsString = "\(w.blockChainHeight()) / \(w.daemonBlockChainHeight()) / \(w.daemonBlockChainTargetHeight())"
            Swift.debugPrint("Refreshing block: ", blockHeightsString)
            blockHeightsLabel.text = blockHeightsString
        }
    }

    @IBAction func refreshButtonClicked(_ view: UIView) {
        self.wallet?.refreshAsync()
    }

}

extension WalletViewController: WalletDelegate {
    func walletMoneySpent(_ wallet: Wallet!, transactionId txId: String!, amount: UInt64) {
        Swift.debugPrint("walletMoneySpent")
        wallet.refresh()
        wallet.history.refresh()
        DispatchQueue.main.async {
            self.refreshBalance()
        }
    }

    func walletMoneyReceived(_ wallet: Wallet!, transactionId txId: String!, amount: UInt64) {
        Swift.debugPrint("walletMoneyReceived")
        wallet.refresh()
        wallet.history.refresh()
        DispatchQueue.main.async {
            self.refreshBalance()
        }
    }

    func walletNewBlock(_ wallet: Wallet!, height: UInt64) {
        //Swift.debugPrint("walletNewBlock: ", height)
        if CFAbsoluteTimeGetCurrent() - lastTimeRefreshed > 1 {
            lastTimeRefreshed = CFAbsoluteTimeGetCurrent()
            DispatchQueue.main.async {
                self.refreshBlockHeights()
            }
        }
    }

    func walletUpdated(_ wallet: Wallet!) {
        Swift.debugPrint("walletUpdated")
        DispatchQueue.main.async {
            self.refreshBlockHeights()
            self.refreshBalance()
        }
    }

    func walletRefreshed(_ wallet: Wallet!) {
        Swift.debugPrint("walletRefreshed")
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: WalletStore.isRecoveringKey)
        wallet.store()
        DispatchQueue.main.async {
            self.refreshBlockHeights()
            self.refreshBalance()
        }
    }
}
