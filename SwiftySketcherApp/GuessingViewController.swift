//
//  GuessingViewController.swift
//  SwiftySketcherApp
//
//  Created by Shijir Tsogoo on 6/1/16.
//  Copyright © 2016 Shijir Tsogoo. All rights reserved.
//

import UIKit
import Firebase

class GuessingViewController: UIViewController {
    
    var sessionKey:String!
    var PlayerId: Int!

    @IBOutlet var guessingInputField: UITextField!
    
    @IBOutlet var displayImage: UIImageView!
    
    @IBAction func doneButton(sender: AnyObject) {
        
        let ref = FIRDatabase.database().reference()
        let refSessions = ref.child("Sessions")
        let refCurrentSession = refSessions.child(self.sessionKey)
        
        //setting the next user active
        let nextPlayerID = self.PlayerId + 1
        refCurrentSession.child("ActivePlayerId").setValue(nextPlayerID)
        
        //Converting image to base64

        
        
        let reportingViewController = self.storyboard?.instantiateViewControllerWithIdentifier("reportingScreen") as! ReportingViewController
        reportingViewController.sessionKey = self.sessionKey
        self.presentViewController(reportingViewController, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let ref = FIRDatabase.database().reference().child("Sessions").child(self.sessionKey)
    
        
        
        ref.child("CurrentImage").observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            let base64String = snapshot.value as! String
            
            print(base64String)
            
//            let decodedData = NSData(base64EncodedString: base64String, options: NSDataBase64DecodingOptions(rawValue: 0))
//            let decodedimage = UIImage(data: decodedData!)
//            
//            self.displayImage.image = decodedimage! as UIImage
            
        })
        
        
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
