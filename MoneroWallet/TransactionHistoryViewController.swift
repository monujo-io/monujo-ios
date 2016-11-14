//
//  TransactionHistory.swift
//  MoneroWallet
//
//  Created by Ugo on 2016/11/14.
//  Copyright © 2016 Ugo Bataillard. All rights reserved.
//

import UIKit

class TransactionHistoryViewController: UITableViewController {

    var wallet: Wallet? = nil
    var transactions: Array<TransactionInfo> = []

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let wallet = WalletStore.wallet else {
            return
        }

        self.wallet = wallet
        let history = wallet.history!
        transactions = history.getAll() as? Array<TransactionInfo> ?? []
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let transaction = transactions[indexPath.row]

        if let direction = cell.viewWithTag(0) as? UILabel {
            direction.text = String(transaction.direction)
        }
        if let status = cell.viewWithTag(1) as? UILabel {
            status.text = transaction.failed ? "Failed" : ( transaction.pending ? "Pending" :"Completed" )
        }
        if let amount = cell.viewWithTag(2) as? UILabel {
            amount.text = String(transaction.amount)
        }

        return cell
    }

}
