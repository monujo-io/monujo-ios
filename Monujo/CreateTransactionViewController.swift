//
//  CreateTransactionViewController.swift
//  MoneroWallet
//
//  Created by Ugo on 2016/12/18.
//  Copyright © 2016 Ugo Bataillard. All rights reserved.
//

import UIKit

class CreateTransactionViewController: UIViewController {

    let wallet = WalletStore.wallet!
    @IBOutlet var addressTV: UITextView!
    @IBOutlet var amountTF: UITextField!
    @IBOutlet var paymentIdTF: UITextField!
    @IBOutlet var mixinCountTF: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        addressTV.delegate = self
        amountTF.delegate = self
        paymentIdTF.delegate = self
        mixinCountTF.delegate = self
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {

        guard let rawAmount = amountTF.text, !rawAmount.isEmpty else { return false }

        let amountxmr = Wallet.amount(from: rawAmount)

        return amountxmr > 0 && amountxmr <= wallet.unlockedBalance()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if
            let destinationVC = segue.destination as? ConfirmTransactionViewController,
            let address = addressTV.text, !address.isEmpty,
            let rawAmount = amountTF.text, !rawAmount.isEmpty {

            let amount = Wallet.amount(from: rawAmount)
            let paymentId = paymentIdTF.text ?? ""
            let mixinCount = UInt32(mixinCountTF.text ?? "") ?? 0

            let pendingTransaction = wallet.createTransaction(toAddress: address,
                                     withPaymentId: paymentId,
                                     andAmount: amount,
                                     andMixinCount: mixinCount,
                                     andPriority: 1)

            destinationVC.transaction = pendingTransaction
            destinationVC.address = address
            destinationVC.paymentId = paymentId
            destinationVC.mixinCount = mixinCount
        }
    }
}

extension CreateTransactionViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension CreateTransactionViewController: UITextViewDelegate {
    func textViewShouldReturn(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
}
