//
//  ViewController.swift
//  Trip2BD
//
//  Created by Md. Mehedi Hasan Akash on 2/26/20.
//  Copyright © 2020 Code_x. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var homeLoginButton: UIButton!
    @IBOutlet weak var topPlaceCollectionView: UICollectionView!
    //@IBOutlet weak var topCardCollectionView: UICollectionView!
    //@IBOutlet weak var topGuideCollectionView: UICollectionView!
    
    var topPlaceTitle = ["Cox's Bazar", "Sajek Valley", "Cox's Bazar", "Sajek Valley"]
    var topPlaceImage: [UIImage] = [
        UIImage(named: "coxsbazar")!,
        UIImage(named: "sajek")!,
        UIImage(named: "coxsbazar")!,
        UIImage(named: "sajek")!,
        ]
    var topPlaceRatingsIconSet: [UIImage] = [
        UIImage(named: "yellowStarIcon")!,
        UIImage(named: "yellowStarIcon")!,
        UIImage(named: "yellowStarIcon")!,
        UIImage(named: "yellowStarIcon")!,
        ]
    var topPlaceRatings = ["4.6", "4.7", "4.6", "4.7"]
    
    var topCardGuideName = ["Farisa Benta Safir", "Faysal Ibne Safir"]
    var topCardImage: [UIImage] = [
        UIImage(named: "sajek")!,
        UIImage(named: "coxsbazar")!,
        ]
    var topCardRatings = ["4.6", "4.7"]
    var topCardPayPerDay = ["40", "45"]
    
    var topGuideName = ["Farisa Benta Safir", "Faysal Ibne Safir"]
    var topGuideImage: [UIImage] = [
        UIImage(named: "avatar")!,
        UIImage(named: "avatar")!,
        ]
    var topGuideRatings = ["4.3", "4.5"]
    var topGuidePayPerDay = ["40", "45"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeLoginButton.layer.cornerRadius = 8
        
        topPlaceCollectionView.delegate = self
        topPlaceCollectionView.dataSource = self
        
        //topCardCollectionView.delegate = self
        //topCardCollectionView.dataSource = self
        
        //topGuideCollectionView.delegate = self
        //topGuideCollectionView.dataSource = self
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topPlaceTitle.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let forTopPlaceCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopPlaceCell", for: indexPath) as! TopPlaceCollectionViewCell
        forTopPlaceCell.topPlaceTitleLabel.text = topPlaceTitle[indexPath.item]
        forTopPlaceCell.topPlaceImageView.image = topPlaceImage[indexPath.item]
        //forTopPlaceCell.topPlaceRatingsIcon.image = topPlaceRatingsIconSet[indexPath.item]
        forTopPlaceCell.topPlaceRatingsLabel.text = topPlaceRatings[indexPath.item]
        
        return forTopPlaceCell
        
    }


}

