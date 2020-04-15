//
//  LNotificationDetailsViewController.swift
//  Trip2BD
//
//  Created by Md. Mehedi Hasan Akash on 4/15/20.
//  Copyright © 2020 Code_x. All rights reserved.
//

import UIKit
import Alamofire

class LNotificationDetailsViewController: UIViewController {
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var cardTitleLabel: UILabel!
    @IBOutlet weak var guideNameLabel: UILabel!
    @IBOutlet weak var cardPricePerDayLabel: UILabel!
    
    var lTouristGuideRelationIDReceived = ""
    var lIsAcceptedReceived = ""
    var lCardIDReceived = ""
    var lCardTitleReceived = ""
    var lCardPricePerDayReceived = ""
    var lGuideNameReceived = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cardTitleLabel.text = String(lCardTitleReceived)
        self.guideNameLabel.text = String(lGuideNameReceived)
        self.cardPricePerDayLabel.text = String(lCardPricePerDayReceived)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func tripCompletedButtonTapped(_ sender: Any) {
        if self.lIsAcceptedReceived == "1"{
            let tripCompletedParameter = ["id" : String(self.lTouristGuideRelationIDReceived),
                                         "is_accepted" : String(self.lIsAcceptedReceived),
                                         "is_complited" : 1,
                                         "is_cancelled_by_tourist" : 0,
                                         "is_cancelled_by_guide" : 0,
                                         "api_key" : API.API_key] as [String : Any]
            
            //Calling the API
            Alamofire.request(API.baseURL + "/tourist/updateTouristGuideRelation", method: .post, parameters: tripCompletedParameter).validate().responseJSON {
                response in
                //print(response)
            }
        } else{
            let requestIsNotAcceptedYetAlert = UIAlertController(title: "Alert!", message: "Trip request is pending. You are not allowed to perform this operation.", preferredStyle: UIAlertController.Style.alert)
            
            requestIsNotAcceptedYetAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                
            }))
            
            present(requestIsNotAcceptedYetAlert, animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelTripButtonTapped(_ sender: Any) {
        if self.lIsAcceptedReceived == "0"{
            let requestIsNotAcceptedYetAlert = UIAlertController(title: "Alert!", message: "Trip request is pending. This operation will cancel the request without any cahrge. Press Ok to continue.", preferredStyle: UIAlertController.Style.alert)
            
            requestIsNotAcceptedYetAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                
                let tripCancelledParameter = ["id" : String(self.lTouristGuideRelationIDReceived),
                                              "is_accepted" : String(self.lIsAcceptedReceived),
                                              "is_complited" : 0,
                                              "is_cancelled_by_tourist" : 1,
                                              "is_cancelled_by_guide" : 0,
                                              "api_key" : API.API_key] as [String : Any]
                
                //Calling the API
                Alamofire.request(API.baseURL + "/tourist/updateTouristGuideRelation", method: .post, parameters: tripCancelledParameter).validate().responseJSON {
                    response in
                    //print(response)
                }
            }))
            
            requestIsNotAcceptedYetAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                //print("Handle Cancel Logic here")
            }))
            
            present(requestIsNotAcceptedYetAlert, animated: true, completion: nil)
        } else{
            let requestIsAcceptedAlert = UIAlertController(title: "Alert!", message: "Trip request is accepted already by Guide. Cancelling this trip will cost 20% penalty money. Press Ok to continue.", preferredStyle: UIAlertController.Style.alert)
            
            requestIsAcceptedAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                let tripCancelledParameter = ["id" : String(self.lTouristGuideRelationIDReceived),
                                              "is_accepted" : String(self.lIsAcceptedReceived),
                                              "is_complited" : 0,
                                              "is_cancelled_by_tourist" : 1,
                                              "is_cancelled_by_guide" : 0,
                                              "api_key" : API.API_key] as [String : Any]
                
                //Calling the API
                Alamofire.request(API.baseURL + "/tourist/updateTouristGuideRelation", method: .post, parameters: tripCancelledParameter).validate().responseJSON {
                    response in
                    //print(response)
                }
            }))
            
            requestIsAcceptedAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                //print("Handle Cancel Logic here")
            }))
            
            present(requestIsAcceptedAlert, animated: true, completion: nil)
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
