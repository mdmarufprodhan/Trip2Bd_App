//
//  RegistrationPageViewController.swift
//  Trip2BD
//
//  Created by Md. Mehedi Hasan Akash on 3/27/20.
//  Copyright © 2020 Code_x. All rights reserved.
//

import UIKit
import Alamofire
import Foundation

// for tourist registration
//struct RegApiResponse: Decodable{
//    let access_token: String?
//    let tourist: [RegProfile]?
//}
//
//struct RegProfile: Decodable {
//    let id: Int
//    let first_name: String?
//    let last_name: String?
//    let email: String?
//    //let email_verified_at: String
//    let image: String?
//    let gender: String?
//    let phone_no: String?
//    let date_of_birth: String?
//    let country: String?
//    let created_at: String?
//    let updated_at: String?
//}

// MARK: - RegAPIResponse
struct RegAPIResponse: Codable {
    let tourist: NTourist
    let accessToken: String
    
    enum CodingKeys: String, CodingKey {
        case tourist
        case accessToken = "access_token"
    }
}

// MARK: - Tourist
struct NTourist: Codable {
    let firstName, lastName, email, image: String
    let gender, phoneNo, dateOfBirth, country: String
    let updatedAt, createdAt: String
    let id: Int
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case email, image, gender
        case phoneNo = "phone_no"
        case dateOfBirth = "date_of_birth"
        case country
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case id
    }
}

class RegistrationPageViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    

    @IBOutlet weak var profieImageView: UIImageView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var passportNoTextField: UITextField!
    @IBOutlet weak var creditCardNoTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var reEnterPasswordTextField: UITextField!
    
    var selectedGender: String?
    var genderList = ["Female", "Male", "Other"]
    var datePicker = UIDatePicker()
    
    var touristID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //make image view circular
        profieImageView.layer.borderWidth = 1
        profieImageView.layer.masksToBounds = false
        profieImageView.layer.borderColor = UIColor.black.cgColor
        profieImageView.layer.cornerRadius = profieImageView.frame.height/2
        profieImageView.clipsToBounds = true
        
        // submit button radius
        submitButton.layer.cornerRadius = 8
        
        
        self.createPickerView()
        self.dismissPickerView()
        
        self.showDatePicker()
        
    }
    
    // for picker view setup
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genderList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genderList[row] // dropdown item
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedGender = genderList[row] // selected item
        genderTextField.text = selectedGender
    }
    
    // for gender picker
    func createPickerView() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        genderTextField.inputView = pickerView
    }
    
    func dismissPickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(self.action))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        genderTextField.inputAccessoryView = toolBar
    }
    
    @objc func action() {
        view.endEditing(true)
    }
    
    // for date picker
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        dateOfBirthTextField.inputAccessoryView = toolbar
        dateOfBirthTextField.inputView = datePicker
        
    }
    
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        dateOfBirthTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        let firstName = firstNameTextField.text
        let lastName = lastNameTextField.text
        let gender = genderTextField.text
        let dateOfBirth = dateOfBirthTextField.text
        let email = emailTextField.text
        let phoneNo = phoneNumberTextField.text
        let country = countryTextField.text
        let passportNo = passportNoTextField.text
        let creditCardNo = creditCardNoTextField.text
        let password = passwordTextField.text
        let reEnterPassword = reEnterPasswordTextField.text
        
        // Checking if the fields are empty
        if(firstName == ""){
            self.displayAlertMessage("First Name field is empty!", "Please enter your First Name.")
        } else if(lastName == ""){
            self.displayAlertMessage("Last Name field is empty!", "Please enter your Last Name.")
        } else if(gender == ""){
            self.displayAlertMessage("Gender field is empty!", "Please select your Gender .")
        } else if(dateOfBirth == ""){
            self.displayAlertMessage("Date Of Birth field is empty!", "Please select your Date Of Birth.")
        } else if(email == ""){
            self.displayAlertMessage("Email field is empty!", "Please enter your valid Email.")
        } else if(phoneNo == ""){
            self.displayAlertMessage("Phone No field is empty!", "Please enter your valid Phone Number.")
        } else if(country == ""){
            self.displayAlertMessage("Country field is empty!", "Please enter your Country Name.")
        } else if(passportNo == ""){
            self.displayAlertMessage("Passport No field is empty!", "Please enter your valid Passport Number.")
        } else if(creditCardNo == ""){
            self.displayAlertMessage("Credit Card No field is empty!", "Please enter your Credit Card Number.")
        } else if(password == ""){
            self.displayAlertMessage("Password field is empty!", "Please enter your account Password.")
        } else if(reEnterPassword == ""){
            self.displayAlertMessage("Re Enter Password field is empty!", "Please re enter your account Password.")
        } else if(firstName != "" && lastName != "" && gender != "" && dateOfBirth != "" && email != "" && phoneNo != "" && country != "" && passportNo != "" && creditCardNo != "" && password != "" && reEnterPassword != ""){
            if (isValidEmail(email: email!)){
                if password == reEnterPassword{
                    let image = "profileAvatar"
                    let registrationParameter = ["first_name" : firstName!,
                                                 "last_name" : lastName!,
                                                 "email" : email!,
                                                 "password" : password!,
                                                 "image" : image,
                                                 "gender" : gender!,
                                                 "phone_no" : phoneNo!,
                                                 "date_of_birth" : dateOfBirth!,
                                                 "country" : country!,
                                                 "password_confirmation" : reEnterPassword!,
                                                 "api_key" : API.API_key] as [String : Any]
                    
                    //Calling the API
                    Alamofire.request(API.baseURL + "/tourist/registration", method: .post, parameters: registrationParameter).validate().responseJSON {
                        response in
                        //print(response)
                        if((response.result.value) != nil){
                            //let newTouristID = response.data.objectForKey("tourist")! as [[String:AnyObject]]
                            do{
                                let touristProfileDataAll = try JSONDecoder().decode(RegAPIResponse.self, from: response.data!)
                                //print(touristProfileDataAll)
                                //print(touristProfileDataAll.tourist.id)
                                self.touristID = String(touristProfileDataAll.tourist.id)
                                let registrationBankInfoParameter = ["tourists_id" : String(touristProfileDataAll.tourist.id),
                                                             "credit_card_no" : creditCardNo!,
                                                             "api_key" : API.API_key] as [String : Any]

                                //Calling the API
                                Alamofire.request(API.baseURL + "/tourist/BankInfo", method: .post, parameters: registrationBankInfoParameter).validate().responseJSON {
                                    response in
                                    //print(response)
                                }

                                let passportImage = "passportImage"
                                let visaImage = "visaImage"

                                let registrationPassportParameter = ["tourists_id" : String(touristProfileDataAll.tourist.id),
                                                                     "passport_no" : passportNo!,
                                                                     "passport_image" : passportImage,
                                                                     "visa_image" : visaImage,
                                                                     "api_key" : API.API_key] as [String : Any]

                                //Calling the API
                                Alamofire.request(API.baseURL + "/tourist/Passport", method: .post, parameters: registrationPassportParameter).validate().responseJSON {
                                    response in
                                    //print(response)
                                }
                                
                                let regAlert = UIAlertController(title: "Alert!", message: "Successfully registered. Press Ok to continue.", preferredStyle: UIAlertController.Style.alert)
                                
                                regAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                                    self.dismiss(animated: true, completion: nil)
                                }))
                                
                                self.present(regAlert, animated: true, completion: nil)
                                
                            } catch{
                                print("We got an error to set Tourist Profile info!")
                            }
                        }
                    }
                    
                } else{
                    displayAlertMessage("Passwords did not match!", "Please provide same password entry in Password and Re Enter Password field.")
                }
                
            } else{
                displayAlertMessage("Invalid email!", "Your email address is not valid. Please use valid email address.")
            }
        }
    }
    
    //function to display alert message
    func displayAlertMessage(_ title: String, _ userMessage: String){
        let userAlert = UIAlertController(title: title, message: userMessage, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        userAlert.addAction(okAction)
        self.present(userAlert, animated: true, completion: nil)
    }
    
    //function to verify email address
    func isValidEmail(email: String) -> Bool{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
}
