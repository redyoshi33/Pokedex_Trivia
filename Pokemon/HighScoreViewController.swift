//
//  HighScoreViewController.swift
//  Pokemon
//
//  Created by jojoestar on 3/29/18.
//  Copyright © 2018 jojoestar. All rights reserved.
//

import UIKit
import CoreData

class HighScoreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

    
    @IBAction func triangleButtonPress(_ sender: UIButton) {
        self.performSegue(withIdentifier: "unwindToMenu", sender: self)
        print("clicked")
    }
    
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var scoreTableView: UITableView!
    
    var genIscores = [UserScore]()
    var genAllscores = [UserScore]()
    let headers = ["Gen I Pokemon","All 721 Pokemon"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchGenI()
        fetchGenAll()
        scoreTableView.delegate = self
        scoreTableView.dataSource = self
        scoreTableView.reloadData()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func fetchGenI(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserScore")
        let predicate = NSPredicate(format: "gen == %@", "151")
        request.predicate = predicate
        let descriptors = [NSSortDescriptor(key: "score", ascending: false)]
        request.sortDescriptors = descriptors
        do{
            let result = try managedObjectContext.fetch(request)
            genIscores = result as! [UserScore]
        } catch {
            print("\(error)")
        }
    }
    func fetchGenAll(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserScore")
        let predicate = NSPredicate(format: "gen == %@", "all")
        request.predicate = predicate
        let descriptors = [NSSortDescriptor(key: "score", ascending: false)]
        request.sortDescriptors = descriptors
        do{
            let result = try managedObjectContext.fetch(request)
            genAllscores = result as! [UserScore]
        } catch {
            print("\(error)")
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let header = headers[section]
        if header == "Gen I Pokemon"{
            if genIscores.count < 3{
                return genIscores.count
            }
            else{
                return 3
            }
        }
        else if header == "All 721 Pokemon"{
            if genAllscores.count < 3{
                return genAllscores.count
            }
            else{
                return 3
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
        if indexPath.section == 0 {
            let score = genIscores[indexPath.row]
            cell.textLabel?.text = score.name
            cell.detailTextLabel?.text = String(score.score)
        }
        else if indexPath.section == 1{
            let score = genAllscores[indexPath.row]
            cell.textLabel?.text = score.name
            cell.detailTextLabel?.text = String(score.score)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headers[section]
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return headers.count
    }
}
