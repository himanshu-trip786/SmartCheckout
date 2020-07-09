//
//  ProductDetailViewController.swift
//  SmartCheckout
//
//  Created by himanshu on 12/05/20.
//  Copyright © 2020 himanshu. All rights reserved.
//

import Foundation
import UIKit

class ProductDetailViewController: UIViewController{
    var dataDict = Dictionary<String, Any>()
    @IBOutlet var productImageView: UIImageView!
//    @IBOutlet var articleNameLabel: UILabel!
    @IBOutlet var articlePriceLabel: UILabel!
    @IBOutlet var articleDescLabel: UILabel!
    
    override func viewDidLoad() {
        self.navigationItem.title = dataDict["name"] as? String
        productImageView.layer.borderColor = UIColor.darkGray.cgColor
        productImageView.layer.borderWidth = 1.0
        if let urlStr = dataDict["product_image"] as? String {
                   productImageView?.sd_setImage(with: URL(string: urlStr))
               }
        articlePriceLabel.text = "Price: $ \(dataDict["Price"] ?? "")"
        articleDescLabel.text = "\(dataDict["description"] ?? "")"
    }
}
