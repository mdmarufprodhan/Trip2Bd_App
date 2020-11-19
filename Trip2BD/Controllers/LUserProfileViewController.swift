//
//  LUserProfileViewController.swift
//  Trip2BD
//
//  Created by Md. Mehedi Hasan Akash on 4/6/20.
//  Copyright © 2020 Code_x. All rights reserved.
//

import UIKit
import Alamofire

// for tourist profile
struct LProfileApiResponse: Decodable{
    let success: Bool?
    let data: [LProfile]?
}

struct LProfile: Decodable {
    let id: Int
    let first_name: String
    let last_name: String
    let email: String
    //let email_verified_at: String
    let image: String
    let gender: String
    let phone_no: String
    let date_of_birth: String
    let country: String
    let created_at: String
    let updated_at: String
}

// for tourist bank info
struct LBankApiResponse: Decodable{
    let success: Bool?
    let data: [LBank]?
}

struct LBank: Decodable {
    let id: Int
    let tourists_id: Int
    let credit_card_no: String
    let created_at: String
    let updated_at: String
}

// for tourist passport info
struct LPassportApiResponse: Decodable{
    let success: Bool?
    let data: [LPassport]?
}

struct LPassport: Decodable {
    let id: Int
    let tourists_id: Int
    let passport_no: String
    let passport_image: String
    let visa_image: String
    let created_at: String
    let updated_at: String
}

class LUserProfileViewController: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileFullNameTextField: UITextField!
    @IBOutlet weak var profileEmailTextField: UITextField!
    @IBOutlet weak var profileGenderTextField: UITextField!
    @IBOutlet weak var profileDateOfBirthTextField: UITextField!
    @IBOutlet weak var profilePhoneNumberTextField: UITextField!
    @IBOutlet weak var profileCountryTextField: UITextField!
    @IBOutlet weak var profileCreditCardNoTextField: UITextField!
    @IBOutlet weak var profilePassportNoTextField: UITextField!
    
    var loggedInUserIDReceived = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //make image view circular
        profileImageView.layer.borderWidth = 0.25
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.borderColor = UIColor.black.cgColor
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.clipsToBounds = true
        
        self.getTouristProfileAPIData()
        
    }
    
    func getTouristProfileAPIData(){
        let touristProfileParameter = ["id" : self.loggedInUserIDReceived,
                                       "api_key" : API.API_key] as [String : Any]
        
        // calling getTouristProfileByIDSelf API
        Alamofire.request(API.baseURL + "/tourist/ProfileSelf", method: .post, parameters: touristProfileParameter).validate().responseJSON{
            response in
            //print(response)
            if((response.result.value) != nil){
                do{
                    let touristProfileDataAll = try JSONDecoder().decode(LProfileApiResponse.self, from: response.data!)
                    //print(touristProfileDataAll)
                    for touristProfileData in touristProfileDataAll.data!{
                        self.profileFullNameTextField.text = String(touristProfileData.first_name + " " + touristProfileData.last_name)
                        self.profileEmailTextField.text = String(touristProfileData.email)
                        self.profileGenderTextField.text = String(touristProfileData.gender)
                        self.profileDateOfBirthTextField.text = String(touristProfileData.date_of_birth)
                        self.profilePhoneNumberTextField.text = String(touristProfileData.phone_no)
                        self.profileCountryTextField.text = String(touristProfileData.country)
                    }
                } catch{
                    print("We got an error to get Tourist Profile info!")
                }
            }
        }
        
        // bank info
        let touristBankInfoParameter = ["id" : self.loggedInUserIDReceived,
                                       "api_key" : API.API_key] as [String : Any]
        
        // calling getTouristBankInfoByID API
        Alamofire.request(API.baseURL + "/tourist/ProfileBankInfo", method: .post, parameters: touristBankInfoParameter).validate().responseJSON{
            response in
            //print(response)
            if((response.result.value) != nil){
                do{
                    let touristBankDataAll = try JSONDecoder().decode(LBankApiResponse.self, from: response.data!)
                    //print(touristBankDataAll)
                    for touristBankData in touristBankDataAll.data!{
                        self.profileCreditCardNoTextField.text = String(touristBankData.credit_card_no)
                    }
                } catch{
                    print("We got an error to get Tourist Bank info!")
                }
            }
        }
        
        // passport info
        let touristPassportInfoParameter = ["id" : self.loggedInUserIDReceived,
                                        "api_key" : API.API_key] as [String : Any]
        
        // calling getTouristProfilePassportByID API
        Alamofire.request(API.baseURL + "/tourist/ProfilePassport", method: .post, parameters: touristPassportInfoParameter).validate().responseJSON{
            response in
            //print(response)
            if((response.result.value) != nil){
                do{
                    let touristPassportDataAll = try JSONDecoder().decode(LPassportApiResponse.self, from: response.data!)
                    //print(touristPassportDataAll)
                    for touristPassportData in touristPassportDataAll.data!{
                        self.profilePassportNoTextField.text = String(touristPassportData.passport_no)
                    }
                } catch{
                    print("We got an error to get Tourist Passport info!")
                }
            }
        }
    }
    
}
