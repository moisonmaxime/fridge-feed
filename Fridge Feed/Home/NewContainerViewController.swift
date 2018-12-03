//
//  NewContainerViewController.swift
//  Fridge Feed
//
//  Created by Maxime Moison on 12/2/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import UIKit

class NewContainerViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    
    var container: ContainerInfo?
    
    init(container: ContainerInfo?=nil) {
        self.container = container
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        hideKeyboardWhenTappedAround()
        guard let container = container else { return }
        nameTextField.text = container.name
        typeTextField.text = container.type
    }
    
    @IBAction func saveTap() {
        guard let name = nameTextField.text else {
            displayAlert(title: "Missing", message: "Enter name")
            return
        }
        guard let type = typeTextField.text else {
            displayAlert(title: "Missing", message: "Enter type")
            return
        }
        
        if let container = container {
            RestAPI.updateContainer(id: container.id,
                                    name: name,
                                    type: type,
                                    completionHandler: {
                                        self.dismiss(animated: true)
            }, errorHandler: handleError)
        } else {
            RestAPI.createContainer(name: name,
                                    type: type,
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
