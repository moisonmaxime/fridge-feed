//
//  FridgeItemCell.swift
//  Fridge Feed
//
//  Created by Maxime Moison on 12/2/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import UIKit

class FridgeItemCell: UITableViewCell {
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var daysLeftLabel: UILabel!
    
    func setup(_ item: FridgeItem) {
        nameLabel.text = item.name.capitalized
        quantityLabel.text = String(item.quantity ?? 1)
        if let date = item.expiration,
            let numberOfDays = Calendar.current.dateComponents([.day], from: Date(), to: date).day {
            if numberOfDays > 0 {
                daysLeftLabel.text = "\(numberOfDays) days left"
            } else {
                daysLeftLabel.text = "expired \(numberOfDays) ago"
            }
        } else {
            daysLeftLabel.text = ""
        }
    }
    
}
