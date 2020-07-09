//
//  ReceiptViewController.swift
//  SmartCheckout
//
//  Created by himanshu on 09/05/20.
//  Copyright © 2020 himanshu. All rights reserved.
//

import Foundation
import UIKit


class ReceiptViewController: UIViewController,UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var receiptTableView: UITableView!
    @IBOutlet weak var receiptScrollView: UIScrollView!
    @IBOutlet weak var orderID: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    var totalAmount = String()
    var orderIDStr = String()
    var dateStr = String()
    var dataArray = [Dictionary<String, Any>]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        receiptTableView.layer.borderColor = UIColor.lightGray.cgColor
        receiptTableView.layer.borderWidth = 1.0
        receiptTableView.layer.cornerRadius = 5.0
        receiptTableView.tableFooterView = UIView()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Basket", style: .plain, target:self, action: #selector(basketButtonAction))
        
        if dateStr==""{
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MMM-yyyy HH:mm"
            formatter.timeZone = .current
            dateStr = formatter.string(from: Date())
            saveReciept()
        }
        
        dateLabel.text = dateStr
        
        orderID.text = "Tran. Id:\(orderIDStr)"
        
        receiptTableView.layoutIfNeeded()
        receiptScrollView.contentSize = CGSize(width: 375, height: 250+receiptTableView.contentSize.height+80)
        receiptTableView.frame.size = receiptTableView.contentSize
        receiptTableView.frame.size.height = receiptTableView.contentSize.height
        receiptTableView.backgroundColor = UIColor.blue
    }
    
    @objc func basketButtonAction() {
        let appDelegate = AppDelegate()
        appDelegate.resetApp()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40))
        footerView.backgroundColor = UIColor.white
      
        let label1 = UILabel()
        label1.frame = CGRect(x: 15, y: 0, width: 80, height: 40)
        label1.text = "ITEM"
        label1.textColor = UIColor.gray
        label1.font  = UIFont.boldSystemFont(ofSize: 13)
        footerView.addSubview(label1)
        
        let label2 = UILabel()
        label2.frame = CGRect(x: 175, y: 0, width: 40, height: 40)
        label2.text = "QTY"
        label2.textColor = UIColor.gray
        label2.font  = UIFont.boldSystemFont(ofSize: 13)
        footerView.addSubview(label2)
        
        let label3 = UILabel()
        label3.frame = CGRect(x: 220, y: 0, width: 80, height: 40)
        label3.text = "PRICE"
        label3.textColor = UIColor.gray
        label3.font  = UIFont.boldSystemFont(ofSize: 13)
        footerView.addSubview(label3)
        
        let label4 = UILabel()
        label4.frame = CGRect(x: 290, y: 0, width: 80, height: 40)
        label4.text = "TOTAL"
        label4.textColor = UIColor.gray
        label4.font  = UIFont.boldSystemFont(ofSize: 13)
        footerView.addSubview(label4)
        
        let separator = UILabel()
        separator.frame = CGRect(x: 0, y: 39, width: tableView.frame.size.width, height: 1)
        separator.backgroundColor = UIColor.lightGray
        footerView.addSubview(separator)
        
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40))
        footerView.backgroundColor = UIColor.black

        
        let label1 = UILabel()
        label1.frame = CGRect(x: 15, y: 0, width: 200, height: 40)
        label1.text = "Total Paid"
        label1.textColor = UIColor.white
        label1.font  = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(rawValue: 8))
        footerView.addSubview(label1)
        
        let label2 = UILabel()
        label2.frame = CGRect(x: 210, y: 0, width: 130, height: 40)
        label2.textAlignment = NSTextAlignment.right
//        totalAmount = totalAmount.replacingOccurrences(of: "Total: ", with: "")
        label2.text = "\(totalAmount.replacingOccurrences(of: "Total: ", with: ""))"
        label2.textColor = UIColor.white
        label2.font  = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(rawValue: 8))
        footerView.addSubview(label2)
        
        return footerView
    }
    
    // set height for footer
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
         
        return 65.0
     }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiptCells", for: indexPath)
        
        let dataDic :Dictionary<String, Any> = dataArray[indexPath.row]
        
        let label1:UILabel = cell.viewWithTag(101) as! UILabel
        label1.text = dataDic["name"] as? String
        
        let label2:UILabel = cell.viewWithTag(102) as! UILabel
        label2.text = "\(dataDic["Qty"] ?? "")"
        
        let label3:UILabel = cell.viewWithTag(103) as! UILabel
        label3.text = dataDic["Price"] as? String
        
        let label4:UILabel = cell.viewWithTag(104) as! UILabel
//        label4.text = dataDic["Total"] as? String
//        label4.text = "\(dataDic["Total"] ?? "")"
        label4.text = dataDic["Total"] as? String
        return cell
    }
    
    func saveReciept(){
        
        var recieptDic = Dictionary<String, Any>()
        recieptDic["Order Id"] = orderIDStr
        recieptDic["Total Amount"] = totalAmount
        recieptDic["Items"] = dataArray
        recieptDic["Purchase Date"] = dateStr
        
        var receiptsArray = [Dictionary<String, Any>]()
        
        if (UserDefaults.standard.object(forKey: "Receipts") != nil) {
            receiptsArray = UserDefaults.standard.array(forKey: "Receipts") as! [Dictionary<String, Any>]
            receiptsArray.insert(recieptDic, at: 0)
            UserDefaults.standard.set(receiptsArray, forKey: "Receipts")
        }
        else{
            receiptsArray.insert(recieptDic, at: 0)
            UserDefaults.standard.set(receiptsArray, forKey: "Receipts")
        }
    }
}
