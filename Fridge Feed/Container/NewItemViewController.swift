//
//  NewItemViewController.swift
//  Fridge Feed
//
//  Created by Maxime Moison on 12/2/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import UIKit

class NewItemViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var brandTextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var caloriesTextField: UITextField!
    @IBOutlet weak var monthTextField: UITextField!
    @IBOutlet weak var dayTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    
    var item: FridgeItem?
    let containerID: Int
    
    init(containerID: Int, item: FridgeItem?=nil) {
        self.containerID = containerID
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        hideKeyboardWhenTappedAround()
        guard let item = item else { return }
        nameTextField.text = item.name
        brandTextField.text = item.brand ?? ""
        if let quantity = item.quantity {
            quantityTextField.text = String(quantity)
        }
        if let calories = item.calories {
            caloriesTextField.text = String(calories)
        }
        if let expiration = item.expiration {
            let components = Calendar.current.dateComponents([.day, .year, .month], from: expiration)
            monthTextField.text = String(components.month ?? 1)
            dayTextField.text = String(components.day ?? 1)
            yearTextField.text = String(components.year ?? 2018)
        }
    }
    
    @IBAction func saveTap() {
        guard let name = nameTextField.text, !name.isEmpty else {
            displayAlert(title: "Missing", message: "Enter name")
            return
        }
        
        let brand = brandTextField.text?.isEmpty ?? true ? nil : nameTextField.text
        
        var expiration: Date?
        if let day = dayTextField.text, !day.isEmpty,
            let month = monthTextField.text, !month.isEmpty,
            let year = yearTextField.text, !year.isEmpty {
            let dateString = "\(month)/\(day)/\(year)"
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy"
            expiration = formatter.date(from: dateString)
        }
        
        var calories: Int?
        if let caloriesString = caloriesTextField.text,
            !caloriesString.isEmpty {
            calories = Int(caloriesString)
        }
        
        var quantity: Int?
        if let quantityString = quantityTextField.text,
            !quantityString.isEmpty {
            quantity = Int(quantityString)
        }
        
        if let item = item {
            RestAPI.updateItem(id: item.id,
                               name: name,
                               brand: brand,
                               expiration: expiration,
                               calories: calories,
                               quantity: quantity,
                               completionHandler: {
                                self.dismiss(animated: true)
            }, errorHandler: handleError)
        } else {
            RestAPI.addItem(container: containerID,
                            name: name,
                            brand: brand,
                            expiration: expiration,
                            calories: calories,
                            quantity: quantity,
                            completionHandler: {
                                self.dismiss(animated: true)
            }, errorHandler: handleError)
        }
    }
    
    @IBAction func cancelTap() {
        self.dismiss(animated: true)
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
