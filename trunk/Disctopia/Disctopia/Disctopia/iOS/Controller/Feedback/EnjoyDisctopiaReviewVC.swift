//
//  EnjoyDisctopiaReviewVC.swift
//  Disctopia
//
//  Created by Mitesh on 3/2/17.
//  Copyright © 2017 'byPeople Technologies'. All rights reserved.
//

import UIKit

class EnjoyDisctopiaReviewVC: BaseVC
{

    // MARK: - Variable
    
    var isClick = 1 //1.NO 2.YES
    
    
    // MARK: - Outlet
    
    @IBOutlet var lblTitle: UILabel!
    
    @IBOutlet var btnNoThanks: UIButton!
    
    @IBOutlet var btnOkSure: UIButton!
    
    @IBOutlet var imgAnimationView: UIImageView!
    // MARK: - LifeCycle Method -
   
    override func viewDidLoad() {
        super.viewDidLoad()

        self.btnNoThanks.layer.borderWidth = 1
        self.btnNoThanks.layer.borderColor = UIColor.whiteColor().CGColor
        self.btnOkSure.layer.borderWidth = 1
        self.btnOkSure.layer.borderColor = UIColor.whiteColor().CGColor
        
        if isClick == 1
        {
            lblTitle.text = "Would you mind giving us some feedback?"
        }
        else
        {
            lblTitle.text = "How about a rating on App store?"
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Button Actions
    
    
    @IBAction func btnOnClickNo(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func btnOnClickOK(sender: AnyObject)
    {
        

        
                UIView.animateWithDuration(0.5, animations: {() -> Void in
            self.imgAnimationView.frame = CGRectMake(self.btnNoThanks.frame.origin.x, self.btnNoThanks.frame.origin.y, self.btnNoThanks.frame.size.width, self.btnNoThanks.frame.size.height)
            }, completion: {(finished: Bool) -> Void in
                self.dismissViewControllerAnimated(false, completion: { () -> Void in
                    
                    if self.isClick == 1
                    {
                        let vc = STORY_BOARD_MAIN.instantiateViewControllerWithIdentifier("GiveFeedbackVC") as! GiveFeedbackVC
                        let navigationController = UINavigationController(rootViewController: vc)
                        navigationController.modalPresentationStyle = .OverCurrentContext
                        navigationController.navigationBarHidden = true
                        appDelegate.navigationController!.visibleViewController!.presentViewController(navigationController, animated: true, completion: nil)
                    }
                    else
                    {
                        
                        let RATING_URL = "https://itunes.apple.com/us/app/disctopia/id1162011563?mt=8"
                        let url  = NSURL(string: RATING_URL)
                        if UIApplication.sharedApplication().canOpenURL(url!)
                        {
                            UIApplication.sharedApplication().openURL(url!)
                        }
                        //UIApplication.sharedApplication().openURL(NSURL(string: "itms://itunes.apple.com/us/app/disctopia/id1162011563?mt=8")!)
                    }
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
