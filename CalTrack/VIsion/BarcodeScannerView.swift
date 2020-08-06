//
//  BarcodeScannerView.swift
//  CalTrack
//
//  Created by Jalp on 29/01/2020.
//  Copyright © 2020 jdc0rp. All rights reserved.
//

import Foundation
import SwiftUI
import AVKit
import Vision
import BLTNBoard

//**************** Shows Barcode Scanner ****************\\
struct BarcodeScannerView : UIViewControllerRepresentable {
    // Init view controller
    func makeUIViewController(context: UIViewControllerRepresentableContext<BarcodeScannerView>) -> UIViewController {
        // Initialise Barcode Scanner
        let controller = BarcodeView()
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<BarcodeScannerView>) {
        // Don't know what to do
    }
}

//**************** Shows live preview of the camera and detects barcode ****************\\
class BarcodeView : UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    //**************** Variables ****************\\
    @EnvironmentObject var session : SessionStore
    var videoLayer = AVCaptureVideoPreviewLayer()
    var isShowingAlert = false
    var hasShownOnce = false
    var foodEnergy = FoodEnergy.shared
    let avSession = AVCaptureSession()
    
    @Published var networkManager = NetworkManager.shared
    
    // Card View variables
    let detailPage = BLTNPageItem(title: "Food Info")
    lazy var bulletinManager: BLTNItemManager = {
        let rootItem: BLTNItem = detailPage
        return BLTNItemManager(rootItem: rootItem)
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCameraPreview()
        setupCardView()
    }
    
    // Sets up the camera and displays it on the device
    func setupCameraPreview() {
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        avSession.addInput(input)
        let cameraPreview = AVCaptureVideoPreviewLayer(session: avSession)
        view.layer.addSublayer(cameraPreview)
        cameraPreview.frame = view.frame
        let output = AVCaptureMetadataOutput()
        avSession.addOutput(output)
        output.metadataObjectTypes = [.upce, .ean8, .ean13]
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        avSession.startRunning()
    }
    
    // Looks for barcode in each camera frame
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Once detected check for barcode type
        if metadataObjects.count > 0,
            metadataObjects.first is AVMetadataMachineReadableCodeObject,
            let scan = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
            if (hasShownOnce == false) {
                print("Showing Details!!!!!")
                hasShownOnce = true
                var newValue = scan.stringValue!
                newValue.remove(at: newValue.startIndex)
                // Sends barcode to the API via Network Manager
                networkManager.getItemDetailsByUPC(upc: newValue)
                
                if (self.networkManager.foodDetail.first == nil) {
                    self.detailPage.descriptionText = "Barcode Error. Scan Again!"
                    self.detailPage.actionButtonTitle = "Try Again"
                    self.bulletinManager.showBulletin(above: self)
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                        self.avSession.stopRunning()
                        print(self.networkManager.foodDetail)
                        self.detailPage.descriptionText = self.networkManager.foodDetail.first!.food_name
                        self.detailPage.actionButtonTitle = "Corrent Item"
                        self.bulletinManager.showBulletin(above: self)
                        let swiftview = FoodDetailedView(session: self._session)
                        let viewctrl = UIHostingController(rootView: swiftview)
                        self.addChild(viewctrl)
                        viewctrl.view.frame = self.view.bounds
                        self.view.addSubview(viewctrl.view)
                        
                        viewctrl.didMove(toParent: self)
                    }
                }
            }
        }
    }
    
    // Sets up the card view with buttons/labels
    func setupCardView() {
        DispatchQueue.main.async {
            self.bulletinManager.backgroundViewStyle = .blurredDark
            // 1st Page
            self.detailPage.descriptionText = "Item Description"
            self.detailPage.actionButtonTitle = "Correct Item"
            self.detailPage.alternativeButtonTitle = "Cancel"
            
            // Page Handlers
            self.detailPage.actionHandler = { (item : BLTNActionItem) in
                print("Correct Button Tapped")
                self.hasShownOnce = false
                self.bulletinManager.displayActivityIndicator()
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
            self.detailPage.alternativeHandler = { (item : BLTNActionItem) in
                print("Cancel Button Tapped")
                self.bulletinManager.dismissBulletin()
                self.dismiss(animated: true, completion: nil)
                
            }
        }
    }
}
