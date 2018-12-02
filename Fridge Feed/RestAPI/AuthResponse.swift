//
//  AuthResponse.swift
//  Lynx
//
//  Created by Maxime Moison on 8/27/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

struct AuthResponse: Codable {
    let accessKey: String

    enum CodingKeys: String, CodingKey {
        case accessKey = "token"
    }
}
