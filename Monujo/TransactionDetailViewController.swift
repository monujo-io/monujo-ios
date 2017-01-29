//
//  TransactionDetailViewController.swift
//  Monujo
//
//  Created by Ugo on 2017/01/29.
//  Copyright © 2017 Ugo Bataillard. All rights reserved.
//

import UIKit

class TransactionDetailViewController: UIViewController {

    @IBOutlet weak var transactionDetailTV: UITextView!

    var transaction: TransactionInfo! = nil

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        var text = "Hash \(transaction.hash)"
            + "\nPayment ID: \(transaction.paymentId)"
            + "\n\nAmount: \(Wallet.displayAmount(transaction.amount))"
            + "\nFee: \(Wallet.displayAmount(transaction.fee))"
            + "\nTransfers:"

        (transaction.transfers as! [Transfer]).forEach { (t) in
            text += "\nAddress: (t.address)"
                + "\nAmount: \(Wallet.displayAmount(t.amount))"
                + "\n-----------------"
        }

        transactionDetailTV.text = text
    }

}
