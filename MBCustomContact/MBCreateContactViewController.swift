//
//  MBCreateContactViewController.swift
//  MBCustomContact
//
//  Created by Mac on 9/27/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
import Alamofire


class MBCreateContactViewController: UIViewController, UITableViewDelegate,UITextFieldDelegate, UITableViewDataSource, sendingCountryDataDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate  {
    @IBOutlet weak var selectCountryButton: UIButton!
   
    @IBOutlet weak var createConactButton: UIButton!
    @IBOutlet weak var profileViewPicture: UIImageView!
    var selectedModel = CountryModel()
    var createdContactModel = MBCreatedContactModel()
    @IBOutlet weak var selectPhotoButton: UIButton!
    @IBOutlet weak var tableviewCreateContact: UITableView!
    var imagePicker = UIImagePickerController()

    let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
    let okBackAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
    var countryCodesArray = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.tableviewCreateContact.tableFooterView = UITableViewHeaderFooterView()
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false

        let notifier = NotificationCenter.default
    notifier.addObserver(self,selector:#selector(self.keyboardWillShowNotification(_:)),name: UIWindow.keyboardWillShowNotification,object: nil)
    notifier.addObserver(self,selector:#selector(self.keyboardWillHideNotification(_:)),name: UIWindow.keyboardWillHideNotification,object: nil)
        

        view.addGestureRecognizer(tap)
        self.profileViewPicture.layer.cornerRadius = 60.0
        self.profileViewPicture.clipsToBounds = true
        self.getCountryWebservice()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell :MBContactTableViewCell = tableView.dequeueReusableCell(withIdentifier: "firstNameCell", for: indexPath as IndexPath) as! MBContactTableViewCell
            cell.firstNameField.tag = 1001
            cell.firstNameField.delegate = self
            return cell

        }else if indexPath.row == 1 {
            let cell :MBContactTableViewCell = tableView.dequeueReusableCell(withIdentifier: "lastNameCell", for: indexPath as IndexPath) as! MBContactTableViewCell
            cell.lastNameField.tag = 1002
            cell.lastNameField.delegate = self

            return cell

        }
        else if indexPath.row == 2 {
            let cell:MBContactTableViewCell = tableView.dequeueReusableCell(withIdentifier: "mobileCell", for: indexPath as IndexPath) as! MBContactTableViewCell
            cell.mobileNoField.tag = 1003
            cell.mobileNoField.delegate = self
            return cell

        }
        else if indexPath.row == 3 {
            let cell:MBContactTableViewCell = tableView.dequeueReusableCell(withIdentifier: "emailCell", for: indexPath as IndexPath) as! MBContactTableViewCell
            cell.emailDField.tag = 1004
            cell.emailDField.delegate = self
            return cell
        }
        else {
            let cell:MBContactTableViewCell = tableView.dequeueReusableCell(withIdentifier: "countryCell", for: indexPath as IndexPath) as! MBContactTableViewCell
            cell.selectCountryButton.addTarget(self, action: #selector(actionSelectCountry), for: UIControl.Event.touchUpInside)
            if (selectedModel.name != nil)
            {
                cell.selectCountryButton.setTitle(selectedModel.name, for: .normal)
            }
            cell.selectionStyle = .none

            return cell

        }

        // cell.textLabel!.text = "\(myArray[indexPath.row])"
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Num: \(indexPath.row)")
        // print("Value: \(myArray[indexPath.row])")
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @objc func actionSelectCountry() {
        self.performSegue(withIdentifier: "selectCountSeg", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectCountSeg" {
            let viewControllerDest : MBSelectCountryViewController = segue.destination as! MBSelectCountryViewController
            viewControllerDest.countryCodesArray = self.countryCodesArray
            viewControllerDest.contactDelegate = self
        }
    }
    func getCountryWebservice()  {
        let URL = "https://restcountries.eu/rest/v1/all"
        Alamofire.request(URL, method: .get).responseJSON { response in
            print(response.result.value ?? "")
            if let JSON = response.result.value {
                if let arrayCountry = JSON as? NSArray {
                    let countryArray: NSMutableArray = NSMutableArray()
                    for countryMap in arrayCountry {
                        if let  responseValue = countryMap as? NSDictionary {
                            let objModel : CountryModel = CountryModel()
                            objModel.name = responseValue["name"] as? String
                            objModel.countryCode = responseValue["alpha2Code"] as? String
                            countryArray.add(objModel)
                        }
                    }
                    self.countryCodesArray = countryArray
//                    if let  responseValue = dict["ResponseValue"] as? NSDictionary {
//                        let mobileNo = responseValue["Mobile"] as? String
//                        let partnerId = responseValue["PartnerId"] as? Int
//
//                        }
                    
                    }
                }
            }
    }

    
    /**
     - parameter name: The any text field string, requested for name validations
     
     */
     func isValidName(_ name : String) -> Bool {
        let nameRegEx = "[a-zA-z]+([ '-][a-zA-Z]+)*$"
        let range = name.range(of: nameRegEx, options:.regularExpression)
        let result = range != nil ? true : false
        return result
    }
    
    // Validate phone number string.
    /**
     :param phoneNumber The number from text field
     */
     func isPhoneValidate(_ phoneNumber: String) -> Bool {
        let phoneRegex = "[0-9]{10,10}$"
        let range = phoneNumber.range(of: phoneRegex, options:.regularExpression)
        let result = range != nil ? true : false
        return result
    }
    
    // Email validation regex
    /**
     - parameter testStr: The email id string
     */
    func isValidEmail(_ testStr: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let range = testStr.range(of: emailRegEx, options:.regularExpression)
        let result = range != nil ? true : false
        return result
    }
    func validate(value: String) -> Bool {
        let PHONE_REGEX = "^((\\+)|(00))[0-9]{6,14}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    func contactModelToCreateScreen(_ modelClas: CountryModel?){
        self.selectedModel = modelClas as! CountryModel
        self.createdContactModel.countryID = self.selectedModel.countryCode
        self.tableviewCreateContact.reloadData()
    }
    @IBAction func btnClicked() {
        
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
            
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func cameraAction(_ sender: Any) {
        self.showActionSheet()
    }
    @IBAction func openCameraButton(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    @IBAction func openPhotoLibraryButton(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    // MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker .dismiss(animated: true, completion: nil)
        let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
//        let desiredSize = CGSize(width: 120, height: 120)
//        let resizedImage = self.resizeImage(image: imageSelected!, targetSize: desiredSize)
        profileViewPicture.image = imageSelected;
        let randomInt = Int.random(in: 0..<2000)
        let fileName = "img_" + String(randomInt)
        let stored : Bool = MBUTILITY.storeImageLocally(fileName:fileName , image:imageSelected!)
        if stored{
            self.createdContactModel.contentID = fileName
        }
        print(stored)
        profileViewPicture.contentMode = .scaleAspectFill

    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker .dismiss(animated: true, completion: nil)
        print("picker cancel.")
    }
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    func showActionSheet() {
        let alertController = UIAlertController(title: "Select profile photo from :", message:nil, preferredStyle: .actionSheet)
        
        let sendButton = UIAlertAction(title: "Camera", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
            self.openCameraButton(sender: self)

        })
        
        let  deleteButton = UIAlertAction(title: "Choose from Gallery", style: .default, handler: { (action) -> Void in
            print("Delete button tapped")
            self.openPhotoLibraryButton(sender: self)
        })
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            print("Cancel button tapped")
        })
        
        
        alertController.addAction(sendButton)
        alertController.addAction(deleteButton)
        alertController.addAction(cancelButton)
        
        self.navigationController!.present(alertController, animated: true, completion: nil)
    }
    func textFieldActive() {
//        if(mobileNumber.text?.characters.count == 10) {
//           // nextButton.isHidden = false
//        } else {
//          //  nextButton.isHidden = true
//        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let nsString = textField.text as NSString?
        let newString = nsString?.replacingCharacters(in: range, with: string)
        if textField.tag == 1001
        {
            self.createdContactModel.firstName = newString
        }else if textField.tag == 1002 {
            self.createdContactModel.lastName = newString
        }else if textField.tag == 1003 {
            self.createdContactModel.mobileNo = newString
        }
        else if textField.tag == 1004 {
            self.createdContactModel.emailId = newString
        }

        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    @IBAction func createContactAction(_ sender: Any) {
        // first name can't be nil & needs to be validated

        if (self.createdContactModel.firstName != nil){
            if !self.isValidName(self.createdContactModel.firstName!){
                let myAlert = UIAlertController(title: "Alert",
                                                message: "Please enter valid first name ",
                                                preferredStyle: UIAlertController.Style.alert)
                myAlert.addAction(self.okAction)
                self.present(myAlert, animated: true, completion: nil)
                self.tableviewCreateContact.reloadData()
                return
            }
        }else{
            let myAlert = UIAlertController(title: "Alert",
                                            message: "Please enter your first name",
                                            preferredStyle: UIAlertController.Style.alert)
            myAlert.addAction(self.okAction)
            self.present(myAlert, animated: true, completion: nil)
            self.tableviewCreateContact.reloadData()
            return

        }
        // last name can be nil but if provided needs to be validated
        if((self.createdContactModel.lastName) != nil){
            if !self.isValidName(self.createdContactModel.lastName!){
                let myAlert = UIAlertController(title: "Alert",
                                                message: "Please enter valid last name ",
                                                preferredStyle: UIAlertController.Style.alert)
                myAlert.addAction(self.okAction)
                self.present(myAlert, animated: true, completion: nil)
                self.tableviewCreateContact.reloadData()
                return
            }
        }
        // email can't be nil & needs to be validated
        if (self.createdContactModel.emailId != nil){
            if !self.isValidEmail(self.createdContactModel.emailId!){
                let myAlert = UIAlertController(title: "Alert",
                                                message: "Please enter valid email id",
                                                preferredStyle: UIAlertController.Style.alert)
                myAlert.addAction(self.okAction)
                self.present(myAlert, animated: true, completion: nil)
                self.tableviewCreateContact.reloadData()
                return
            }

        }else{
            let myAlert = UIAlertController(title: "Alert",
                                            message: "Please enter email id",
                                            preferredStyle: UIAlertController.Style.alert)
            myAlert.addAction(self.okAction)
            self.present(myAlert, animated: true, completion: nil)
            self.tableviewCreateContact.reloadData()
            return

        }
        // mobile no can't be nil & needs to be validated

        if(self.createdContactModel.mobileNo != nil){
            if !self.validate(value: self.createdContactModel.mobileNo!){
                let myAlert = UIAlertController(title: "Alert",
                                                message: "Please enter valid mobile no",
                                                preferredStyle: UIAlertController.Style.alert)
                myAlert.addAction(self.okAction)
                self.present(myAlert, animated: true, completion: nil)
                self.tableviewCreateContact.reloadData()

                return

            }
        }else{
            let myAlert = UIAlertController(title: "Alert",
                                            message: "Please enter your mobile no",
                                            preferredStyle: UIAlertController.Style.alert)
            myAlert.addAction(self.okAction)
            self.present(myAlert, animated: true, completion: nil)
            self.tableviewCreateContact.reloadData()
            return

        }
        if(self.createdContactModel.countryID == nil){
            let myAlert = UIAlertController(title: "Alert",
                                            message: "Please select your country code.",
                                            preferredStyle: UIAlertController.Style.alert)
            myAlert.addAction(self.okAction)
            self.present(myAlert, animated: true, completion: nil)
            self.tableviewCreateContact.reloadData()
            return
        }
        if(self.createdContactModel.contentID == nil){
            let myAlert = UIAlertController(title: "Alert",
                                            message: "Please add profile image for contact.",
                                            preferredStyle: UIAlertController.Style.alert)
            myAlert.addAction(self.okAction)
            self.present(myAlert, animated: true, completion: nil)
            self.tableviewCreateContact.reloadData()
            return

        }
        MBUTILITY.addConatct(withModel: self.createdContactModel)
        self.showConatctList()
    }
    func showConatctList() {
        let refreshAlert = UIAlertController(title: "Success", message: "Contact has been saved.", preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            self.navigationController?.popViewController(animated: true)
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    // Mark keyboard notifications
    @objc func keyboardWillHideNotification(_ notification: NSNotification) {
        let edgeIns: UIEdgeInsets = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        self.tableviewCreateContact.contentInset = edgeIns
        self.tableviewCreateContact.scrollIndicatorInsets = edgeIns


    }
    
    @objc func keyboardWillShowNotification(_ notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo["UIKeyboardFrameEndUserInfoKey"] as? NSValue)?.cgRectValue
            let edgeIns: UIEdgeInsets = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: (endFrame?.size.height)!+30, right: 0.0)
            self.tableviewCreateContact.contentInset = edgeIns
            self.tableviewCreateContact.scrollIndicatorInsets = edgeIns


        }
    }
}
