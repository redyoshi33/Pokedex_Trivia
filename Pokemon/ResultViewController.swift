//
//  ResultViewController.swift
//  Pokemon
//
//  Created by jojoestar on 3/21/18.
//  Copyright © 2018 jojoestar. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {

    @IBOutlet weak var spriteImageView: UIImageView!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    
    var delegate: AnswerDelegate?
    var pokename: String?
    var score = ""
//    var pokemon = ""
    var pokesprite: UIImage?
    
    @IBAction func continueButtonPress(_ sender: UIButton) {
        delegate?.cancelResultViewController(self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rightLabel.clipsToBounds = true
        rightLabel.layer.cornerRadius = 5
        rightLabel.layer.maskedCorners = [.layerMaxXMaxYCorner]
        
        leftLabel.clipsToBounds = true
        leftLabel.layer.cornerRadius = 5
        leftLabel.layer.maskedCorners = [.layerMinXMaxYCorner]
        
        resultLabel.clipsToBounds = true
        resultLabel.layer.cornerRadius = 5
        resultLabel.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]

        continueButton.clipsToBounds = true
        continueButton.layer.cornerRadius = 5
        
        spriteImageView.image = pokesprite
        if let pokemon = pokename {
            resultLabel.text = "Correct! it was \(pokemon)!"
        }
        scoreLabel.text = score
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
