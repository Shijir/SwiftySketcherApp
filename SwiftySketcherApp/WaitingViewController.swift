//
//  WaitingViewController.swift
//  SwiftySketcherApp
//
//  Created by Shijir Tsogoo on 5/30/16.
//  Copyright © 2016 Shijir Tsogoo. All rights reserved.
//

import UIKit
import Firebase

class WaitingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    
    let deviceUniqID:String = UIDevice.currentDevice().identifierForVendor!.UUIDString
    var sessionKey:String!
    var players = []
    let playersTableIdentifier = "playersTableIdentifier"
    var tableViewController = UITableViewController(style: .Plain)
    var recentPlayerKey:String!
    
    @IBOutlet var startButton: UIBarButtonItem!
    
    @IBAction func startButtonAction(sender: AnyObject) {
        
        let ref = FIRDatabase.database().reference()
        let refSessions = ref.child("Sessions")
        let refCurrentSession = refSessions.child(self.sessionKey)
        var playersInSession = 0
        
//        refCurrentSession.child("PlayersNumber").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
//
//            playersInSession = snapshot.value as! Int
//            
//            if playersInSession {
//            
//                refCurrentSession.child("GameOn").setValue(true);
//                
//            }
//            
//
//        
//        }) { (error) in
//            print(error.localizedDescription)
//        }
        
        
        
    }

    @IBOutlet var playersLabel: UILabel!
    @IBOutlet var playersTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ref = FIRDatabase.database().reference()
        let refSessions = ref.child("Sessions")
        let refCurrentSession = refSessions.child(self.sessionKey)
        let refSessionPlayers = refCurrentSession.child("Players")
        
        refCurrentSession.observeEventType(.Value, withBlock: { (snapshot) in
            // Get user value
            let creatorDevice = snapshot.value!["CreatorDevice"] as! String
            let playersInSession = snapshot.value!["PlayersNumber"] as! Int
            
            print(creatorDevice)
            print(playersInSession)
            
            if playersInSession < 3 {
                self.startButton.enabled = false
            }else{
                self.startButton.enabled = true
                
                if (playersInSession % 2) == 0 {
                    self.startButton.enabled = false
                }
                
            }
            
            if creatorDevice != self.deviceUniqID {
                self.startButton.enabled = false
            }
            
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
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
        let refSessionPlayers = refCurrentSession.child("Players")
        
        
        refSessionPlayers.observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            
            
            if snapshot.exists()  {

                let fbSessions = snapshot.value as! [String: AnyObject]
                
                
                self.players = Array(fbSessions.values)
                
                
                if self.players.count>1{
                    
                    
                    //refSessionPlayers.child(self.deviceUniqID).child("id").setValue(playerID)
                    self.playersLabel.text = "There are \(self.players.count) players."
                    
                }
                
                else {
                    
                    //refSessionPlayers.child(self.deviceUniqID).child("id").setValue(playerID)
                    self.playersLabel.text = "You are the only player in this session."
                    
                }
                
                self.playersTableView.reloadData()
                
            }else{
                
                self.playersLabel.text = "No players. Create your session."
                self.players = []
                self.playersTableView.reloadData()
                
            }
            
            
            
        })
        
        // Do any additional setup after loading the view.
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.players.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(playersTableIdentifier)
        if (cell == nil) {
            cell = UITableViewCell(
                style: UITableViewCellStyle.Default,
                reuseIdentifier: playersTableIdentifier)
        }
        
        //cell?.textLabel?.text = "test"
        cell?.textLabel?.text = self.players[indexPath.row]["PlayerName"] as! String
        
        
        return cell!
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
