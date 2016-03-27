//
//  CheckoutVC.swift
//  BarcodeCheckoutUser
//
//  Created by Joseph Pecoraro on 3/27/16.
//  Copyright © 2016 Joseph Pecoraro. All rights reserved.
//

import UIKit
import QRCode

class CheckoutVC: UIViewController {
    
    @IBOutlet weak var qrImageView: UIImageView!
    
    var barcodeList : [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barcodeString = randomStringWithLength(16)
        generateQRCode(barcodeString)
        NetworkingFacade().uploadBarcodes(barcodeString, barcodes: barcodeList) { (success) -> Void in
            print(success)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func generateQRCode(barcodeString: String) {
        var qrCode = QRCode(barcodeString)
        qrCode?.size = qrImageView.frame.size
        qrImageView.image = qrCode?.image
    }
    
    func randomStringWithLength (len : Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        let randomString : NSMutableString = NSMutableString(capacity: len)
        
        for (var i=0; i < len; i++){
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        }
        
        return randomString as String
    }
}
