//
//  ReceiptsListViewController.swift
//  SmartCheckout
//
//  Created by himanshu on 12/05/20.
//  Copyright © 2020 himanshu. All rights reserved.
//

import Foundation
import UIKit

class ReceiptsListViewController: UITableViewController{
    
    var recieptsArray = [Dictionary<String, Any>]()
    //    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    //        return UIView()
    //    }
    override func viewDidLoad() {
        //        UserDefaults.standard.object(forKey: "Receipts")
        if UserDefaults.standard.array(forKey: "Receipts") != nil {
            recieptsArray = UserDefaults.standard.array(forKey: "Receipts") as! [Dictionary<String, Any>]
            print("\(recieptsArray)")
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recieptsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiptListCells", for: indexPath)
        cell.textLabel?.text = "Tran. Id: \(recieptsArray[indexPath.row]["Order Id"] ?? "")"
        cell.detailTextLabel?.text = "\(recieptsArray[indexPath.row]["Purchase Date"] ?? "")"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        //        let newViewController = ReceiptViewController()
        //        self.navigationController?.pushViewController(newViewController, animated: true)
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ReceiptViewController") as! ReceiptViewController
        nextViewController.dataArray = recieptsArray[indexPath.row]["Items"] as! [Dictionary<String, Any>]
        nextViewController.orderIDStr = recieptsArray[indexPath.row]["Order Id"] as? String ?? ""
        nextViewController.totalAmount = recieptsArray[indexPath.row]["Total Amount"] as? String ?? ""
        nextViewController.dateStr = recieptsArray[indexPath.row]["Purchase Date"] as? String ?? ""
        self.show(nextViewController, sender: nil)
    }
}
