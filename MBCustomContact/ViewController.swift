//
//  ViewController.swift
//  MBCustomContact
//
//  Created by Mac on 9/27/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
import CoreData
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    @IBOutlet weak var searchBarContact: UISearchBar!
    @IBOutlet weak var noContactLabel: UILabel!
    @IBOutlet weak var buttonAddContact: UIButton!
    @IBOutlet weak var tableViewObj: UITableView!
    var mySearchBarActive = false
    var filtered:[MBCreatedContactModel] = []
    var arrayContacts   = [MBCreatedContactModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.mySearchBarActive = false
        self.tabBarController?.tabBar.isHidden = true;
        self.tableViewObj.tableFooterView = UITableViewHeaderFooterView()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.arrayContacts = MBUTILITY.getContactModels() as! [MBCreatedContactModel]
        if self.arrayContacts.count == 0 && self.filtered.count == 0 {
            self.tableViewObj.isHidden = true
            self.noContactLabel.isHidden = false
        }else{
            self.tableViewObj.isHidden = false
            self.noContactLabel.isHidden = true
        }
        self.tableViewObj.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.mySearchBarActive = false

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.mySearchBarActive == true {
            return filtered.count
        }else{
            return arrayContacts.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell :MBConatctDisplayTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath as IndexPath) as! MBConatctDisplayTableViewCell
        let modelContact : MBCreatedContactModel
        if self.mySearchBarActive == true{
            modelContact = self.filtered[indexPath.row]
        }else{
            modelContact = self.arrayContacts[indexPath.row]
        }
        cell.titleContact.text = modelContact.firstName! + " " + modelContact.lastName!
        cell.subtitleContact.text = modelContact.mobileNo
        if((modelContact.contentID) != nil){
            cell.displayImage.image = MBUTILITY.getImageForContact(fileName: modelContact.contentID!)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Num: \(indexPath.row)")
       // print("Value: \(myArray[indexPath.row])")
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.mySearchBarActive = true;
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
       filtered = self.arrayContacts.filter({($0.firstName!.localizedCaseInsensitiveContains(searchText))||($0.lastName!.localizedCaseInsensitiveContains(searchText))})
        if(filtered.count == 0 && (searchText.count==0)){
            self.mySearchBarActive = false;
        } else {
            self.mySearchBarActive = true;
        }
        self.tableViewObj.reloadData()
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.mySearchBarActive = true;
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.mySearchBarActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.mySearchBarActive = false;
        self.searchBarContact.resignFirstResponder()
    }
}

