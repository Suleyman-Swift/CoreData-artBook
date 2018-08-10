//
//  infoVC.swift
//  Art Book
//
//  Created by Süleyman Ekici on 10.08.2018.
//  Copyright © 2018 Süleyman Ekici. All rights reserved.
//

import UIKit
import CoreData

class infoVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var resimGoster: UIImageView!
    @IBOutlet weak var ResimAdiText: UITextField!
    @IBOutlet weak var SanatAdi: UITextField!
    @IBOutlet weak var YilText: UITextField!
    var resimBilgisi = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if resimBilgisi != "" {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Resimler")
            fetchRequest.predicate = NSPredicate(format: "name = %@", self.resimBilgisi)
            fetchRequest.returnsObjectsAsFaults = false
            
            do {
                let results = try context.fetch(fetchRequest)
                
                if results.count > 0 {
                    
                    for result in results as! [NSManagedObject]{
                        if let name = result.value(forKey: "name") as? String {
                            ResimAdiText.text = name
                        }
                        if let year = result.value(forKey: "year") as? Int {
                            YilText.text = String(year)
                        }
                        if let artist = result.value(forKey: "artist") as? String {
                            SanatAdi.text = artist
                        }
                        if let imageData = result.value(forKey: "image") as? Data {
                            let image = UIImage(data: imageData)
                            self.resimGoster.image = image
                            
                        }
                   
                        
     }
         }
            } catch {
                print("hatta")
            }
            
        }
        
   
        resimGoster.isUserInteractionEnabled = true
        let gestrueRecognizer = UITapGestureRecognizer(target: self, action: #selector(infoVC.selectImage))
        resimGoster.addGestureRecognizer(gestrueRecognizer)
       
    }
    
    @objc func selectImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        resimGoster.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }

  
  
    
    @IBAction func saveButton(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate?.persistentContainer.viewContext
        
        let newArt = NSEntityDescription.insertNewObject(forEntityName: "Resimler", into: context!)
        
        newArt.setValue(ResimAdiText.text, forKey: "name")
        newArt.setValue(SanatAdi.text, forKey: "artist")
        
        if let year = Int(YilText.text!) {
            newArt.setValue(year, forKey: "year")
        }
        
        let data = UIImageJPEGRepresentation(resimGoster.image!, 0.5)
        newArt.setValue(data, forKey: "image")
        
        do {
            try context?.save()
            print("Başarılı Bir Şekilde Tamamlandı")
        } catch{
            print("Hatta")
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "yeniResimler"), object: nil)
        self.navigationController?.popViewController(animated: true)
        
    }
    
}
