//
//  ReportingViewController.swift
//  SwiftySketcherApp
//
//  Created by Shijir Tsogoo on 6/1/16.
//  Copyright © 2016 Shijir Tsogoo. All rights reserved.
//

import UIKit
import Firebase

class ReportingViewController: UIViewController {
    
    var sessionKey:String!
    var PlayerId:Int!
    var PlayerName:String!
    let deviceUniqID:String = UIDevice.currentDevice().identifierForVendor!.UUIDString
    
    @IBOutlet var yourTurnLabel: UILabel!
    @IBOutlet var doWorkButton: UIButton!
    @IBAction func doWorkButton(sender: AnyObject) {
        
        let ref = FIRDatabase.database().reference()
        let refSessions = ref.child("Sessions")
        let refCurrentSession = refSessions.child(self.sessionKey)
        
        let nextPlayerID = PlayerId + 1
        refCurrentSession.child("ActivePlayerId").setValue(nextPlayerID)
        
    }

    @IBOutlet var activePlayerReporting: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doWorkButton.enabled = false;
        yourTurnLabel.hidden = true;
        


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        

        let ref = FIRDatabase.database().reference().child("Sessions").child(self.sessionKey)
        
        ref.child("Players").child(self.deviceUniqID).observeSingleEventOfType(FIRDataEventType.Value, withBlock: { (snapshot) in
            
            
            // Get user value
            self.PlayerId = snapshot.value!["PlayerID"] as! Int
            self.PlayerName = snapshot.value!["PlayerName"] as! String
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
        //observing changes in the entire session
        ref.child("ActivePlayerId").observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            let activePlayerId = snapshot.value as! Int
        
            if self.PlayerId == activePlayerId {
                
                self.doWorkButton.enabled = true;
                
            }
            
            if self.PlayerId == activePlayerId+1{
                
                self.yourTurnLabel.hidden = false;
                
            }else{
                
                self.yourTurnLabel.hidden = true;
            
            }
            
            if self.PlayerId == activePlayerId{
            
                if self.PlayerId>1 {
                
                    if self.PlayerId % 2 == 0 {
                    
                        //go to sketching word
                        
                        let sketchingViewController = self.storyboard?.instantiateViewControllerWithIdentifier("sketchingScreen") as! SketchingViewController
                        
                        sketchingViewController.sessionKey = self.sessionKey
                        sketchingViewController.PlayerId = self.PlayerId
                        
                        self.presentViewController(sketchingViewController, animated: true, completion: nil)
                        
                    }else{
                    
                        //go to guessing word
                        
                    }
                
                }
            
            }
            
            self.activePlayerReporting.text = "Players \(activePlayerId) is working now!"
            
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
