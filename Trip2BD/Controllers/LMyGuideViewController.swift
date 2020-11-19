//
//  LMyGuideViewController.swift
//  Trip2BD
//
//  Created by Md. Mehedi Hasan Akash on 4/14/20.
//  Copyright © 2020 Code_x. All rights reserved.
//

import UIKit
import Alamofire

// for my guide
struct LMyGuideAPIResponse: Decodable{
    let success: Bool?
    let data: [LMyGuideData]?
}

struct LMyGuideData: Decodable {
    let id: Int
    let tourists_id: Int
    let guide_id: Int
    let card_id: Int
    let is_accepted: Int
    let is_complited: Int
    let is_cancelled_by_tourist: Int
    let is_cancelled_by_guide: Int
    let created_at: String
    let updated_at: String
}

// for cards
struct LMyGuideCardByIDAPIResponse: Decodable{
    let success: Bool?
    let data: [MyGuideCardByIDData]?
}

struct MyGuideCardByIDData: Decodable {
    let id: Int
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

// for guides
struct LMyGuideByIDAPIResponse: Decodable{
    let success: Bool?
    let data: [LMyGuideByIDData]?
}

struct LMyGuideByIDData: Decodable {
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

class LMyGuideViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var lMyGuideCollectionView: UICollectionView!
    
    var loggedInUserIDReceived = ""
    
    var lTouristGuideRelationID = [String]()
    var lUpdatedAt = [String]()
    var lTripStatus = [Int]()
    
    var lCardTitle = [String]()
    var lCardPricePerDay = [String]()
    
    var lGuideName = [String]()
    var lGuideRating = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lMyGuideCollectionView.delegate = self
        lMyGuideCollectionView.dataSource = self
        
        self.getMyGuide()

        // Do any additional setup after loading the view.
    }

    
    func getMyGuide(){
        let allMyGuideParameter = ["tourists_id" : loggedInUserIDReceived,
                                        "api_key" : API.API_key] as [String : Any]
        
        // calling getTouristGuideRelationByTouristID API
        Alamofire.request(API.baseURL + "/tourist/TouristGuideRelationByTouristID", method: .post, parameters: allMyGuideParameter).validate().responseJSON{
            response in
            //print(response)
            if((response.result.value) != nil){
                do{
                    let allMyGuide = try JSONDecoder().decode(LMyGuideAPIResponse.self, from: response.data!)
                    for myGuide in allMyGuide.data!{
                        if (myGuide.is_accepted == 1 && myGuide.is_complited == 0 && myGuide.is_cancelled_by_tourist == 0 && myGuide.is_cancelled_by_guide == 0){
                            self.lTouristGuideRelationID.append(String(myGuide.id))
                            self.lUpdatedAt.append(String(myGuide.updated_at))
                            self.lTripStatus.append(1)
                            
                            self.getCardByID(cardID: String(myGuide.card_id), guideID: String(myGuide.guide_id))
                        }
                    }
                } catch{
                    print("We got an error to get Tourist Guide Relations info!")
                }
            }
        }
    }
    
    func getCardByID(cardID: String, guideID: String){
        let cardParameter = ["id" : cardID,
                             "api_key" : API.API_key] as [String : Any]
        
        // calling getCardByID API
        Alamofire.request(API.baseURL + "/cards/ByID", method: .post, parameters: cardParameter).validate().responseJSON{
            response in
            //print(response)
            if((response.result.value) != nil){
                do{
                    let allCardData = try JSONDecoder().decode(LMyGuideCardByIDAPIResponse.self, from: response.data!)
                    for card in allCardData.data!{
                        self.lCardTitle.append(String(card.card_title))
                        self.lCardPricePerDay.append(String(card.price_per_day))
                        self.getGuideByID(guideID: guideID)
                    }
                } catch{
                    print("We got an error to get Card info!")
                }
            }
        }
    }
    
    func getGuideByID(guideID: String){
        let guideParameter = ["id" : guideID,
                              "api_key" : API.API_key] as [String : Any]
        
        // calling getCardByID API
        Alamofire.request(API.baseURL + "/guides/details", method: .post, parameters: guideParameter).validate().responseJSON{
            response in
            //print(response)
            if((response.result.value) != nil){
                do{
                    let allGuideData = try JSONDecoder().decode(LMyGuideByIDAPIResponse.self, from: response.data!)
                    for guide in allGuideData.data!{
                        self.lGuideName.append(String(guide.first_name + " " + guide.last_name))
                        self.lGuideRating.append(String(Double(round(10*guide.ratings)/10)))
                    }
                    if self.lGuideName.count > 0{
                        self.lMyGuideCollectionView?.reloadData()
                    }
                } catch{
                    print("We got an error to get Guide info!")
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lGuideName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let forlMyGuideCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyGuideCell", for: indexPath) as! LMyGuideCollectionViewCell
        
        forlMyGuideCell.lMyGuideCardTitleLabel.text = String(self.lCardTitle[indexPath.item])
        forlMyGuideCell.lMyGuideNameLabel.text = String(self.lGuideName[indexPath.item])
        forlMyGuideCell.lMyGuideRatingLabel.text = String(self.lGuideRating[indexPath.item])
        if self.lTripStatus[indexPath.item] == 1{
            forlMyGuideCell.lMyGuideTripStatusLabel.text = "Trip Accepted & Ongoing"
        }
        
        // for cell ui
        forlMyGuideCell.layer.borderColor = UIColor.lightGray.cgColor
        forlMyGuideCell.layer.borderWidth = 0.23
        //forTopPlaceCell.layer.
        //forTopPlaceCell.layer.cornerRadius = 5
        forlMyGuideCell.layer.backgroundColor = UIColor.white.cgColor
        forlMyGuideCell.layer.shadowColor = UIColor.lightGray.cgColor
        forlMyGuideCell.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        forlMyGuideCell.layer.shadowRadius = 2.0
        forlMyGuideCell.layer.shadowOpacity = 0.5
        forlMyGuideCell.layer.masksToBounds = false
        
        //make image view circular
        forlMyGuideCell.lMyGuideProfileImageView.layer.borderWidth = 0.25
        forlMyGuideCell.lMyGuideProfileImageView.layer.masksToBounds = false
        forlMyGuideCell.lMyGuideProfileImageView.layer.borderColor = UIColor.black.cgColor
        forlMyGuideCell.lMyGuideProfileImageView.layer.cornerRadius = forlMyGuideCell.lMyGuideProfileImageView.frame.height/2
        forlMyGuideCell.lMyGuideProfileImageView.clipsToBounds = true
        
        return forlMyGuideCell
    }

}
