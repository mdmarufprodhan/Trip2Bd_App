//
//  RegistrationPageViewController.swift
//  Trip2BD
//
//  Created by Md. Mehedi Hasan Akash on 3/27/20.
//  Copyright © 2020 Code_x. All rights reserved.
//

import UIKit

class RegistrationPageViewController: UIViewController {

    @IBOutlet weak var profieImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //make image view circular
        profieImageView.layer.borderWidth = 1
        profieImageView.layer.masksToBounds = false
        profieImageView.layer.borderColor = UIColor.black.cgColor
        profieImageView.layer.cornerRadius = profieImageView.frame.height/2
        profieImageView.clipsToBounds = true
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
