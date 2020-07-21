//
//  LocationsTableViewController.swift
//  On The Map
//
//  Created by Riham Mastour on 28/11/1441 AH.
//  Copyright © 1441 Riham Mastour. All rights reserved.
//

import UIKit

class LocationsTableViewController: UITableViewController {
    

    @IBOutlet var locationsTableView: UITableView!
//    var allLocations: AllLocations?
    var allLocations: AllLocations? {
        didSet {
            locationsTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                self.locationsTableView.reloadData()
            }
        }
    }
    
    @IBAction func refereshPressed(_ sender: Any) {
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
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the number of rows
        if allLocations?.results != nil{
            return allLocations!.results.count
        } else {
            return 0
        }
    }
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LocationsCell") as! LocationsTableViewCell
        if allLocations?.results != nil{
         
        let locations = self.allLocations!.results[indexPath.row]
            
        // Set the image and label
        cell.title.text = locations.firstName! + " " + locations.lastName!
        cell.subTitle.text = locations.mediaURL
        return cell

        } else {
            cell.title.text = ""
            cell.subTitle.text = ""
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if allLocations?.results != nil{
            let locations = self.allLocations!.results[indexPath.row]
            let url = URL(string:locations.mediaURL!)!
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        
        }
    }
    
    @IBAction func unwindToLocationsTableView(_ unwindSegue: UIStoryboardSegue) {
        _ = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
    }
}
