//
//  LiveCameraPreview.swift
//  CalTrack
//
//  Created by Jalp on 21/12/2019.
//  Copyright © 2019 jdc0rp. All rights reserved.
//

import Foundation
import SwiftUI
import AVKit
import Vision
import BLTNBoard

//**************** Shows live camera preview to the user ****************\\
struct LiveCameraPreview : UIViewControllerRepresentable {
    // Init view controller
    func makeUIViewController(context: UIViewControllerRepresentableContext<LiveCameraPreview>) -> UIViewController {
        // Initialise camera view
        let controller = CameraView()
        return controller
    }
    
    // No idea what this is but we need it for this to work 😎
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<LiveCameraPreview>) {
        // 🎵 Don't know what to do 🎵
    }
}

//**************** Shows live preview and sends data to the ML Model ****************\\
class CameraView : UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    //**************** Variables ****************\\
    @EnvironmentObject var session : SessionStore
    @Published var networkManager = NetworkManager.shared
    var myResult : String = "nil"
    var hasShownOnce = false
    let model = CalTrackImageClassifier_2()
    var avSession : AVCaptureSession = AVCaptureSession()
    
    
    // Setting up Card View
    let page = BLTNPageItem(title: "Welcome")
    let secondPage = BLTNPageItem(title: "Object Detected!")
    let thirdPage = BLTNPageItem(title: "Item Tracked!")
    lazy var bulletinManager: BLTNItemManager = {
        let rootItem: BLTNItem = page
        return BLTNItemManager(rootItem: rootItem)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCameraPreview()
        setupCardView()
    }
    
    // Loads the Camera view on the device
    func loadCameraPreview() {
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        guard let input = try? AVCaptureDeviceInput(device : captureDevice) else { return }
        avSession.addInput(input)
        //        avSession.startRunning()
        
        let cameraPreview = AVCaptureVideoPreviewLayer(session: avSession)
        view.layer.addSublayer(cameraPreview)
        cameraPreview.frame = view.frame
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "cameraQueue"))
        avSession.addOutput(dataOutput)
    }
    
    
    // Captures each frame from the camera and sends it to the ML Model for food detection
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        guard let pixelBuffer : CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        guard let model = try? VNCoreMLModel(for : model.model) else {return}
        
        let request = VNCoreMLRequest(model: model)
        { (finishedreq, err) in
            
            guard let results = finishedreq.results as? [VNClassificationObservation] else { return }
            guard let firstObservation = results.first else { return }
            
            if (self.myResult != firstObservation.identifier) {
                self.myResult = firstObservation.identifier
                if (firstObservation.confidence > 0.7) {
                    DispatchQueue.main.async {
                        self.secondPage.descriptionText = self.myResult
                    }
                }
            }
        }
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }
    
    // Checks whether the string passed contains any numbers
    func doStringContainsNumber( _string : String) -> Bool{
        let numberRegEx  = ".*[0-9]+.*"
        let testCase = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let containsNumber = testCase.evaluate(with: _string)
        return containsNumber
    }
    
    // Loads FoodDetailView with all the nutritional value
    func loadData(result : String) {
        HapticFeedbackGenerator.shared.generateSuccessFeedback()
        
        if (self.doStringContainsNumber(_string: self.myResult)) {
            self.networkManager.getBrandedFoodItemDetails(food_name: result, callback: {})
            
        } else {
            self.networkManager.getCommonFoodItemDetails(food_name: result, callback: {})
        }
        // Shows an indicatior view while the nutritional data is fetched
        let indicatorView = ActivityIndicator()
        self.addChild(indicatorView)
        indicatorView.view.frame = view.frame
        view.addSubview(indicatorView.view)
        indicatorView.didMove(toParent: self)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            // Remove the indicator view
            indicatorView.willMove(toParent: nil)
            indicatorView.view.removeFromSuperview()
            indicatorView.removeFromParent()
            // Display the FoodDetailedView
            let detailView = FoodDetailedView(session: self._session)
            self.bulletinManager.dismissBulletin()
            let view = UIHostingController(rootView: detailView)
            self.addChild(view)
            view.view.frame = self.view.bounds
            self.view.addSubview(view.view)
            view.didMove(toParent: self)
        }
    }
    
    // Sets up the card view and all its buttons/labels
    func setupCardView() {
        DispatchQueue.main.async {
            // 1st Page
            self.page.descriptionText = "Please press the button to start scanning"
            self.page.actionButtonTitle = "Start Scanning"
            self.page.alternativeButtonTitle = "Cancel"
            self.page.next = self.secondPage
            
            // Second Page
            self.secondPage.descriptionText = "Is this correct?"
            self.secondPage.actionButtonTitle = "Add Item"
            self.secondPage.alternativeButtonTitle = "Try Again"
            self.secondPage.next = self.thirdPage
            
            self.bulletinManager.showBulletin(above: self)
            
            // Third Page
            self.thirdPage.descriptionText = "Item Added to the list"
            self.thirdPage.actionButtonTitle = "Correct"
            self.thirdPage.alternativeButtonTitle = "Try Again"
            
            // Page Handlers
            self.page.actionHandler = { (item : BLTNActionItem) in
                print("Start Button Tapped")
                self.bulletinManager.displayActivityIndicator()
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.page.manager?.displayNextItem()
                }
                self.avSession.startRunning()
            }
            
            self.page.alternativeHandler = { (item : BLTNActionItem) in
                print("Cancel Button Tapped")
                self.bulletinManager.dismissBulletin()
                self.dismiss(animated: true, completion: nil)
                self.page.manager = nil
                self.secondPage.manager = nil
                self.avSession.stopRunning()
            }
            
            self.secondPage.alternativeHandler = { (item : BLTNActionItem) in
                print("Trying Again!")
                
            }
            
            self.secondPage.actionHandler = { (item : BLTNActionItem) in
                print("Tracking...")
                //                self.secondPage.manager?.displayNextItem()
                self.avSession.stopRunning()
                print(self.myResult)
                self.loadData(result: self.myResult)
            }
            
            self.thirdPage.actionHandler = { (item : BLTNActionItem) in
                self.thirdPage.manager?.displayActivityIndicator()
            }
            
            self.thirdPage.alternativeHandler = { (item : BLTNActionItem) in
                print("Cancel Button Tapped")
                self.bulletinManager.dismissBulletin()
                self.dismiss(animated: true, completion: nil)
                self.thirdPage.manager = nil
                self.avSession.stopRunning()
                
            }
            
            
        }
    }
    
}

