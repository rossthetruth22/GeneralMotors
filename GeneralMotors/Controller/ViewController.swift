//
//  ViewController.swift
//  GeneralMotors
//
//  Created by Royce Reynolds on 10/4/20.
//  Copyright © 2020 Royce Reynolds. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let network = NetworkService.sharedInstance()
        network.getDataMethod(song: "ciscero") { (result, error) in
            print("here")
        }
        
        // Do any additional setup after loading the view.
    }


}

