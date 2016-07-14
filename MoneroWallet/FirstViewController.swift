//
//  FirstViewController.swift
//  MoneroWallet
//
//  Created by Ugo on 7/14/16.
//  Copyright © 2016 Ugo Bataillard. All rights reserved.
//

import UIKit
import Moya

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let provider = ReactiveCocoaMoyaProvider<RPCService>()
        provider.request(.Getinfo).start { result in
            // do something with the result (read on for more details)
            Swift.debugPrint("Yeah: ", result)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
