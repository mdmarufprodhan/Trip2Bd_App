//
//  LPlaceDetailsViewController.swift
//  Trip2BD
//
//  Created by Md. Mehedi Hasan Akash on 4/6/20.
//  Copyright © 2020 Code_x. All rights reserved.
//

import UIKit
import Alamofire

// for places details
struct LPlaceDetailsApiResponse: Decodable{
    let success: Bool?
    let data: [LPlaceDetails]?
}

struct LPlaceDetails: Decodable {
    let id: Int
    let name: String
    let description: String
    let place_category_tags: String
    let location: String
}

//for avgRatings
struct LPlaceAvgRating: Decodable{
    let success: Bool?
    let data: [LPlaceRating]?
}

struct LPlaceRating: Decodable{
    let avg_rating: Double
}

class LPlaceDetailsViewController: UIViewController {
    @IBOutlet weak var lPlaceLocationLabel: UILabel!
    @IBOutlet weak var lPlaceDescriptionHeightConstrains: NSLayoutConstraint!
    @IBOutlet weak var lPlaceAvgRatingLabel: UILabel!
    @IBOutlet weak var lPlaceDescriptionTextView: UITextView!
    @IBOutlet weak var lPlaceTitleLabel: UILabel!
    
    var lPlaceIDReceived = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getPlaceDetailsData()
        self.placeAvgRatingData()
        
        //placeDescriptionTextViewHeightCons.constant = self.placeDescriptionTextView.contentSize.height
    }
    
    // calling place details by id API
    func getPlaceDetailsData(){
        let placeDetailsParameter = ["id" : lPlaceIDReceived,
                                     "api_key" : API.API_key] as [String: Any]
        
        Alamofire.request(API.baseURL + "/places/Details", method: .post, parameters: placeDetailsParameter).validate().responseJSON{
            response in
            if((response.result.value) != nil){
                do{
                    let placeDetailsPlaces = try JSONDecoder().decode(LPlaceDetailsApiResponse.self, from: response.data!)
                    for place in placeDetailsPlaces.data!{
                        self.lPlaceLocationLabel.text = String(place.location)
                        self.lPlaceDescriptionTextView.text = String(place.description)
                        //self.navigationItem.title = String(place.name)
                        self.lPlaceTitleLabel.text = String(place.name)
                        
                        self.lPlaceDescriptionHeightConstrains.constant = self.lPlaceDescriptionTextView.contentSize.height
                        
                    }
                } catch{
                    print("We got an error while fetching places table data!")
                }
            }
        }
    }
    
    // calling place avg rating API
    func placeAvgRatingData(){
        let ratingPlaceParameter = ["place_id" : lPlaceIDReceived,
                                    "api_key" : API.API_key] as [String : Any]
        // calling avgRating API
        Alamofire.request(API.baseURL + "/places/avgPlaceRatingByID", method: .post, parameters: ratingPlaceParameter).validate().responseJSON{
            response in
            if((response.result.value) != nil){
                do{
                    let avgRatingByPlaceID = try JSONDecoder().decode(LPlaceAvgRating.self, from: response.data!)
                    //print(avgRatingByPlaceID)
                    for avgRatingOfPlace in avgRatingByPlaceID.data!{
                        self.lPlaceAvgRatingLabel.text = String(avgRatingOfPlace.avg_rating)
                    }
                } catch{
                    print("We got an error to get avgRating!")
                }
            }
        }
    }

    @IBAction func homeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
