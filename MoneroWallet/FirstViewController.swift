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
 
    var wallet: Wallet {
        return Wallet(daemonAddress: daemonURL)
    }

    @IBOutlet weak var outputTV: UITextView?
    @IBOutlet weak var generateButton: UIButton?


    @IBAction func generateClicked(sender: UIButton) {
        generate()
    }

    @IBAction func openClicked(sender: UIButton) {
        open()
    }

    @IBAction func refreshClicked(sender: UIButton) {
        refresh()
    }

    @IBAction func balanceClicked(sender: UIButton) {
        showBalance()
    }


    func walletPath() -> String? {
        let file = "file.txt" //this is the file. we will write to and read from it

        if let dir = NSSearchPathForDirectoriesInDomains(
            NSSearchPathDirectory.DocumentDirectory,
            NSSearchPathDomainMask.AllDomainsMask,
            true).first {
            return "\(dir)/\(file)"
        } else {
            return nil
        }
    }

    func open() {
        if let path = walletPath() {
            //writing
            let res = wallet.openInFile(path, withPassword: "groscaca", andTestNet: false)
            outputText(res)
        } else {
            Swift.debugPrint("Could not find document directory")
        }
    }

    func generate() {

        if let path = walletPath() {
            //writing
            let res = wallet.generateInFile(path, withPassword: "groscaca", andTestNet: false)
            outputText(res)
        } else {
            Swift.debugPrint("Could not find document directory")
        }

    }

    func refresh() {
        wallet.refreshWithStartHeight(0, andReset: false)
        showBalance()
    }

    func showBalance() {
        let res = wallet.show_balance_unlocked()
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

    
    func outputText(text: String) {
        outputTV?.text = text
    }

}
