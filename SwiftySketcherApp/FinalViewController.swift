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

    @IBOutlet var magicWordSelf: UILabel!
    @IBOutlet var magicWordLabel: UILabel!
    @IBOutlet var statusLabel: UILabel!
    
    @IBOutlet var sketcherLabel: UILabel!
    
    @IBOutlet var guesserLabel: UILabel!
    
    
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
        
        
        ref.observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            
            let magicWord = snapshot.value!["MagicWord"] as! String
            let blamePictureObject = snapshot.value!["blamePicture"]
            
            let blamePicture = blamePictureObject as! String
            let blameSketcherId = snapshot.value!["blameSketcherId"] as! String
            let blameGuesserId = snapshot.value!["blameGuesserId"] as! String
            
            let playerObjects = snapshot.value!["Players"] as! [String: AnyObject]
            let players = Array(playerObjects.values)
            print(players)
            
            var blameSketcherName = blameSketcherId
            var blameGuesserName = blameGuesserId
            
            for player in players {
                
                let playerInfo = player as! [String:String]
                print(playerInfo)
                
            
            }
            
            
            
            if blamePictureObject == nil {
                self.statusLabel.text = "YOUR TEAM WON!"
                
                self.magicWordLabel.text = "Indeed, The Magic Word was:"
                self.magicWordSelf.text = magicWord.uppercaseString
            
            }
            else{
                self.statusLabel.text = "YOUR TEAM LOST!"
                self.magicWordLabel.text = "The Magic Word was:"
                self.magicWordSelf.text = magicWord.uppercaseString
            
            }
            

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
