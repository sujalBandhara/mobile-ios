//
//  ConfirmAddtoCartVC.swift
//  Disctopia
//
//  Created by Mitesh on 26/10/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//



import UIKit
import SwiftyJSON

class ConfirmAddtoCartVC: BaseVC
{
    
    // MARK: - Outlets
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var frameButton: UIButton!
    
    @IBOutlet weak var animationView: UIImageView!
    
    @IBOutlet weak var btnYes: UIButton!
    
    @IBOutlet weak var btnNo: UIButton!
    
    @IBOutlet weak var viewLogout: UIView!
    
    let duration    = 1.0
    
    var presenting  = true
    
    var isFromSearchBtn = Bool()
    
    var originFrame = CGRectMake(288, 35, 126, 84)
    
    var originFrame1 = CGRectMake(114, 196, 186, 70)
    
    var idTrackOrAlbum = ""
    
    var isFrom = 0 // 0-track 1-Album
    // MARK: - Methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        originFrame1 = CGRectMake(self.frameButton.frame.origin.x, self.frameButton.frame.origin.y, self.frameButton.frame.width, self.frameButton.frame.height)
        
        if isFrom == 0
        {
            self.lblMessage.text = "Add this track to cart?"
        }
        else
        {
            self.lblMessage.text = "Add this album to cart?"
        }
    }
    
    override func viewWillAppear(animated: Bool)
    {
        self.navigationController?.navigationBarHidden = true
        super.viewWillAppear(true)
        BaseVC.sharedInstance.DLog("WillAppear ConfirmShoppingViewController")
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(true)
        BaseVC.sharedInstance.DLog("WillDisappear ConfirmShoppingViewController")
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(true)
        BaseVC.sharedInstance.DLog("DidAppear ConfirmShoppingViewController")
    }
    
    override func viewDidDisappear(animated: Bool)
    {
        super.viewDidDisappear(true)
        BaseVC.sharedInstance.DLog("DidDisappear ConfirmShoppingViewController")
    }
    
    
    @IBAction func onYesClick(button: UIButton)
    {
        
        
        
        UIView.animateWithDuration(0.5, animations: {() -> Void in
            self.animationView.frame = CGRectMake(self.btnYes.frame.origin.x, self.btnYes.frame.origin.y, self.btnYes.frame.size.width, self.btnYes.frame.size.height)
            }, completion: {(finished: Bool) -> Void in
                
                

                if self.isFrom == 0
                {
                    self.AddTrackInCart(self.idTrackOrAlbum)
                }
                else
                {
                    self.addAlbumInCart(self.idTrackOrAlbum)
                }
                
        })
        
    }
    
    // MARK: - Addshoppingcart API
    func AddTrackInCart(trackId:String)
    {
        var param = Dictionary<String, String>()
        
        param["trackId"] = trackId
        DLog("track id = \(appDelegate.selectedTrackId)")
        //albumid
        API.AddShoppingCart(param, aViewController: self) { (result: JSON) in
            if ( result != nil )
            {
                BaseVC.sharedInstance.DLog("#### AddShoppingCart API Response: \(result)")
                
                //self.ViewshoppingcartData()
            }
            self.dismissViewControllerAnimated(true, completion:
                {
                BaseVC.sharedInstance.pushToViewControllerIfNotExistWithClassName("CartSummaryVC", animated: true)
            })
        }
        
    }
    // MARK: - Addshoppingcart API
    func addAlbumInCart(albumId:String)
    {
        var param = Dictionary<String, String>()
        
        param["albumid"] = albumId
        //print("\(self.albumId)")
        //albumid
        API.AddShoppingCart(param, aViewController: self) { (result: JSON) in
            if ( result != nil )
            {
                BaseVC.sharedInstance.DLog("#### AddShoppingCart API Response: \(result)")
                //self.ViewshoppingcartData()
            }
            self.dismissViewControllerAnimated(true, completion:
                {
                    BaseVC.sharedInstance.pushToViewControllerIfNotExistWithClassName("CartSummaryVC", animated: true)
            })
        }
        
    }
    func loadThankyouScreen()
    {
        self.view.removeFromSuperview()
        let vc : ThankYouPurchasingVC = STORY_BOARD_MAIN.instantiateViewControllerWithIdentifier("ThankYouPurchasingVC") as! ThankYouPurchasingVC
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.modalPresentationStyle = .OverCurrentContext
        navigationController.navigationBarHidden = true
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    
    @IBAction func onNoClick(sender: AnyObject)
    {
        
        
        UIView.animateWithDuration(0.5, animations: {() -> Void in
            self.animationView.frame = CGRectMake(self.btnNo.frame.origin.x, self.btnNo.frame.origin.y, self.btnNo.frame.size.width, self.btnNo.frame.size.height)
            }, completion: {(finished: Bool) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
                self.isFromSearchBtn = false
                self.presenting = false
                
                if self.parentViewController != nil
                {
                    self.cycleFromViewController(self, toViewController: self.parentViewController!)
                }
        })
        
    }
    
    // MARK: - Animation Function
    
    func cycleFromViewController(oldViewController: UIViewController, toViewController newViewController: UIViewController)
    {
        oldViewController.willMoveToParentViewController(nil)
        
        newViewController.view.alpha = 1
        oldViewController.view.alpha = 1
        newViewController.view.layoutIfNeeded()
        
        //let thisView = oldViewController.view
        //let toView = newViewController.view
        
        let herbView = oldViewController.view
        let initialFrame = self.presenting ? self.originFrame : herbView.frame
        
        var finalFrame = self.originFrame   //CGRectMake(139, 290, 80, 100)
        var myTimeInterval = NSTimeInterval()
        
        if !self.isFromSearchBtn
        {
            finalFrame  = self.presenting ? herbView.frame : self.originFrame1
            myTimeInterval = 0.3
        }
        else
        {
            finalFrame  = self.presenting ? herbView.frame : self.originFrame1
            myTimeInterval = 0.3
        }
        
        let xScaleFactor = self.presenting ?
            initialFrame.width / finalFrame.width :
            finalFrame.width / initialFrame.width
        
        let yScaleFactor = self.presenting ?
            initialFrame.height / finalFrame.height :
            finalFrame.height / initialFrame.height
        
        let scaleTransform = CGAffineTransformMakeScale(xScaleFactor, yScaleFactor)
        UIView.animateKeyframesWithDuration(0.3, delay: myTimeInterval, options: UIViewKeyframeAnimationOptions.CalculationModeCubic , animations:
            {
                newViewController.view.alpha = 1
                oldViewController.view.alpha = 1
                
                herbView.transform = self.presenting ?
                    CGAffineTransformIdentity : scaleTransform
                
                herbView.center = CGPoint(x: CGRectGetMidX(finalFrame), y: CGRectGetMidY(finalFrame))
                herbView.clipsToBounds = true
            },
                                            
                                            completion:
            {
                finished in
                //self.willMoveToParentViewController(nil)
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
                
                // self.pushToViewControllerIfNotExistWithClassName("ThankYouPurchasingVC", animated: true)
                
        })
    }
}
