//
//  LGuideCardsViewController.swift
//  Trip2BD
//
//  Created by Md. Mehedi Hasan Akash on 4/14/20.
//  Copyright © 2020 Code_x. All rights reserved.
//

import UIKit
import Alamofire

// for cards
struct LMyGuideCardDetailsByIDAPIResponse: Decodable{
    let success: Bool?
    let data: [MyGuideCardDetailsByIDData]?
}

struct MyGuideCardDetailsByIDData: Decodable {
    let id: Int
    let card_title: String
    let guide_id: Int
    let card_description: String
    let price_per_hour: Int?
    let price_per_day: Int
    let place_ids: String?
    let card_average_rating: Double
    let service_status: Int
    let card_status: Int
    let card_category_tags: String?
    let created_at: String?
    let updated_at: String?
}

class LGuideCardsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var lGuideCardsCollectionView: UICollectionView!
    
    var lCardTitle = [String]()
    var lCardID = [String]()
    var lCardPricePerDay = [String]()
    var lCardRating = [String]()
    var lCardServiceStatus = [Int]()
    
    var lGuideID = ""
    
    var lCardIDForSegue = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lGuideCardsCollectionView.delegate = self
        lGuideCardsCollectionView.dataSource = self
        
        self.getCardByGuideID()

        // Do any additional setup after loading the view.
    }
    
    func getCardByGuideID(){
        let cardParameter = ["guide_id" : lGuideID,
                             "api_key" : API.API_key] as [String : Any]
        
        // calling getCardsByGuideID API
        Alamofire.request(API.baseURL + "/cards/ByGuideID", method: .post, parameters: cardParameter).validate().responseJSON{
            response in
            //print(response)
            if((response.result.value) != nil){
                do{
                    let allCardData = try JSONDecoder().decode(LMyGuideCardDetailsByIDAPIResponse.self, from: response.data!)
                    for card in allCardData.data!{
                        self.lCardID.append(String(card.id))
                        self.lCardTitle.append(String(card.card_title))
                        self.lCardPricePerDay.append(String(card.price_per_day))
                        self.lCardRating.append(String(Double(round(10*card.card_average_rating)/10)))
                        self.lCardServiceStatus.append(Int(card.service_status))
                    }
                    if self.lCardTitle.count > 0{
                        self.lGuideCardsCollectionView?.reloadData()
                    }
                } catch{
                    print("We got an error to get Card info!")
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lCardTitle.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let forlMyGuideCardCell = collectionView.dequeueReusableCell(withReuseIdentifier: "GuideCardsCell", for: indexPath) as! LGuideCardsCollectionViewCell
        
        forlMyGuideCardCell.lGuideCardsTitleLabel.text = String(self.lCardTitle[indexPath.item])
        forlMyGuideCardCell.lGuideCardsPricePerDay.text = String(self.lCardPricePerDay[indexPath.item])
        forlMyGuideCardCell.lGuideCardsRatingsLabel.text = String(self.lCardRating[indexPath.item])
        if self.lCardServiceStatus[indexPath.item] == 1{
            forlMyGuideCardCell.lGuideCardsActivityLabel.text = "On Service"
            forlMyGuideCardCell.lGuideCardsActivityIconImageView.image = UIImage(named: "orangeDotIcon")!
        } else{
            forlMyGuideCardCell.lGuideCardsActivityLabel.text = "Available"
            forlMyGuideCardCell.lGuideCardsActivityIconImageView.image = UIImage(named: "greenDotIcon")!
        }
        
        // for cell ui
        forlMyGuideCardCell.layer.borderColor = UIColor.lightGray.cgColor
        forlMyGuideCardCell.layer.borderWidth = 0.23
        //forTopPlaceCell.layer.
        //forTopPlaceCell.layer.cornerRadius = 5
        forlMyGuideCardCell.layer.backgroundColor = UIColor.white.cgColor
        forlMyGuideCardCell.layer.shadowColor = UIColor.lightGray.cgColor
        forlMyGuideCardCell.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        forlMyGuideCardCell.layer.shadowRadius = 2.0
        forlMyGuideCardCell.layer.shadowOpacity = 0.5
        forlMyGuideCardCell.layer.masksToBounds = false
        
        //make image view circular
        forlMyGuideCardCell.lGuideCardsActivityIconImageView.layer.borderWidth = 0.25
        forlMyGuideCardCell.lGuideCardsActivityIconImageView.layer.masksToBounds = false
        forlMyGuideCardCell.lGuideCardsActivityIconImageView.layer.borderColor = UIColor.black.cgColor
        forlMyGuideCardCell.lGuideCardsActivityIconImageView.layer.cornerRadius = forlMyGuideCardCell.lGuideCardsActivityIconImageView.frame.height/2
        forlMyGuideCardCell.lGuideCardsActivityIconImageView.clipsToBounds = true
        
        return forlMyGuideCardCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.lGuideCardsCollectionView{
            lCardIDForSegue = lCardID[indexPath.item]
            self.performSegue(withIdentifier: "guideCardsToCardDetails", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "guideCardsToCardDetails"){
            let vc = segue.destination as! LCardDetailsViewController
            vc.lCardIDReceived = self.lCardIDForSegue
        }
    }
    
    @IBAction func lBackButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
