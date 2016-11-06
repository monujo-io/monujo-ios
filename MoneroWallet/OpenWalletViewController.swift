//
//  OpenWalletViewController.swift
//  MoneroWallet
//
//  Created by Ugo on 2016/11/06.
//  Copyright © 2016 Ugo Bataillard. All rights reserved.
//

import UIKit

class OpenWalletViewController: UIViewController {
    
    @IBOutlet weak var passwordTF: UITextField!

    let walletManager = WalletStore.walletManager

    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTF.delegate = self
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {

        let wallet =  walletManager.openWallet(withPath: WalletStore.walletFile(),
                                               andPassword: passwordTF.text,
                                               inTestNet: WalletStore.testNet)

        WalletStore.wallet = wallet
        WalletStore.initWallet()
        return wallet != nil
    }
}

extension OpenWalletViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
