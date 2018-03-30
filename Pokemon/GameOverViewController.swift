//
//  GameOverViewController.swift
//  Pokemon
//
//  Created by jojoestar on 3/27/18.
//  Copyright © 2018 jojoestar. All rights reserved.
//

import UIKit
import CoreData

class GameOverViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var pokemonLabel: UILabel!
    @IBOutlet weak var spriteImageView: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var gameOverLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var pokename: String?
    var score = ""
    var pokesprite: UIImage?
    var mode: String = ""
    
    @IBAction func submitButtonPress(_ sender: UIButton) {
        let user = NSEntityDescription.insertNewObject(forEntityName: "UserScore", into: managedObjectContext) as! UserScore
        user.name = nameTextField.text!
        if let scoreint = Int(score){
            let score32 = Int32(scoreint)
            user.score = score32
        }
        user.gen = mode
        appDelegate.saveContext()
        performSegue(withIdentifier: "GameOverScoreSegue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let pokemon = pokename {
            pokemonLabel.text = "It was \(pokemon)!"
        }
        scoreLabel.text = score
        spriteImageView.image = pokesprite
        // Do any additional setup after loading the view.
        
        submitButton.clipsToBounds = true
        submitButton.layer.cornerRadius = 5
        
        gameOverLabel.clipsToBounds = true
        gameOverLabel.layer.cornerRadius = 5
        gameOverLabel.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        nameLabel.clipsToBounds = true
        nameLabel.layer.cornerRadius = 5
        nameLabel.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        self.nameTextField.delegate = self
        
    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let destination = segue.destination as! HighScoreViewController
//        
//    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
   //Keyboard stuff

}
