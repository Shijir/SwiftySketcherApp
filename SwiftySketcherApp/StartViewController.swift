//
//  StartViewController.swift
//  SwiftySketcherApp
//
//  Created by Shijir Tsogoo on 5/30/16.
//  Copyright © 2016 Shijir Tsogoo. All rights reserved.
//

import UIKit
import Firebase

class StartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var sessions = []
    let sessionsTableIdentifier = "sessionsTableIdentifier"
    var tableViewController = UITableViewController(style: .Plain)
    let deviceUniqID:String = UIDevice.currentDevice().identifierForVendor!.UUIDString

    @IBOutlet var sessionLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    @IBAction func createNewSession(sender: AnyObject) {
        //Create new session key in Firebase
        let newSession = FIRDatabase.database().reference().child("Sessions").childByAutoId()
        //Passing the unique Id of the device to creator field
        
        
        newSession.child("id").setValue(newSession.key)
        newSession.child("CreatorDevice").setValue(deviceUniqID)
        newSession.child("MagicWord").setValue("none")
        newSession.child("CurrentImage").setValue("none")
        newSession.child("CreatorName").setValue("New session being created")
        newSession.child("Players").child(deviceUniqID).child("PlayerName").setValue("_")
        newSession.child("GameOn").setValue(false)
        
        let nameViewController = storyboard?.instantiateViewControllerWithIdentifier("nameScreen") as! NameViewController
        
        nameViewController.creatingSession = true
        nameViewController.sessionKey = newSession.key
        nameViewController.deviceID = deviceUniqID
        
        
        self.presentViewController(nameViewController, animated: true, completion: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        let ref = FIRDatabase.database().reference()
        
        ref.child("Sessions").observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            
            
            
            if snapshot.exists()  {
            
                let fbSessions = snapshot.value as! [String: AnyObject]
                
                
                self.sessions = Array(fbSessions.values)

                if self.sessions.count==1 {
                    
                    self.sessionLabel.text = "There is a session."
                    
                }
                
                if self.sessions.count>1{
                    
                    self.sessionLabel.text = "There are \(self.sessions.count) sessions."
                    
                }
                
                self.tableView.reloadData()
                
            }else{
                
                self.sessionLabel.text = "No sessions. Create your session."
                self.sessions = []
                self.tableView.reloadData()
                
            }

            
            
        })

        // Do any additional setup after loading the view.
    
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sessions.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(sessionsTableIdentifier)
        if (cell == nil) {
            cell = UITableViewCell(
                style: UITableViewCellStyle.Default,
                reuseIdentifier: sessionsTableIdentifier)
        }
        
        let sessionCreatorName = self.sessions[indexPath.row]["CreatorName"] as? String
        
        if sessionCreatorName != nil {
            cell?.textLabel?.text = self.sessions[indexPath.row]["CreatorName"] as? String
        }
        
        
        
        return cell!
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //selecting tableRow
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        
        let nameViewController = storyboard?.instantiateViewControllerWithIdentifier("nameScreen") as! NameViewController
        
        nameViewController.creatingSession = false
        
        nameViewController.sessionKey = self.sessions[indexPath.row]["id"] as! String
        nameViewController.deviceID = deviceUniqID
        
        self.presentViewController(nameViewController, animated: true, completion: nil)
        
        
    }

}
