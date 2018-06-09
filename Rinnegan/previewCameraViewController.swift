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


class previewCameraViewController: UIViewController {
    
    let cameraController = CameraController()
    
    var image: UIImage?
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?

    @IBOutlet weak var previewView: UIView!
    @IBOutlet fileprivate var photoModeButton: UIButton!
    @IBOutlet fileprivate var toggleCameraButton: UIButton!
    @IBOutlet fileprivate var toggleFlashButton: UIButton!
    
    ///Allows the user to put the camera in video mode.
    @IBOutlet fileprivate var videoModeButton: UIButton!
    
    @IBOutlet weak var captureButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
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
    }
    
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
