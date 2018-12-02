//
//  LoginViewController.swift
//  Fridge Feed
//
//  Created by Maxime Moison on 12/2/18.
//  Copyright © 2018 Maxime Moison. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
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
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginTap() {
        guard let username = usernameTextField.text else {
            displayAlert(title: "Missing", message: "Enter username")
            return
        }
        guard let password = passwordTextField.text else {
            displayAlert(title: "Missing", message: "Enter password")
            return
        }
        
        RestAPI.login(user: username,
                      password: password,
                      completionHandler: { [weak self] in
                        let registerVC = HomeViewController()
                        self?.navigationController?.pushViewController(registerVC, animated: true)
            }, errorHandler: handleError)
    }
    
    @IBAction func registerTap() {
        let registerVC = RegisterViewController()
        navigationController?.pushViewController(registerVC, animated: true)
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
