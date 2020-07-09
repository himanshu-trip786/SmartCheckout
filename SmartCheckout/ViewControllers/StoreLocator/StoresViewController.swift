//
//  StoresViewController.swift
//  SmartCheckout
//
//  Created by himanshu on 20/05/20.
//  Copyright © 2020 himanshu. All rights reserved.
//

import Foundation
import GoogleMaps
import UIKit


class StoresViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,CLLocationManagerDelegate, UISearchBarDelegate
{
    @IBOutlet weak var storeSearchBar : UISearchBar!
    @IBOutlet weak var storesTableView : UITableView!
    var storesDataArray = [Dictionary<String, Any>]()
    let locationManager = CLLocationManager()
    var searchActive : Bool = false
    var filteredstoresDataArray = [Dictionary<String, Any>]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeGetCall()
        //        self.storesTableView.reloadData()
        storeSearchBar.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //        self.storesTableView.reloadData()
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        searchBar.resignFirstResponder()

    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        //        filteredstoresDataArray = storesDataArray.filter({ (text) -> Bool in
        //            let tmp: NSString = text
        //            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
        //            return range.location != NSNotFound
        //        })
        //        let name : String = "name"
        //        filteredstoresDataArray = storesDataArray.filter { $0.["name"].contains(searchText) }
        var search = searchText
        if searchText == "" {
            search  = searchBar.text ?? ""
        }
        
        let searchPredicate = NSPredicate(format: "name CONTAINS[C] %@", search)
        
        filteredstoresDataArray = (storesDataArray as
            NSArray).filtered(using: searchPredicate) as! [Dictionary<String, Any>]
        
        
        if(filteredstoresDataArray.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.storesTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filteredstoresDataArray.count
        }
        return storesDataArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoresListCells", for: indexPath)
        
        if(searchActive){
            if let address = filteredstoresDataArray[indexPath.row]["address"] as? Dictionary<String, Any> {
                let label1:UILabel = cell.viewWithTag(101) as! UILabel
                label1.text = "\(address["streetName1"] ?? ""), \(address["postalAddress"] ?? "" )"
            }
        }
        else{
            if let address = storesDataArray[indexPath.row]["address"] as? Dictionary<String, Any> {
                let label1:UILabel = cell.viewWithTag(101) as! UILabel
                label1.text = "\(address["streetName1"] ?? ""), \(address["postalAddress"] ?? "" )"
            }
        }
        //         cell.detailTextLabel?.text = ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        //        let newViewController = ReceiptViewController()
        //        self.navigationController?.pushViewController(newViewController, animated: true)
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
        //        nextViewController.storeID =
        
        //        nextViewController.dataArray = recieptsArray[indexPath.row]["Items"] as! [Dictionary<String, Any>]
        //        nextViewController.orderIDStr = recieptsArray[indexPath.row]["Order Id"] as? String ?? ""
        //        nextViewController.totalAmount = recieptsArray[indexPath.row]["Total Amount"] as? String ?? ""
        //        nextViewController.dateStr = recieptsArray[indexPath.row]["Purchase Date"] as? String ?? ""
        self.show(nextViewController, sender: nil)
    }
    
    
    func makeGetCall() {
        // Set up the URL request
        //        showSpinner()
        var todoEndpoint = String()
        /*
         if let card_number: String = data["card_number"] as? String {
         if let email: String = data["email"] as? String {
         if let cvv: String = data["cvv"] as? String {
         if let expiry: String = data["expiry"] as? String {
         todoEndpoint = "https://smartcheckout1.free.beeceptor.com/my/api/path/card_number=\(card_number)&cvv=\(cvv)&email=\(email)&expiry=\(expiry)"
         }
         }
         }
         }
         */
//        todoEndpoint = "https://api.storelocator.hmgroup.tech/v2/brand/hm/stores/locale/en_in/latitude/19.0760/longitude/72.8777/radiusinmeters/100000"
  todoEndpoint = "https://api.storelocator.hmgroup.tech/v2/brand/hm/stores/locale/en_in/latitude/28.7041/longitude/77.1025/radiusinmeters/100000"
        //        todoEndpoint = "https://api.storelocator.hmgroup.tech/v2/brand/hm/stores/locale/en_in/country/IN"
        
        guard let url = URL(string: todoEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = URLRequest(url: url)
        //        urlRequest.httpMethod = "POST"
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            // check for any errors
            guard error == nil else {
                print("error calling GET on /todos/1")
                print(error ?? "")
                self.showAlertwith(Title: "Error", andMessage: "Error calling GET API.")
                return
            }
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                self.showAlertwith(Title: "Error", andMessage: "Did not receive data.")
                return
            }
            
            // parse the result as JSON, since that's what the API provides
            do {
                guard let todo: Dictionary = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] else {
                    print("error trying to convert data to JSON")
                    self.showAlertwith(Title: "Error", andMessage: "Error trying to convert data to JSON")
                    return
                }
                // now we have the todo, let's just print it to prove we can access it
                print("The todo is: " + (todo as Dictionary).description)
                
                if let array = todo["stores"] as? [Dictionary<String, Any>]{
                    self.storesDataArray = array
                }
                
                //                self.storesDataArray.append(todo["stores"] as! [String : Any])
                
                print("The dataArray is: " + self.storesDataArray.description)
                
                //                if (self.storesDataArray.count>0){
                //                    self.storesTableView.reloadData()
                //                }
                self.reloadStoreTable()
                //                self.transactionIdStr = todo["Transaction Id"] as! String
                
                //                self.showAlertwith(Title: "Payment Successful!", andMessage: "Your Transaction Id is \(self.transactionIdStr).")
                
                // the todo object is a dictionary
                // so we just access the title using the "title" key
                // so check for a title and print it if we have one
                
                guard let todoTitle = todo["name"] as? String else {
                    print("Could not get todo title from JSON")
                    return
                }
                print("The title is: " + todoTitle)
                
            } catch  {
                print("error trying to convert data to JSON")
                self.showAlertwith(Title: "Payment Failed!", andMessage: "Sorry, we are unable to process your payment.Please check the entered details and try again.")
                return
            }
        }
        
        task.resume()
    }
    
    func reloadStoreTable(){
        DispatchQueue.main.async {
            //               self.hideSpinner()
            if self.storesDataArray.count>0{
                self.storesTableView.reloadData()
                //                   self.scrollToBottom()
                //                   self.cartTableView.isHidden = false
            }
            //               self.readerView.isHidden = true
        }
    }
    
    func showAlertwith(Title: String, andMessage:String){
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: Title, message: andMessage, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        storeSearchBar.endEditing(true)
        storeSearchBar.resignFirstResponder()
    }
}
