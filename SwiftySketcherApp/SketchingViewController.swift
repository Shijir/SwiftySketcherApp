//
//  SketchingViewController.swift
//  SwiftySketcherApp
//
//  Created by Shijir Tsogoo on 6/1/16.
//  Copyright © 2016 Shijir Tsogoo. All rights reserved.
//

import UIKit
import Firebase
class SketchingViewController: UIViewController {
    
    var start: CGPoint?
    var sessionKey:String!
    var PlayerId: Int!

    @IBOutlet var magicWordLabel: UILabel!
    
    @IBOutlet weak var drawImageView: UIImageView!
    
    @IBAction func doneButton(sender: AnyObject) {
        
        
        let ref = FIRDatabase.database().reference()
        let refSessions = ref.child("Sessions")
        let refCurrentSession = refSessions.child(self.sessionKey)
        
        let nextPlayerID = self.PlayerId + 1
        refCurrentSession.child("ActivePlayerId").setValue(nextPlayerID)
        
        
        
        let reportingViewController = self.storyboard?.instantiateViewControllerWithIdentifier("reportingScreen") as! ReportingViewController
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
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first as UITouch!
        start = touch.locationInView(self.drawImageView)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first as UITouch!
        let end = touch.locationInView(self.drawImageView)
        
        // interaction call
        if let s = self.start {
            draw(s, end: end)
        }
        
        // sets the end of the touch interaction to the start of the new one
        self.start = end
    }
    
    func draw(start: CGPoint, end: CGPoint) {
        
        //how big the image view will be
        UIGraphicsBeginImageContext(self.drawImageView.frame.size)
        
        let context = UIGraphicsGetCurrentContext()
        
        drawImageView?.image?.drawInRect(CGRect(x: 0, y: 0, width: drawImageView.frame.width, height: drawImageView.frame.height))
        
        CGContextSetLineWidth(context, 6)
        CGContextBeginPath(context)
        CGContextMoveToPoint(context, start.x, start.y)
        CGContextAddLineToPoint(context, end.x, end.y)
        CGContextStrokePath(context)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        drawImageView.image = newImage
        
        
        
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
