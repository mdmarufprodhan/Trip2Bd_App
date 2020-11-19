//
//  ViewController.swift
//  Trip2BD
//
//  Created by Md. Mehedi Hasan Akash on 2/26/20.
//  Copyright © 2020 Code_x. All rights reserved.
//

import UIKit
import Alamofire

// for places
struct ApiResponse: Decodable{
    let success: Bool?
    let data: [Place]?
}

struct Place: Decodable {
    let id: Int
    let name: String
    let description: String
    let place_category_tags: String
    let location: String
}

//for avgRatings
struct AvgRating: Decodable{
    let success: Bool?
    let data: [Rating]?
}

struct Rating: Decodable{
    let avg_rating: Double
}

// for cards
struct AllCardsAPIResponse: Decodable{
    let success: Bool?
    let data: [AllCardsData]?
}

struct AllCardsData: Decodable {
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
struct AllGuidesAPIResponse: Decodable{
    let success: Bool?
    let data: [AllGuidesData]?
}

struct AllGuidesData: Decodable {
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

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var homeLoginButton: UIButton!
    @IBOutlet weak var topPlaceCollectionView: UICollectionView!
    @IBOutlet weak var topCardCollectionView: UICollectionView!
    @IBOutlet weak var topGuideCollectionView: UICollectionView!
    
    let topPlaceCollectionViewIdentifier = "TopPlaceCell"
    let topCardCollectionViewIdentifier = "TopCardCell"
    let topGuideCollectionViewIdentifier = "TopGuideCell"
    
    // for top place collection view
    var topPlaceName = [String]()
    var topPlaceID = [String]()
//    var topPlaceImage: [UIImage] = [
//        UIImage(named: "sajek")!,
//        UIImage(named: "coxsbazar")!,
//        UIImage(named: "sajek")!,
//        UIImage(named: "coxsbazar")!,
//        UIImage(named: "sajek")!,
//        UIImage(named: "coxsbazar")!,
//        ]
    var topPlaceRating = [String]()
    
    // for top card collection view
//    var topCardImage: [UIImage] = [
//        UIImage(named: "sajek")!,
//        UIImage(named: "coxsbazar")!,
//        ]
    var topCardID = [String]()
    var topCardGuideID = [String]()
    var topCardTitle = [String]()
    var topCardRatings = [String]()
    var topCardPayPerDay = [String]()
    var topCardServiceStatus = [String]()
    
    // for top guide collection view
//    var topGuideImage: [UIImage] = [
//        UIImage(named: "sajek")!,
//        UIImage(named: "coxsbazar")!,
//        ]
    var topGuideID = [String]()
    var topGuideName = [String]()
    var topGuideRatings = [String]()
    var topGuideAvailability = [String]()
    
    // for cell click to detail page segue call
    var placeIDForDetailsViewCall = ""
    
    var cardIDForDetailsViewCall = ""
    var cardGuideIDForDetailsViewCall = ""
    
    var guideIDForDetailsViewCall = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeLoginButton.layer.cornerRadius = 8
        
        topPlaceCollectionView.delegate = self
        topCardCollectionView.delegate = self
        topGuideCollectionView.delegate = self
        
        topPlaceCollectionView.dataSource = self
        topCardCollectionView.dataSource = self
        topGuideCollectionView.dataSource = self
        
        self.getPlaceAPIData()
        self.getGuideAPIData()
        self.getCardAPIData()
        
        self.view.addSubview(topPlaceCollectionView)
        self.view.addSubview(topCardCollectionView)
        self.view.addSubview(topGuideCollectionView)
        
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
                    let allPlaces = try JSONDecoder().decode(ApiResponse.self, from: response.data!)
                    
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
                                    let avgRatingByPlaceID = try JSONDecoder().decode(AvgRating.self, from: response.data!)
                                    //print(avgRatingByPlaceID)
                                    for avgRatingOfPlace in avgRatingByPlaceID.data!{
                                        self.topPlaceRating.append(String(Double(round(10*avgRatingOfPlace.avg_rating)/10)))
                                        self.topPlaceName.append(place.name)
                                        self.topPlaceID.append(String(place.id))
                                    }
                                    if self.topPlaceRating.count > 0{
                                        self.topPlaceCollectionView?.reloadData()
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
            //print("Card: ")
            //print(response)
            if((response.result.value) != nil){
                do{
                    let allCards = try JSONDecoder().decode(AllCardsAPIResponse.self, from: response.data!)
                    //print(allCards)
                    for card in allCards.data!{
                        if card.card_status == 1{
                            self.topCardID.append(String(card.id))
                            self.topCardTitle.append(String(card.card_title))
                            self.topCardRatings.append(String(Double(round(10*card.card_average_rating)/10)))
                            self.topCardGuideID.append(String(card.guide_id))
                            self.topCardPayPerDay.append(String(card.price_per_day))
                            if card.service_status == 1{
                                self.topCardServiceStatus.append("On Service")
                            } else{
                                self.topCardServiceStatus.append("Available")
                            }
                        }
                    }
                    if self.topCardID.count > 0{
                        self.topCardCollectionView?.reloadData()
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
            //print("Guide: ")
            //print(response)
            if((response.result.value) != nil){
                do{
                    let allGuides = try JSONDecoder().decode(AllGuidesAPIResponse.self, from: response.data!)
                    //print(allGuides)
                    for guide in allGuides.data!{
                        if guide.is_verified == 1{
                            self.topGuideName.append(String(guide.first_name + " " + guide.last_name))
                            self.topGuideID.append(String(guide.id))
                            self.topGuideRatings.append(String(Double(round(10*guide.ratings)/10)))
                            if guide.is_available == 1{
                                self.topGuideAvailability.append("Available")
                            } else{
                                self.topGuideAvailability.append("Unavailable")
                            }
                        }
                    }
                    if self.topGuideName.count > 0{
                        self.topGuideCollectionView?.reloadData()
                    }
                } catch{
                    print("We got an error to get Guide info!")
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var counter = 0
        if collectionView == self.topPlaceCollectionView{
            counter = self.topPlaceName.count
        } else if collectionView == self.topCardCollectionView{
            counter = self.topCardID.count
        } else{
            counter = self.topGuideName.count
        }
        return counter
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.topPlaceCollectionView{
            let forTopPlaceCell = collectionView.dequeueReusableCell(withReuseIdentifier: topPlaceCollectionViewIdentifier, for: indexPath) as! TopPlaceCollectionViewCell
            forTopPlaceCell.topPlaceTitleLabel.text = topPlaceName[indexPath.item]
            //forTopPlaceCell.topPlaceImageView.image = topPlaceImage[indexPath.item]
            forTopPlaceCell.topPlaceRatingsLabel.text = topPlaceRating[indexPath.item]
            
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
        } else if collectionView == self.topCardCollectionView{
            let forTopCardCell = collectionView.dequeueReusableCell(withReuseIdentifier: topCardCollectionViewIdentifier, for: indexPath) as! TopCardCollectionViewCell
            //forTopCardCell.topCardImageView.image = topCardImage[indexPath.item]
            forTopCardCell.topCardTitleLabel.text = topCardTitle[indexPath.item]
            forTopCardCell.topCardRatingsLabel.text = topCardRatings[indexPath.item]
            forTopCardCell.topCardPayPerDayLabel.text = topCardPayPerDay[indexPath.item]
            forTopCardCell.topCardServiceStatusLabel.text = topCardServiceStatus[indexPath.item]
            
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
            let forTopGuideCell = collectionView.dequeueReusableCell(withReuseIdentifier: topGuideCollectionViewIdentifier, for: indexPath) as! TopGuideCollectionViewCell
            //forTopGuideCell.topGuideImageView.image = topGuideImage[indexPath.item]
            forTopGuideCell.topGuideNameLabel.text = topGuideName[indexPath.item]
            forTopGuideCell.topGuideRatingLabel.text = topGuideRatings[indexPath.item]
            forTopGuideCell.topGuideProfileActivityLabel.text = topGuideAvailability[indexPath.item]
            
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
        if collectionView == self.topPlaceCollectionView{
            //print(topPlaceID[indexPath.item])
            placeIDForDetailsViewCall = topPlaceID[indexPath.item]
            self.performSegue(withIdentifier: "homeToPlaceDetails", sender: self)
        } else if collectionView == self.topCardCollectionView{
            //print(topCardID[indexPath.item])
            cardIDForDetailsViewCall = topCardID[indexPath.item]
            cardGuideIDForDetailsViewCall = topCardGuideID[indexPath.item]
            self.performSegue(withIdentifier: "homeToCardDetails", sender: self)
        } else if collectionView == self.topGuideCollectionView{
            //print(topGuideID[indexPath.item])
            guideIDForDetailsViewCall = topGuideID[indexPath.item]
            self.performSegue(withIdentifier: "homeToGuideDetails", sender: self)
        }
    }
    
    
    @IBAction func loginToFindAGuideButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "loginToFindAGuideButtonToLoginPage", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "homeToPlaceDetails"){
            let vc = segue.destination as! PlaceDetailsViewController
            vc.placeIDReceived = self.placeIDForDetailsViewCall
        } else if (segue.identifier == "homeToCardDetails"){
            let vc = segue.destination as! CardDetailsViewController
            vc.cardIDReceived = self.cardIDForDetailsViewCall
            vc.cardGuideID = self.cardGuideIDForDetailsViewCall
        } else if (segue.identifier == "homeToGuideDetails"){
            let vc = segue.destination as! GuideDetailsViewController
            vc.guideIDReceived = self.guideIDForDetailsViewCall
        }
        
    }
    
}

