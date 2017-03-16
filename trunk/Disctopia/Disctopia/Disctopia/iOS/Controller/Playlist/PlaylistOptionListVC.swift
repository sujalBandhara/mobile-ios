//
//  PlaylistOptionListVC.swift
//  Disctopia
//
//  Created by Damini on 12/07/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit
import SwiftyJSON

class PlaylistOptionListVC: BaseVC
{
    @IBOutlet var btnEditPlaylist: UIButton!
    @IBOutlet var btnDeletePlaylist: UIButton!
    @IBOutlet var btnSufflePlayON: UIButton!
    @IBOutlet var btnCancel: UIButton!
    
    @IBOutlet weak var animationView: UIView!
    /////////////////////
    let duration    = 1.0
    var presenting  = false
    var isFromCancel = true
    var isFromNo = false
    var originFrame = CGRect.zero
    var deleteFrame = CGRect.zero
    var deletePlaylistFrame = CGRect.zero
    /////////////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        BaseVC.sharedInstance.DLog("WillAppear PlaylistOptionListVC")
        
        self.navigationController?.navigationBarHidden = true
        btnCancel.layer.borderWidth = 1.0
        btnCancel.layer.borderColor = UIColor(white: 1.0, alpha: 1).CGColor
        
        self.originFrame = appDelegate.playlistFrame
        self.deleteFrame = self.view.frame
       
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PlaylistOptionListVC.removePlaylistSettingMenu), name:"removePlaylistSettingMenu", object: nil)

        
        if (appDelegate.selectedPlaylistId["playlistId"]!.stringValue.characters.count > 0)
        {
            let playlistId = appDelegate.selectedPlaylistId["playlistId"]!.stringValue
            if appDelegate.shufflePlaylistArray.contains(playlistId)
            {
                btnSufflePlayON.setTitle("shuffle play Off", forState: .Normal)
            }
            else
            {
                //appDelegate.playerView.isShuffle = true
                btnSufflePlayON.setTitle("shuffle play On", forState: .Normal)
            }
        }
        
        /*
         * Created Date: 16 Jan 2017 s
         * Updated Date:
         * Ticket No: PMT Task 11061 Edit Playlist: editing name of playlist
         * Description : There edit dots for edit playlist is now missing (bug)
         You should be able to edit, but not delete, as you may want to reorder the tracks...
         
         * Logic:
         */
        if (appDelegate.selectedPlaylistId["playlistname"]!.stringValue == "Disctopia Favs") //"Favourite"
        {
            btnEditPlaylist.hidden = true
            
            self.animationView.frame = CGRectMake(self.btnDeletePlaylist.frame.origin.x, self.btnDeletePlaylist.frame.origin.y, self.btnDeletePlaylist.frame.size.width, self.btnDeletePlaylist.frame.size.height)
            btnDeletePlaylist.setTitle("edit playlist", forState: UIControlState.Normal)
            btnDeletePlaylist.addTarget(self, action: #selector(btnEditPlaylistTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        }
        else
        {
            btnEditPlaylist.addTarget(self, action: #selector(btnEditPlaylistTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            btnDeletePlaylist.addTarget(self, action: #selector(btnDeletePlaylistTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)

        }

    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        NSNotificationCenter.defaultCenter().removeObserver(self)

        BaseVC.sharedInstance.DLog("WillDisappear PlaylistOptionListVC")
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        BaseVC.sharedInstance.DLog("DidAppear PlaylistOptionListVC")
        
        /*
         * Created Date: 16 Jan 2017 s
         * Updated Date:
         * Ticket No: PMT Task 11061 Edit Playlist: editing name of playlist
         * Description : There edit dots for edit playlist is now missing (bug)
         You should be able to edit, but not delete, as you may want to reorder the tracks...
         
         * Logic:
         */

        if (appDelegate.selectedPlaylistId["playlistname"]!.stringValue == "Disctopia Favs") //"Favourite"
        {
            self.animationView.frame = CGRectMake(self.btnDeletePlaylist.frame.origin.x, self.btnDeletePlaylist.frame.origin.y, self.btnDeletePlaylist.frame.size.width, self.btnDeletePlaylist.frame.size.height)
        }

        if self.isFromNo
        {
            self.animationView.frame = self.deletePlaylistFrame
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        BaseVC.sharedInstance.DLog("DidDisappear PlaylistOptionListVC")
    }
    
    class func instantiateFromStoryboard() -> SettingsMenuVC {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier(String(self)) as! SettingsMenuVC
    }
    
    func removePlaylistSettingMenu(notification: NSNotification)
    {
        if self.parentViewController != nil
        {
            self.cycleFromViewController(self, toViewController: self.parentViewController!)
        }
        //self.view.removeFromSuperview()
        //self.removeFromParentViewController()
        //        self.willMoveToParentViewController(nil)
        //        self.view.removeFromSuperview()
        //        self.removeFromParentViewController()
    }
    // MARK: - Action -
    
    @IBAction func btnEditPlaylistTapped(sender: AnyObject)
    {
        /*
        if self.btnEditPlaylist.frame.origin.y == self.animationView.frame.origin.y
        {
            BaseVC.sharedInstance.pushToViewControllerIfNotExistWithClassName("AddNewPlaylistVC", animated: true)
        }
        else
        {
            UIView.animateWithDuration(0.5)
            {
                self.animationView.frame = CGRectMake(self.btnEditPlaylist.frame.origin.x, self.btnEditPlaylist.frame.origin.y, self.btnEditPlaylist.frame.size.width, self.btnEditPlaylist.frame.size.height)
            }
        }
        */
        
        if self.parentViewController != nil
        {
            self.cycleFromViewController(self, toViewController: self.parentViewController!)
        }
        
        UIView.animateWithDuration(0.5, animations: {() -> Void in
            self.animationView.frame = CGRectMake(self.btnEditPlaylist.frame.origin.x, self.btnEditPlaylist.frame.origin.y, self.btnEditPlaylist.frame.size.width, self.btnEditPlaylist.frame.size.height)
            }, completion: {(finished: Bool) -> Void in
               // NSNotificationCenter.defaultCenter().postNotificationName("removePlaylistSettingMenu", object: nil)
                let vc = STORY_BOARD_MAIN.instantiateViewControllerWithIdentifier("AddNewPlaylistVC") as! AddNewPlaylistVC
                vc.newPlayListId = appDelegate.selectedPlaylistId["playlistId"]!.stringValue
                vc.newPlayListName = appDelegate.selectedPlaylistId["playlistname"]!.stringValue
                self.pushToViewControllerIfNotExistWithClassObj(vc, animated: true)
        })
        
        
    }
    
    @IBAction func btnDeletePlaylistTapped(sender: AnyObject)
    {
        //        if self.btnDeletePlaylist.frame.origin.y == self.animationView.frame.origin.y
        //        {
        //            self.isFromCancel = false
        //
        //            //self.DeletePlayListAPI()
        //            NSNotificationCenter.defaultCenter().postNotificationName("deletePlaylistClicked", object: self.btnDeletePlaylist)
        //
        //            self.presenting = false
        //            if self.parentViewController != nil
        //            {
        //                self.cycleFromViewController(self, toViewController: self.parentViewController!)
        //            }
        //
        //            return
        //        }
        //        else
        //        {
     /*   UIView.animateWithDuration(0.5)
        {
            self.animationView.frame = CGRectMake(self.btnDeletePlaylist.frame.origin.x, self.btnDeletePlaylist.frame.origin.y, self.btnDeletePlaylist.frame.size.width, self.btnDeletePlaylist.frame.size.height)
        }
        
        
        
        
        self.isFromCancel = false
        
        //self.DeletePlayListAPI()
        NSNotificationCenter.defaultCenter().postNotificationName("deletePlaylistClicked", object: self.btnDeletePlaylist)
        
        self.presenting = false
        if self.parentViewController != nil
        {
            self.cycleFromViewController(self, toViewController: self.parentViewController!)
        }
        
        return
        //        }
        */
        
        UIView.animateWithDuration(0.5, animations: {() -> Void in
            self.animationView.frame = CGRectMake(self.btnDeletePlaylist.frame.origin.x, self.btnDeletePlaylist.frame.origin.y, self.btnDeletePlaylist.frame.size.width, self.btnDeletePlaylist.frame.size.height)
            }, completion: {(finished: Bool) -> Void in
                self.isFromCancel = false
                //self.DeletePlayListAPI()
                //NSNotificationCenter.defaultCenter().postNotificationName("removePlaylistSettingMenu", object: nil)
                NSNotificationCenter.defaultCenter().postNotificationName("deletePlaylistClicked", object: self.btnDeletePlaylist)
                
                self.presenting = false
                if self.parentViewController != nil
                {
                    self.cycleFromViewController(self, toViewController: self.parentViewController!)
                }
                
            return
        })
    }
    
    
    
    @IBAction func btnShuffleTapped(sender: AnyObject)
    {
        //        if self.btnSufflePlayON.frame.origin.y == self.animationView.frame.origin.y
        //        {
        //            if (appDelegate.selectedPlaylistId["playlistId"]!.stringValue.characters.count > 0)
        //            {
        //                let playlistId = appDelegate.selectedPlaylistId["playlistId"]!.stringValue
        //                if appDelegate.shufflePlaylistArray.contains(playlistId)
        //                {
        //                    appDelegate.shufflePlaylistArray.removeAtIndex(appDelegate.shufflePlaylistArray.indexOf(playlistId)!)
        //                }
        //                else
        //                {
        //                    appDelegate.shufflePlaylistArray.append(playlistId)
        //                }
        //            }
        //
        //            if self.parentViewController != nil
        //            {
        //                self.cycleFromViewController(self, toViewController: self.parentViewController!)
        //            }
        //            self.dismissViewControllerAnimated(true, completion: nil)
        //            //appDelegate.playerView.btnshuffle.setImage(UIImage.init(named: "green_crossfade"), forState: .Normal)
        //            //return
        //        }
        //        else
        //        {
        UIView.animateWithDuration(0.5)
        {
            self.animationView.frame = CGRectMake(self.btnSufflePlayON.frame.origin.x, self.btnSufflePlayON.frame.origin.y, self.btnSufflePlayON.frame.size.width, self.btnSufflePlayON.frame.size.height)
        }
         //NSNotificationCenter.defaultCenter().postNotificationName("removePlaylistSettingMenu", object: nil)
        appDelegate.isSelectFromPlaylist = true
        if (appDelegate.selectedPlaylistId["playlistId"]!.stringValue.characters.count > 0)
        {
            let playlistId = appDelegate.selectedPlaylistId["playlistId"]!.stringValue
            if appDelegate.shufflePlaylistArray.contains(playlistId)
            {
                 appDelegate.playerView.isShuffle = false
                print("\(appDelegate.playerView.isShuffle)")
                appDelegate.shufflePlaylistArray.removeAtIndex(appDelegate.shufflePlaylistArray.indexOf(playlistId)!)
            }
            else
            {
                if appDelegate.playerView != nil
                {
                      print("\(appDelegate.playerView.isShuffle)")
                    appDelegate.playerView.isShuffle = true
                    appDelegate.shufflePlaylistArray.append(playlistId)
                }
            }
        }
        
        if self.parentViewController != nil
        {
            self.cycleFromViewController(self, toViewController: self.parentViewController!)
        }
        self.dismissViewControllerAnimated(true, completion: nil)
        //        }
        
    }
    
    @IBAction func btnCancelTapped(sender: AnyObject)
    {
        DLog("Cancel button tapped")
        
        self.isFromCancel = true
        self.presenting = false
        
        if self.parentViewController != nil
        {
            self.cycleFromViewController(self, toViewController: self.parentViewController!)
        }
        
        //self.dismissViewControllerAnimated(true, completion: nil)
        self.dismissViewControllerAnimated(true, completion: nil)
        
        //                let presentingViewController: UIViewController! = self.presentingViewController
        //                self.dismissViewControllerAnimated(false)
        //                {
        //                    presentingViewController.dismissViewControllerAnimated(false, completion: nil)
        //                }
        
    }
    
    // MARK: - Animation -
    
    func cycleFromViewController(oldViewController: UIViewController, toViewController newViewController: UIViewController) {
        oldViewController.willMoveToParentViewController(nil)
        newViewController.view.alpha = 1
        oldViewController.view.alpha = 1
        newViewController.view.layoutIfNeeded()
        
        //let thisView = oldViewController.view
        //let toView = newViewController.view
        
        let herbView = oldViewController.view
        
        var initialFrame = CGRectMake(0, 0, 0, 0)
        
        var finalFrame = CGRectMake(0, 0, 0, 0)
        
        var myTimeInterval = NSTimeInterval()
        
        if self.isFromCancel
        {
            initialFrame = self.presenting ? self.originFrame : herbView.frame
            
            finalFrame = self.presenting ? herbView.frame : self.originFrame
        }
        else
        {
            initialFrame = self.presenting ? self.deleteFrame : herbView.frame
            
            finalFrame = self.presenting ? herbView.frame : self.deleteFrame
        }
        
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
            oldViewController.view.alpha = 1
            
            herbView.transform = self.presenting ?
                CGAffineTransformIdentity : scaleTransform
            
            herbView.center = CGPoint(x: CGRectGetMidX(finalFrame), y: CGRectGetMidY(finalFrame))
            herbView.clipsToBounds = true
            
            },
                                            completion: { finished in
                                                
                                                //self.willMoveToParentViewController(nil)
                                                self.view.removeFromSuperview()
                                                self.removeFromParentViewController()
        })
    }
    
    func cycleFromViewController1(oldViewController: UIViewController, toViewController newViewController: UIViewController) {
        newViewController.view.alpha = 1
        oldViewController.view.alpha = 0
        newViewController.view.layoutIfNeeded()
        
        let herbView = oldViewController.view
        
        let initialFrame = self.presenting ? self.originFrame : herbView.frame
        let finalFrame = self.presenting ? herbView.frame : self.originFrame//CGRectMake(288, 35, 126, 84)
        
        let xScaleFactor = self.presenting ?
            initialFrame.width / finalFrame.width :
            finalFrame.width / initialFrame.width
        
        let yScaleFactor = self.presenting ?
            initialFrame.height / finalFrame.height :
            finalFrame.height / initialFrame.height
        
        let scaleTransform = CGAffineTransformMakeScale(xScaleFactor, yScaleFactor)
        
        UIView.animateKeyframesWithDuration(0.1, delay: 0.0, options: UIViewKeyframeAnimationOptions.CalculationModeCubic , animations: {
            newViewController.view.alpha = 1
            oldViewController.view.alpha = 1
            
            herbView.transform = self.presenting ?
                CGAffineTransformIdentity : scaleTransform
            
            herbView.center = CGPoint(x: CGRectGetMidX(finalFrame), y: CGRectGetMidY(finalFrame))
            herbView.clipsToBounds = true
            
            },
                                            
                                            completion: { finished in
                                                
                                                self.willMoveToParentViewController(nil)
                                                self.view.removeFromSuperview()
                                                self.removeFromParentViewController()
        })
    }
}
