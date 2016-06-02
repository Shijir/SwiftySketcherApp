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
    var passedMagicWord:String!
    
    var SketcherID: String!
    var GuesserID: String!
    var PictureBase64: String!

    @IBOutlet var magicWordSelf: UILabel!
    @IBOutlet var magicWordLabel: UILabel!
    @IBOutlet var statusLabel: UILabel!
    
    @IBOutlet var sketcherLabel: UILabel!
    
    @IBOutlet var guesserLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ref = FIRDatabase.database().reference().child("Sessions").child(self.sessionKey)
        
        
        ref.child("blameData").observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            
            if snapshot.exists(){
                
                self.statusLabel.text = "YOUR TEAM LOST!"
                self.magicWordLabel.text = "The wagic word was:"
                self.magicWordSelf.text = self.passedMagicWord.uppercaseString
                
                //self.magicWord = snapshot.value!["MagicWord"] as! String
                
                self.SketcherID = snapshot.value!["SketcherId"] as! String
                self.GuesserID = snapshot.value!["GuesserId"] as! String
                self.PictureBase64  = snapshot.value!["Picture"] as! String
                
            }else{
                
                self.statusLabel.text = "YOUR TEAM WON!"
                self.magicWordLabel.text = "Indeed, the magic word was:"
                self.magicWordSelf.text = self.passedMagicWord.uppercaseString
                self.sketcherLabel.hidden = true;
                self.guesserLabel.hidden = true;
                
                
            }
            
        })

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let ref = FIRDatabase.database().reference().child("Sessions").child(self.sessionKey)
        
        ref.child("Players").observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            
            let sketcherName = snapshot.value![self.SketcherID]!!["PlayerName"] as! String
            let guesserName = snapshot.value![self.GuesserID]!!["PlayerName"] as! String
            self.guesserLabel.text = "\(sketcherName.capitalizedString) sketched a crappy \(self.passedMagicWord.uppercaseString)"
            self.sketcherLabel.text = "So \(guesserName.capitalizedString) didn't guess it right!"
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
