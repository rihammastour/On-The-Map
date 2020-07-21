//
//  ConfirmationViewController.swift
//  On The Map
//
//  Created by Riham Mastour on 28/11/1441 AH.
//  Copyright © 1441 Riham Mastour. All rights reserved.
//

import UIKit
import MapKit

class ConfirmationViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var newLocation: StudentLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map()
        mapView.delegate = self
    }
    
    @IBAction func finishPressed(_ sender: Any) {
        API.postStudentLocation(studentLocation: newLocation!) { (error) in
            DispatchQueue.main.async {
                guard error == nil else {
                    self.alert(title: "Error", message: error)
                    return
                }
                self.dismiss()
            }
        }
    }

    func map(){
        guard let location = newLocation else { return }
        
        let lat = CLLocationDegrees(location.latitude!)
        let long = CLLocationDegrees(location.longitude!)
        
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = location.mapString
        annotation.subtitle = location.mediaURL
        mapView.addAnnotation(annotation)
        
        // Setting current mapView's region to be centered at the pin's coordinate
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
    }
        
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle!,
                let url = URL(string: toOpen), app.canOpenURL(url) {
                app.open(url, options: [:], completionHandler: nil)
            }
        }
    }


}
