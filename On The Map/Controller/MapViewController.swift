//
//  MapViewController.swift
//  On The Map
//
//  Created by Riham Mastour on 28/11/1441 AH.
//  Copyright © 1441 Riham Mastour. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {


    @IBOutlet weak var mapView: MKMapView!
    var allLocations: AllLocations?
     
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
     getAllLocations()
        
    }
    
    func getAllLocations(){
        API.getStudentLocation { (data, error) in
            DispatchQueue.main.async {
                
                guard let data = data else {
                    self.alert(title: "Error", message: "No internet connection found")
                    return
                }
                
                guard data.results.count > 0 else {
                    self.alert(title: "Error", message: "No pins found")
                    return
                }
                
                self.allLocations = data
           
                guard let locations = self.allLocations?.results else { return }
                var annotations = [MKPointAnnotation]()
                  
                for location in locations {
                                   
                    guard let latitude = location.latitude, let longitude = location.longitude else { continue }
                    let lat = CLLocationDegrees(latitude)
                    let long = CLLocationDegrees(longitude)
                                   
                    // The lat and long are used to create a CLLocationCoordinates2D instance.
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                                
                    let first = location.firstName
                    let last = location.lastName
                    let mediaURL = location.mediaURL
                                                    
                    // Here we create the annotation and set its coordiate, title, and subtitle properties
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "\(first ?? "") \(last ?? "")"
                    annotation.subtitle = mediaURL
                                   
                    // Finally we place the annotation in an array of annotations.
                    annotations.append(annotation)
                }
                    
                    // When the array is complete, we add the annotations to the map.
                    self.mapView.removeAnnotations(self.mapView.annotations)
                    self.mapView.addAnnotations(annotations)
            }
        }
    }


    @IBAction func refreshPressed(_ sender: Any) {
        getAllLocations()
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        API.logout { (error) in
            DispatchQueue.main.async {
                guard error == nil else {
                    self.alert(title: "Error", message: error?.localizedDescription)
                    return
                }
            }
        }
        self.performSegue(withIdentifier: "logoutSegue", sender: nil)
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
            if let toOpen = view.annotation?.subtitle!, let url = URL(string: toOpen), app.canOpenURL(url) {
                app.open(url, options: [:], completionHandler: nil)
            }
                
        }
    }
    
    @IBAction func unwindToMap(_ unwindSegue: UIStoryboardSegue) {
        let _ = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
    }
}
   
