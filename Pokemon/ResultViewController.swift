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
    var delegate: AnswerDelegate?
    var pokename: String?
    var score = ""
    var pokemon = ""
    var pokeurl = ""
    var sprite = ""
    
    @IBAction func playagainButtonPress(_ sender: UIButton) {
        delegate?.cancelResultViewController(self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print(pokeurl)
        if let pokemon = pokename {
            resultLabel.text = "Correct! it was \(pokemon). You have a score of \(score)."
        }
        PokedexModel.getSprite(url: URL(string:pokeurl)!, completionHandler: {
            data, response, error in
            do {
                print("grabbing json")
                // Try converting the JSON object to "Foundation Types" (NSDictionary, NSArray, NSString, etc.)
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                    DispatchQueue.main.async {
                        if var spritedict = jsonResult["sprites"] as? NSDictionary{
                            if let spriteurl = spritedict["front_default"] as? String{
                                self.sprite = spriteurl
                                if let data = try? Data(contentsOf: URL(string:self.sprite)!)
                                {
                                    if let image = UIImage(data: data) as? UIImage{
                                        self.spriteImageView.image = image
                                    }
                                }
                            }
                        }
                    }
                }
                
            } catch {
                print("Something went wrong")
            }
        })
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
