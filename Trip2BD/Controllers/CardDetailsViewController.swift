//
//  CardDetailsViewController.swift
//  Trip2BD
//
//  Created by Md. Mehedi Hasan Akash on 4/6/20.
//  Copyright © 2020 Code_x. All rights reserved.
//

import UIKit
import Alamofire

// for cards
struct CardAPIResponse: Decodable{
    let success: Bool?
    let data: [CardData]?
}

struct CardData: Decodable {
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

class CardDetailsViewController: UIViewController {
    @IBOutlet weak var cardServiceStatusLabel: UILabel!
    @IBOutlet weak var cardAvgRatingLabel: UILabel!
    @IBOutlet weak var cardDescriptionTextView: UITextView!
    @IBOutlet weak var cardDescriptionHeightConstrain: NSLayoutConstraint!
    @IBOutlet weak var cardServiceStatusIconImageView: UIImageView!
    @IBOutlet weak var cardPricePerDayLabel: UILabel!
    
    var cardIDReceived = ""
    var cardGuideID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //make image view circular
        cardServiceStatusIconImageView.layer.borderWidth = 0.25
        cardServiceStatusIconImageView.layer.masksToBounds = false
        cardServiceStatusIconImageView.layer.borderColor = UIColor.black.cgColor
        cardServiceStatusIconImageView.layer.cornerRadius = cardServiceStatusIconImageView.frame.height/2
        cardServiceStatusIconImageView.clipsToBounds = true
        
        self.getCardDetailsData()

        // Do any additional setup after loading the view.
    }
    
    // calling card details by id API
    func getCardDetailsData(){
        let cardDetailsParameter = ["id" : cardIDReceived,
                                     "api_key" : API.API_key] as [String: Any]
        
        Alamofire.request(API.baseURL + "/cards/ByID", method: .post, parameters: cardDetailsParameter).validate().responseJSON{
            response in
            if((response.result.value) != nil){
                do{
                    let cardDetails = try JSONDecoder().decode(CardAPIResponse.self, from: response.data!)
                    for card in cardDetails.data!{
                        self.cardAvgRatingLabel.text = String(Double(round(10*card.card_average_rating)/10))
                        self.cardDescriptionTextView.text = card.card_description
                        self.navigationItem.title = String(card.card_title)
                        self.cardPricePerDayLabel.text = String(card.price_per_day)
                        if card.service_status == 1{
                            self.cardServiceStatusLabel.text = "On Service"
                            self.cardServiceStatusIconImageView.image = UIImage(named: "orangeDotIcon")!
                        } else{
                            self.cardServiceStatusLabel.text = "Available"
                            self.cardServiceStatusIconImageView.image = UIImage(named: "greenDotIcon")!
                        }

                        self.cardDescriptionHeightConstrain.constant = self.cardDescriptionTextView.contentSize.height

                    }
                } catch{
                    print("We got an error while fetching service_cards table data!")
                }
            }
        }
    }

}
