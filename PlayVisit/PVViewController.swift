//
//  PVViewController.swift
//  SimpleFramework
//
//  Created by Oriol Janés on 23/07/2018.
//  Copyright © 2018 Geomotion Games. All rights reserved.
//

import UIKit

open class PVViewController: UIViewController {

    public var PVToken: String!

    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view = PVWebView(token: self.PVToken)
    }

}
