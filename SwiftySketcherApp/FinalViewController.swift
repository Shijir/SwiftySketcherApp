//
//  FinalViewController.swift
//  SwiftySketcherApp
//
//  Created by Shijir Tsogoo on 6/2/16.
//  Copyright © 2016 Shijir Tsogoo. All rights reserved.
//

import UIKit
import Firebase

class FinalViewController: UIViewController {
    
    var sessionKey:String!

    @IBOutlet var statusLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let ref = FIRDatabase.database().reference().child("Sessions").child(self.sessionKey)
        
        
        ref.child("blamePicture").observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            
            if snapshot.exists() {
            //if blamePicture field exists, it means the team failed    
                self.statusLabel.text = "YOUR TEAM LOST!"
                
            }else{
            //if blamePicture field doesn't exist, it means the team won
                self.statusLabel.text = "YOUR TEAM WON!"
            
            }
            //let base64String = snapshot.value as! String
        })
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
