//
//  NetworkingFacade.swift
//  BarcodeCheckoutUser
//
//  Created by Joseph Pecoraro on 3/27/16.
//  Copyright © 2016 Joseph Pecoraro. All rights reserved.
//

import Foundation
import Alamofire

class NetworkingFacade : NSObject {
    
    typealias BooleanClosure = (success: Bool) -> Void;
    let baseURL = "http://45.55.145.225:4001";

    // POST
    func uploadBarcodes(barcodeId: String, barcodes: [String], completionBlock: BooleanClosure?) {
        Alamofire.request(.POST, URLStringWithExtension("barcode"), parameters: [ "barcodeId" : barcodeId, "barcodes" : barcodes], encoding: .JSON)
            .responseJSON { response in
                if let json = response.result.value {
                    print(json);
                    completionBlock?(success: true);
                }
                else {
                    completionBlock?(success: false);
                }
        }
    }
    
    // Utility
    
    func URLStringWithExtension(urlExtension: String) -> String {
        return "\(baseURL)/\(urlExtension)";
    }
}