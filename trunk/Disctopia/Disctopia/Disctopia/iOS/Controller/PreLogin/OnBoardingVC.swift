//
//  OnBoardingVC.swift
//  Disctopia
//
//  Created by abc on 6/21/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit

class OnBoardingVC: BaseVC {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    override func viewDidLoad() {
        
        self.dynamicFontNeeded = false
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        BaseVC.sharedInstance.DLog("WillAppear OnBoardingVC")
        
        self.bottomView.alpha = 0
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        BaseVC.sharedInstance.DLog("WillDisappear OnBoardingVC")
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        BaseVC.sharedInstance.DLog("DidAppear OnBoardingVC")
        
        UIView.animateWithDuration(0.5, delay: 0.1, options: .TransitionCrossDissolve, animations: {
            
            self.bottomView.alpha = 1
            
            }, completion: { (true) in
                
        })
        
        self.performSelector(#selector(pushToMenuVC), withObject: nil, afterDelay: 0.6)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        BaseVC.sharedInstance.DLog("DidDisappear OnBoardingVC")
    }
    
    
    func pushToMenuVC(){
        
        NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: #selector(OnBoardingVC.onCloseSaveChangeView(_:)), userInfo: nil, repeats: false)
       
    }
    
    @IBAction func onCloseSaveChangeView(sender: UIButton)
        {
            BaseVC.sharedInstance.DLog("pushToMenuVC OnBoardingVC called")
            appDelegate.distopiaUserType = .Artist
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let menuVC = storyboard.instantiateViewControllerWithIdentifier("MenuVC") as! MenuVC
            menuVC.view.translatesAutoresizingMaskIntoConstraints = false;
            self.view.alpha = 1
            
            UIView.animateWithDuration(0.75, animations: { () -> Void in
                
                self.view.alpha = 0
                
                UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
                
                //UIView.setAnimationTransition(UIViewAnimationTransition.FlipFromRight, forView: self.navigationController!.view!, cache: false)
                
                //self.navigationController!.pushViewController(menuVC, animated: false)
                
                //self.performSegueWithIdentifier("menuVC", sender: nil)
                appDelegate.distopiaUserType = .Artist
                appDelegate.loadFirstViewController("MenuVC")
            })
        }
}
