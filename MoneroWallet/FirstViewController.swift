//
//  FirstViewController.swift
//  MoneroWallet
//
//  Created by Ugo on 7/14/16.
//  Copyright © 2016 Ugo Bataillard. All rights reserved.
//

import UIKit
//import Moya

class FirstViewController: UIViewController {

    let daemonURL: String = "http://node.moneroworld.com:18081"
    
    let walletManager: WalletManager! = WalletManager.getInstance();// Wallet(daemonAddress: "http://node.moneroworld.com:18081")
    var wallet: Wallet? = nil
    
    
    @IBOutlet weak var outputTV: UITextView?
    @IBOutlet weak var generateButton: UIButton?

    @IBAction func generateClicked(_ sender: UIButton) {
        generate()
    }

    @IBAction func openClicked(_ sender: UIButton) {
        open()
    }
    
    @IBAction func initClicked(_ sender: UIButton) {
        initWallet()
    }


    @IBAction func refreshClicked(_ sender: UIButton) {
        refresh()
    }

    @IBAction func balanceClicked(_ sender: UIButton) {
        showBalance()
    }


    func walletPath() -> String? {
        let file = "file.txt" //this is the file. we will write to and read from it

        if let dir = NSSearchPathForDirectoriesInDomains(
            FileManager.SearchPathDirectory.documentDirectory,
            FileManager.SearchPathDomainMask.allDomainsMask,
            true).first {
            return "\(dir)/\(file)"
        } else {
            return nil
        }
    }

    func open() {
        if let path = walletPath() {
            //writing
            wallet =  walletManager.openWallet(withPath: path, andPassword: "groscaca", inTestNet: false);
            outputText(wallet?.address() ?? "Error opening wallet")
        } else {
            Swift.debugPrint("Could not find document directory")
        }
    }

    func generate() {

        if let path = walletPath() {
            //writing
            wallet =  walletManager.createWallet(withPath: path, andPassword: "groscaca", andLanguage: "English", inTestNet: false)
            outputText(wallet?.address() ?? "Error creating wallet")
        } else {
            Swift.debugPrint("Could not find document directory")
        }

    }
    
    func initWallet() {
        Swift.debugPrint("Initting wallet")
        wallet?.initWallet(withDaemonAddress: daemonURL, andUpperTransactionLimit: 0, andIsRecovering: false, andRestoreHeight: 0)
        Swift.debugPrint("Initted wallet")

    }

    func refresh() {
        //wallet.refresh(withStartHeight: 0, andReset: false)
        showBalance()
    }

    func showBalance() {
        let res = "";//wallet.show_balance_unlocked()
        outputText(res)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

//        let provider = ReactiveCocoaMoyaProvider<RPCService>()
//        provider.request(.Getinfo).start { result in
            // do something with the result (read on for more details)
//            Swift.debugPrint("Yeah: ", result)
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func outputText(_ text: String) {
        outputTV?.text = text
    }

}
