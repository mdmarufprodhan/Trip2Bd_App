//
//  GuideDetailsViewController.swift
//  Trip2BD
//
//  Created by Md. Mehedi Hasan Akash on 4/7/20.
//  Copyright © 2020 Code_x. All rights reserved.
//

import UIKit
import Alamofire

// for guides
struct GuideAPIResponse: Decodable{
    let success: Bool?
    let data: [GuideData]?
}

struct GuideData: Decodable {
    let id: Int
    let first_name: String
    let last_name: String
    let email: String
    let image: String
    let gender: String
    let phone_no: String
    let date_of_birth: String
    let is_available: Int
    let urgent_availability: Int
    let ratings: Double
}

class GuideDetailsViewController: UIViewController {
    @IBOutlet weak var guideProfileImageView: UIImageView!
    @IBOutlet weak var guideNameLabel: UILabel!
    @IBOutlet weak var guideAgeAndGenderLabel: UILabel!
    @IBOutlet weak var guideRatingAndReviewLabel: UILabel!
    @IBOutlet weak var guideUrgentAvailabilityLabel: UILabel!
    
    var guideIDReceived = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.guideDataLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func guideDataLoad(){
        let guideDetailsParameter = ["id" : guideIDReceived,
                                    "api_key" : API.API_key] as [String: Any]
        
        Alamofire.request(API.baseURL + "/guides/details", method: .post, parameters: guideDetailsParameter).validate().responseJSON{
            response in
            if((response.result.value) != nil){
                do{
                    let guideDetails = try JSONDecoder().decode(GuideAPIResponse.self, from: response.data!)
                    for guide in guideDetails.data!{
                        self.guideNameLabel.text = String(guide.first_name + " " + guide.last_name)
                        self.guideAgeAndGenderLabel.text = String(guide.gender)
                        self.guideRatingAndReviewLabel.text = String(Double(round(10*guide.ratings)/10))
                        if guide.urgent_availability == 1{
                            self.guideUrgentAvailabilityLabel.text = "Available for urgent guide service."
                        }
                    }
                } catch{
                    print("We got an error while fetching guides table data!")
                }
            }
        }
    }
    
    @IBAction func guideCardsButtonTapped(_ sender: Any) {
        
    }

}
