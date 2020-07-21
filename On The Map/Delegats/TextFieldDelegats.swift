//
//  TextFieldDelegats.swift
//  On The Map
//
//  Created by Riham Mastour on 27/11/1441 AH.
//  Copyright © 1441 Riham Mastour. All rights reserved.
//

import Foundation
import UIKit

class TextFieldDelegate: NSObject, UITextFieldDelegate{

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true;
    }
}
