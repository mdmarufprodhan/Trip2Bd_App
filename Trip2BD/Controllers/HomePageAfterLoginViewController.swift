//
//  HomePageAfterLoginViewController.swift
//  Trip2BD
//
//  Created by Md. Mehedi Hasan Akash on 3/27/20.
//  Copyright © 2020 Code_x. All rights reserved.
//

import UIKit
import Alamofire

// for places
struct LApiResponse: Decodable{
    let success: Bool?
    let data: [LPlace]?
}

struct LPlace: Decodable {
    let id: Int
    let name: String
    let description: String
    let place_category_tags: String
    let location: String
}

//for avgRatings
struct LAvgRating: Decodable{
    let success: Bool?
    let data: [LRating]?
}

struct LRating: Decodable{
    let avg_rating: Double
}

// for cards
struct LAllCardsAPIResponse: Decodable{
    let success: Bool?
    let data: [LAllCardsData]?
}

struct LAllCardsData: Decodable {
    let id: Int
    let guide_id: Int
    let card_title: String
    let card_description: String
    //let price_per_hour: String
    let price_per_day: Int
    //let place_ids: String
    let card_average_rating: Double
    let service_status: Int
    let card_status: Int
    //let card_category_tags: String
}

// for guides
struct LAllGuidesAPIResponse: Decodable{
    let success: Bool?
    let data: [LAllGuidesData]?
}

struct LAllGuidesData: Decodable {
    let id: Int
    let first_name: String
    let last_name: String
    let image: String
    let gender: String
    let date_of_birth: String
    let is_available: Int
    let urgent_availability: Int
    let ratings: Double
    let is_verified: Int
}


class HomePageAfterLoginViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var lTopPlaceCollectionView: UICollectionView!
    @IBOutlet weak var lTopCardCollectionView: UICollectionView!
    @IBOutlet weak var lTopGuideCollectionView: UICollectionView!
    
    var loggedInUserIDReceived = ""
    
    let lTopPlaceCollectionViewIdentifier = "LTopPlaceCell"
    let lTopCardCollectionViewIdentifier = "LTopCardCell"
    let lTopGuideCollectionViewIdentifier = "LTopGuideCell"
    
    // for top place collection view
    var lTopPlaceName = [String]()
    var lTopPlaceID = [String]()
    //    var lTopPlaceImage: [UIImage] = [
    //        UIImage(named: "sajek")!,
    //        UIImage(named: "coxsbazar")!,
    //        UIImage(named: "sajek")!,
    //        UIImage(named: "coxsbazar")!,
    //        UIImage(named: "sajek")!,
    //        UIImage(named: "coxsbazar")!,
    //        ]
    var lTopPlaceRating = [String]()
    
    // for top card collection view
    //    var lTopCardImage: [UIImage] = [
    //        UIImage(named: "sajek")!,
    //        UIImage(named: "coxsbazar")!,
    //        ]
    var lTopCardID = [String]()
    var lTopCardTitle = [String]()
    var lTopCardRatings = [String]()
    var lTopCardPayPerDay = [String]()
    var lTopCardServiceStatus = [String]()
    
    // for top guide collection view
    //    var lTopGuideImage: [UIImage] = [
    //        UIImage(named: "sajek")!,
    //        UIImage(named: "coxsbazar")!,
    //        ]
    var lTopGuideID = [String]()
    var lTopGuideName = [String]()
    var lTopGuideRatings = [String]()
    var lTopGuideAvailability = [String]()
    
    // for cell click to detail page segue call
    var placeIDForDetailsViewCall = ""
    var cardIDForDetailsViewCall = ""
    var guideIDForDetailsViewCall = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lTopPlaceCollectionView.delegate = self
        lTopCardCollectionView.delegate = self
        lTopGuideCollectionView.delegate = self
        
        lTopPlaceCollectionView.dataSource = self
        lTopCardCollectionView.dataSource = self
        lTopGuideCollectionView.dataSource = self
        
        self.getPlaceAPIData()
        self.getGuideAPIData()
        self.getCardAPIData()
        
        self.view.addSubview(lTopPlaceCollectionView)
        self.view.addSubview(lTopCardCollectionView)
        self.view.addSubview(lTopGuideCollectionView)
        
        var fifthTab = self.tabBarController?.viewControllers![4] as! LUserProfileViewController
        fifthTab.loggedInUserIDReceived = self.loggedInUserIDReceived
        
        // Do any additional setup after loading the view.
    }
    
    func getPlaceAPIData(){
        // calling places API
        let placeParameter = ["api_key" : API.API_key] as [String : Any]
        
        Alamofire.request(API.baseURL + "/places/list", method: .post, parameters: placeParameter).validate().responseJSON {
            response in
            //print("Place: ")
            //print(response)
            if ((response.result.value) != nil){
                do{
                    let allPlaces = try JSONDecoder().decode(LApiResponse.self, from: response.data!)
                    
                    for place in allPlaces.data!{
                        //self.topPlaceName.append(place.name)
                        
                        var ratingPlaceParameter = ["place_id" : place.id,
                                                    "api_key" : API.API_key] as [String : Any]
                        
                        // calling avgRating API
                        Alamofire.request(API.baseURL + "/places/avgPlaceRatingByID", method: .post, parameters: ratingPlaceParameter).validate().responseJSON{
                            response in
                            //print("AvgRating: ")
                            //print(response)
                            if((response.result.value) != nil){
                                do{
                                    let avgRatingByPlaceID = try JSONDecoder().decode(LAvgRating.self, from: response.data!)
                                    //print(avgRatingByPlaceID)
                                    for avgRatingOfPlace in avgRatingByPlaceID.data!{
                                        self.lTopPlaceRating.append(String(Double(round(10*avgRatingOfPlace.avg_rating)/10)))
                                        self.lTopPlaceName.append(place.name)
                                        self.lTopPlaceID.append(String(place.id))
                                    }
                                    if self.lTopPlaceRating.count > 0{
                                        self.lTopPlaceCollectionView?.reloadData()
                                    }
                                } catch{
                                    print("We got an error to get avgRating!")
                                }
                            }
                        }
                    }
                } catch{
                    print("We got an error!")
                }
            }
        }
    }
    
    func getCardAPIData(){
        let allCardParameter = ["api_key" : API.API_key] as [String : Any]
        
        // calling getAllCards API
        Alamofire.request(API.baseURL + "/cards/All", method: .post, parameters: allCardParameter).validate().responseJSON{
            response in
            //print(response)
            if((response.result.value) != nil){
                do{
                    let allCards = try JSONDecoder().decode(LAllCardsAPIResponse.self, from: response.data!)
                    //print(allCards)
                    for card in allCards.data!{
                        if card.card_status == 1{
                            self.lTopCardID.append(String(card.id))
                            self.lTopCardTitle.append(String(card.card_title))
                            self.lTopCardRatings.append(String(Double(round(10*card.card_average_rating)/10)))
                            self.lTopCardPayPerDay.append(String(card.price_per_day))
                            if card.service_status == 1{
                                self.lTopCardServiceStatus.append("On Service")
                            } else{
                                self.lTopCardServiceStatus.append("Available")
                            }
                        }
                    }
                    if self.lTopCardID.count > 0{
                        self.lTopCardCollectionView?.reloadData()
                    }
                    
                } catch{
                    print("We got an error to get Card info!")
                }
            }
        }
    }
    
    func getGuideAPIData(){
        let allGuideParameter = ["api_key" : API.API_key] as [String : Any]
        
        // calling getAllGuides API
        Alamofire.request(API.baseURL + "/guides/list", method: .post, parameters: allGuideParameter).validate().responseJSON{
            response in
            //print(response)
            if((response.result.value) != nil){
                do{
                    let allGuides = try JSONDecoder().decode(LAllGuidesAPIResponse.self, from: response.data!)
                    //print(allGuides)
                    for guide in allGuides.data!{
                        if guide.is_verified == 1{
                            self.lTopGuideName.append(String(guide.first_name + " " + guide.last_name))
                            self.lTopGuideID.append(String(guide.id))
                            self.lTopGuideRatings.append(String(Double(round(10*guide.ratings)/10)))
                            if guide.is_available == 1{
                                self.lTopGuideAvailability.append("Available")
                            } else{
                                self.lTopGuideAvailability.append("Unavailable")
                            }
                        }
                    }
                    if self.lTopGuideID.count > 0{
                        self.lTopGuideCollectionView?.reloadData()
                    }
                } catch{
                    print("We got an error to get Guide info!")
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var counter = 0
        if collectionView == self.lTopPlaceCollectionView{
            counter = self.lTopPlaceID.count
        } else if collectionView == self.lTopCardCollectionView{
            counter = self.lTopCardID.count
        } else if collectionView == self.lTopGuideCollectionView{
            counter = self.lTopGuideID.count
        }
        return counter
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.lTopPlaceCollectionView{
            let forTopPlaceCell = collectionView.dequeueReusableCell(withReuseIdentifier: lTopPlaceCollectionViewIdentifier, for: indexPath) as! LTopPlaceCollectionViewCell
            forTopPlaceCell.lTopPlaceTitleLabel.text = lTopPlaceName[indexPath.item]
            //forTopPlaceCell.lTopPlaceImageView.image = lTopPlaceImage[indexPath.item]
            forTopPlaceCell.lTopPlaceRatingLabel.text = lTopPlaceRating[indexPath.item]
            
            // for cell ui
            forTopPlaceCell.layer.borderColor = UIColor.lightGray.cgColor
            forTopPlaceCell.layer.borderWidth = 0.5
            //forTopPlaceCell.layer.
            //forTopPlaceCell.layer.cornerRadius = 5
            forTopPlaceCell.layer.backgroundColor = UIColor.white.cgColor
            forTopPlaceCell.layer.shadowColor = UIColor.lightGray.cgColor
            forTopPlaceCell.layer.shadowOffset = CGSize(width: 2.0, height: 4.0)
            forTopPlaceCell.layer.shadowRadius = 2.0
            forTopPlaceCell.layer.shadowOpacity = 0.5
            forTopPlaceCell.layer.masksToBounds = false
            
            return forTopPlaceCell
        } else if collectionView == self.lTopCardCollectionView{
            let forTopCardCell = collectionView.dequeueReusableCell(withReuseIdentifier: lTopCardCollectionViewIdentifier, for: indexPath) as! LTopCardCollectionViewCell
            //forTopCardCell.lTopCardImageView.image = lTopCardImage[indexPath.item]
            forTopCardCell.lTopCardTitleLabel.text = lTopCardTitle[indexPath.item]
            forTopCardCell.lTopCardRatingLabel.text = lTopCardRatings[indexPath.item]
            forTopCardCell.lTopCardPricePerDayLabel.text = lTopCardPayPerDay[indexPath.item]
            forTopCardCell.lTopCardStatusLabel.text = lTopCardServiceStatus[indexPath.item]
            
            // for cell ui
            forTopCardCell.layer.borderColor = UIColor.lightGray.cgColor
            forTopCardCell.layer.borderWidth = 0.5
            //forTopPlaceCell.layer.
            //forTopPlaceCell.layer.cornerRadius = 5
            forTopCardCell.layer.backgroundColor = UIColor.white.cgColor
            forTopCardCell.layer.shadowColor = UIColor.lightGray.cgColor
            forTopCardCell.layer.shadowOffset = CGSize(width: 2.0, height: 4.0)
            forTopCardCell.layer.shadowRadius = 2.0
            forTopCardCell.layer.shadowOpacity = 0.5
            forTopCardCell.layer.masksToBounds = false
            
            return forTopCardCell
        } else{
            let forTopGuideCell = collectionView.dequeueReusableCell(withReuseIdentifier: lTopGuideCollectionViewIdentifier, for: indexPath) as! LTopGuideCollectionViewCell
            //forTopGuideCell.lTopGuideProfileImageView.image = lTopGuideImage[indexPath.item]
            forTopGuideCell.lTopGuideFullNameLabel.text = lTopGuideName[indexPath.item]
            forTopGuideCell.lTopGuideRatingLabel.text = lTopGuideRatings[indexPath.item]
            forTopGuideCell.lTopGuideAvailabilityLabel.text = lTopGuideAvailability[indexPath.item]
            
            // for cell ui
            forTopGuideCell.layer.borderColor = UIColor.lightGray.cgColor
            forTopGuideCell.layer.borderWidth = 0.5
            //forTopPlaceCell.layer.
            //forTopPlaceCell.layer.cornerRadius = 5
            forTopGuideCell.layer.backgroundColor = UIColor.white.cgColor
            forTopGuideCell.layer.shadowColor = UIColor.lightGray.cgColor
            forTopGuideCell.layer.shadowOffset = CGSize(width: 2.0, height: 4.0)
            forTopGuideCell.layer.shadowRadius = 2.0
            forTopGuideCell.layer.shadowOpacity = 0.5
            forTopGuideCell.layer.masksToBounds = false
            
            return forTopGuideCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.lTopPlaceCollectionView{
            print(lTopPlaceID[indexPath.item])
            placeIDForDetailsViewCall = lTopPlaceID[indexPath.item]
            self.performSegue(withIdentifier: "afterLoginHomeToPlaceDetails", sender: self)
        } else if collectionView == self.lTopCardCollectionView{
            print(lTopCardID[indexPath.item])
            cardIDForDetailsViewCall = lTopCardID[indexPath.item]
        } else{
            print(lTopGuideID[indexPath.item])
            guideIDForDetailsViewCall = lTopGuideID[indexPath.item]
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "afterLoginHomeToPlaceDetails"){
            let vc = segue.destination as! LPlaceDetailsViewController
            vc.lPlaceIDReceived = self.placeIDForDetailsViewCall
        } else if (segue.identifier == "loginToFindAGuideButtonToLoginPage"){
            
        }
        
    }
    

}
