//
//  MainViewController.swift
//  MoneroWallet
//
//  Created by Ugo on 2016/11/06.
//  Copyright © 2016 Ugo Bataillard. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard let _ = WalletStore.openSavedWallet() else {
            return performSegue(withIdentifier: "LoginSegue", sender: self)
        }
    }
}
