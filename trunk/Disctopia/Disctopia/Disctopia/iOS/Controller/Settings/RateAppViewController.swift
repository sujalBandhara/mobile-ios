//
//  RateAppViewController.swift
//  Disctopia
//
//  Created by iMac03 on 02/08/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

class RateAppViewController: BaseVC
{
    // MARK: - Outlets

    @IBOutlet var rateMeButton:UIButton!
    
    @IBOutlet var remindMeLaterButton:UIButton!
    
    @IBOutlet var noThanksButton:UIButton!
    
    @IBOutlet var animationView:UIImageView!
    
    @IBOutlet weak var btnCancel: UIButton!
    
    // MARK: - Methods

    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(true)
        BaseVC.sharedInstance.DLog("WillAppear RateAppViewController")
        
        btnCancel.layer.borderWidth = 1.0
        btnCancel.layer.borderColor = UIColor(white: 1.0, alpha: 1).CGColor
        BaseVC.sharedInstance.defaultsAppLunchDate.setObject(NSDate(), forKey:Constants.userDefault.appLaunchDate)
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(true)
        BaseVC.sharedInstance.DLog("WillDisappear RateAppViewController")
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(true)
        BaseVC.sharedInstance.DLog("DidAppear RateAppViewController")
    }
    
    override func viewDidDisappear(animated: Bool)
    {
        super.viewDidDisappear(true)
        BaseVC.sharedInstance.DLog("DidDisappear RateAppVievarntroller")
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        //Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Actions
    
    @IBAction func rateMeClicked(sender : AnyObject)
    {
        /*
        if self.rateMeButton.frame == self.animationView.frame
        {
            Constants.userDefault.rateMe = true
            
            let iTunesLink: String = "itms://itunes.apple.com/us/app/apple-store/id375380948?mt=8"
            UIApplication.sharedApplication().openURL(NSURL(string: iTunesLink)!)
            
            self.cyclicViewController(false, originFrame: self.view.frame, oldViewController: self, toViewController: parentViewController!)
        }
        else
        {
            UIView.animateWithDuration(0.5, animations:
            {
                self.animationView.frame = self.rateMeButton.frame
            }
            , completion:
            {
                (true) in
                    
            })
        }*/
        
        UIView.animateWithDuration(0.5, animations: {() -> Void in
            self.animationView.frame = self.rateMeButton.frame
            }, completion: {(finished: Bool) -> Void in
                Constants.userDefault.rateMe = true
                
                let iTunesLink: String = "itms://itunes.apple.com/us/app/apple-store/id375380948?mt=8"
                UIApplication.sharedApplication().openURL(NSURL(string: iTunesLink)!)
                
              self.cyclicViewController(false, originFrame: self.view.frame, oldViewController: self, toViewController: self.parentViewController!)
        })
    }
    
    @IBAction func remindMeLaterClicked(sender : AnyObject)
    {
        /*
        if self.remindMeLaterButton.frame == self.animationView.frame
        {
            Constants.userDefault.rateMe = false
            Constants.userDefault.noThanks = false
            
            self.cyclicViewController(false, originFrame: self.view.frame, oldViewController: self, toViewController: parentViewController!)
        }
        else
        {
            UIView.animateWithDuration(0.5, animations:
            {
                self.animationView.frame = self.remindMeLaterButton.frame
            }
            , completion:
            {
                (true) in
            })
        }
 */
        
        UIView.animateWithDuration(0.5, animations: {() -> Void in
            self.animationView.frame = self.remindMeLaterButton.frame
            }, completion: {(finished: Bool) -> Void in
                Constants.userDefault.rateMe = false
                Constants.userDefault.noThanks = false
                
                self.cyclicViewController(false, originFrame: self.view.frame, oldViewController: self, toViewController: self.parentViewController!)
        })
    }
    
    @IBAction func noThanksClicked(sender : AnyObject)
    {
        /*
        if self.noThanksButton.frame == self.animationView.frame
        {
            Constants.userDefault.noThanks = true
            
            self.cyclicViewController(false, originFrame: self.view.frame, oldViewController: self, toViewController: parentViewController!)
        }
        else
        {
            UIView.animateWithDuration(0.5, animations:
            {
                self.animationView.frame = self.noThanksButton.frame
            }
            , completion:
            {
                (true) in
            })
        }
        */
        UIView.animateWithDuration(0.5, animations: {() -> Void in
            self.animationView.frame = self.noThanksButton.frame
            }, completion: {(finished: Bool) -> Void in
                Constants.userDefault.noThanks = true
                
                self.cyclicViewController(false, originFrame: self.view.frame, oldViewController: self, toViewController: self.parentViewController!)
        })
    }
    
    @IBAction func cancelClicked(sender : AnyObject)
    {
        self.cyclicViewController(false, originFrame: self.view.frame, oldViewController: self, toViewController: parentViewController!)
    }
    
}