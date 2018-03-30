//
//  SelectViewController.swift
//  Pokemon
//
//  Created by jojoestar on 3/26/18.
//  Copyright © 2018 jojoestar. All rights reserved.
//

import UIKit

class SelectViewController: UIViewController {
    
    var randlimit: UInt32 = 0
    var mode: String = ""

    @IBAction func backButtonPress(_ sender: UIButton) {
        self.performSegue(withIdentifier: "UnwindFromSelectSegue", sender: self)
    }
    
    @IBAction func onefiftyoneButtonPress(_ sender: UIButton) {
        randlimit = 2473
        mode = "151"
        performSegue(withIdentifier: "GameStartSegue", sender: self)
    }
    
    @IBAction func allButtonPress(_ sender: UIButton) {
        randlimit = 13176
        mode = "all"
        performSegue(withIdentifier: "GameStartSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GameStartSegue"{
            let destination = segue.destination as! PokedexViewController
            destination.randlimit = randlimit
            destination.mode = mode
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
