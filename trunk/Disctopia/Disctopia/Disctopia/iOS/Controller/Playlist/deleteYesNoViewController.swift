//
//  deleteYesNoViewController.swift
//  
//
//  Created by Dhaval on 30/07/16.
//
//


import UIKit
import SwiftyJSON

class deleteYesNoViewController: BaseVC
{
    
    @IBOutlet weak var frameButton: UIButton!
    
    @IBOutlet weak var animationView: UIImageView!
    
    @IBOutlet weak var btnYes: UIButton!
    
    @IBOutlet weak var btnNo: UIButton!
    
    @IBOutlet weak var viewLogout: UIView!
    
    @IBOutlet weak var btnCancel: UIButton!
    
    let duration    = 1.0
    
    var presenting  = false
    
    var originFrame = CGRect.zero

    //var originFrame1 = CGRectMake(114, 196, 186, 70)
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        self.navigationController?.navigationBarHidden = true
        
        // Pratik
        super.viewWillAppear(true)
        BaseVC.sharedInstance.DLog("WillAppear deleteYesNoViewController")
        self.originFrame = self.view.frame
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        BaseVC.sharedInstance.DLog("WillDisappear deleteYesNoViewController")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        BaseVC.sharedInstance.DLog("DidAppear deleteYesNoViewController")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        BaseVC.sharedInstance.DLog("DidDisappear deleteYesNoViewController")
    }
    
    // MARK: - Action
    
    @IBAction func onYesClick(button: UIButton)
    {
        /*
        if self.btnYes.frame.origin.y == self.animationView.frame.origin.y
        {
            NSNotificationCenter.defaultCenter().postNotificationName("deletePlayistOptionYesClicked\(appDelegate.selectedPlaylistId["playlistId"]!.stringValue)", object: nil)
            self.DeletePlayListAPI()
            
            
        }
        else
        {
            UIView.animateWithDuration(0.5)
            {
                self.animationView.frame = CGRectMake(self.btnYes.frame.origin.x, self.btnYes.frame.origin.y, self.btnYes.frame.size.width, self.btnYes.frame.size.height)
            }
        }
 */
        
        UIView.animateWithDuration(0.5, animations: {() -> Void in
           self.animationView.frame = CGRectMake(self.btnYes.frame.origin.x, self.btnYes.frame.origin.y, self.btnYes.frame.size.width, self.btnYes.frame.size.height)
            }, completion: {(finished: Bool) -> Void in
                NSNotificationCenter.defaultCenter().postNotificationName("deletePlayistOptionYesClicked", object: nil)
                self.DeletePlayListAPI()
        })

        
    }
    @IBAction func onNoClick(sender: AnyObject)
    {
        /*
        if self.btnNo.frame.origin.y == self.animationView.frame.origin.y
        {
           NSNotificationCenter.defaultCenter().postNotificationName("deletePlayistOptionNoClicked\(appDelegate.selectedPlaylistId["playlistId"]!.stringValue)", object: nil)
            
            self.presenting = false
            if self.parentViewController != nil
            {
                self.cycleFromViewController(self, toViewController: self.parentViewController!)
            }
            
        }
        else
        {
            UIView.animateWithDuration(0.5)
            {
                self.animationView.frame = CGRectMake(self.btnNo.frame.origin.x, self.btnNo.frame.origin.y, self.btnNo.frame.size.width, self.btnNo.frame.size.height)
            }
        }
        */
        UIView.animateWithDuration(0.5, animations: {() -> Void in
            self.animationView.frame = CGRectMake(self.btnNo.frame.origin.x, self.btnNo.frame.origin.y, self.btnNo.frame.size.width, self.btnNo.frame.size.height)
            }, completion: {(finished: Bool) -> Void in
                self.presenting = false
                if self.parentViewController?.parentViewController != nil
                {
                    self.willMoveToParentViewController(nil)
                    self.view.removeFromSuperview()
                    self.removeFromParentViewController()
                }

                // NSNotificationCenter.defaultCenter().postNotificationName("deletePlayistOptionNoClicked)", object: nil)
                //NSNotificationCenter.defaultCenter().postNotificationName("deletePlayistOptionNoClicked\(appDelegate.selectedPlaylistId["playlistId"]!.stringValue)", object: nil)
                
                        })
        
    }
    //MARK: - DeletePlayListAPI -
    func DeletePlayListAPI()
    {
        var param = Dictionary<String, String>()
        
        if let id = appDelegate.selectedPlaylistId["playlistId"]
        {
            if (appDelegate.selectedPlaylistId["playlistId"]!.stringValue.characters.count > 0)
            {
                param["PlayListId"] =  appDelegate.selectedPlaylistId["playlistId"]!.stringValue
                
                API.DeletePlayList(param , aViewController: self) { (result: JSON) in
                    if ( result != nil )
                    {
                        BaseVC.sharedInstance.DLog("#### DeletePlayList API Response: \(result)")
                        
                        //BaseVC.sharedInstance.pushToViewControllerIfNotExistWithClassName("PlaylistDeletedVC", animated: true)
                        if self.parentViewController != nil
                        {
                            dispatch_async(dispatch_get_main_queue()) {
                                self.presenting = false
                                if self.parentViewController != nil
                                {
                                    appDelegate.newPlaylistId = "0"
                                    
                                    self.cycleFromViewController(self, toViewController: self.parentViewController!)
                                }
                            }
                        }
                        // BaseVC.sharedInstance.pushToViewControllerIfNotExistWithClassName("PlaylistVC", animated: true)
                        //self.removeFromParentViewController()
                        //self.popToSelf(self)
                        //self.dismissViewAnimated(true)
                        //appDelegate.pagingMenuController.moveToMenuPage(1, animated: true)
                    }
                }
            }
        }
    }

    
    // MARK: - Animation
    
    func cycleFromViewController(oldViewController: UIViewController, toViewController newViewController: UIViewController) {
        oldViewController.willMoveToParentViewController(nil)
        newViewController.view.alpha = 1
        oldViewController.view.alpha = 0
        newViewController.view.layoutIfNeeded()
        
        //let thisView = oldViewController.view
        //let toView = newViewController.view
        
        let herbView = oldViewController.view
        
        let initialFrame = self.presenting ? self.originFrame : herbView.frame
        
        let finalFrame = self.presenting ? herbView.frame : self.originFrame
        
        var myTimeInterval = NSTimeInterval()

        myTimeInterval = 0.0
       
        let xScaleFactor = self.presenting ?
            initialFrame.width / finalFrame.width :
            finalFrame.width / initialFrame.width
        
        let yScaleFactor = self.presenting ?
            initialFrame.height / finalFrame.height :
            finalFrame.height / initialFrame.height
        
        let scaleTransform = CGAffineTransformMakeScale(xScaleFactor, yScaleFactor)
        
        UIView.animateKeyframesWithDuration(0.3, delay: myTimeInterval, options: UIViewKeyframeAnimationOptions.CalculationModeCubic , animations: {
            newViewController.view.alpha = 1
            oldViewController.view.alpha = 0
            
            herbView.transform = self.presenting ?
                CGAffineTransformIdentity : scaleTransform
            
            herbView.center = CGPoint(x: CGRectGetMidX(finalFrame), y: CGRectGetMidY(finalFrame))
            herbView.clipsToBounds = true
            
            },   completion: { finished in
                                                
                                                //self.willMoveToParentViewController(nil)
                                                
                                                //self.view.removeFromSuperview()
                                                //self.removeFromParentViewController()
                                                //self.popToSelf(self)
                                                self.popToRootViewController()
                                                appDelegate.pagingMenuController.moveToMenuPage(1, animated: true)
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.DLog("Playlist deleted .....")
                    appDelegate.playlistVC.reloadPlaylist()
                    //NSNotificationCenter.defaultCenter().postNotificationName("reloadPlaylist", object: nil)
                }
        })
    }
        
}