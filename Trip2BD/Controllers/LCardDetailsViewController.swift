//
//  LCardDetailsViewController.swift
//  Trip2BD
//
//  Created by Md. Mehedi Hasan Akash on 4/8/20.
//  Copyright © 2020 Code_x. All rights reserved.
//

import UIKit
import Alamofire

// for cards
struct LCardAPIResponse: Decodable{
    let success: Bool?
    let data: [LCardData]?
}

struct LCardData: Decodable {
    let id: Int
    //let guide_id: Int
    let card_title: String
    let card_description: String
    let price_per_hour: Int?
    let price_per_day: Int
    let place_ids: String?
    let card_average_rating: Double
    let service_status: Int
    let card_status: Int
    let card_category_tags: String?
}

class LCardDetailsViewController: UIViewController {

    @IBOutlet weak var lCardServiceStatusLabel: UILabel!
    @IBOutlet weak var lCardAvgRatingLabel: UILabel!
    @IBOutlet weak var lCardDescriptionTextView: UITextView!
    @IBOutlet weak var lCardServiceStatusIconImageView: UIImageView!
    @IBOutlet weak var lCardDescriptionHeightConstrain: NSLayoutConstraint!
    @IBOutlet weak var lCardPricePerDayLabel: UILabel!
    @IBOutlet weak var lCardTitleLabel: UILabel!
    
    var lCardIDReceived = ""
    var lCardGuideID = ""
    var lTouristID = ""
    var cardPricePerDay = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //make image view circular
        lCardServiceStatusIconImageView.layer.borderWidth = 0.25
        lCardServiceStatusIconImageView.layer.masksToBounds = false
        lCardServiceStatusIconImageView.layer.borderColor = UIColor.black.cgColor
        lCardServiceStatusIconImageView.layer.cornerRadius = lCardServiceStatusIconImageView.frame.height/2
        lCardServiceStatusIconImageView.clipsToBounds = true
        
        self.lGetCardDetailsData()
    }

    // calling card details by id API
    func lGetCardDetailsData(){
        let lCardDetailsParameter = ["id" : lCardIDReceived,
                                    "api_key" : API.API_key] as [String: Any]
        
        Alamofire.request(API.baseURL + "/cards/ByID", method: .post, parameters: lCardDetailsParameter).validate().responseJSON{
            response in
            if((response.result.value) != nil){
                do{
                    let lCardDetails = try JSONDecoder().decode(LCardAPIResponse.self, from: response.data!)
                    for card in lCardDetails.data!{
                        self.lCardAvgRatingLabel.text = String(Double(round(10*card.card_average_rating)/10))
                        self.lCardDescriptionTextView.text = card.card_description
                        self.lCardTitleLabel.text = String(card.card_title)
                        self.lCardPricePerDayLabel.text = String(card.price_per_day)
                        self.cardPricePerDay = String(card.price_per_day)
                        if card.service_status == 1{
                            self.lCardServiceStatusLabel.text = "On Service"
                            self.lCardServiceStatusIconImageView.image = UIImage(named: "orangeDotIcon")!
                        } else{
                            self.lCardServiceStatusLabel.text = "Available"
                            self.lCardServiceStatusIconImageView.image = UIImage(named: "greenDotIcon")!
                        }
                        
                        self.lCardDescriptionHeightConstrain.constant = self.lCardDescriptionTextView.contentSize.height
                    }
                } catch{
                    print("We got an error while fetching service_cards table data!")
                }
            }
        }
    }
    
    @IBAction func buyThisCardButtonTapped(_ sender: Any) {
        let cardPurchaseAlert = UIAlertController(title: "Alert!", message: "You are about to purchace this card. This guide will charge \(self.cardPricePerDay) Dollars per day. You will be notified when this guide accepts and then can plan your tour. Press Ok to proceed.", preferredStyle: UIAlertController.Style.alert)
        
        cardPurchaseAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            let setGuideTouristRelationParameter = ["card_id" : self.lCardIDReceived,
                                                    "tourists_id" : self.lTouristID,
                                                    "guide_id" : self.lCardGuideID,
                                                    "is_accepted" : 0,
                                                    "is_complited" : 0,
                                                    "is_cancelled_by_tourist" : 0,
                                                    "is_cancelled_by_guide" : 0,
                                                    "api_key" : API.API_key] as [String: Any]
            
            Alamofire.request(API.baseURL + "/tourist/setTouristGuideRelation", method: .post, parameters: setGuideTouristRelationParameter).validate().responseJSON{
                response in
                //print(response)
            }
        }))
        
        cardPurchaseAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            //print("Handle Cancel Logic here")
        }))
        
        present(cardPurchaseAlert, animated: true, completion: nil)
    }
    
    @IBAction func homeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
