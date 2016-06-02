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

    @IBOutlet var activePlayerReporting: UILabel!
    
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
        
        
        let ref = FIRDatabase.database().reference()
        let refSessions = ref.child("Sessions")
        let refCurrentSession = refSessions.child(self.sessionKey)
        
        
        refCurrentSession.child("ActivePlayerId").observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            let activePlayerId = snapshot.value as! Int
            print(activePlayerId)
            
            self.activePlayerReporting.text = String(activePlayerId)
            
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
