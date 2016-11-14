//
//  WalletViewController.swift
//  MoneroWallet
//
//  Created by Ugo on 2016/11/06.
//  Copyright © 2016 Ugo Bataillard. All rights reserved.
//

import UIKit

class WalletViewController: UIViewController {

    @IBOutlet weak var addressLabel: UITextView!
    @IBOutlet weak var mnemonicLabel: UITextView!
    @IBOutlet weak var balanceLabel: UILabel!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let wallet = WalletStore.wallet else {
            return
        }
        addressLabel.text = wallet.address()
        mnemonicLabel.text = wallet.getSeed()
        balanceLabel.text = String(wallet.balance())
    }

}
