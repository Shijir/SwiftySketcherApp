//
//  NameViewController.swift
//  SwiftySketcherApp
//
//  Created by Shijir Tsogoo on 5/30/16.
//  Copyright © 2016 Shijir Tsogoo. All rights reserved.
//

import UIKit
import Firebase

class NameViewController: UIViewController, UITextFieldDelegate{
    
    var sessionKey:String!
    var deviceID:String!
    var creatingSession:Bool = false;
    
    @IBOutlet var nameField: UITextField!

    @IBAction func nameEntered(sender: AnyObject) {
        
        //if true, create a new session
        if self.creatingSession {
            
            let ref = FIRDatabase.database().reference().child("Sessions").child(self.sessionKey)
            ref.child("CreatorName").setValue(nameField.text)
            ref.child("Players").child(self.deviceID).child("PlayerName").setValue(nameField.text)
            ref.child("Players").child(self.deviceID).child("PlayerCompleted").setValue(false)
            ref.child("Players").child(self.deviceID).child("PlayerID").setValue(1)
            ref.child("PlayersNumber").setValue(1)
            
            let waitingViewController = storyboard?.instantiateViewControllerWithIdentifier("waitingScreen") as! WaitingViewController
            
            waitingViewController.sessionKey = self.sessionKey
            waitingViewController.recentPlayerKey = self.deviceID
            
            self.presentViewController(waitingViewController, animated: true, completion: nil)
        
        
        }
        //if false, join an existing session
        else{
            
            let ref = FIRDatabase.database().reference().child("Sessions").child(self.sessionKey)
            
            
            ref.child("Players").child(self.deviceID).child("PlayerName").setValue(nameField.text)
            ref.child("Players").child(self.deviceID).child("PlayerCompleted").setValue(false)
            
            ref.child("PlayersNumber").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                // Get user value
                let playersNumbers = 1 + (snapshot.value as! Int)
                print(playersNumbers)
                
                ref.child("Players").child(self.deviceID).child("PlayerID").setValue(playersNumbers)
                ref.child("PlayersNumber").setValue(playersNumbers)
                
                
            }) { (error) in
                print(error.localizedDescription)
            }
            
            print(ref.child("PlayersNumber"))
            
            let waitingViewController = storyboard?.instantiateViewControllerWithIdentifier("waitingScreen") as! WaitingViewController
            
            waitingViewController.sessionKey = self.sessionKey
            waitingViewController.recentPlayerKey = self.deviceID
            
            self.presentViewController(waitingViewController, animated: true, completion: nil)

        
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameField.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        //textField code
        
        textField.resignFirstResponder()  //if desired
        nameEntered(self)
        
        return true
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
