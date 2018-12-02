//
//  UserResponse.swift
//  Fridge Feed
//
//  Created by Maxime Moison on 12/2/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import Foundation

struct UserResponse: Codable {
    let username:String
    let name:String
    let email:String
    let type:String
}
