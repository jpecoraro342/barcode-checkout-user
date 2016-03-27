//
//  ViewController.swift
//  BarcodeCheckoutUser
//
//  Created by Joseph Pecoraro on 3/27/16.
//  Copyright © 2016 Joseph Pecoraro. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var barcodes: [Barcode] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        print(barcodes)
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func addBarcode(barcode: Barcode) {
        barcodes.append(barcode)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.destinationViewController is BarcodeScannerViewController {
            let vc = segue.destinationViewController as! BarcodeScannerViewController
            vc.controller = self
        } else if segue.identifier! == "checkoutSegue" {
            let destVC = segue.destinationViewController as! CheckoutVC
            
            var barList = [String]()
            
            for var barcode in barcodes {
                barList.append(barcode.barcodeValue!)
            }
            
            destVC.barcodeList = barList;
        }
    }
}

extension ViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

extension ViewController : UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return barcodes.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell") as! ItemTableViewCell;
        
        cell.nameLabel.text = "Polo Shirt"
        cell.priceLabel.text = "$49.99"
        cell.barcodeLabel.text = barcodes[indexPath.row].barcodeValue
        
        return cell;
    }
}

