//
//  RecoverWalletViewController.swift
//  MoneroWallet
//
//  Created by Ugo on 2016/11/06.
//  Copyright © 2016 Ugo Bataillard. All rights reserved.
//

import UIKit

class RecoverWalletViewController: UIViewController {

    @IBOutlet weak var walletNameTF: UITextField!
    @IBOutlet weak var memoTV: UITextView!

    let walletManager = WalletStore.walletManager

    override func viewDidLoad() {
        super.viewDidLoad()
        memoTV.delegate = self
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {

        guard let walletName = walletNameTF.text, !walletName.isEmpty else {
            return false
        }

        let wallet =  walletManager.recoveryWallet(withPath: WalletStore.walletFile(filename: walletName),
                                                   andMemo: memoTV.text ?? "",
                                                   andRestoreHeight: 0,
                                                   inTestNet: WalletStore.testNet)

        WalletStore.wallet = wallet
        WalletStore.initWallet(recovering: true)
        return wallet != nil
    }
}

extension RecoverWalletViewController: UITextViewDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
