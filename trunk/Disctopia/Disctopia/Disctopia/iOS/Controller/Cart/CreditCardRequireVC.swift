//
//  CreditCardRequireVC.swift
//  Disctopia
//
//  Created by Brijesh shiroya on 9/24/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit

class CreditCardRequireVC: BaseVC {

    //MARK: - Outlets
    @IBOutlet weak var animationView: UIImageView!
    @IBOutlet var btnNO: UIButton!
    @IBOutlet var btnYES: UIButton!
    
    //MARK: - View LifeCycle

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
       /*
        if self.btnNO.frame.origin.y == self.animationView.frame.origin.y
        {
            self.dismissViewControllerAnimated(true, completion: nil)
            
            /* self.dismissViewControllerAnimated(false, completion: { () -> Void in
                self.pushToViewControllerIfNotExistWithClassName("MyMusicPlaylistVC", animated: true)
            })
             */
        }
        else
        {
            UIView.animateWithDuration(0.5)
            {
                self.animationView.frame = CGRectMake(self.btnNO.frame.origin.x, self.btnNO.frame.origin.y, self.btnNO.frame.size.width, self.btnNO.frame.size.height)
            }
        }
 */
        
        UIView.animateWithDuration(0.5, animations: {() -> Void in
            self.animationView.frame = CGRectMake(self.btnNO.frame.origin.x, self.btnNO.frame.origin.y, self.btnNO.frame.size.width, self.btnNO.frame.size.height)
            }, completion: {(finished: Bool) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
        })

    }
    @IBAction func OnYESClick(sender: AnyObject)
    {
        /*
        if self.btnYES.frame.origin.y == self.animationView.frame.origin.y
        {
             self.dismissViewControllerAnimated(false, completion: { () -> Void in
                 self.pushToViewControllerIfNotExistWithClassName("SettingsMenuVC", animated: true)
             })
        }
        else
        {
            UIView.animateWithDuration(0.5)
            {
                self.animationView.frame = CGRectMake(self.btnYES.frame.origin.x, self.btnYES.frame.origin.y, self.btnYES.frame.size.width, self.btnYES.frame.size.height)
            }
        }
 */
        
        UIView.animateWithDuration(0.5, animations: {() -> Void in
            self.animationView.frame = CGRectMake(self.btnYES.frame.origin.x, self.btnYES.frame.origin.y, self.btnYES.frame.size.width, self.btnYES.frame.size.height)
            }, completion: {(finished: Bool) -> Void in
                self.dismissViewControllerAnimated(false, completion: { () -> Void in
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
