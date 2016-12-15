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

    @IBAction func generateClicked() {

        guard let walletName = walletNameTF.text, !walletName.isEmpty else {
            return
        }
        
        let wallet = WalletStore.createWallet(walletName,
                                              password: passwordTF.text ?? "",
                                              language: languageTV.text ?? "")

        if wallet != nil {
            dismiss(animated: true, completion: nil)
        }
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
