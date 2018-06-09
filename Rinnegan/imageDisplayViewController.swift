//
//  imageDisplayViewController.swift
//  Rinnegan
//
//  Created by Indresh Arora on 09/06/18.
//  Copyright © 2018 Indresh Arora. All rights reserved.
//

import UIKit

class imageDisplayViewController: UIViewController {
    
    var image_import: UIImage?

   
    
    
    @IBOutlet weak var image_view: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(">>>>>>>>>><<<<<<<<<<")
        print(image_import)
        
        if(image_import != nil){
            self.image_view.image = image_import
            
        }
        // Do any additional setup after loading the view.
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
