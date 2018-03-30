//
//  PokedexViewController.swift
//  Pokemon
//
//  Created by jojoestar on 3/20/18.
//  Copyright © 2018 jojoestar. All rights reserved.
//

import UIKit
import AVFoundation

class PokedexViewController: UIViewController, UITextFieldDelegate, AnswerDelegate {
    
    
    @IBOutlet weak var pokedexLabel: UILabel!
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var hint2Label: UILabel!
    @IBOutlet weak var answerTextField: UITextField!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var answerButtonPress: UIButton!
    
    var api = "https://pokeapi.co/api/v1/description/"
    var newurl: URL?
    var count = 3
    var pokename: String = " "
    var score = 0
    var pokeurl: URL?
    var sprite = ""
    var audioPlayer:AVAudioPlayer!
    var hint1 = "This Pokemon's type is "
    var hint2 = ""
    var pokesprite: UIImage?
    var randlimit: UInt32 = 0
    var mode: String = ""
    var dataget: Bool = false

    @IBAction func submitButtonPress(_ sender: UIButton) {
        if dataget == true{
            let answer = answerTextField.text
            if(answer?.lowercased() == pokename){
                if(count == 3){
                    score += 2
                }
                else{
                    score += 1
                }
                performSegue(withIdentifier: "SubmitSegue", sender: self)
                playSound(songname: "Pokedex Sound Effect 2")
            }
            else{
                playSound(songname: "Wrong Answer")
                count -= 1
                if count == 0 {
                    performSegue(withIdentifier: "GameOverSegue", sender: sender)
                    //                let alert = UIAlertController(title: "Too Bad!", message: "It was \(pokename.uppercased())!", preferredStyle: .alert)
                    //                alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: {action in self.viewDidLoad()}))
                    //                self.present(alert, animated: true)
                }
                else{
                    let alert = UIAlertController(title: "Try Again!", message: "\(count) more guess(es) left!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: {action in self.hints()}))
                    self.present(alert, animated: true)
                }
            }
        }
    }
    func randomurl(){
        let rand = arc4random_uniform(randlimit) + 2 //2475 for first 151, 13178 for all
        let strrand = String(rand)
        let newlink = api + strrand
        newurl = URL(string: newlink)
    }
    func hints(){
        if count == 2 {
            hintLabel.text = hint1
        }
        else if count == 1 {
            hint2Label.text = hint2
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        playSound(songname: "Pokedex Sound Effect")
        count = 3
        self.hintLabel.text = " "
        self.hint2Label.text = " "
        hint1 = "This Pokemon's type is "
        hint2 = ""
        pokesprite = nil
        dataget = false
        loadingActivityIndicator.startAnimating()

        // styling stuff
        
        pokedexLabel.clipsToBounds = true
        pokedexLabel.layer.cornerRadius = 5
        pokedexLabel.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        hint2Label.clipsToBounds = true
        hint2Label.layer.cornerRadius = 5
        hint2Label.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        scoreLabel.clipsToBounds = true
        scoreLabel.layer.cornerRadius = 5
        
        answerButtonPress.clipsToBounds = true
        answerButtonPress.layer.cornerRadius = 5
        
        //end styling
        
        randomurl()
        self.answerTextField.delegate = self;
        scoreLabel.text = "Score: \(String(score))"
        answerTextField.text = ""
        self.pokedexLabel.text = " "
        PokedexModel.getPokedex(url: newurl!, completionHandler: {
            data, response, error in
            do {
                print("grabbing pokemon")
                // Try converting the JSON object to "Foundation Types" (NSDictionary, NSArray, NSString, etc.)
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                    if var entry = jsonResult["description"] as? String{
                        
                            if let name = jsonResult["pokemon"] as? NSDictionary{
                                if let poke = name["name"] as? String{
                                    self.pokename = poke
                                    print(self.pokename.capitalized)
                                    entry = entry.replace(target: self.pokename.capitalized, withString: "_____")
                                    entry = entry.replace(target: self.pokename.uppercased(), withString: "_____")
                                    entry = entry.replace(target: "POKMON", withString: "Pokemon")
                                }
                                if var info = name["resource_uri"] as? String{
                                    info = info.replace(target:"v1", withString: "v2")
                                    info = "https://pokeapi.co" + info
                                    self.pokeurl = URL(string:info)!
                                }
                            }
                        DispatchQueue.main.async {
                            self.pokedexLabel.text = entry
                            self.getPokemon()
                            self.hint2 = "The Pokemon starts with a " + String(describing: self.pokename.first!).uppercased()
                            self.loadingActivityIndicator.stopAnimating()
                            self.loadingActivityIndicator.hidesWhenStopped = true
                            }
                        }
                    }
                
            } catch {
                print("Something went wrong")
            }
        })
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SubmitSegue" {
            let destination = segue.destination as! ResultViewController
            destination.score = String(describing: score)
            destination.pokename = pokename.uppercased()
            destination.pokesprite = pokesprite
            destination.delegate = self
        }
        else if segue.identifier == "GameOverSegue" {
            let destination = segue.destination as! GameOverViewController
            destination.score = String(describing: score)
            destination.pokename = pokename.uppercased()
            destination.pokesprite = pokesprite
            destination.mode = mode
        }
    }
    
    func cancelResultViewController(_ controller: ResultViewController) {
        dismiss(animated: true, completion: nil)
        self.viewDidLoad()
    }
    
    func playSound(songname: String) {
        
        let audioFilePath = Bundle.main.path(forResource: songname, ofType: "mp3")
        
        if audioFilePath != nil {
            
            let audioFileUrl = NSURL.fileURL(withPath: audioFilePath!)
            do{
                
                audioPlayer = try AVAudioPlayer(contentsOf: audioFileUrl)
                audioPlayer.play()
            }
            catch{
                print("audio file cannot play")
            }
        }
        else {
            print("audio file is not found")
        }
    }
    func getPokemon(){
        PokedexModel.getPokemon(url: self.pokeurl!, completionHandler: {
            data, response, error in
            do {
                print("grabbing json")
                // Try converting the JSON object to "Foundation Types" (NSDictionary, NSArray, NSString, etc.)
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                    if var spritedict = jsonResult["sprites"] as? NSDictionary{
                        if let spriteurl = spritedict["front_default"] as? String{
                            self.sprite = spriteurl
                            if let data = try? Data(contentsOf: URL(string:self.sprite)!)
                            {
                                if let image = UIImage(data: data) as? UIImage{
                                    self.pokesprite = image
                                }
                            }
                        }
                    }
                    if let typedict = jsonResult["types"] as? NSArray{
                        if typedict.count == 2{
                            if let types = typedict[1] as? NSDictionary{
                                if let type1 = types["type"] as? NSDictionary{
                                    if let type = type1["name"] as? String{
                                        self.hint1 = self.hint1 + type.capitalized
                                    }
                                }
                            }
                            if let types = typedict[0] as? NSDictionary{
                                if let type2 = types["type"] as? NSDictionary{
                                    if let type = type2["name"] as? String{
                                        self.hint1 = self.hint1 + " and " + type.capitalized
                                    }
                                }
                            }
                        }
                        else{
                            if let types = typedict[0] as? NSDictionary{
                                if let type1 = types["type"] as? NSDictionary{
                                    if let type = type1["name"] as? String{
                                        self.hint1 = self.hint1 + type.capitalized
                                    }
                                }
                            }
                        }
                        self.dataget = true
                        
                    }
                }
            }
            catch {
                print("Something went wrong")
            }
        })
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension String
{
    func replace(target: String, withString: String) -> String
    {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
}


