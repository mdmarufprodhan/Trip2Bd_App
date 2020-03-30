//
//  ViewController.swift
//  Trip2BD
//
//  Created by Md. Mehedi Hasan Akash on 2/26/20.
//  Copyright © 2020 Code_x. All rights reserved.
//

import UIKit
import Alamofire

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
    let rating: Int
    let comments: String
}

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var homeLoginButton: UIButton!
    @IBOutlet weak var topPlaceCollectionView: UICollectionView!
    //@IBOutlet weak var topCardCollectionView: UICollectionView!
    //@IBOutlet weak var topGuideCollectionView: UICollectionView!
    
    var topPlaceName = [String]()
    var topPlaceImage: [UIImage] = [
        UIImage(named: "coxsbazar")!,
        UIImage(named: "sajek")!,
        UIImage(named: "coxsbazar")!,
        UIImage(named: "sajek")!,
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
        // places API call
        let placeParameter = ["api_key" : API.API_key] as [String : Any]
        
        Alamofire.request(API.baseURL + "/places/list", method: .post, parameters: placeParameter).validate().responseJSON {
            response in
            //print(response.result.value)
            if ((response.result.value) != nil){
                do{
                    let allPlaces = try JSONDecoder().decode(ApiResponse.self, from: response.data!)
                    //print(allPlaces)
                    //print("Now:")
                    //print(allPlaces.data!)
                    for place in allPlaces.data!{
                        //self.topPlaceData = place as! [[String : String]]
                        //print("ID: " + String(place.id) + " Place Name: " + place.name + " Location: " + place.location + " Place Category Tags: " + place.place_category_tags + " Description: " + place.description + " Ratings: " + String(place.rating) + " Comments: " + place.comments)
                        self.topPlaceName.append(place.name)
                        self.topPlaceRating.append(String(place.rating))
                    }
                    if self.topPlaceName.count > 0{
                        self.topPlaceCollectionView?.reloadData()
                        //print("Reload")
                    }
                } catch{
                    print("We got an error!")
                }
            }
        }
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
        print(topPlaceName[indexPath.item])
    }


}

