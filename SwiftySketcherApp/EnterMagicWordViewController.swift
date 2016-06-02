//
//  EnterMagicWordViewController.swift
//  SwiftySketcherApp
//
//  Created by Shijir Tsogoo on 6/1/16.
//  Copyright © 2016 Shijir Tsogoo. All rights reserved.
//

import UIKit
import Firebase

class EnterMagicWordViewController: UIViewController {
    
    var sessionKey:String!

    @IBOutlet var magicWordInputField: UITextField!
    
    
    @IBAction func magicWordInputDone(sender: AnyObject) {
        
        print("word entered")
        
        let ref = FIRDatabase.database().reference()
        let refSessions = ref.child("Sessions")
        let refCurrentSession = refSessions.child(self.sessionKey)
        
        refCurrentSession.child("ActivePlayerId").setValue(2)
        
        refCurrentSession.child("MagicWord").setValue(self.magicWordInputField.text)
        
        let reportingViewController = storyboard?.instantiateViewControllerWithIdentifier("reportingScreen") as! ReportingViewController
        
        reportingViewController.sessionKey = self.sessionKey
        
        
        self.presentViewController(reportingViewController, animated: true, completion: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
