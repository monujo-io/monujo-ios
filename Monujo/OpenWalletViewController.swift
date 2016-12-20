//
//  OpenWalletViewController.swift
//  MoneroWallet
//
//  Created by Ugo on 2016/11/06.
//  Copyright © 2016 Ugo Bataillard. All rights reserved.
//

import UIKit

class OpenWalletViewController: UIViewController {

    @IBOutlet weak var walletNameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!

    let walletManager = WalletStore.walletManager

    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTF.delegate = self
    }

    @IBAction func generateClicked() {

        guard let walletName = walletNameTF.text, !walletName.isEmpty else {
            return
        }

        let wallet =  WalletStore.openWallet(walletName,
                                             password: passwordTF.text ?? "")

        if wallet != nil {
            dismiss(animated: true, completion: nil)
        }
    }
}

extension OpenWalletViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
