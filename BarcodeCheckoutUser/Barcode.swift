//
//  Barcode.swift
//  Barcode Scanner
//
//  Created by Joseph Pecoraro
//  Copyright (c) 2015 Joseph Pecoraro. All rights reserved.
//

import UIKit
import AVFoundation

enum BarcodeType : String {
    case QRCode = "org.iso.QRCode"
    case PDF417 = "org.iso.PDF417"
    case UPCE = "org.gs1.UPC-E"
    case Aztec = "org.iso.Aztec"
    case Code39 = "org.iso.Code39"
    case Code39Mod43 = "org.iso.Code39Mod43"
    case EAN13 = "org.gs1.EAN-13"
    case EAN8 = "org.gs1.EAN-8"
    case Code93 = "com.intermec.Code93"
    case Code128 = "org.iso.Code128"
}

public class Barcode: NSObject {
    var barcodeType : BarcodeType?
    var barcodeValue : NSString?
    
    init(metadataCode: AVMetadataMachineReadableCodeObject) {
        barcodeType = BarcodeType(rawValue: metadataCode.type!)!
        barcodeValue = metadataCode.stringValue!
    }
    
    override public var description : String {
        return "Barcode: \(barcodeValue!) Type: \(barcodeType!.rawValue)"
    }
}
