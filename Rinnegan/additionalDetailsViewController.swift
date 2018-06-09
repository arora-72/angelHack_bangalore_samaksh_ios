//
//  additionalDetailsViewController.swift
//  Rinnegan
//
//  Created by Indresh Arora on 09/06/18.
//  Copyright © 2018 Indresh Arora. All rights reserved.
//

import UIKit
import Alamofire

class additionalDetailsViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var descriptionTxt: UITextField!
    @IBOutlet weak var postBtn: UIButton!
    @IBOutlet weak var otherBtn: UIButton!
    @IBOutlet weak var eveBtn: UIButton!
    @IBOutlet weak var molestationBtn: UIButton!
    @IBOutlet weak var fireBtn: UIButton!
    @IBOutlet weak var rapeBtn: UIButton!
    @IBOutlet weak var kidnappingBtn: UIButton!
    

    var latitude: Double?
    var longitude: Double?
    var masterDescription: String?
    var imageData: Data?
    var faceDetected: Bool = true
    var primaryDescription: String?
    var imageStringData: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(">>>>>>>>>>>>>>")
        
        // Do any additional setup after loading the view.
        BtnFunctionality()
        print(masterDescription)
        print(primaryDescription)
        print(longitude)
        print(latitude)
        
        var stringData = String(data: self.imageData!, encoding: String.Encoding.utf8)
        self.imageStringData = stringData
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
            "photo":  self.imageStringData as AnyObject,
            "faceDetected": self.faceDetected as AnyObject
            
        ]
        Alamofire.request(url!, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { (response) in
                print(response.result)
                self.dismiss(animated: true, completion: nil)
        }
        
        
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
    
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
