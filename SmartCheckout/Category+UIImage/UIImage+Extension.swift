//
//  UIImage+Extension.swift
//  HMTargetApp
//
//  Created by angelo.ippolito on 24/05/2018.
//  Copyright © 2018 Accenture. All rights reserved.
//

import Foundation
import ZXingObjC

extension UIImage {
    func image(withRotation radians: CGFloat) -> UIImage? {
        
        let LARGEST_SIZE = CGFloat(max(self.size.width, self.size.height))
        
        let context: CGContext?
        
        if let cgImage = self.cgImage, let colorSpace = cgImage.colorSpace {
            context = CGContext(data: nil, width: Int(LARGEST_SIZE), height: Int(LARGEST_SIZE), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: colorSpace, bitmapInfo: cgImage.bitmapInfo.rawValue)
        } else {
            context = nil
        }
        
        let drawOrigin = CGPoint(x: (LARGEST_SIZE - self.size.width) * 0.5, y: (LARGEST_SIZE - self.size.height) * 0.5)
        
        let drawRect = CGRect(origin: drawOrigin, size: self.size)
        
        var tf = CGAffineTransform(translationX: LARGEST_SIZE * 0.5, y: LARGEST_SIZE * 0.5)
        
        tf = tf.rotated(by: CGFloat(radians))
        tf = tf.translatedBy(x: LARGEST_SIZE * -0.5, y: LARGEST_SIZE * -0.5)
        context?.concatenate(tf)
        
        if let im = cgImage {
            context?.draw(im, in: drawRect)
        }
        
        let rotatedImage = context?.makeImage()?.cropping(to: drawRect.applying(tf))
        
        if let rotated = rotatedImage {
            return UIImage(cgImage: rotated)
        }
        
        return nil
    }
    
    static func generateQRCode(from string: String) -> UIImage? {

        let writer = ZXMultiFormatWriter()
        let hints = ZXEncodeHints()
        hints.gs1Format = true
        
        guard
            let result: ZXBitMatrix = try? writer.encode(
                string,
                format: kBarcodeFormatQRCode,
                width: 540,
                height: 540,
                hints: hints
            ),
            let image = ZXImage(matrix: result)?.cgimage else {
            return nil
        }
        
        return UIImage(cgImage: image)
    }
    
    static func generateBarCodeTransparencyBackground(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        let filter = CIFilter(name: "CICode128BarcodeGenerator")
        filter?.setValue(data, forKey: "inputMessage")
        filter?.setValue(0.0, forKey: "inputQuietSpace")
        let filterFalseColor = CIFilter(name: "CIFalseColor")
        filterFalseColor?.setDefaults()
        filterFalseColor?.setValue(filter?.outputImage, forKey: "inputImage")
        
        // convert method
        let cgColor: CGColor? = UIColor.black.cgColor
        let qrColor: CIColor = CIColor(cgColor: cgColor!)
        let transparentBG: CIColor = CIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        filterFalseColor?.setValue(qrColor, forKey: "inputColor0")
        filterFalseColor?.setValue(transparentBG, forKey: "inputColor1")
        
        if let image = filterFalseColor?.outputImage {
            let transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
            return UIImage(ciImage: image.transformed(by: transform), scale: 1.0, orientation: UIImage.Orientation.up)
        } else {
            return nil
        }
    }
    
    static func generateQRCodeTransparencyBackground(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setValue(data, forKey: "inputMessage")
        filter?.setValue(0.0, forKey: "inputQuietSpace")
        filter?.setValue("H", forKey: "inputCorrectionLevel")
        
        let filterFalseColor = CIFilter(name: "CIFalseColor")
        filterFalseColor?.setDefaults()
        filterFalseColor?.setValue(filter?.outputImage, forKey: "inputImage")
        // convert method
        let cgColor: CGColor? = UIColor.black.cgColor
        let qrColor: CIColor = CIColor(cgColor: cgColor!)
        let transparentBG: CIColor = CIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        filterFalseColor?.setValue(qrColor, forKey: "inputColor0")
        filterFalseColor?.setValue(transparentBG, forKey: "inputColor1")
        
        if let image = filterFalseColor?.outputImage {
            let transform = CGAffineTransform(scaleX: 5.0, y: 5.0)
            return UIImage(ciImage: image.transformed(by: transform), scale: 1.0, orientation: UIImage.Orientation.up)
        } else {
            return nil
        }
    }
}
