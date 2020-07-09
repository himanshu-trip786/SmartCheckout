//
//  CheckoutViewController.swift
//  SmartCheckout
//
//  Created by himanshu on 09/05/20.
//  Copyright © 2020 himanshu. All rights reserved.
//

import Foundation
import UIKit

//extension String {
//    var stringByRemovingWhitespaces: String {
//        let components = componentsSeparatedByCharactersInSet(.whitespaceCharacterSet())
//        return components.joinWithSeparator("")
//    }
//}

extension UITextField {
    func addDoneCancelToolbar(onDone: (target: Any, action: Selector)? = nil, onCancel: (target: Any, action: Selector)? = nil) {
        let onCancel = onCancel ?? (target: self, action: #selector(cancelButtonTapped))
        let onDone = onDone ?? (target: self, action: #selector(doneButtonTapped))
        
        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(title: "Cancel", style: .plain, target: onCancel.target, action: onCancel.action),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: onDone.target, action: onDone.action)
        ]
        toolbar.sizeToFit()
        
        self.inputAccessoryView = toolbar
    }
    
    // Default actions:
    @objc func doneButtonTapped() { self.resignFirstResponder() }
    @objc func cancelButtonTapped() { self.resignFirstResponder() }
}

class CheckoutViewController: UIViewController, UITextFieldDelegate
{
    @IBOutlet var articleTotalLabel: UILabel!
    @IBOutlet var payButton: UIButton!
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var cardTextfield: UITextField! {
        didSet { cardTextfield?.addDoneCancelToolbar() }
    }
    @IBOutlet var exipiryTextfield: UITextField!
        {
        didSet { exipiryTextfield?.addDoneCancelToolbar() }
    }
    @IBOutlet var cvvTextfield: UITextField!
        {
        didSet { cvvTextfield?.addDoneCancelToolbar() }
    }
    private var previousTextFieldContent: String?
    private var previousSelection: UITextRange?
    
    var articleTotalStr = String()
    var transactionIdStr = String()
    var dataArray = [Dictionary<String, Any>]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        articleTotalLabel.text = articleTotalStr
        
        payButton.layer.cornerRadius = 10.0
        
        payButton.layer.shadowRadius = 5
        payButton.layer.shadowOpacity = 0.5
        payButton.layer.shadowOffset = CGSize(width: 3, height: 3)
        
        cardTextfield.addTarget(self, action: #selector(reformatAsCardNumber), for: .editingChanged)
        
    }
    
    @IBAction func payButtonAction(_ sender: Any) {

        guard let email = emailTextfield.text else {
            return
        }
        
        let isValidateEmail = validateEmailId(emailID: email)
        if (isValidateEmail == false) {
            print("Incorrect Email")
            
            showAlertwith(Title: "Incorrect email", andMessage: "Please enter proper email address.")
            
//            let alertController = UIAlertController(title: "Incorrect email", message: "Please enter proper email addresss", preferredStyle: .alert)
//            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
//            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        if let cardTextCount: Int =  cardTextfield.text?.count{
            if cardTextCount == 0 || cardTextCount < 19{
          showAlertwith(Title: "Incorrect card number", andMessage: "Please enter proper card number.")
//                let alertController = UIAlertController(title: "Incorrect card number", message: "Please enter proper card Number", preferredStyle: .alert)
//                alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
//                self.present(alertController, animated: true, completion: nil)
                return
            }
        }
        
        if let expiryTextCount: Int =  exipiryTextfield.text?.count{
            if expiryTextCount == 0 || expiryTextCount < 5{
                showAlertwith(Title: "Incorrect expiry date", andMessage: "Please enter proper expiry date.")

//                let alertController = UIAlertController(title: "Incorrect expiry date", message: "Please enter proper expiry date", preferredStyle: .alert)
//                alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
//                self.present(alertController, animated: true, completion: nil)
                return
            }
        }
        
        
        if let cvvTextCount: Int =  cvvTextfield.text?.count{
            if cvvTextCount == 0 || cvvTextCount < 3{
                showAlertwith(Title: "Incorrect cvv", andMessage: "Please enter proper cvv code.")

//                let alertController = UIAlertController(title: "Incorrect cvv", message: "Please enter proper cvv Code", preferredStyle: .alert)
//                alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
//                self.present(alertController, animated: true, completion: nil)
                return
            }
        }
        
        var dataDic = Dictionary<String, Any>()
        dataDic["card_number"] = cardTextfield.text?.replacingOccurrences(of: " ", with: "")
        dataDic["cvv"] = cvvTextfield.text
        dataDic["email"] = emailTextfield.text
        dataDic["expiry"] = exipiryTextfield.text
        makeGetCall(data: dataDic)

//        navigatetoNextScreen()
    }
    
    // MARK: - API Call
    
    func makeGetCall(data: Dictionary<String, Any>) {
        // Set up the URL request
        showSpinner()
        var todoEndpoint = String()
        if let card_number: String = data["card_number"] as? String {
            if let email: String = data["email"] as? String {
                if let cvv: String = data["cvv"] as? String {
                    if let expiry: String = data["expiry"] as? String {
                        todoEndpoint = "https://smartcheckout1.free.beeceptor.com/my/api/path/card_number=\(card_number)&cvv=\(cvv)&email=\(email)&expiry=\(expiry)"
                    }
                }
            }
        }
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
                
                self.transactionIdStr = todo["Transaction Id"] as! String
                
                self.showAlertwith(Title: "Payment Successful!", andMessage: "Your Transaction Id is \(self.transactionIdStr).")
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
    
    // MARK: - Textfield Delegate methods
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty { return true }
        
        if textField == cardTextfield {
            previousTextFieldContent = textField.text;
            previousSelection = textField.selectedTextRange;
        }
        
        if textField == cvvTextfield {
            if cvvTextfield.text!.count>2{
                return false
            }
        }
        
        if textField == exipiryTextfield {
            
            // check the chars length dd -->2 at the same time calculate the dd-MM --> 5
            if (exipiryTextfield?.text?.count == 2) {
                //Handle backspace being pressed
                if !(string == "") {
                    // append the text
                    exipiryTextfield?.text = (exipiryTextfield?.text)! + "/"
                }
            }
            // check the condition not exceed 9 chars
            return !(textField.text!.count > 4 && (string.count ) > range.length)
        }
        
        return true
    }
    
    @objc func reformatAsCardNumber(textField: UITextField) {
        var targetCursorPosition = 0
        if let startPosition = textField.selectedTextRange?.start {
            targetCursorPosition = textField.offset(from: textField.beginningOfDocument, to: startPosition)
        }
        
        var cardNumberWithoutSpaces = ""
        if let text = textField.text {
            cardNumberWithoutSpaces = self.removeNonDigits(string: text, andPreserveCursorPosition: &targetCursorPosition)
        }
        
        if cardNumberWithoutSpaces.count > 19 {
            textField.text = previousTextFieldContent
            textField.selectedTextRange = previousSelection
            return
        }
        
        let cardNumberWithSpaces = self.insertCreditCardSpaces(cardNumberWithoutSpaces, preserveCursorPosition: &targetCursorPosition)
        textField.text = cardNumberWithSpaces
        
        if let targetPosition = textField.position(from: textField.beginningOfDocument, offset: targetCursorPosition) {
            textField.selectedTextRange = textField.textRange(from: targetPosition, to: targetPosition)
        }
    }
    
    func removeNonDigits(string: String, andPreserveCursorPosition cursorPosition: inout Int) -> String {
        var digitsOnlyString = ""
        let originalCursorPosition = cursorPosition
        
        for i in Swift.stride(from: 0, to: string.count, by: 1) {
            let characterToAdd = string[string.index(string.startIndex, offsetBy: i)]
            if characterToAdd >= "0" && characterToAdd <= "9" {
                digitsOnlyString.append(characterToAdd)
            }
            else if i < originalCursorPosition {
                cursorPosition -= 1
            }
        }
        
        return digitsOnlyString
    }
    
    func insertCreditCardSpaces(_ string: String, preserveCursorPosition cursorPosition: inout Int) -> String {
        // Mapping of card prefix to pattern is taken from
        // https://baymard.com/checkout-usability/credit-card-patterns
        
        // UATP cards have 4-5-6 (XXXX-XXXXX-XXXXXX) format
        let is456 = string.hasPrefix("1")
        
        // These prefixes reliably indicate either a 4-6-5 or 4-6-4 card. We treat all these
        // as 4-6-5-4 to err on the side of always letting the user type more digits.
        let is465 = [
            // Amex
            "34", "37",
            
            // Diners Club
            "300", "301", "302", "303", "304", "305", "309", "36", "38", "39"
            ].contains { string.hasPrefix($0) }
        
        // In all other cases, assume 4-4-4-4-3.
        // This won't always be correct; for instance, Maestro has 4-4-5 cards according
        // to https://baymard.com/checkout-usability/credit-card-patterns, but I don't
        // know what prefixes identify particular formats.
        let is4444 = !(is456 || is465)
        
        var stringWithAddedSpaces = ""
        let cursorPositionInSpacelessString = cursorPosition
        
        for i in 0..<string.count {
            let needs465Spacing = (is465 && (i == 4 || i == 10 || i == 15))
            let needs456Spacing = (is456 && (i == 4 || i == 9 || i == 15))
            let needs4444Spacing = (is4444 && i > 0 && (i % 4) == 0)
            
            if needs465Spacing || needs456Spacing || needs4444Spacing {
                stringWithAddedSpaces.append(" ")
                
                if i < cursorPositionInSpacelessString {
                    cursorPosition += 1
                }
            }
            
            let characterToAdd = string[string.index(string.startIndex, offsetBy:i)]
            stringWithAddedSpaces.append(characterToAdd)
        }
        
        return stringWithAddedSpaces
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func validateEmailId(emailID: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let trimmedString = emailID.trimmingCharacters(in: .whitespaces)
        let validateEmail = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let isValidateEmail = validateEmail.evaluate(with: trimmedString)
        return isValidateEmail
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is ReceiptViewController
        {
            let vc = segue.destination as? ReceiptViewController
            vc?.dataArray = dataArray
            vc?.orderIDStr = transactionIdStr
        }
    }
    
    func showAlertwith(Title: String, andMessage:String){
        hideSpinner()
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: Title, message: andMessage, preferredStyle: .alert)
            if Title == "Payment Successful!"{
                alertController.addAction( UIAlertAction(title: "OK", style: .default) {
                    UIAlertAction in
                    NSLog("OK Pressed")
                    self.navigatetoNextScreen()
                })
            }
            else{
                alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            }
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func showSpinner(){
        DispatchQueue.main.async {
            SpinnerView.shared().show(in: self.view)
        }
    }
    
    func hideSpinner(){
        DispatchQueue.main.async {
            SpinnerView.shared().removeSpinner(from: self.view)
        }
    }
    
    func navigatetoNextScreen(){
        DispatchQueue.main.async {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ReceiptViewController") as! ReceiptViewController
            nextViewController.dataArray = self.dataArray
            nextViewController.orderIDStr = self.transactionIdStr
            nextViewController.totalAmount = self.articleTotalStr
            self.show(nextViewController, sender: nil)
        }
    }
}
