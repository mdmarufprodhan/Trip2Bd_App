//
//  LoginViewController.swift
//  Trip2BD
//
//  Created by Md. Mehedi Hasan Akash on 3/18/20.
//  Copyright © 2020 Code_x. All rights reserved.
//

import UIKit
import Alamofire
import QuartzCore

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var rememberMeSwitch: UISwitch!
    
    var check = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.layer.cornerRadius = 6
        emailTextField.layer.masksToBounds = true
        passwordTextField.layer.cornerRadius = 6
        passwordTextField.layer.masksToBounds = true
        loginButton.layer.cornerRadius = 8
        rememberMeSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        let userEmail = emailTextField.text
        let userPassword = passwordTextField.text
        
        // Checking if the fields are empty
        if(userEmail == ""){
            self.displayAlertMessage("Email field is empty!", "Please enter your email.")
        } else if(userPassword == ""){
            self.displayAlertMessage("Password field is empty!", "Please enter the password.")
        } else if(userEmail != "" && userPassword != ""){
            //check if the email is valid
            if(isValidEmail(email: userEmail!)){
                let loginDictionary = ["email" : userEmail!,
                                       "password" : userPassword!,
                                       "api_key" : API.API_key] as [String : Any]
                
                //Calling the API
                Alamofire.request(API.baseURL + "/tourist/Login", method: .post, parameters: loginDictionary).validate().responseJSON {
                    response in
                    
                    //Showing response in log
                    print(response)
                    
                    if let result = response.result.value {
                        let JSON = result as! NSDictionary
                        print("Success = ")
                        print(JSON["success"]!)
                        self.check = JSON["success"] as! Bool
                        print(self.check)
                    }
                    
                    if(!self.check){
                        self.displayAlertMessage("Invalid Email ID or Password", "Please enter correct email and password.")
                    } else if(self.check){
                        do{
                            let loginResponseData = try JSONDecoder().decode(Tourist.self, from: response.data!)
                            let successMesage = loginResponseData.success
                            //let isVerified = loginResponseData.data[0].is_verified
                            let id = loginResponseData.data[0].id
                            //print(isVerified!)
                            print(id!)
                            
                            print(successMesage as Any)
                            
                            if(successMesage == true){
                                //if(isVerified == 0){
                                print("I am there!")
                                self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil); // .presentingViewController?.presentingViewController?
                                print("Passed there")
                                    //self.dismiss(animated: true, completion: nil)
                                    //self.performSegue(withIdentifier: "", sender: self)
                                //}
                            }
                        } catch{
                            print("Error while parsing JSON")
                        }
                    }
                }
            } else{
                displayAlertMessage("Invalid email", "Your email address is not valid")
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
