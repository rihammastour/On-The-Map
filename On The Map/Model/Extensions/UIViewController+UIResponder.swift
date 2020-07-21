//
//  UIViewController+UIResponder.swift
//  On The Map
//
//  Created by Riham Mastour on 29/11/1441 AH.
//  Copyright © 1441 Riham Mastour. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func startAnActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.medium
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        return activityIndicator
    }
    
    func alert(title: String, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func dismiss(){
        self.dismiss(animated: true, completion: nil)
    }

    
    //MARK: KEYBOARD
       
    func subscribeToKeyboardNotifications() {
        //keyboardWillShow
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
           
        //keyboardWillHide
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {
        //keyboardWillShow
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
           
        //keyboardWillHide
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
       
    @objc func keyboardWillShow(_ notification:Notification) {
        guard let textField = UIResponder.currentFirstResponder as? UITextField else { return }
        let keyboardHeight = getKeyboardHeight(notification)
           
        // kbMinY is minY of the keyboard rect
        let kbMinY = (view.frame.height-keyboardHeight)
           
        // Check if the current textfield is covered by the keyboard
        var bottomCenter = textField.center
        bottomCenter.y += textField.frame.height/2
        let textFieldMaxY = textField.convert(bottomCenter, to: self.view).y
        if textFieldMaxY - kbMinY > 0 {
               
            // Displace the view's origin by the difference between kb's minY and textfield's maxY
            view.frame.origin.y = -(textFieldMaxY - kbMinY)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        //change to original hieght
        view.frame.origin.y = 0
    }
       
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
}


extension UIResponder {

    private static weak var _currentFirstResponder: UIResponder?

    static var currentFirstResponder: UIResponder? {
        _currentFirstResponder = nil
        UIApplication.shared.sendAction(#selector(UIResponder.findFirstResponder(_:)), to: nil, from: nil, for: nil)
        
        return _currentFirstResponder
    }

    @objc func findFirstResponder(_ sender: Any) {
        UIResponder._currentFirstResponder = self
    }
}

