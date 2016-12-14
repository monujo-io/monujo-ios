//
//  CreateWalletViewController.swift
//  MoneroWallet
//
//  Created by Ugo on 2016/11/06.
//  Copyright © 2016 Ugo Bataillard. All rights reserved.
//

import UIKit

class CreateViewController: UIViewController {

    @IBOutlet weak var languageTV: UILabel!
    @IBOutlet weak var walletNameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!

    let walletManager = WalletStore.walletManager

    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTF.delegate = self
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {

        guard let walletName = walletNameTF.text, !walletName.isEmpty else {
            return false
        }
        
        let wallet =  walletManager.createWallet(withPath: WalletStore.walletFile(filename: walletName),
                                                 andPassword: passwordTF.text,
                                                 andLanguage: languageTV.text,
                                                 inTestNet: WalletStore.testNet)

        WalletStore.wallet = wallet
        WalletStore.initWallet()

        return wallet != nil
    }

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        wallet =  walletManager.createWallet(withPath: path, andPassword: "groscaca", andLanguage: "English", inTestNet: false)
//    }

}

extension CreateViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
