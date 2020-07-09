//
//  SmartCartCell.swift
//  SmartCheckout
//
//  Created by himanshu on 05/05/20.
//  Copyright © 2020 himanshu. All rights reserved.
//

import UIKit

class SmartCartCell: UITableViewCell, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet var productImageView: UIImageView!
    @IBOutlet var articleNameLabel: UILabel!
    @IBOutlet var articlePriceLabel: UILabel!
    @IBOutlet weak var articleQtyTextField : UITextField!
    @IBOutlet weak var articleTotalLabel: UILabel!
    let quantity = ["1","2","3","4","5","6","7","8","9","10"]
    var totalAmount : Int = 0
    var articlePrice: Int = 0
    weak var cartViewController : CartViewController?
    let pickerView = UIPickerView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //        productImageView.layers.cornerRadius = productImageView.frame.height/2
        //        productImageView.clipsToBounds = true
        productImageView.layer.borderColor = UIColor.darkGray.cgColor
        productImageView.layer.borderWidth = 1.0
        
//        let pickerView = UIPickerView()
        pickerView.delegate = self
        
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(donepicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton,doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        articleQtyTextField.inputAccessoryView = toolBar
        articleQtyTextField.inputView = pickerView
        setNeedsUpdateConstraints()
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.productImageView.sd_setImage(with: nil)
        self.articleNameLabel.text = nil
        self.articlePriceLabel.text = nil
        self.articleTotalLabel.text = nil
        self.articleQtyTextField.text = nil
    }
    
    func setupWithModel(data: Dictionary<String, Any>){
        
        articleNameLabel.text = data["name"] as? String
        
        articleQtyTextField.text = "\(data["Qty"] ?? 1)"
        
        let qty : Int = data["Qty"] as? Int ?? 1
        pickerView.selectRow(qty-1, inComponent: 0, animated: false)
        if let price: String =  data["Price"] as? String{
            
            articlePriceLabel.text = "$ \(price)"
            articlePrice = Int(price) ?? 0
            let totalPrice = articlePrice*qty
            articleTotalLabel.text = "$ \(totalPrice)"
            totalAmount = Int(price) ?? 0
        }

        if let urlStr = data["product_image"] as? String {
            productImageView?.sd_setImage(with: URL(string: urlStr))
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        quantity.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return quantity[row]
    }
    
    // When user selects an option, this function will set the text of the text field to reflect
    // the selected option.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        articleQtyTextField.text = quantity[row]

        if let myInt2 = Int(quantity[row]) {
            totalAmount = articlePrice * myInt2
            articleTotalLabel.text = "$ \(totalAmount)"
            cartViewController?.updateQty(forCellwith: self.tag, withQty: myInt2, andTotal:totalAmount)
            cartViewController?.updateTotal()
        }
    }
    
    @objc func donepicker(){
        articleQtyTextField.resignFirstResponder()
    }
}
