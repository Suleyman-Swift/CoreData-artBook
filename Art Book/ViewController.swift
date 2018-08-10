//
//  ViewController.swift
//  Art Book
//
//  Created by Süleyman Ekici on 10.08.2018.
//  Copyright © 2018 Süleyman Ekici. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var nameArray = [String]()
    var yearArray = [Int]()
    var artistArray = [String]()
    var imageArray = [UIImage]()
    var sellectedResimler = ""
    
    override func viewDidLoad() {
       super.viewDidLoad()
       tableView.delegate = self
       tableView.dataSource = self
       getinfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.getinfo), name: NSNotification.Name(rawValue: "yeniResimler"), object: nil)
    }
    
    @objc func getinfo() {
        
        nameArray.removeAll(keepingCapacity: false)
        yearArray.removeAll(keepingCapacity: false)
        artistArray.removeAll(keepingCapacity: false)
        imageArray.removeAll(keepingCapacity: false)
        
        let apDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = apDelegate?.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Resimler")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            
            let results = try context!.fetch(fetchRequest)
            
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    if let name = result.value(forKey: "name") as? String {
                        self.nameArray.append(name)
                    }
                    if let year = result.value(forKey: "year") as? Int {
                        self.yearArray.append(year)
                        }
                    if let artist = result.value(forKey: "artist") as? String {
                        self.artistArray.append(artist)
                        
                    }
                    if let imageData = result.value(forKey: "image") as? Data {
                        let image = UIImage(data: imageData)
                        self.imageArray.append(image!)
                    }
                    self.tableView.reloadData()
                }
            }
        }
        catch
        {
            print("Hatta")
        }
        
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sellectedResimler = nameArray[indexPath.row]
        performSegue(withIdentifier: "toinfoVC", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toinfoVC" {
            let destination = segue.destination as? infoVC
            destination?.resimBilgisi = sellectedResimler
            
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            
            nameArray.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text =  nameArray[indexPath.row]
        return cell
    }
    
    
    @IBAction func addButton(_ sender: Any) {
        sellectedResimler = ""
        performSegue(withIdentifier: "toinfoVC", sender: nil)
    }
    
}

