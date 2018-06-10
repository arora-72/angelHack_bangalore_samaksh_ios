//
//  previewCameraViewController.swift
//  Rinnegan
//
//  Created by Indresh Arora on 09/06/18.
//  Copyright © 2018 Indresh Arora. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import Vision
import CoreLocation

class previewCameraViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager:CLLocationManager!
    
    
    let cameraController = CameraController()
    
    var image: UIImage?
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var imageData: Data?
    var imageDataArray: Array <Any>?
    var latitude: Double?
    var longitude: Double?

    @IBOutlet weak var previewView: UIView!
    @IBOutlet fileprivate var photoModeButton: UIButton!
    @IBOutlet fileprivate var toggleCameraButton: UIButton!
    @IBOutlet fileprivate var toggleFlashButton: UIButton!
    
    ///Allows the user to put the camera in video mode.
    @IBOutlet fileprivate var videoModeButton: UIButton!
    
    @IBOutlet weak var captureButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        determineCurrentLocation()
        

       
        func styleCaptureButton() {
            captureButton.layer.borderColor = UIColor.black.cgColor
            captureButton.layer.borderWidth = 2
            
            captureButton.layer.cornerRadius = min(captureButton.frame.width, captureButton.frame.height) / 2
        }
        
        func configureCameraController() {
            cameraController.prepare {(error) in
                if let error = error {
                    print(error)
                }
                
                try? self.cameraController.displayPreview(on: self.previewView)
            }
        }
        styleCaptureButton()
        configureCameraController()
        
        
    }
    
    
    
    func determineCurrentLocation(){
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        self.latitude = userLocation.coordinate.latitude
        self.longitude = userLocation.coordinate.longitude
        locationManager.stopUpdatingLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")

    }
    
    
    @IBAction func captureImage(_ sender: UIButton) {
        cameraController.captureImage {(image, error) in
            print(">>>>>>>>:")
            print(image)
            self.image = image
            print(self.image)
            
            
            if(self.image != nil){
//                let vc = imageDisplayViewController()
//                vc.image_view.image = self.image
//                print(vc.image_import)
//                let viewController = self.storyboard!.instantiateViewController(withIdentifier: "imageDisplayVC") as! imageDisplayViewController
//                self.present(viewController, animated: true, completion: nil)
                let imageView = UIImageView(image: self.image)
                imageView.contentMode = .scaleAspectFit
                let scaledHeight = self.view.frame.width / (self.image?.size.width)! * (self.image?.size.height)!
                imageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: scaledHeight)
                self.view.addSubview(imageView)
                
                let request = VNDetectFaceRectanglesRequest { (req, err) in
                    
                    if let err = err {
                        print("Failed to detect faces:", err)
                        return
                    }
                    
                    req.results?.forEach({ (res) in
                        
                        DispatchQueue.main.async {
                            guard let faceObservation = res as? VNFaceObservation else { return }
                            
                            let x = self.view.frame.width * faceObservation.boundingBox.origin.x
                            
                            let height = scaledHeight * faceObservation.boundingBox.height
                            
                            let y = scaledHeight * (1 -  faceObservation.boundingBox.origin.y) - height
                            
                            let width = self.view.frame.width * faceObservation.boundingBox.width
                            
                            
                            let redView = UIView()
                            redView.backgroundColor = .red
                            redView.alpha = 0.4
                            redView.frame = CGRect(x: x + 50.0, y: y - 50.0 , width: width, height: height)
//                            self.view.addSubview(redView)
                            
                            if(faceObservation.boundingBox != nil){
                                let alertController = UIAlertController(title: "pritority high", message: "face detected", preferredStyle: .alert)
                                let alert = UIAlertAction(title: "OK", style: .default, handler: nil)
                                alertController.addAction(alert)
                                self.present(alertController, animated: true, completion: nil)
                                
                            }else{
                                let alertController = UIAlertController(title: "priority low", message: "no face detected", preferredStyle: .alert)
                                let alert = UIAlertAction(title: "OK", style: .default, handler: nil)
                                alertController.addAction(alert)
                                self.present(alertController, animated: true, completion: nil)
                            }
                        }
                    })
                    
                    
                }
                
                guard let cgImage = self.image?.cgImage else { return }
                
                DispatchQueue.global(qos: .background).async {
                    let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
                    do {
                        try handler.perform([request])
                    } catch let reqErr {
                        print("Failed to perform request:", reqErr)
                    }
                }
                guard let imageMaster =  self.image else{ return }
                let data = UIImageJPEGRepresentation(imageMaster, 0.1)
//                let nsData = NSData(base64Encoded: data, options: .ignoreMetacharacters)
                let data1: Data = data!
                let bytes = [UInt8](data1)
                print(bytes)
                self.imageDataArray = bytes
                self.imageData = data
                
                
                if(self.imageData != nil){
                    let viewController = self.storyboard!.instantiateViewController(withIdentifier: "additionalDetails") as! additionalDetailsViewController
                    viewController.imageData = self.imageData
                    viewController.latitude = self.latitude
                    viewController.longitude = self.longitude
                    viewController.imageArray = self.imageDataArray
                    self.present(viewController, animated: true, completion: nil)
                }
                //segue
                
                
                
                

            }else{
                let alertController = UIAlertController(title: "error", message: "not able to perform segue", preferredStyle: .alert)
                let alert = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(alert)
                self.present(alertController, animated: true, completion: nil)
            }
            
//            try? PHPhotoLibrary.shared().performChangesAndWait {
//                PHAssetChangeRequest.creationRequestForAsset(from: image!)
//            }
        }
        
        //byte array implementation
        
        
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if(segue.identifier=="imageMaster"){
//            print("master")
//            print(self.image)
//            let vc = imageDisplayViewController()
//            vc.image_import = self.image
//        }
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
    func getArrayOfBytesFromImage(imageData:NSData) -> NSMutableArray
    {
        
        // the number of elements:
//        let count = imageData.length / sizeof(UInt8)
        let s = MemoryLayout.size(ofValue: UInt8())
        let count = imageData.length / s
        
        // create array of appropriate length:
        var bytes = [UInt8](repeating: 0, count: count)
        
        // copy bytes into array
        imageData.getBytes(&bytes, length:count * s)
        
        var byteArray:NSMutableArray = NSMutableArray()
        
//        for (var i = 0; i < count; i++) {
//            byteArray.addObject(NSNumber(unsignedChar: bytes[i]))
//        }

        for i in 0..<count {
            byteArray.add(NSNumber(value: bytes[i]))
        }
        return byteArray
        
        
    }

    
    func resize(_ image: UIImage) -> UIImage {
        var actualHeight = Float(image.size.height)
        var actualWidth = Float(image.size.width)
        let maxHeight: Float = 300.0
        let maxWidth: Float = 400.0
        var imgRatio: Float = actualWidth / actualHeight
        let maxRatio: Float = maxWidth / maxHeight
        let compressionQuality: Float = 0.5
        //50 percent compression
        if actualHeight > maxHeight || actualWidth > maxWidth {
            if imgRatio < maxRatio {
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            }
            else if imgRatio > maxRatio {
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            }
            else {
                actualHeight = maxHeight
                actualWidth = maxWidth
            }
        }
        let rect = CGRect(x: 0.0, y: 0.0, width: CGFloat(actualWidth), height: CGFloat(actualHeight))
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        let imageData = UIImageJPEGRepresentation(img!, CGFloat(compressionQuality))
        
        UIGraphicsEndImageContext()
        return UIImage(data: imageData!) ?? UIImage()
    }
}

//extension UIImage {
//    enum JPEGQuality: CGFloat {
//        case lowest  = 0
//        case low     = 0.25
//        case medium  = 0.5
//        case high    = 0.75
//        case highest = 1
//    }
//
//    /// Returns the data for the specified image in JPEG format.
//    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
//    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
//    func jpeg(_ quality: JPEGQuality) -> Data? {
//        //return UIImageJPEGRepresentation(self, quality.rawValue)
//
//    }
//}
