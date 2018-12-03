//
//  RegisterViewController.swift
//  Fridge Feed
//
//  Created by Maxime Moison on 12/2/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        self.title = "Login"
    }
    
    @IBAction func registerTap() {
        guard let name = nameTextField.text else {
            displayAlert(title: "Missing", message: "Enter name")
            return
        }
        guard let email = emailTextField.text else {
            displayAlert(title: "Missing", message: "Enter email")
            return
        }
        guard let username = usernameTextField.text else {
            displayAlert(title: "Missing", message: "Enter username")
            return
        }
        guard let password = passwordTextField.text else {
            displayAlert(title: "Missing", message: "Enter password")
            return
        }
        
        navigationController?.didStartLoading()
        RestAPI.register(user: username,
                         password: password,
                         email: email,
                         name: name,
                         completionHandler: { [weak self] in
                            self?.navigationController?.didFinishLoading()
                            let homeVC = HomeViewController()
                            self?.navigationController?.setAnimationType(type: FadingAnimation.self, forever: false)
                            self?.navigationController?.viewControllers = [homeVC]
            }, errorHandler: handleError)
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
