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

    
    let wallet = Wallet()
    
    @IBOutlet weak var outputTV: UITextView?
    @IBOutlet weak var generateButton: UIButton?
    
    
    @IBAction func generateClicked(sender: UIButton) {
        generate()
    }
    
    func generate() {
        let file = "file.txt" //this is the file. we will write to and read from it
        
        if let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
            let path = "\(dir)/\(file)"
            
            //writing
            let res = wallet.generateInFile(path, withPassword: "groscaca", andTestNet: false)
            outputTV?.text = res
        }
        else {
            Swift.debugPrint("Could not find document directory")
        }

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


}
