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
    @IBOutlet weak var initialHeightTF: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        memoTV.delegate = self
    }

    @IBAction func generateClicked() {

        guard let walletName = walletNameTF.text,
            !walletName.isEmpty,
            let memo = memoTV.text,
            !memo.isEmpty
            else {
            return
        }

        let restoreHeight = UInt64(initialHeightTF.text ?? "0") ?? 0
        let wallet =  WalletStore.recoverWallet(walletName,
                                                 memo: memo,
                                                 restoreHeight: restoreHeight)

        if wallet != nil {
            dismiss(animated: true, completion: nil)
        }
    }
}

extension RecoverWalletViewController: UITextViewDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
