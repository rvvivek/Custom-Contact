//
//  MBSelectCountryViewController.swift
//  MBCustomContact
//
//  Created by Mac on 9/29/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
@objc protocol sendingCountryDataDelegate:NSObjectProtocol {
     func contactModelToCreateScreen(_ modelClas: CountryModel?)
    
}

class MBSelectCountryViewController: UIViewController , UITableViewDelegate, UITableViewDataSource  {
    weak var contactDelegate: sendingCountryDataDelegate?

    var countryCodesArray = NSArray()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.countryCodesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryNameCell", for: indexPath as IndexPath)
        let objCountryModel : CountryModel = self.countryCodesArray.object(at: indexPath.row) as! CountryModel
        cell.textLabel?.text = objCountryModel.name
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let modelSelected : CountryModel = self.countryCodesArray.object(at: indexPath.row) as! CountryModel
        self.contactDelegate?.contactModelToCreateScreen(modelSelected)
        self.navigationController?.popViewController(animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
