//
//  CartViewController.swift
//  SmartCheckout
//
//  Created by himanshu on 05/05/20.
//  Copyright © 2020 himanshu. All rights reserved.
//

import Foundation
import UIKit
import CocoaLumberjack
import ZXingObjC
import ReactiveCocoa
import MTBBarcodeScanner
//import SpinnerView

private let cellId: String = "SmartCartCell"

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    var dataArray = [Dictionary<String, Any>]()
    var storeID = String()
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var receiptButton: UIButton!
    @IBOutlet weak var checkoutButton: UIButton!
    @IBOutlet var totalLabel: UILabel!
    @IBOutlet weak var readerView: UIView!
    //    var scanner: MTBBarcodeScanner?
    @IBOutlet weak var cartTableView: UITableView! {
        didSet {
            let nib = UINib(nibName: cellId, bundle: Bundle.main)
            self.cartTableView.register(nib, forCellReuseIdentifier: cellId)
        }
    }
    private var allCells = [SmartCartCell]()
    
    //    private let mainDisposable = CompositeDisposable()
    private let hints: ZXDecodeHints = ZXDecodeHints.init()
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    private var captureSession: AVCaptureSession = AVCaptureSession()
    private let reader: ZXMultiFormatReader = ZXMultiFormatReader.init()
    //    private var scanErrorConfiguration: ScanError? = .notHMProduct
    private var multiReader: ZXGenericMultipleBarcodeReader = ZXGenericMultipleBarcodeReader.init()
    private var scannerIsBusy: Bool = false
    let queue = DispatchQueue(label: "com.hm.BarCodeScanner")
    
    @objc static let shared = CartViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        scanner = MTBBarcodeScanner(previewView: readerView)
        cartTableView.isHidden = false
        readerView.isHidden = true
        cartTableView.tableFooterView = UIView()
        
        receiptButton.layer.cornerRadius = 10.0
        checkoutButton.layer.cornerRadius = 10.0
        scanButton.layer.cornerRadius = 10.0
        
        scanButton.layer.shadowRadius = 5
        scanButton.layer.shadowOpacity = 0.5
        scanButton.layer.shadowOffset = CGSize(width: 3, height: 3)
        
        receiptButton.layer.shadowRadius = 5
        receiptButton.layer.shadowOpacity = 0.5
        receiptButton.layer.shadowOffset = CGSize(width: 1, height: 1)
        
        checkoutButton.layer.shadowRadius = 5
        checkoutButton.layer.shadowOpacity = 0.5
        checkoutButton.layer.shadowOffset = CGSize(width: 1, height: 1)
        
        //        productImageView.clipsToBounds = true
        
        //         Do any additional setup after loading the view.
        
        self.configureViews()
        self.initializeScanner()
        //        startScanner()
        NotificationCenter.default.addObserver(self, selector: #selector(startScanner), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(stopScanner), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        /*
        let dataDic : Dictionary = ["code": "10004",
                                    "name": "Black Floral Jacket",
                                    "description": "Jacket in washed denim with a collar and buttons down the front. Flap chest pockets with a button, welt side pockets, buttoned cuffs and an adjustable tab and button at the sides.",
                                    "Price": "850",
                                    "product_image": "https://lp2.hm.com/hmgoepprod?set=source[/f8/bf/f8bfa53089302e356c0923d55592e1e99222c257.jpg],origin[dam],category[men_jacketscoats_jackets],type[DESCRIPTIVESTILLLIFE],res[y],hmver[1]&call=url[file:/product/main]","Qty":1,"Total":"850"] as [String : Any]
        
        
        dataArray.append(dataDic)
        dataArray.append(dataDic)
        dataArray.append(dataDic)
        dataArray.append(dataDic)
        dataArray.append(dataDic)
        dataArray.append(dataDic)
        dataArray.append(dataDic)
        dataArray.append(dataDic)
        dataArray.append(dataDic)
        dataArray.append(dataDic)
        dataArray.append(dataDic)
 */
        //        scrollToBottom()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if dataArray.count==0 {
            cartTableView.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NSLog("viewWillDisappear")
        stopScanner()
    }
    
    private func configureViews() {
        
        
    }
    
    private func initializeScanner() {
        guard checkCameraPermission() else {return}
        
        // Configure layer
        let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer.frame = self.readerView.layer.bounds
        
        let image = UIImage(named: "cross")
        
        let button = UIButton(frame: CGRect(x: 340, y: 10, width: 20, height: 20))
        button.setImage(image, for: UIControl.State.normal)
        //        button.backgroundColor = .white
        button.addTarget(self, action: #selector(self.removeScanner(_:)), for: .touchUpInside)
        //        myView.addSubview(button)
        
        self.readerView.layer.addSublayer(videoPreviewLayer)
        //        self.readerView.layer.addSublayer(button.layer)
        self.readerView.addSubview(button)
        self.videoPreviewLayer = videoPreviewLayer
        
        // Configure reader
        
        self.hints.addPossibleFormat(kBarcodeFormatAztec)
        self.hints.addPossibleFormat(kBarcodeFormatITF)
        self.hints.addPossibleFormat(kBarcodeFormatDataMatrix)
        self.hints.addPossibleFormat(kBarcodeFormatEan13)
        self.hints.addPossibleFormat(kBarcodeFormatCode128)
        self.hints.addPossibleFormat(kBarcodeFormatUPCEANExtension)
        self.hints.addPossibleFormat(kBarcodeFormatUPCE)
        self.hints.addPossibleFormat(kBarcodeFormatUPCA)
        self.hints.addPossibleFormat(kBarcodeFormatRSSExpanded)
        self.hints.addPossibleFormat(kBarcodeFormatQRCode)
        self.hints.addPossibleFormat(kBarcodeFormatPDF417)
        self.hints.addPossibleFormat(kBarcodeFormatMaxiCode)
        self.hints.addPossibleFormat(kBarcodeFormatITF)
        
        self.hints.tryHarder = false
        self.reader.hints = hints
        self.multiReader = ZXGenericMultipleBarcodeReader.init(delegate: self.reader)
    }
    
    @objc private func startScanner() {
        guard checkCameraPermission() else {
            return
        }
        self.scannerIsBusy = false
        configureCamera()
    }
    
    @objc private func stopScanner() {
        guard captureSession.isRunning else { return }
        captureSession.stopRunning()
    }
    
    private func checkCameraPermission() -> Bool {
        let authStatus: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        guard authStatus == AVAuthorizationStatus.denied else {
            return true
        }
        //        let grantTitle: String = HMWLocalizationManager.shared().localizedString(forKey: kScanCameraGrantTitle)
        //        let grantDescription: String = HMWLocalizationManager.shared().localizedString(forKey: kScanCameraGrantDescription)
        //
        //        Utilities.showGenericAlertMessage(in: self, withHeader: grantTitle, andMessage: grantDescription, andActions: nil)
        return false
    }
    
    
    private func configureCamera() {
        
        // Configure AVSession
        captureSession.beginConfiguration()
        if captureSession.canSetSessionPreset(.hd1920x1080) {
            captureSession.sessionPreset = .hd1920x1080
        } else if captureSession.canSetSessionPreset(.medium) {
            captureSession.sessionPreset = .medium
        }
        
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {return}
        guard let deviceInput = try? AVCaptureDeviceInput(device: captureDevice) else {return}
        if captureSession.canAddInput(deviceInput) {
            captureSession.addInput(deviceInput)
        }
        
        do {
            try captureDevice.lockForConfiguration()
            
            if captureDevice.maxAvailableVideoZoomFactor >= 2.0 {
                captureDevice.videoZoomFactor = 2.0
            } else {
                captureDevice.videoZoomFactor = captureDevice.maxAvailableVideoZoomFactor
            }
            
            if captureDevice.isTorchModeSupported(.auto) {
                captureDevice.torchMode = .auto
            }
            
            captureDevice.unlockForConfiguration()
        } catch let error {
            DDLogDebug("Error lockingConfiguration: \(error.localizedDescription)")
        }
        
        let dataOutput: AVCaptureVideoDataOutput = AVCaptureVideoDataOutput()
        dataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as String): NSNumber(value: kCVPixelFormatType_32BGRA as UInt32)]
        dataOutput.alwaysDiscardsLateVideoFrames = true
        dataOutput.setSampleBufferDelegate(self, queue: queue)
        if captureSession.canAddOutput(dataOutput) {
            captureSession.addOutput(dataOutput)
        }
        captureSession.commitConfiguration()
        
        captureSession.startRunning()
    }
    
    // MARK: - TableView Delegate and Datasource methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as?        SmartCartCell
            else{
                return UITableViewCell()
        }
        if !allCells.contains(cell) { allCells.insert(cell, at: indexPath.row) }
        //        cell.separatorInset = UIEdgeInsets.zero
        //        cell.preservesSuperviewLayoutMargins = false
        //        cell.layoutMargins =  UIEdgeInsets.zero
        cell.tag = indexPath.row+1
        cell.setupWithModel(data: dataArray[indexPath.row])
        cell.cartViewController = self
        updateTotal()
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            // remove the item from the data model
            dataArray.remove(at: indexPath.row)
            
            // delete the table view row
            tableView.deleteRows(at: [indexPath], with: .fade)
            allCells.remove(at: indexPath.row)
            if dataArray.count==0 {
                cartTableView.isHidden = true
            }
            tableView.reloadData()
            updateTotal()
        } else if editingStyle == .insert {
            // Not used in our example, but if you were adding a new row, this is where you would do it.
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
            nextViewController.dataDict = dataArray[indexPath.row]
            self.show(nextViewController, sender: nil)
        }
    
    // MARK: - Button Actions Methods
    
    @IBAction func scanButtonAction(_ sender: Any) {
        //        cartTableView.isHidden = true
        readerView.isHidden = false
        startScanner()
    }

    @IBAction func cartButtonAction(_ sender: Any) {
      
//        let storyBoard : UIStoryboard = UIStoryboard(name: "StoreLocator", bundle:nil)
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "StoresViewController") as! StoresViewController
//        self.show(nextViewController, sender: nil)


        
        if UserDefaults.standard.array(forKey: "Receipts") == nil {
            showAlertwith(Title: "Alert", andMessage: "Currently, you have no saved receipts in you app.")
            return
        }

        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ReceiptsListViewController") as! ReceiptsListViewController
        self.show(nextViewController, sender: nil)
    
    }
    
    @IBAction func checkoutButtonAction(_ sender: Any) {
        if dataArray.count==0 {
            showAlertwith(Title: "Alert", andMessage: "Please scan and add items into the cart before proceeding.")
            return
        }
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CheckoutViewController") as! CheckoutViewController
        nextViewController.articleTotalStr = totalLabel.text ?? ""
        nextViewController.dataArray = dataArray
        self.show(nextViewController, sender: nil)
    }
    
    @IBAction func removeScanner(_ sender: Any) {
        stopScanner()
        readerView.isHidden = true
        if dataArray.count>0 {
            cartTableView.isHidden = false
        }
    }
    
    // MARK: - BarCode methods
    private func extractCodeFromOneBarCodeZXing(barCodeScanned: ZXResult) -> String? {
        guard let barCodeText = barCodeScanned.text else {
            return nil
        }
        
        DDLogDebug("Complete BarCode Scanned \(String(describing: barCodeText))")
        
        if barCodeText.count == 22 {
            if barCodeScanned.barcodeFormat == kBarcodeFormatCode128 {
                return barCodeText
            } else if barCodeScanned.barcodeFormat == kBarcodeFormatITF && (barCodeText.hasPrefix("7") || barCodeText.hasPrefix("8")) {
                
                let qrString: NSMutableString = NSMutableString()
                
                var rangeA: String.Index = String.Index(utf16Offset: 2, in: barCodeText)
                var rangeB: String.Index = String.Index(utf16Offset: 6, in: barCodeText)
                
                let orderIDValueFromFirstString: String = String(barCodeText[rangeA...rangeB])
                qrString.append(orderIDValueFromFirstString)
                
                rangeA = String.Index(utf16Offset: 11, in: barCodeText)
                let seasonValue: String = String(barCodeText[rangeA])
                qrString.append(seasonValue)
                
                rangeA = String.Index(utf16Offset: 7, in: barCodeText)
                rangeB = String.Index(utf16Offset: 10, in: barCodeText)
                let departmentValue: String = String(barCodeText[rangeA...rangeB])
                qrString.append(departmentValue)
                
                rangeA = String.Index(utf16Offset: 12, in: barCodeText)
                rangeB = String.Index(utf16Offset: 13, in: barCodeText)
                let colourCodeValue: String = String(barCodeText[rangeA...rangeB])
                qrString.append(colourCodeValue)
                
                return String(qrString)
            } else {
                return nil
            }
        } else if barCodeScanned.barcodeFormat == kBarcodeFormatEan13 {
            // For EAN13 it has to add the "0" at the beginning of bar code
            return "0\(barCodeText)"
        } else if (barCodeScanned.barcodeFormat == kBarcodeFormatDataMatrix) && (barCodeText.count >= 17) {
            // For DataMatrix The 14 digits from the 3° to the 16° are exactly the GTIN-14 code
            // First character is invisible
            
            let rangeA: String.Index = String.Index(utf16Offset: 3, in: barCodeText)
            let rangeB: String.Index = String.Index(utf16Offset: 16, in: barCodeText)
            
            return String(barCodeText[rangeA...rangeB])
        }
        
        return nil
    }
    
    private func extractCodeFromThreeBarCodesI25(sortedScannedCodes: [String]) -> String? {
        let qrString: NSMutableString = NSMutableString.init()
        
        if self.isThreeBarCodesValidated(sortedScannedCodes: sortedScannedCodes) {
            // The first char is always "0"
            qrString.append("0")
            
            guard sortedScannedCodes.count == 3 else { return nil }
            let firstObject = sortedScannedCodes[0]
            let secondObject = sortedScannedCodes[1]
            _ = sortedScannedCodes[2]
            
            var rangeA: String.Index = String.Index(utf16Offset: 2, in: firstObject)
            var rangeB: String.Index = String.Index(utf16Offset: 6, in: firstObject)
            
            let orderIDValueString: String = String(firstObject[rangeA...rangeB])
            qrString.append(orderIDValueString)
            
            rangeA = .init(utf16Offset: 7, in: secondObject)
            let seasonValueString: String = String(secondObject[rangeA])
            qrString.append(seasonValueString)
            
            rangeA = .init(utf16Offset: 1, in: secondObject)
            rangeB = .init(utf16Offset: 4, in: secondObject)
            let sizeValueString: String = String(secondObject[rangeA...rangeB])
            qrString.append(sizeValueString)
            
            rangeA = .init(utf16Offset: 5, in: secondObject)
            rangeB = .init(utf16Offset: 6, in: secondObject)
            let colourCodeValueString: String = String(secondObject[rangeA...rangeB])
            qrString.append(colourCodeValueString)
            
            // Calculate the check digit
            if qrString.length == 13 {
                guard let checkDigit = self.calculateCheckDigit(barCodeString: String(qrString)) else { return String(qrString) }
                qrString.append(checkDigit)
            } else {
                return nil
            }
            return String(qrString)
        }
        return nil
    }
    
    private func calculateCheckDigit(barCodeString: String) -> String? {
        var multiplier: Int = 3
        var sum = 0
        
        for index in 0 ..< barCodeString.count {
            
            let charPosition = String.Index(utf16Offset: index, in: barCodeString)
            guard let singleChar: Int = Int(String(barCodeString[charPosition])) else { return nil }
            let result = singleChar * multiplier
            if multiplier == 3 {
                sum += result
                multiplier -= 2
            } else {
                sum += result
                multiplier += 2
            }
        }
        if sum > 0 {
            let remainder = Int((sum) % 10)
            if remainder == 0 {
                return String(remainder)
            } else {
                let delta: Int = 10 - remainder
                return String(delta)
            }
        } else {
            return nil
        }
    }
    
    private func isThreeBarCodesValidated(sortedScannedCodes: [String]) -> Bool {
        
        guard sortedScannedCodes.count == 3 else { return false }
        let firstOrderedCode = sortedScannedCodes[0]
        let secondOrderedCode = sortedScannedCodes[1]
        let thirdOrderedCode = sortedScannedCodes[2]
        
        if firstOrderedCode.count != 12 || !firstOrderedCode.hasPrefix("3") {
            return false
        }
        
        if secondOrderedCode.count != 12 || !secondOrderedCode.hasPrefix("4") {
            return false
        }
        
        if thirdOrderedCode.count != 8 && (!thirdOrderedCode.hasPrefix("5") || !thirdOrderedCode.hasPrefix("7")) {
            return false
        }
        return true
    }
    
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        guard !self.scannerIsBusy else {return}
        DDLogDebug("scanning....")
        let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
        guard let image: CGImage = ZXCGImageLuminanceSource.createImage(from: pixelBuffer),
            let source: ZXCGImageLuminanceSource = ZXCGImageLuminanceSource.init(cgImage: image),
            let binarizer = ZXHybridBinarizer.init(source: source),
            let bitmap: ZXBinaryBitmap = ZXBinaryBitmap(binarizer: binarizer) else {
                return
        }
        
        let imageRotated = UIImage(cgImage: image)
        
        guard let sourceRotated: ZXCGImageLuminanceSource = ZXCGImageLuminanceSource(cgImage: imageRotated.cgImage),
            let binarizerRotated = ZXHybridBinarizer.init(source: sourceRotated),
            let bitmapRotated: ZXBinaryBitmap = ZXBinaryBitmap(binarizer: binarizerRotated) else {
                return
        }
        
        var zxResults: [ZXResult] = []
        if let results = try? self.multiReader.decodeMultiple(bitmapRotated, hints: self.hints) {
            for code in results {
                guard let zxCode = code as? ZXResult else {continue}
                zxResults.append(zxCode)
            }
        } else if let results = try? self.multiReader.decodeMultiple(bitmap, hints: self.hints) {
            for code in results {
                guard let zxCode = code as? ZXResult else {continue}
                zxResults.append(zxCode)
            }
        }
        
        guard zxResults.count > 0 else {return}
        
        var codeDecoded: String = ""
        
        if zxResults.count == 1 {
            DDLogDebug("founded 1 bar codes")
            guard let zxResult = zxResults.first else {
                return
            }
            // Check for garment collecting data matrix code
            /*
             if zxResult.barcodeFormat == kBarcodeFormatDataMatrix && zxResult.text.contains(garmentCollectingIdentifier){
             self.extractGarmentCollectingCodeFromDataMatrixZXing(codeScanned: zxResult)
             return
             }
             */
            guard let codeExtracted = self.extractCodeFromOneBarCodeZXing(barCodeScanned: zxResult) else {
                return
            }
            codeDecoded = codeExtracted
            
        } else if zxResults.count == 3 {
            
            DDLogDebug("founded 3 bar codes")
            var codesScanned: [String] = []
            codesScanned.append(contentsOf: zxResults.compactMap({ (zxResult) -> String? in
                guard let code = zxResult.text else {return nil}
                return code
            }))
            
            let sortedCodesScanned = codesScanned.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
            guard let codeExtracted = self.extractCodeFromThreeBarCodesI25(sortedScannedCodes: sortedCodesScanned) else {
                return
            }
            codeDecoded = codeExtracted
        }
        
        guard !self.scannerIsBusy else { return }
        self.scannerIsBusy = true
        guard codeDecoded.count > 0 else {
            self.scannerIsBusy = false
            return
        }
        DDLogDebug("Code Decoded: \(codeDecoded)\n")
        
        self.callAPI(barCode: codeDecoded)
        DDLogDebug("exit")
    }
    
    private func callAPI(barCode: String) {
        
        NSLog("Barcode String === %@",barCode)
        AudioServicesPlaySystemSoundWithCompletion(kSystemSoundID_Vibrate, nil)
        showSpinner()
        makeGetCall(BarCode: barCode)
        //        DispatchQueue.main.async {
        //            self.cartTableView.isHidden = false
        //            self.readerView.isHidden = true
        //        }
    }
    
    func makeGetCall(BarCode: String) {
        // Set up the URL request
        let todoEndpoint: String = "https://smartcheckout.free.beeceptor.com/my/api/path/\(BarCode)"
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
                self.showAlertwith(Title: "No Internet connnection", andMessage: "Please check your internet connection.")
                self.hideSpinner()
//                let alertController = UIAlertController(title: "Error", message: "Error calling GET API", preferredStyle: .alert)
//                alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
//                self.present(alertController, animated: true, completion: nil)
//                self.reloadCart()
                return
            }
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                self.showAlertwith(Title: "Product Not Found!", andMessage: "We are unable to find the product in our inventory.")
                self.hideSpinner()
//                let alertController = UIAlertController(title: "Error", message: "Did not receive data", preferredStyle: .alert)
//                alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
//                self.present(alertController, animated: true, completion: nil)
//                self.reloadCart()
                return
            }
            
            // parse the result as JSON, since that's what the API provides
            do {
                guard var todo: Dictionary = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] else {
                    print("error trying to convert data to JSON")
                    self.showAlertwith(Title: "Error", andMessage: "Error trying to convert data to JSON.")
                    self.hideSpinner()
//                    self.reloadCart()
                    return
                }
                // now we have the todo, let's just print it to prove we can access it
                print("The todo is: " + (todo as Dictionary).description)
                todo["Qty"] = 1
                todo["Total"] = todo["Price"]
                self.dataArray.append(todo)
                
                print("The dataArray is: " + self.dataArray.description)
//                self.showAlertwith(Title: "Success!", andMessage: "Item added successfully to your cart.")
                if self.dataArray.count>0 {
                    self.reloadCart()
                }
                
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
                self.showAlertwith(Title: "Product Not Found", andMessage: "This product doesn't belong to our store.")
//                self.hideSpinner()
                self.reloadCart()
                return
            }
        }
        
        task.resume()
    }
    
    func reloadCart(){
        DispatchQueue.main.async {
            self.hideSpinner()
            if self.dataArray.count>0{
                self.cartTableView.reloadData()
                self.scrollToBottom()
                self.cartTableView.isHidden = false
            }
            self.readerView.isHidden = true
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

/*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is CheckoutViewController
        {
            let vc = segue.destination as? CheckoutViewController
            vc?.articleTotalStr = totalLabel.text ?? ""
            vc?.dataArray = dataArray
        }
    }
*/
    func updateQty(forCellwith Tag: Int, withQty:Int, andTotal:Int){
        var data: Dictionary<String, Any> = dataArray[Tag-1]
        data["Qty"] =  withQty
        data["Total"] =  "\(andTotal)"
        dataArray[Tag-1] = data
    }
    
    func updateTotal(){
        var totalAmount: Int = 0
        for (_, data) in dataArray.enumerated() {
            print("\(data)")
            if let total : String = data["Total"] as? String{
                totalAmount = totalAmount + (Int(total) ?? 0)
            }
        }
        self.totalLabel.text = "Total: $ \(totalAmount)"
    }
    
    func showAlertwith(Title: String, andMessage:String){
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: Title, message: andMessage, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func scrollToBottom(){
        
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.dataArray.count-1, section: 0)
            self.cartTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
}

