//
//  MenuViewController.swift
//  Pokemon
//
//  Created by jojoestar on 3/26/18.
//  Copyright © 2018 jojoestar. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {}
    
    @IBAction func startButtonPress(_ sender: UIButton) {
        performSegue(withIdentifier: "SelectSegue", sender: self)
    }
    
    @IBAction func highscoreButtonPress(_ sender: UIButton) {
        performSegue(withIdentifier: "MenuScoreSegue", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
