//
//  BarcodeFinderView.swift
//  Barcode Scanner
//
//  Created by Joseph Pecoraro
//  Copyright (c) 2015 Joseph Pecoraro. All rights reserved.
//

import UIKit

class BarcodeFinderView: UIView {

    override func drawRect(rect: CGRect) {
        let height = CGRectGetHeight(frame)
        let width = CGRectGetWidth(frame)
        
        UIColor.whiteColor().set()
        
        let leftFrame = UIBezierPath()
        leftFrame.lineWidth = 6;
        leftFrame.moveToPoint(CGPointMake(30, 0))
        leftFrame.addLineToPoint(CGPointMake(0, 0))
        leftFrame.addLineToPoint(CGPointMake(0, height))
        leftFrame.addLineToPoint(CGPointMake(30, height))
        leftFrame.stroke()
        
        let rightFrame = UIBezierPath()
        rightFrame.lineWidth = 6;
        rightFrame.moveToPoint(CGPointMake(width - 30, 0))
        rightFrame.addLineToPoint(CGPointMake(width, 0))
        rightFrame.addLineToPoint(CGPointMake(width, height))
        rightFrame.addLineToPoint(CGPointMake(width-30, height))
        rightFrame.stroke()
    }
}
