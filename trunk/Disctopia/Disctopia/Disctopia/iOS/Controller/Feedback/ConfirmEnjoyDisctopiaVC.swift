//
//  ConfirmEnjoyDisctopiaVC.swift
//  Disctopia
//
//  Created by Mitesh on 3/2/17.
//  Copyright © 2017 'byPeople Technologies'. All rights reserved.
//

import UIKit

class ConfirmEnjoyDisctopiaVC: BaseVC
{

    // MARK: - Variable
    
    
    // MARK: - Outlet
   
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var imgAnimationView: UIImageView!
    
    @IBOutlet var btnNotReally: UIButton! //Emjoy disctopia
    @IBOutlet var btnYes: UIButton!  //Emjoy disctopia
    
    // MARK: - LifeCycle Method -
   
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.btnNotReally.layer.borderWidth = 1
        self.btnNotReally.layer.borderColor = UIColor.whiteColor().CGColor
        self.btnYes.layer.borderWidth = 1
        self.btnYes.layer.borderColor = UIColor.whiteColor().CGColor

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Button Actions

    @IBAction func btnOnClickNotReally(sender: AnyObject)
    {
        UIView.animateWithDuration(0.5, animations: {() -> Void in
            self.imgAnimationView.frame = CGRectMake(self.btnNotReally.frame.origin.x, self.btnNotReally.frame.origin.y, self.btnNotReally.frame.size.width, self.btnNotReally.frame.size.height)
            }, completion: {(finished: Bool) -> Void in
                self.dismissViewControllerAnimated(false, completion: { () -> Void in
                   
                    let vc = STORY_BOARD_MAIN.instantiateViewControllerWithIdentifier("EnjoyDisctopiaReviewVC") as! EnjoyDisctopiaReviewVC
                    vc.isClick = 1
                    let navigationController = UINavigationController(rootViewController: vc)
                    navigationController.modalPresentationStyle = .OverCurrentContext
                    navigationController.navigationBarHidden = true
                     appDelegate.navigationController!.visibleViewController!.presentViewController(navigationController, animated: true, completion: nil)
                    
                })
        })
    }
    
    
    @IBAction func btnOnClickYes(sender: AnyObject)
    {
        UIView.animateWithDuration(0.5, animations: {() -> Void in
            self.imgAnimationView.frame = CGRectMake(self.btnYes.frame.origin.x, self.btnYes.frame.origin.y, self.btnYes.frame.size.width, self.btnYes.frame.size.height)
            }, completion: {(finished: Bool) -> Void in
                self.dismissViewControllerAnimated(false, completion: { () -> Void in
                    
                    let vc = STORY_BOARD_MAIN.instantiateViewControllerWithIdentifier("EnjoyDisctopiaReviewVC") as! EnjoyDisctopiaReviewVC
                    vc.isClick = 2
                    let navigationController = UINavigationController(rootViewController: vc)
                    navigationController.modalPresentationStyle = .OverCurrentContext
                    navigationController.navigationBarHidden = true
                    appDelegate.navigationController!.visibleViewController!.presentViewController(navigationController, animated: true, completion: nil)
                    
                })
        })
    }

}
