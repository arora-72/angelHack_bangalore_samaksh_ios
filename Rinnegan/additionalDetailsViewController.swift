//
//  additionalDetailsViewController.swift
//  Rinnegan
//
//  Created by Indresh Arora on 09/06/18.
//  Copyright © 2018 Indresh Arora. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation
import AlamofireImage


class additionalDetailsViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {
    

    @IBOutlet weak var descriptionTxt: UITextField!
    @IBOutlet weak var postBtn: UIButton!
    @IBOutlet weak var otherBtn: UIButton!
    @IBOutlet weak var eveBtn: UIButton!
    @IBOutlet weak var molestationBtn: UIButton!
    @IBOutlet weak var fireBtn: UIButton!
    @IBOutlet weak var rapeBtn: UIButton!
    @IBOutlet weak var kidnappingBtn: UIButton!
    

    var locationManager: CLLocationManager?
    var latitude: Double?
    var longitude: Double?
    var masterDescription: String?
    var imageData: Data?
    var faceDetected: Bool = true
    var primaryDescription: String?
    var imageStringData: String?
    var imageArray: Array<Any>?
    var receivedArray: [UInt8] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(">>>>>>>>>>>>>>")
        determineCurrentLocation()
        // Do any additional setup after loading the view.
        BtnFunctionality()
        print(masterDescription)
        print(primaryDescription)
        print(longitude)
        print(latitude)
        print(self.imageArray)
        checkSOS()
        print("><><><><><>")
        
        //let nsData = NSData(base64Encoded: self.imageData!, options: .ignoreUnknownCharacters)
        
//       self.receivedArray = Array(self.imageData?)
//            print("<<<<<<<<>>>>>>>>>>>>>>>>")
////            print(bytes, String(bytes: bytes, encoding: .utf8))
//        print(self.receivedArray)
        
//        let nsData = NSData(base64Encoded: (self.imageData)!, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
//        print(nsData)
       let nsData = self.imageData?.base64EncodedString()
        print(nsData)
        self.imageStringData = nsData
        
        descriptionTxt.delegate = self
        
    }
    func determineCurrentLocation(){
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager?.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }
    }
    
   
    @IBAction func closeBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        self.latitude = userLocation.coordinate.latitude
        self.longitude = userLocation.coordinate.longitude
        locationManager?.stopUpdatingLocation()
    }
    
//    private class func uploadImage(to url: String, with headers: HTTPHeaders,for image: UIImage, completionHandler: @escaping (Bool, Any) -> ()){
//
//        print(url)
//
//        Alamofire.upload(multipartFormData: { (multipartFormData) in
//            for (key, value) in headers {
//                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
//            }
//
//            if let data = UIImageJPEGRepresentation(image, 0.2){
//                multipartFormData.append(data, withName: "image", fileName: "image.png", mimeType: "image/png")
//            }
//
//        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers) { (result) in
//            switch result{
//            case .success(let upload, , ):
//                upload.responseJSON { response in
//                    print("Succesfully uploaded")
//                    if let err = response.error{
//                        print(err.localizedDescription)
//                        completionHandler(false,Data())
//                        return
//                    }
//                    if let data = response.result.value{
//                        completionHandler(true,data)
//                    }else{
//                        completionHandler(false,Data())
//                    }
//                }
//            case .failure(let error):
//                print("Error in upload: \(error.localizedDescription)")
//                completionHandler(false,Data())
//            }
//        }
//    }
//
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("Error \(error)")
//
//    }
//
    func checkSOS(){
        if(self.imageData == nil){
            let url = URL(string: "http://samaksh.herokuapp.com/emergency")
            let parameters: [String:AnyObject] = [
                "latitude": self.latitude as AnyObject,
                "longitude": self.longitude as AnyObject,
                "description": descriptionTxt.text as AnyObject,
                "remarks": primaryDescription as AnyObject
            ]
            Alamofire.request(url!, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseJSON { (response) in
                    print(response.result)
                    print(response.data)
                    print(response.request)
            }
        }
    }
    
    @IBAction func textClicked(_ sender: Any) {
        self.masterDescription = self.descriptionTxt.text
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.view.endEditing(true)
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        descriptionTxt.resignFirstResponder()
    }
    @IBAction func postBtnClicked(_ sender: Any) {
      
        
        let url = URL(string: "http://samaksh.herokuapp.com/saveCamData")
        let parameters: [String: AnyObject] = [
            "description": descriptionTxt.text as AnyObject,
            "remarks": primaryDescription as AnyObject,
            "longitude": self.longitude as AnyObject,
            "latitude": self.latitude as AnyObject,
            "photo":  "fuck" as AnyObject,
            "faceDetected": self.faceDetected as AnyObject
            
        ]
        Alamofire.request(url!, method: .post, parameters: parameters, encoding: JSONEncoding.default)
//            .responseString { (response) in
//                print(response.response)
//                print(response.result)
//                self.dismiss(animated: true, completion: nil)
//        }
            .responseJSON { (response) in
                print(response.response)
                print(response.error)
                print(response.result)
                self.dismiss(animated: true, completion: nil)
        }
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func BtnFunctionality(){
        
        if(rapeBtn.isSelected){
            primaryDescription = "Rape"
        }else if (kidnappingBtn.isSelected){
            primaryDescription = "Kidnapping"
        }else if (fireBtn.isSelected){
            primaryDescription = "Fire"
        }else if (molestationBtn.isSelected){
            primaryDescription = "Molestation"
        }else if (eveBtn.isSelected){
            primaryDescription = "Eve Teasing"
        }else if (otherBtn.isSelected){
            primaryDescription = "Other"
        }else{
            primaryDescription = "Other not specified"
        }
        
        
    }
    
    
    
    
    
    
    
}


