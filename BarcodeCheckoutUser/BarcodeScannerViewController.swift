//
//  BarcodeScannerViewController.swift
//  Barcode Scanner
//
//  Created by Joseph Pecoraro
//  Copyright (c) 2015 Joseph Pecoraro. All rights reserved.
//

import UIKit
import AVFoundation

class BarcodeScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, UIAlertViewDelegate {
    
    //MARK: Variables
    var captureSession = AVCaptureSession()
    var videoDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
    var videoInput : AVCaptureDeviceInput?
    var previewLayer : AVCaptureVideoPreviewLayer?
    var metadataOutput = AVCaptureMetadataOutput()
    
    var highlightView = UIView()
    var bottomBar = UIView()
    var topBar = UIView()
    var barcodeFinderWindow : BarcodeFinderView?
    
    var alertView : UIAlertView?
    
    //MARK:
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHUD()
        setupCaptureSession()
        setupVideoLayer()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        startRunning()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        stopRunning()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //setupHUD()
    }
    
    //MARK:
    //MARK: Setup
    func setupCaptureSession() {
        var error : NSError? = nil
        do {
            videoInput = try AVCaptureDeviceInput(device: videoDevice)
        } catch let error1 as NSError {
            error = error1
            videoInput = nil
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        }
        else {
            NSLog("Could not add video input %@", error!.description)
        }
        
        if captureSession.canAddOutput(metadataOutput) {
            metadataOutput.setMetadataObjectsDelegate(self, queue:dispatch_get_main_queue())
            
            captureSession.addOutput(metadataOutput)
            metadataOutput.metadataObjectTypes = metadataOutput.availableMetadataObjectTypes
        }
        else {
            NSLog("Could not add metadeta output")
        }
    }
    
    func setupVideoLayer() {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer!.frame = UIScreen.mainScreen().bounds
        previewLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
        view.layer.addSublayer(previewLayer!)
        
        bringAllSubviewsToFront()
        
        startRunning()
    }
    
    
    //MARK: HUD Setup
    func setupHUD() {
        setupTopBar()
        setupBottomBar()
        setupHighlightView()
        setupBarcodeArea()
    }
    
    func setupTopBar() {
        topBar.frame = CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen().bounds), 80)
        topBar.backgroundColor = UIColor(white: 0.15, alpha: 0.7)
        
        let instructionLabel = UILabel(frame:
            CGRectMake(0, 20,CGRectGetWidth(UIScreen.mainScreen().bounds), 80))
        instructionLabel.backgroundColor = UIColor.clearColor()
        instructionLabel.textColor = UIColor.whiteColor()
        instructionLabel.text = "Place the barcode into the view to scan"
        instructionLabel.textAlignment = NSTextAlignment.Center
        instructionLabel.font = UIFont.systemFontOfSize(13)
        
        topBar.addSubview(instructionLabel)
        view.addSubview(topBar)
    }
    
    func setupBottomBar() {
        bottomBar.frame = CGRectMake(0,
            CGRectGetHeight(UIScreen.mainScreen().bounds) - 60,
            CGRectGetWidth(UIScreen.mainScreen().bounds), 60)
        bottomBar.backgroundColor = UIColor(white: 0.15,
            alpha: 0.7)
        
        view.addSubview(bottomBar)
    }
    
    func setupHighlightView() {
        let width = CGRectGetWidth(UIScreen.mainScreen().bounds)/1.5
        
        highlightView.frame = CGRectMake(
            CGRectGetMidX(UIScreen.mainScreen().bounds) - width/2.0,
            CGRectGetMidY(UIScreen.mainScreen().bounds) - 1,
            width, 2)
        highlightView.layer.borderColor = UIColor.redColor().CGColor
        highlightView.layer.borderWidth = 2
        
        view.addSubview(highlightView)
    }
    
    func setupBarcodeArea() {
        barcodeFinderWindow = BarcodeFinderView(frame:
            CGRectMake(10,
                CGRectGetMidY(UIScreen.mainScreen().bounds) - 120,
                CGRectGetWidth(UIScreen.mainScreen().bounds) - 20, 240))
        barcodeFinderWindow?.backgroundColor = UIColor.clearColor()
        view.addSubview(barcodeFinderWindow!)
    }
    
    //MARK:
    //MARK: AVCapture Delegate
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        for metadataObject : AnyObject in metadataObjects {
            var highlightViewRect = CGRectZero
            
            var metadataObject = previewLayer!.transformedMetadataObjectForMetadataObject(metadataObject as! AVMetadataObject)
            if metadataObject.isKindOfClass(AVMetadataMachineReadableCodeObject.self) {
                var barcodeMetadata = metadataObject as! AVMetadataMachineReadableCodeObject
                highlightViewRect = barcodeMetadata.bounds
                highlightView.frame = highlightViewRect
                
                var barcode = Barcode(metadataCode: barcodeMetadata)
                if isValidBarcode(barcode) {
                    validBarcodeFound(barcode)
                }
            }
        }
        
    }
    
    //MARK:
    //MARK: Alert Delegate
    func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        self.alertView = nil
        setupHighlightView()
        startRunning()
    }
    
    //MARK:
    func isValidBarcode(barcode: Barcode) -> Bool {
        if barcode.barcodeType != nil {
            return true
        }
        return false
    }
    
    func validBarcodeFound(barcode: Barcode) {
        if alertView != nil {
            return;
        }
        
        NSLog("Barcode: \(barcode)\n\n")
        
        alertView = UIAlertView(title: "Barcode Found", message: barcode.description, delegate: self, cancelButtonTitle: "Ok")
        alertView?.show()
    }
    
    func bringAllSubviewsToFront() {
        view.bringSubviewToFront(barcodeFinderWindow!)
        view.bringSubviewToFront(highlightView)
        view.bringSubviewToFront(bottomBar)
        view.bringSubviewToFront(topBar)
    }
    
    func startRunning() {
        if (!captureSession.running) {
            captureSession.startRunning()
        }
    }
    
    func stopRunning() {
        if (captureSession.running) {
            captureSession.stopRunning()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
     
    }
    
}
