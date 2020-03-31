//
//  PlaceDetailsViewController.swift
//  Trip2BD
//
//  Created by Md. Mehedi Hasan Akash on 3/29/20.
//  Copyright © 2020 Code_x. All rights reserved.
//

import UIKit

class PlaceDetailsViewController: UIViewController {
    
    @IBOutlet weak var placeDescriptionTextView: UITextView!
    @IBOutlet weak var placeDescriptionTextViewHeightCons: NSLayoutConstraint!
    @IBOutlet weak var placeLocationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placeDescriptionTextViewHeightCons.constant = self.placeDescriptionTextView.contentSize.height
    }
    

}
