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
    //let rating: Double
    //let comments: String
}

//for avgRatings
struct AvgRating: Decodable{
    let success: Bool?
    let data: [Rating]?
}

struct Rating: Decodable{
    let avg_rating: Double
}

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var homeLoginButton: UIButton!
    @IBOutlet weak var topPlaceCollectionView: UICollectionView!
    //@IBOutlet weak var topCardCollectionView: UICollectionView!
    //@IBOutlet weak var topGuideCollectionView: UICollectionView!
    
    var topPlaceName = [String]()
    var topPlaceID = [String]()
    var topPlaceImage: [UIImage] = [
        UIImage(named: "sajek")!,
        UIImage(named: "coxsbazar")!,
        UIImage(named: "sajek")!,
        UIImage(named: "coxsbazar")!,
        UIImage(named: "sajek")!,
        UIImage(named: "coxsbazar")!,
        ]
    var topPlaceRating = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeLoginButton.layer.cornerRadius = 8
        
        topPlaceCollectionView.delegate = self
        topPlaceCollectionView.dataSource = self
        
        //topCardCollectionView.delegate = self
        //topCardCollectionView.dataSource = self
        
        //topGuideCollectionView.delegate = self
        //topGuideCollectionView.dataSource = self
        
        self.getPlaceAPIData()
        
    }
    
    func getPlaceAPIData(){
        // calling places API
        let placeParameter = ["api_key" : API.API_key] as [String : Any]
        
        Alamofire.request(API.baseURL + "/places/list", method: .post, parameters: placeParameter).validate().responseJSON {
            response in
            
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
                            if((response.result.value) != nil){
                                do{
                                    let avgRatingByPlaceID = try JSONDecoder().decode(AvgRating.self, from: response.data!)
                                    //print(avgRatingByPlaceID)
                                    for avgRatingOfPlace in avgRatingByPlaceID.data!{
                                        self.topPlaceRating.append(String(avgRatingOfPlace.avg_rating))
                                        self.topPlaceName.append(place.name)
                                        self.topPlaceID.append(String(place.id))
                                    }
                                    if self.topPlaceRating.count > 0{
                                        self.topPlaceCollectionView?.reloadData()
//                                        print("Reload 2")
//                                        print(self.topPlaceName)
//                                        print(self.topPlaceRating)
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
    
    func placeDetailsSegueCall(){
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topPlaceName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let forTopPlaceCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopPlaceCell", for: indexPath) as! TopPlaceCollectionViewCell
        forTopPlaceCell.topPlaceTitleLabel.text = topPlaceName[indexPath.item]
        forTopPlaceCell.topPlaceImageView.image = topPlaceImage[indexPath.item]
        forTopPlaceCell.topPlaceRatingsLabel.text = topPlaceRating[indexPath.item]
        //
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
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(topPlaceID[indexPath.item])
    }


}

