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
        
        
        let ref = FIRDatabase.database().reference()
        let refSessions = ref.child("Sessions")
        let refCurrentSession = refSessions.child(self.sessionKey)
        let refAllPlayers = refSessions.child("Players")
        let myPlayerData = refAllPlayers.child(deviceUniqID)
        
        myPlayerData.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            // Get user value
            self.PlayerId = snapshot.value!["PlayerID"] as! Int
            self.PlayerName = snapshot.value!["PlayerName"] as! String
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
        //observing changes in the entire session
        refCurrentSession.child("ActivePlayerId").observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            let activePlayerId = snapshot.value as! Int
        
            if self.PlayerId == activePlayerId {
                
                self.doWorkButton.enabled = true;
                self.yourTurnLabel.hidden = false;
                
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
