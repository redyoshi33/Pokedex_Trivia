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
    @IBOutlet weak var answerTextField: UITextField!
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var answerButtonPress: UIButton!
    
    var api = "https://pokeapi.co/api/v1/description/"
    var newurl: URL?
    var count = 3
    var pokename: String = ""
    var score = 0
    var pokeurl = ""
    var audioPlayer:AVAudioPlayer!
    
    @IBAction func submitButtonPress(_ sender: UIButton) {
        let answer = answerTextField.text
        if(answer?.lowercased() == pokename){
            if(count == 3){
                score += 2
            }
            else{
                score += 1
            }
            performSegue(withIdentifier: "SubmitSegue", sender: sender)
            playSound(songname: "Pokedex Sound Effect 2")
        }
        else{
            playSound(songname: "Wrong Answer")
            count -= 1
            if count == 0 {
                let alert = UIAlertController(title: "Too Bad!", message: "It was \(pokename.uppercased())!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: {action in self.viewDidLoad()}))
                self.present(alert, animated: true)
            }
            else{
                let alert = UIAlertController(title: "Try Again!", message: "\(count) more guess(es) left!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: {action in self.hintLabel.isHidden = false}))
                self.present(alert, animated: true)
            }
        }
    }
    func randomurl(){
        let rand = arc4random_uniform(2475) + 1
        let strrand = String(rand)
        let newlink = api + strrand
        newurl = URL(string: newlink)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playSound(songname: "Pokedex Sound Effect")
        count = 3
        hintLabel.isHidden = true
        randomurl()
        self.answerTextField.delegate = self;
        scoreLabel.text = "Score: \(String(score))"
        answerTextField.text = ""
        self.pokedexLabel.text = ""
        PokedexModel.getPokedex(url: newurl!, completionHandler: {
            data, response, error in
            do {
                print("grabbing json")
                // Try converting the JSON object to "Foundation Types" (NSDictionary, NSArray, NSString, etc.)
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                    if var entry = jsonResult["description"] as? String{
                        DispatchQueue.main.async {
                            if let name = jsonResult["pokemon"] as? NSDictionary{
                                if let poke = name["name"] as? String{
                                    self.pokename = poke
                                    print(self.pokename.uppercased())
                                    entry = entry.replace(target: self.pokename.uppercased(), withString: "_____")
                                    entry = entry.replace(target: "POKMON", withString: "Pokemon")
                                }
                                if var info = name["resource_uri"] as? String{
                                    info = info.replace(target:"v1", withString: "v2")
                                    info = "https://pokeapi.co" + info
                                    self.pokeurl = info
                                }
                            }
                            self.pokedexLabel.text = entry
                            let hint = "The Pokemon starts with a " + String(describing: self.pokename.first!).uppercased()
                            self.hintLabel.text = hint
                            print(hint)
                        
                        }
                    }
                }
                
            } catch {
                print("Something went wrong")
            }
        })
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ResultViewController
        destination.score = String(describing: score)
        destination.pokename = pokename.uppercased()
        destination.pokeurl = pokeurl
        destination.delegate = self
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


