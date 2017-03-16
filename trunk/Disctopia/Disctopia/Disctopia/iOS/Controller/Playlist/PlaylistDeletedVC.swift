//
//  PlaylistDeletedVC.swift
//  Disctopia
//
//  Created by Damini on 25/07/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit

class PlaylistDeletedVC: BaseVC
{

    var presenting  = false
    var originFrame = CGRect()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(true)
        BaseVC.sharedInstance.DLog("WillAppear PlaylistDeletedVC")
        
        self.originFrame = self.view.frame
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(true)
        BaseVC.sharedInstance.DLog("WillDisappear PlaylistDeletedVC")
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(true)
        BaseVC.sharedInstance.DLog("DidAppear PlaylistDeletedVC")
        
        self.performSelector(#selector(moveToParent), withObject: nil, afterDelay: 2.0)
    }
    
    override func viewDidDisappear(animated: Bool)
    {
        super.viewDidDisappear(true)
        BaseVC.sharedInstance.DLog("DidDisappear PlaylistDeletedVC")
    }

    @IBAction func btnPlaylistDeleted(sender: AnyObject)
    {
        //self.pushToViewControllerIfNotExistWithClassName("PlaylistVC", animated: true)
    }

    func moveToParent()
    {
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
        //parentViewController!.view.removeFromSuperview()
        //parentViewController!.removeFromParentViewController()
        self.popToRootViewController()
        appDelegate.pagingMenuController.moveToMenuPage(1, animated: true)
       
        //self.cycleFromViewController(self, toViewController: parentViewController!)
    }
    
    // MARK: - Animation -
    
    func cycleFromViewController(oldViewController: UIViewController, toViewController newViewController: UIViewController) {
        oldViewController.willMoveToParentViewController(nil)
        newViewController.view.alpha = 1
        newViewController.view.layoutIfNeeded()
        
        //let thisView = oldViewController.view
        let toView = newViewController.view
        
        let herbView = newViewController.view
        
        let initialFrame = self.presenting ? self.originFrame : herbView.frame
        let finalFrame = self.presenting ? herbView.frame : self.originFrame
        
        let xScaleFactor = self.presenting ?
            initialFrame.width / finalFrame.width :
            finalFrame.width / initialFrame.width
        
        let yScaleFactor = self.presenting ?
            initialFrame.height / finalFrame.height :
            finalFrame.height / initialFrame.height
        
        let scaleTransform = CGAffineTransformMakeScale(xScaleFactor, yScaleFactor)
        
        if self.presenting {
            herbView.transform = scaleTransform
            herbView.center = CGPoint(
                x: CGRectGetMidX(initialFrame),
                y: CGRectGetMidY(initialFrame))
            herbView.clipsToBounds = true
            
            self.view.addSubview(toView)
            self.view.bringSubviewToFront(herbView)
        }
        
        
        UIView.animateKeyframesWithDuration(0.5, delay: 0.0, options: UIViewKeyframeAnimationOptions.CalculationModeCubic , animations: {
            newViewController.view.alpha = 1
            oldViewController.view.alpha = 0
            
            herbView.transform = self.presenting ?
                CGAffineTransformIdentity : scaleTransform
            
            herbView.center = CGPoint(x: CGRectGetMidX(finalFrame),
                y: CGRectGetMidY(finalFrame))
            
            },
                                            completion: { finished in

                                            self.view.removeFromSuperview()
                                                self.removeFromParentViewController()
        })
    }
}
