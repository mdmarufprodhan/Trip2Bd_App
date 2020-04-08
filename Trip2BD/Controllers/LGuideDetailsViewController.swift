//
//  LGuideDetailsViewController.swift
//  Trip2BD
//
//  Created by Md. Mehedi Hasan Akash on 4/8/20.
//  Copyright © 2020 Code_x. All rights reserved.
//

import UIKit
import Alamofire

// for guides
struct LGuideAPIResponse: Decodable{
    let success: Bool?
    let data: [LGuideData]?
}

struct LGuideData: Decodable {
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

class LGuideDetailsViewController: UIViewController {
    @IBOutlet weak var lGuideProfileImageView: UIImageView!
    @IBOutlet weak var lGuideNameLabel: UILabel!
    @IBOutlet weak var lGuideAgeAndGenderLabel: UILabel!
    @IBOutlet weak var lGuideRatingAndReviewLabel: UILabel!
    @IBOutlet weak var lGuideUrgentAvailabilityLabel: UILabel!
    
    var lGuideIDReceived = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lGuideDataLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func lGuideDataLoad(){
        let lGuideDetailsParameter = ["id" : lGuideIDReceived,
                                     "api_key" : API.API_key] as [String: Any]
        
        Alamofire.request(API.baseURL + "/guides/details", method: .post, parameters: lGuideDetailsParameter).validate().responseJSON{
            response in
            if((response.result.value) != nil){
                do{
                    let lGuideDetails = try JSONDecoder().decode(LGuideAPIResponse.self, from: response.data!)
                    for guide in lGuideDetails.data!{
                        self.lGuideNameLabel.text = String(guide.first_name + " " + guide.last_name)
                        self.lGuideAgeAndGenderLabel.text = String(guide.gender)
                        self.lGuideRatingAndReviewLabel.text = String(Double(round(10*guide.ratings)/10))
                        if guide.urgent_availability == 1{
                            self.lGuideUrgentAvailabilityLabel.text = "Available for urgent guide service."
                        }
                    }
                } catch{
                    print("We got an error while fetching guides table data!")
                }
            }
        }
    }
    
    @IBAction func lGuideCardsButtonTapped(_ sender: Any) {
        
    }

    @IBAction func lHomeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
