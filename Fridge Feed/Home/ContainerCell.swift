//
//  ContainerCell.swift
//  Fridge Feed
//
//  Created by Maxime Moison on 12/2/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import UIKit

class ContainerCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    func setup(_ containerInfo: ContainerInfo) {
        nameLabel.text = containerInfo.name.capitalized
        typeLabel.text = containerInfo.type.capitalized
    }
    
}
