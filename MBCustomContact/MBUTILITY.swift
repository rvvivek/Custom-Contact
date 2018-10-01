//
//  MBUTILITY.swift
//  MBCustomContact
//
//  Created by Mac on 9/29/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
import CoreData

class MBUTILITY: NSObject {
   class func storeImageLocally(fileName : String, image : UIImage) -> Bool {
        let fileManager = FileManager.default
        do {
            let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
            let fileURL = documentDirectory.appendingPathComponent(fileName)
            let image = image
           // NSData *somenewImageData = UIImageJPEGRepresentation(newimg,1.0);
            if let imageData = image.jpegData(compressionQuality: 1.0) {
                try imageData.write(to: fileURL)
                return true
            }
        } catch {
            print(error)
        }
        return false
        
    }
    class  func addConatct(withModel : MBCreatedContactModel) -> Void {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let userEntity = NSEntityDescription.entity(forEntityName: "CustomConatct", in: managedContext)!
        let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
        
        user.setValue(withModel.firstName, forKeyPath: "firstName")
        if((withModel.lastName) != nil){
            user.setValue(withModel.lastName, forKeyPath: "lastName")
        }
        if((withModel.contentID) != nil){
            user.setValue(withModel.contentID, forKeyPath: "contentID")
        }
        user.setValue(withModel.mobileNo, forKeyPath: "mobileNo")
        user.setValue(withModel.emailId, forKeyPath: "email")
        user.setValue(withModel.countryID, forKeyPath: "countryID")

        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        // let formatter = DateFormatter()
        //formatter.dateFormat = "yyyy/MM/dd"
        // let date = formatter.date(from: "1990/10/08")
        // user.setValue(date, forKey: "date_of_birth")
        // user.setValue(0, forKey: "number_of_children")
        
        
    }
  class  func getContactModels() -> NSMutableArray {
        let arrayConatcs : NSMutableArray = NSMutableArray()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CustomConatct")
        //request.predicate = NSPredicate(format: "age = %@", "12")
        request.returnsObjectsAsFaults = false
        do {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return arrayConatcs }
            let managedContext = appDelegate.persistentContainer.viewContext
            
            let result = try managedContext.fetch(request)
            for data in result as! [NSManagedObject] {
                let contactObj: MBCreatedContactModel = MBCreatedContactModel()
                contactObj.lastName = data.value(forKey: "lastName") as? String
                contactObj.firstName = data.value(forKey: "firstName") as? String
                contactObj.countryID = data.value(forKey: "countryID") as? String
                contactObj.emailId = data.value(forKey: "email") as? String
                contactObj.contentID = data.value(forKey: "contentID") as? String
                contactObj.mobileNo = data.value(forKey: "mobileNo") as? String
                arrayConatcs.add(contactObj)
            }
            
        } catch {
            print("Failed")
            return arrayConatcs

        }
        return arrayConatcs
    }
  class  func getImageForContact(fileName : String) -> UIImage {
        let image : UIImage
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath          = paths.first
        {
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            image = UIImage(contentsOfFile: imageURL.path)!
            return image
        }else{
            image = UIImage.init(named: "default-Profile")!
        }
        return image
    }
}
