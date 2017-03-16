//
//  DeactivationMessageViewController.swift
//  Disctopia
//
//  Created by Dhaval on 10/08/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class DeactivationMessageViewController: BaseVC
{
    
    var counter : CGFloat = 0
    var timer = NSTimer()
    var trackArray:[JSON] = []
    var presenting  = false
    var originFrame = CGRect()
    
    let documentsUrl =  NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first! as NSURL
    
    
    // MARK: - Outlets

    @IBOutlet var lblComplete: UILabel!
    
    //@IBOutlet weak var topView: UIView!
    
    //@IBOutlet weak var bottomView: UIView!
    
    @IBOutlet var progressBar: YLProgressBar!

    
    // MARK: - Methods

    override func viewDidLoad()
    {
        self.dynamicFontNeeded = false
        super.viewDidLoad()
        self.initFlatRainbowProgressBar()
        //self.setProgressPerc(0.0)
        //GetPurchasedTrackByUserAPI()
        //self.downloadData()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(true)
        self.DLog("WillAppear SyncMusicVC")
        self.originFrame = self.view.frame
        //self.bottomView.alpha = 0
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(true)
        self.DLog("WillDisappear SyncMusicVC")
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(true)
        self.DLog("DidAppear SyncMusicVC")
        //self.bottomView.alpha = 1
        //self.bottomView.frame = CGRectMake(self.bottomView.frame.origin.x, self.view.frame.size.height, self.bottomView.frame.size.width, self.bottomView.frame.size.height)
        self.performSelector(#selector(animateBottomView), withObject: nil, afterDelay: 0.2)
    }
    
    override func viewDidDisappear(animated: Bool)
    {
        super.viewDidDisappear(true)
        self.DLog("DidDisappear SyncMusicVC")
    }
    
    
    // MARK: - Functions

    func animateBottomView()
    {
        self.DLog("animateBottomView SyncMusicVC called")
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations:
        {
            //self.bottomView.frame = CGRectMake(self.bottomView.frame.origin.x, self.topView.frame.size.height, self.bottomView.frame.size.width, self.bottomView.frame.size.height)
        }
        ,completion:
        {
            (true) in
            self.downloadData()
        })
    }
    
    func downloadData()
    {
        //start the timer
        timer = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    
    // MARK: - Functions/Progress View

    func setProgressPerc(per:CGFloat)
    {
        self.setProgress(per, animated: true)
    }
    
    func setProgress(progress: CGFloat, animated: Bool)
    {
        self.progressBar.setProgress(progress, animated: animated)
    }
    
    func initFlatRainbowProgressBar()
    {
        let tintColors: [AnyObject] = [UIColor(red: 107 / 255.0, green: 191 / 255.0, blue: 113 / 255.0, alpha: 1.0),
                                       UIColor(red: 161 / 255.0, green: 200 / 255.0, blue: 117 / 255.0, alpha: 1.0)]
        self.progressBar.type = .Flat
        self.progressBar.progressTintColors = tintColors
        self.progressBar.hideStripes = true
        self.progressBar.hideTrack = true
        self.progressBar.behavior = .Default
        self.progressBar.setProgress(0.0, animated: false)
    }
    
    func timerAction()
    {
        counter += 0.1
        self.setProgress(counter, animated: true)
        if counter >= 1 //CGFloat(self.trackArray.count)
        {
            timer.invalidate()
            self.loadNextView()
                    //self.openOnBoardingScreen()
        }
//        if (self.trackArray.count == 0)
//        {
//            counter = 1
//            self.setProgress(counter, animated: true)
//            loadNextView()
//            return
//        }
//        counter += 1 / CGFloat(self.trackArray.count ) //0.1//0.01
//        self.setProgress(counter, animated: true)
//        if counter >= 0.99 //CGFloat(self.trackArray.count)
//        {
//            timer.invalidate()
//            self.loadNextView()
//            //self.openOnBoardingScreen()
//        }
    }
    
    func loadNextView()
    {
        BaseVC.sharedInstance.logOut()
        UIView.animateWithDuration(0.8, delay: 0.0, options: .TransitionCrossDissolve, animations:
        {
            self.lblComplete.alpha = 1
        }
        , completion:
        {
            (true) in
            let onBoardingVC = self.storyboard!.instantiateViewControllerWithIdentifier("LoginVC") as! LoginVC
                onBoardingVC.view.translatesAutoresizingMaskIntoConstraints = false;
            self.addChildViewController(onBoardingVC)
            self.addSubview(onBoardingVC.view, toView: self.view)
            UIView.animateWithDuration(0.3, delay: 0.0, options: .TransitionCrossDissolve, animations:
            {
                //self.bottomView.alpha = 0
            }
            , completion:
            {
                (true) in
                onBoardingVC.didMoveToParentViewController(self)
                appDelegate.pagingMenuController = nil
                return
            })
            //self.cycleFromViewController(self, toViewController: onBoardingVC)
        })
    }
    
    func openOnBoardingScreen()
    {
        self.performSegueWithIdentifier("OnBoarding", sender: nil)
    }
    
    func cycleFromViewController(oldViewController: UIViewController, toViewController newViewController: UIViewController)
    {
        //oldViewController.willMoveToParentViewController(nil)
        self.addSubview(newViewController.view, toView: self.view)
        self.addChildViewController(newViewController)
        newViewController.view.alpha = 0
        oldViewController.view.alpha = 1
        newViewController.view.layoutIfNeeded()
        //let thisView = oldViewController.view
        //let toView = newViewController.view
        let herbView = oldViewController.view
        let initialFrame = self.presenting ? self.originFrame : herbView.frame
        var finalFrame = CGRectMake(0, 0, 0, 0)
        var myTimeInterval = NSTimeInterval()
        finalFrame  = self.presenting ? herbView.frame : self.originFrame//CGRectMake(288, 35, 126, 84)
        myTimeInterval = 0.0
        
        let xScaleFactor = self.presenting ?
            initialFrame.width / finalFrame.width :
            finalFrame.width / initialFrame.width
        
        let yScaleFactor = self.presenting ?
            initialFrame.height / finalFrame.height :
            finalFrame.height / initialFrame.height
        
        let scaleTransform = CGAffineTransformMakeScale(xScaleFactor, yScaleFactor)
        
        UIView.animateKeyframesWithDuration(0.5, delay: myTimeInterval, options: UIViewKeyframeAnimationOptions.CalculationModeCubic , animations:
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
            //self.view.removeFromSuperview()
            //self.removeFromParentViewController()
            newViewController.didMoveToParentViewController(self)
        })
    }
    
    
    // MARK: - API/GetPurchasedTrackByUserAPI

    func GetPurchasedTrackByUserAPI()
    {
        API.GetPurchasedTrackByUser(nil, aViewController: self)
        {
            (result: JSON) in
            if ( result != nil )
            {
                self.DLog("#### GetPurchasedTrackByUserAPI API Response: \(result)")
                self.trackArray = result.arrayValue
                if (self.trackArray.count == 0)
                {
                    self.setProgress(1.0, animated: true)
                    self.loadNextView()
                    return
                }
                else
                {
                    self.startDownloadingUrls()
                }
                self.DLog("trackArray = \(self.trackArray)")
            }
            else
            {
                self.setProgress(1.0, animated: true)
                self.loadNextView()
            }
        }
    }
    
    // create a loop to start downloading your urls
    func startDownloadingUrls()
    {
        for dictTrackDetails in self.trackArray
        {
            let trackId = dictTrackDetails["trackId"].stringValue
            let trackUrl = dictTrackDetails["track_url"].stringValue
            let destinationUrl = documentsUrl.URLByAppendingPathComponent("\(trackId).wav")
            
            DLog("destinationUrl \(destinationUrl)")
            if NSFileManager().fileExistsAtPath(destinationUrl.path!)
            {
                let writePath = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent(destinationUrl.lastPathComponent!)
                self.DLog("The file  already exists at path.")
                self.timerAction()
            }
            else
            {
                let writePath = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent(destinationUrl.lastPathComponent!)
                self.DLog("Started downloading \"\(writePath.absoluteString)\".")
                getAudioDataFromUrl(NSURL(string: trackUrl)!)
                {
                    data in
                    dispatch_async(dispatch_get_main_queue())
                    {
                        self.DLog("Finished downloading \"\(writePath.absoluteString)\".")
                        self.DLog("Started saving \"\(writePath.absoluteString)\".")
                        self.timerAction()
                        
                        if data != nil
                        {
                            if self.saveAudioData(data!, destination: self.documentsUrl.URLByAppendingPathComponent("\(trackId).wav") )
                            {
                                self.DLog("Success")
                            }
                            else
                            {
                                self.DLog("The File \"\(writePath.absoluteString)\" was not saved.")
                            }
                        }
                        else
                        {
                            self.DLog("Data is nil")
                        }
                    }
                }
            }
        }
    }
    
    // create a function to start the audio data download
    func getAudioDataFromUrl(audioUrl:NSURL, completion: ((data: NSData?) -> Void))
    {
        NSURLSession.sharedSession().dataTaskWithURL(audioUrl)
        {
            (data, response, error) in
            if error != nil
            {
                self.DLog((error?.localizedDescription)!)
            }
            completion(data:  data)
        }.resume()
    }
    
    // create another function to save the audio data
    func saveAudioData(audio:NSData, destination:NSURL) -> Bool
    {
        if audio.writeToURL(destination, atomically: true)
        {
            self.DLog("The file \"\(destination.lastPathComponent)\" was successfully saved.")
            return true
        }
        return false
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