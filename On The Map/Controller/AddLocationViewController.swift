//
//  AddLocationViewController.swift
//  On The Map
//
//  Created by Riham Mastour on 28/11/1441 AH.
//  Copyright © 1441 Riham Mastour. All rights reserved.
//

import UIKit
import CoreLocation

class AddLocationViewController: UIViewController {

    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    
    let textFDelegate = TextFieldDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationTextField.delegate = textFDelegate
        linkTextField.delegate = textFDelegate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
          
        subscribeToKeyboardNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
          
        unsubscribeFromKeyboardNotifications()
    }
    
    @IBAction func findLocationPressed(_ sender: Any) {
        guard let location = locationTextField.text,
        let mediaLink = linkTextField.text,
        location != "", mediaLink != "" else {
                  self.alert(title: "Missing information", message: "Please fill both fields and try again")
                  return
              }
              
        let studentLocation = StudentLocation(mapString: location, mediaURL: mediaLink)
        geocodeCoordeinates(location: studentLocation)
        
    }
    
    func geocodeCoordeinates (location : StudentLocation){
        let geocoder = CLGeocoder()
        let activityIndicator =  self.startAnActivityIndicator()
        geocoder.geocodeAddressString(location.mapString!) { (placeMarks, _) in
        activityIndicator.stopAnimating()
        guard let marks = placeMarks else {
            self.alert(title: "Error", message: "Couldn't geocode you're location. Please try again.")
            return
        }
            var studentLocation = location
            studentLocation.longitude = Double((marks.first!.location?.coordinate.longitude)!)
            studentLocation.latitude = Double((marks.first!.location?.coordinate.latitude)!)
            self.performSegue(withIdentifier: "confirmationSegue", sender: studentLocation)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "confirmationSegue", let vc = segue.destination as? ConfirmationViewController {
            vc.newLocation = (sender as! StudentLocation)
        }
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "cancelSegue", sender: nil)
    }
    
}
