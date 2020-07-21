//
//  LoginViewController.swift
//  On The Map
//
//  Created by Riham Mastour on 27/11/1441 AH.
//  Copyright © 1441 Riham Mastour. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let textFDelegate = TextFieldDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.delegate = textFDelegate
        passwordTextField.delegate = textFDelegate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        subscribeToKeyboardNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeFromKeyboardNotifications()
    }
    
    
    @IBAction func signUpPressed(_ sender: Any) {
        if let url = URL(string: "https://auth.udacity.com/sign-up"),
            UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        API.login(username: emailTextField.text!, password: passwordTextField.text!) { (error) in
            DispatchQueue.main.async {
                guard error == nil else {
                    self.alert(title: "Error", message: error)
                    return
                }
                self.performSegue(withIdentifier: "Login", sender: nil)
            }
        }
    }
    @IBAction func unwindToLogin(_ unwindSegue: UIStoryboardSegue) {
        _ = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
    }
}
