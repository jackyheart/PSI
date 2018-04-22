//
//  LegendViewController.swift
//  PSI
//
//  Created by Jacky Tjoa on 22/4/18.
//  Copyright © 2018 Jacky Tjoa. All rights reserved.
//

import UIKit

class LegendViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
