//
//  LNotificationViewController.swift
//  Trip2BD
//
//  Created by Md. Mehedi Hasan Akash on 4/13/20.
//  Copyright © 2020 Code_x. All rights reserved.
//

import UIKit
import Alamofire

// for notification
struct LNotificationAPIResponse: Decodable{
    let success: Bool?
    let data: [LNotificationData]?
}

struct LNotificationData: Decodable {
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
struct LCardByIDAPIResponse: Decodable{
    let success: Bool?
    let data: [CardByIDData]?
}

struct CardByIDData: Decodable {
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
struct LGuideByIDAPIResponse: Decodable{
    let success: Bool?
    let data: [LGuideByIDData]?
}

struct LGuideByIDData: Decodable {
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

class LNotificationViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var lNotificationCollectionView: UICollectionView!
    
    var loggedInUserIDReceived = ""
    
    var lTouristGuideRelationID = [String]()
    var lUpdatedAt = [String]()
    var lNotificationStatus = [Int]()
    
    //for cards
    var lCardTitle = [String]()
    var lCardPricePerDay = [String]()
    
    //for guide
    var lGuideName = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        lNotificationCollectionView.delegate = self
        lNotificationCollectionView.dataSource = self
        
        self.getNotification()
        
        // Do any additional setup after loading the view.
    }
    
    func getNotification(){
        let allNotificationParameter = ["tourists_id" : loggedInUserIDReceived,
                                        "api_key" : API.API_key] as [String : Any]
        
        // calling getTouristGuideRelationByTouristID API
        Alamofire.request(API.baseURL + "/tourist/TouristGuideRelationByTouristID", method: .post, parameters: allNotificationParameter).validate().responseJSON{
            response in
            //print(response)
            if((response.result.value) != nil){
                do{
                    let allNotification = try JSONDecoder().decode(LNotificationAPIResponse.self, from: response.data!)
                    for notification in allNotification.data!{
                        self.lTouristGuideRelationID.append(String(notification.id))
                        self.lUpdatedAt.append(String(notification.updated_at))
//                        print("Notification API")
                        if (notification.is_accepted == 0 && notification.is_complited == 0 && notification.is_cancelled_by_tourist == 0 && notification.is_cancelled_by_guide == 0){
                            self.lNotificationStatus.append(1)
                        } else if (notification.is_accepted == 1 && notification.is_complited == 0 && notification.is_cancelled_by_tourist == 0 && notification.is_cancelled_by_guide == 0){
                            self.lNotificationStatus.append(2)
                        } else if (notification.is_accepted == 0 && notification.is_complited == 0 && notification.is_cancelled_by_tourist == 0 && notification.is_cancelled_by_guide == 1){
                            self.lNotificationStatus.append(3)
                        } else if (notification.is_accepted == 1 && notification.is_complited == 1 && notification.is_cancelled_by_tourist == 0 && notification.is_cancelled_by_guide == 0){
                            self.lNotificationStatus.append(4)
                        } else if (notification.is_accepted == 0 && notification.is_complited == 0 && notification.is_cancelled_by_tourist == 1 && notification.is_cancelled_by_guide == 0){
                            self.lNotificationStatus.append(5)
                        }
                        
                        self.getCardByID(cardID: String(notification.card_id), guideID: String(notification.guide_id))
//                        self.getGuideByID(guideID: String(notification.guide_id))
                        
//                        print("Notification API 2")
                    }
//                    if self.lTouristGuideRelationID.count > 0{
//                        self.lNotificationCollectionView?.reloadData()
//                    }
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
                    let allCardData = try JSONDecoder().decode(LCardByIDAPIResponse.self, from: response.data!)
                    for card in allCardData.data!{
                        self.lCardTitle.append(String(card.card_title))
                        self.lCardPricePerDay.append(String(card.price_per_day))
//                        print("Card API")
//                        print("Calling guide")
                        self.getGuideByID(guideID: guideID)
                    }
//                    if self.lCardTitle.count > 0{
//                        self.lNotificationCollectionView?.reloadData()
//                    }
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
                    let allGuideData = try JSONDecoder().decode(LGuideByIDAPIResponse.self, from: response.data!)
                    for guide in allGuideData.data!{
                        self.lGuideName.append(String(guide.first_name + " " + guide.last_name))
//                        print("Guide API")
                    }
                    if self.lGuideName.count > 0{
                        self.lNotificationCollectionView?.reloadData()
                    }
                } catch{
                    print("We got an error to get Guide info!")
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        print("Count")
//        print(lGuideName.count)
        return lGuideName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let forlNotificationCell = collectionView.dequeueReusableCell(withReuseIdentifier: "LNotificationCell", for: indexPath) as! LNotificationCollectionViewCell
        
        forlNotificationCell.lCardPricePerDayLabel.text = String(self.lCardPricePerDay[indexPath.item])
        forlNotificationCell.lCardTitleLabel.text = String(self.lCardTitle[indexPath.item])
        forlNotificationCell.lCardGuideNameLabel.text = String(self.lGuideName[indexPath.item])
        if self.lNotificationStatus[indexPath.item] == 1{
            forlNotificationCell.lRequestedLabel.text = "Requested"
        } else if self.lNotificationStatus[indexPath.item] == 2{
            forlNotificationCell.lAcceptedLabel.text = "Accepted"
        } else if self.lNotificationStatus[indexPath.item] == 3{
            forlNotificationCell.lDeclinedLabel.text = "Declined"
        } else if self.lNotificationStatus[indexPath.item] == 4{
            forlNotificationCell.lRequestedLabel.text = "Compleated"
        } else if self.lNotificationStatus[indexPath.item] == 5{
            forlNotificationCell.lRequestedLabel.text = "Canceled"
        }
        
        // for cell ui
        forlNotificationCell.layer.borderColor = UIColor.lightGray.cgColor
        forlNotificationCell.layer.borderWidth = 0.23
        //forTopPlaceCell.layer.
        //forTopPlaceCell.layer.cornerRadius = 5
        forlNotificationCell.layer.backgroundColor = UIColor.white.cgColor
        forlNotificationCell.layer.shadowColor = UIColor.lightGray.cgColor
        forlNotificationCell.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        forlNotificationCell.layer.shadowRadius = 2.0
        forlNotificationCell.layer.shadowOpacity = 0.5
        forlNotificationCell.layer.masksToBounds = false
        
        return forlNotificationCell
    }
    

}
