//
//  PlaceDetailsViewController.swift
//  Trip2BD
//
//  Created by Md. Mehedi Hasan Akash on 3/29/20.
//  Copyright © 2020 Code_x. All rights reserved.
//

import UIKit
import Alamofire

// for places details
struct PlaceDetailsApiResponse: Decodable{
    let success: Bool?
    let data: [PlaceDetails]?
}

struct PlaceDetails: Decodable {
    let id: Int
    let name: String
    let description: String
    let place_category_tags: String
    let location: String
}


class PlaceDetailsViewController: UIViewController {
    
    @IBOutlet weak var placeDescriptionTextView: UITextView!
    @IBOutlet weak var placeDescriptionTextViewHeightCons: NSLayoutConstraint!
    @IBOutlet weak var placeLocationLabel: UILabel!
    @IBOutlet weak var placeAvgRatingLabel: UILabel!
    
    var placeIDReceived = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getPlaceDetailsData()
        self.placeAvgRatingData()
        
        //placeDescriptionTextViewHeightCons.constant = self.placeDescriptionTextView.contentSize.height
    }
    
    // calling place details by id API
    func getPlaceDetailsData(){
        let placeDetailsParameter = ["id" : placeIDReceived,
        "api_key" : API.API_key] as [String: Any]
        
        Alamofire.request(API.baseURL + "/places/Details", method: .post, parameters: placeDetailsParameter).validate().responseJSON{
            response in
            if((response.result.value) != nil){
                do{
                    let placeDetailsPlaces = try JSONDecoder().decode(PlaceDetailsApiResponse.self, from: response.data!)
                    for place in placeDetailsPlaces.data!{
                        self.placeLocationLabel.text = place.location
                        self.placeDescriptionTextView.text = place.description
                        self.navigationItem.title = place.name
                        
                        self.placeDescriptionTextViewHeightCons.constant = self.placeDescriptionTextView.contentSize.height
                        
                    }
                } catch{
                    print("We got an error while fetching places table data!")
                }
            }
        }
    }
    
    // calling place avg rating API
    func placeAvgRatingData(){
        let ratingPlaceParameter = ["place_id" : placeIDReceived,
                                    "api_key" : API.API_key] as [String : Any]
        // calling avgRating API
        Alamofire.request(API.baseURL + "/places/avgPlaceRatingByID", method: .post, parameters: ratingPlaceParameter).validate().responseJSON{
            response in
            if((response.result.value) != nil){
                do{
                    let avgRatingByPlaceID = try JSONDecoder().decode(AvgRating.self, from: response.data!)
                    //print(avgRatingByPlaceID)
                    for avgRatingOfPlace in avgRatingByPlaceID.data!{
                        self.placeAvgRatingLabel.text = String(Double(round(10*avgRatingOfPlace.avg_rating)/10))
                    }
                } catch{
                    print("We got an error to get avgRating!")
                }
            }
        }
    }
    
}
