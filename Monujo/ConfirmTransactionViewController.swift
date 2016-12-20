//
//  ConfirmTransactionViewController.swift
//  MoneroWallet
//
//  Created by Ugo on 2016/12/18.
//  Copyright © 2016 Ugo Bataillard. All rights reserved.
//

import UIKit

class ConfirmTransactionViewController: UIViewController {

    let wallet = WalletStore.wallet!
    var transaction: PendingTransaction! = nil
    var address: String = ""
    var paymentId: String = ""
    var mixinCount: UInt32 = 0

    @IBOutlet var confirmationMessageTV: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        var message = ""

        if transaction.status != 0 {

            message = "Can't create transaction: \(transaction.errorString())"
            // deleting transaction object, we don't want memleaks
//            wallet.disposeTransaction(transaction);
        } else {

            message = "Please confirm transaction:\n"
            + (address == "" ? "" : "\nAddress: \(address)")
            + (paymentId == "" ? "" : "\nPayment ID: \(paymentId)")
            + "\n\nAmount: \(Wallet.displayAmount(transaction.amount))"
            + "\nFee: \(Wallet.displayAmount(transaction.fee))"
            + "\n\nMixin: \(mixinCount)"
            //+ "\n\nError: \(transaction.errorString())"

            //+ "\n\nNumber of transactions: \(transaction.txCount)"
        }
        confirmationMessageTV.text = message
    }

    @IBAction func confirmButtonClicked(view: UIControl) {
        self.dismiss(animated: true, completion: nil)
    }
}
