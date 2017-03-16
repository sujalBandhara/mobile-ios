//
//  ConfirmGoSubscriptionVC.swift
//  Disctopia
//
//  Created by Mitesh on 3/1/17.
//  Copyright © 2017 'byPeople Technologies'. All rights reserved.
//

import UIKit

class ConfirmGoSubscriptionVC: BaseVC
{

    // MARK: - Variable
    
    // MARK: - Outlet
    @IBOutlet weak var animationView: UIImageView!
    @IBOutlet var btnNO: UIButton!
    @IBOutlet var btnYES: UIButton!
    // MARK: - LifeCycle Method -
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Button Actions
    
    @IBAction func onNOClick(sender: AnyObject)
    {
        
        UIView.animateWithDuration(0.5, animations: {() -> Void in
            self.animationView.frame = CGRectMake(self.btnNO.frame.origin.x, self.btnNO.frame.origin.y, self.btnNO.frame.size.width, self.btnNO.frame.size.height)
            }, completion: {(finished: Bool) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
        })
        
    }
    @IBAction func OnYESClick(sender: AnyObject)
    {
       
        
        UIView.animateWithDuration(0.5, animations: {() -> Void in
            self.animationView.frame = CGRectMake(self.btnYES.frame.origin.x, self.btnYES.frame.origin.y, self.btnYES.frame.size.width, self.btnYES.frame.size.height)
            }, completion: {(finished: Bool) -> Void in
                self.dismissViewControllerAnimated(false, completion: { () -> Void in
                    appDelegate.isFromGoSubsription = true
                    self.pushToViewControllerIfNotExistWithClassName("SettingsMenuVC", animated: true)
                })
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
