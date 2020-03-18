//
//  TouristLoginModel.swift
//  Trip2BD
//
//  Created by Md. Mehedi Hasan Akash on 3/18/20.
//  Copyright © 2020 Code_x. All rights reserved.
//

import Foundation

struct Tourist:Decodable{
    let success: Bool
    let message: String
    let data: [User]
}

struct User:Decodable{
    let id: Int?
    let email: String?
}
