//
//  FridgeItem.swift
//  Fridge Feed
//
//  Created by Maxime Moison on 12/2/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import Foundation

struct FridgeItem: Codable {
    let id: Int
    let brand: String?
    let name: String
    let expiration: Date?
    let calories: Int?
    let quantity: Int?
    
    init(id: Int,
         brand: String?,
         name: String,
         expiration: Date?,
         calories: Int?,
         quantity: Int?) {
        
        self.id = id
        self.brand = brand
        self.name = name
        self.expiration = expiration
        self.calories = calories
        self.quantity = quantity
        
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self) // defining our (keyed) container
        
        let id: Int = try container.decode(Int.self, forKey: .id)
        let brand: String? = try container.decode(String?.self, forKey: .brand)
        let name: String = try container.decode(String.self, forKey: .name)
        let calories: Int? = try container.decode(Int?.self, forKey: .calories)
        let quantity: Int? = try container.decode(Int?.self, forKey: .quantity)
        
        var expiration: Date? = nil
        
        if let dateString = try container.decode(String?.self, forKey: .expiration) {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy"
            expiration = formatter.date(from: dateString)
        }
        
        self.init(id: id, brand: brand, name: name, expiration: expiration, calories: calories, quantity: quantity)
    }
    
    enum CodingKeys: String, CodingKey { // declaring our keys
        case id
        case brand
        case name
        case expiration
        case calories
        case quantity
    }
}
