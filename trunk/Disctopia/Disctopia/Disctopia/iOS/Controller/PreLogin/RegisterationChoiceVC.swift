//
//  RegisterationChoiceVC.swift
//  Disctopia
//
//  Created by abc on 6/21/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit

class RegisterationChoiceVC: BaseVC
{

    /**************ParthStart************/
    let duration    = 1.0
    var presenting  = false
    var originFrame = CGRect()
    var newFrame = CGRect()
    var newFrame1 = CGRect()
    var oldFrame = CGRect()
    
    var leftnewFrame = CGRect()
    var leftoldFrame = CGRect()
    var rightnewFrame = CGRect()
    var rightoldFrame = CGRect()
    var newFanFrame = CGRect()
    var oldFanFrame = CGRect()
    var newFreeFrame = CGRect()
    var oldFreeFrame = CGRect()
    
    ///////
    var newArtistFrame = CGRect()
    var oldArtistFrame = CGRect()
    var newDollarFrame = CGRect()
    var oldDollarFrame = CGRect()
    /////
    var newDescriptionFrame = CGRect()
    var oldDescriptionFrame = CGRect()
    var newartistFrame = CGRect()
    var oldartistFrame = CGRect()
    /////
    
    @IBOutlet weak var chooseScrImgVC: UIImageView!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblFan: UILabel!
    @IBOutlet weak var lblFree: UILabel!
    @IBOutlet weak var lblChoose: UILabel!
    @IBOutlet weak var lblArtist: UILabel!
    @IBOutlet weak var lblDollar: UILabel!
    
    @IBOutlet weak var fanDescriptionView: UIView!
    @IBOutlet weak var artistDescriptionView: UIView!

    
    @IBOutlet weak var artistButton: UIButton!

    var lblString : NSString = ""
    
    //////////
    @IBOutlet weak var chooseScrImgVC1: UIImageView!
    @IBOutlet weak var leftView1: UIView!
    @IBOutlet weak var rightView1: UIView!
    /**************ParthEnd************/
    
    
    @IBOutlet var btnFAN: UIButton!
    @IBOutlet var btnArtist: UIButton!
    
    
    override func viewDidLoad() {
        self.dynamicFontNeeded = false
        super.viewDidLoad()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        BaseVC.sharedInstance.DLog("WillAppear ChooseSubscriptionViewController")
        
        self.chooseScrImgVC.layoutIfNeeded()
        self.chooseScrImgVC1.layoutIfNeeded()
        self.leftView.layoutIfNeeded()
        self.rightView.layoutIfNeeded()
        
        self.originFrame = CGRectMake(self.view.frame.origin.x, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RegisterationChoiceVC.trackViewFrame3(_:)), name:"trackViewFrame3", object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        BaseVC.sharedInstance.DLog("WillDisappear ChooseSubscriptionViewController")
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(true)
        BaseVC.sharedInstance.DLog("DidAppear ChooseSubscriptionViewController")
        
        self.oldFrame = self.chooseScrImgVC1.frame
        
        newFrame = CGRectMake(self.chooseScrImgVC.frame.origin.x, -self.view.frame.size.height, self.chooseScrImgVC.frame.size.width, self.chooseScrImgVC.frame.size.height)
        
        newFrame1 = CGRectMake(self.chooseScrImgVC.frame.origin.x, self.lblChoose.frame.origin.y, self.chooseScrImgVC.frame.size.width, self.chooseScrImgVC.frame.size.height)
        
        self.chooseScrImgVC.frame = newFrame
        
        //////////////////
        self.leftoldFrame = self.leftView1.frame
        
        self.leftnewFrame = CGRectMake(self.leftView.frame.origin.x, self.lblFan.frame.origin.y, self.leftView.frame.size.width, self.leftView.frame.size.height)
        
        self.rightoldFrame = self.rightView1.frame
        
        self.rightnewFrame = CGRectMake(self.rightView.frame.origin.x, self.lblFan.frame.origin.y, self.rightView.frame.size.width, self.rightView.frame.size.height)
        
        self.oldFanFrame = self.lblFan.frame
        
        self.newFanFrame = CGRectMake(self.lblFan.frame.origin.x, self.lblChoose.frame.origin.y , self.lblFan.frame.size.width, self.lblFan.frame.size.height)
        
        self.oldFreeFrame = self.lblFree.frame
        
        self.newFreeFrame = CGRectMake(self.lblFree.frame.origin.x, self.lblFan.frame.origin.y, self.lblFree.frame.size.width, self.lblFree.frame.size.height)
        
        self.oldArtistFrame = self.lblArtist.frame
        
        self.newArtistFrame = CGRectMake(self.lblArtist.frame.origin.x, self.lblFan.frame.origin.y , self.lblArtist.frame.size.width, self.lblArtist.frame.size.height)//self.chooseScrImgVC.frame.origin.y
        
        self.oldDollarFrame = self.lblDollar.frame
        
        self.newDollarFrame = CGRectMake(self.lblDollar.frame.origin.x, self.lblFan.frame.origin.y, self.lblDollar.frame.size.width, self.lblDollar.frame.size.height)//self.chooseScrImgVC.frame.origin.y
        
        self.oldDescriptionFrame = self.fanDescriptionView.frame
        
        self.newDescriptionFrame = CGRectMake(self.fanDescriptionView.frame.origin.x, 200, self.fanDescriptionView.frame.size.width, self.fanDescriptionView.frame.size.height)//self.chooseScrImgVC.frame.origin.y
        
        self.oldartistFrame = self.artistDescriptionView.frame
        
        self.newartistFrame = CGRectMake(self.artistDescriptionView.frame.origin.x, 200, self.artistDescriptionView.frame.size.width, self.artistDescriptionView.frame.size.height)
        
        self.performSelector(#selector(trackViewFrame), withObject: self.chooseScrImgVC, afterDelay: 0.0)
    }
    
    override func viewDidDisappear(animated: Bool)
    {
        super.viewDidDisappear(true)
        BaseVC.sharedInstance.DLog("DidDisappear ChooseSubscriptionViewController")
        
        NSNotificationCenter.defaultCenter().postNotificationName("NotificationIdentifier111", object: nil)
    }
    
    func trackViewFrame(view:UIView )
    {
        UIView.animateWithDuration(0.5, animations: {
            view.frame = self.oldFrame
            view.hidden = false
            view.alpha = 1
            },completion:  { (true) in
                //self.imgView.image = UIImage(named: "artist_logo.png")
                //view.alpha = 0
        })
    }
    
    func trackViewFrame1()
    {
        /*self.chooseScrImgVC.frame = CGRectMake(self.chooseScrImgVC.frame.origin.x, self.chooseScrImgVC1.frame.origin.y, self.chooseScrImgVC.frame.size.width, self.chooseScrImgVC.frame.size.height)//self.oldFrame
         self.leftView.frame = CGRectMake(self.leftView.frame.origin.x, self.leftView1.frame.origin.y, self.leftView.frame.size.width, self.leftView.frame.size.height)//self.leftoldFrame
         self.rightView.frame = CGRectMake(self.rightView.frame.origin.x, self.rightView1.frame.origin.y, self.rightView.frame.size.width, self.rightView.frame.size.height)//self.rightoldFrame*/
        
        if lblString == "Fan"
        {
            UIView.animateWithDuration(0.8, animations: {
                
                self.chooseScrImgVC.frame = self.newFrame1
                self.chooseScrImgVC.alpha = 1
                
                self.leftView.frame = self.leftnewFrame
                self.leftView.alpha = 1
                
                self.rightView.frame = self.rightnewFrame
                self.rightView.alpha = 1
                
                self.lblFan.frame = self.newFanFrame
                self.lblFan.alpha = 1
                
                self.lblFree.frame = self.newFreeFrame
                self.lblFree.alpha = 1
                
                self.fanDescriptionView.frame = self.newDescriptionFrame
                self.fanDescriptionView.alpha = 1
                },completion:  { (true) in
                    //self.imgView.image = UIImage(named: "artist_logo.png")
                    //view.alpha = 0
            })
        }
        else
        {
            UIView.animateWithDuration(0.8, animations: {
                
                self.chooseScrImgVC.frame = self.newFrame1
                self.chooseScrImgVC.alpha = 1
                
                self.leftView.frame = self.leftnewFrame
                self.leftView.alpha = 1
                
                self.rightView.frame = self.rightnewFrame
                self.rightView.alpha = 1
                
                self.lblArtist.frame = self.newArtistFrame
                self.lblArtist.alpha = 1
                
                self.lblDollar.frame = self.newDollarFrame
                self.lblDollar.alpha = 1
                
                self.artistDescriptionView.frame = self.newartistFrame
                self.artistDescriptionView.alpha = 1
                
                },completion:  { (true) in
                    //self.imgView.image = UIImage(named: "artist_logo.png")
                    //view.alpha = 0
            })
        }
        
    }
    
    func trackViewFrame3(notification: NSNotification)
    {
        if lblString == "Fan"
        {
            
            UIView.animateWithDuration(0.5, animations: {
                self.chooseScrImgVC.frame = self.oldFrame
                self.chooseScrImgVC.alpha = 1
                
                self.leftView.frame = self.leftoldFrame
                self.leftView.alpha = 1
                
                self.rightView.frame = self.rightoldFrame
                self.rightView.alpha = 1
                
                
                
                self.lblFan.frame = self.oldFanFrame
                self.lblFan.alpha = 1
                
                self.lblFree.frame = self.oldFreeFrame
                self.lblFree.alpha = 1
                
                self.fanDescriptionView.frame = self.oldDescriptionFrame
                self.fanDescriptionView.alpha = 1
                },completion:  { (true) in
                    //self.imgView.image = UIImage(named: "artist_logo.png")
                    //view.alpha = 0
                    
            })
        }
        else
        {
            self.chooseScrImgVC.frame = self.newFrame1
            self.leftView.frame = self.leftnewFrame
            self.rightView.frame = self.rightnewFrame
            
            UIView.animateWithDuration(0.5, animations: {
                self.artistDescriptionView.frame = self.oldartistFrame
                self.artistDescriptionView.alpha = 1

                
                },completion:  { (true) in
                    //self.imgView.image = UIImage(named: "artist_logo.png")
                    //view.alpha = 0
                    
            })

            UIView.animateWithDuration(0.8, animations: {
                
                self.chooseScrImgVC.frame = self.oldFrame
                self.chooseScrImgVC.alpha = 1
                
                self.leftView.frame = self.leftoldFrame
                self.leftView.alpha = 1
                
                self.rightView.frame = self.rightoldFrame
                self.rightView.alpha = 1
                
                //////////////
                self.oldFrame = CGRectMake(self.chooseScrImgVC.frame.origin.x, self.chooseScrImgVC1.frame.origin.y, self.chooseScrImgVC.frame.size.width, self.chooseScrImgVC.frame.size.height)
                self.leftoldFrame = CGRectMake(self.leftView.frame.origin.x, self.leftView1.frame.origin.y, self.leftView.frame.size.width, self.leftView.frame.size.height)
                self.rightoldFrame = CGRectMake(self.rightView.frame.origin.x, self.rightView1.frame.origin.y, self.rightView.frame.size.width, self.rightView.frame.size.height)
                ///////////////
                
                self.lblArtist.frame = self.oldArtistFrame
                self.lblArtist.alpha = 1
                
                self.lblDollar.frame = self.oldDollarFrame
                self.lblDollar.alpha = 1
                
                
                },completion:  { (true) in
                    //self.imgView.image = UIImage(named: "artist_logo.png")
                    //view.alpha = 0
                    
            })
        }
    }
    
    @IBAction func backToLoginClicked(sender: AnyObject)
    {
        self.beginAppearanceTransition(false, animated: true)
        if self.parentViewController != nil
        {
            self.cycleFromViewController(self, toViewController: self.parentViewController!)
        }
        self.endAppearanceTransition()
        //self.imgView.alpha = 0
        //self.chooseScrImgVC.alpha = 1
        UIView.animateWithDuration(0.5) {
            
            self.chooseScrImgVC.frame = self.newFrame
            self.chooseScrImgVC.hidden = false
            self.chooseScrImgVC.alpha = 1
        }
    }
    
    @IBAction func fanBtnClicked(sender: AnyObject) {
        btnFAN.userInteractionEnabled = false
        lblString = "Fan"
        
        self.performSelector(#selector(trackViewFrame1), withObject:nil, afterDelay: 0.0)
        
        //////////////////
        let fanAccountVC = storyboard!.instantiateViewControllerWithIdentifier("FanAccountInfoVC") as! FanAccountInfoVC
        fanAccountVC.view.translatesAutoresizingMaskIntoConstraints = false;
        
        self.addChildViewController(fanAccountVC)
        self.addSubview(fanAccountVC.view, toView: self.view)
        
        fanAccountVC.view.alpha = 0
        fanAccountVC.view.frame = CGRectMake(self.view.frame.origin.x, -self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)
        
        UIView.animateWithDuration(0.5, animations: {
            
            fanAccountVC.view.alpha = 1
            //fanAccountVC.lblfree.alpha = 1
            //fanAccountVC.lblFan.alpha = 1
            //fanAccountVC.fanImgView.alpha = 1
            
            fanAccountVC.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height)
            
            
            },completion:  { (true) in
                //self.imgView.image = UIImage(named: "artist_logo.png")
                //view.alpha = 0
                fanAccountVC.didMoveToParentViewController(self)
                self.btnFAN.userInteractionEnabled = true
                //fanAccountVC.view.removeFromSuperview()

                //self.removeFromParentViewController()
                
                //self.navigationController?.pushViewController(fanAccountVC, animated: false)

        })
        
        //self.cycleFromViewController1(self, toViewController: fanAccountVC)
        
    }
    
    @IBAction func artistBtnClicked(sender: AnyObject) {
        btnArtist.userInteractionEnabled = false
        lblString = "Artist"
        
        self.performSelector(#selector(trackViewFrame1), withObject:nil, afterDelay: 0.0)
        
        //////////////////
        let artistAccountVC = storyboard!.instantiateViewControllerWithIdentifier("ArtistAccountInfoVC") as! ArtistAccountInfoVC
        artistAccountVC.view.translatesAutoresizingMaskIntoConstraints = false;
        
        self.addChildViewController(artistAccountVC)
        self.addSubview(artistAccountVC.view, toView: self.view)
        
        artistAccountVC.view.alpha = 0
        artistAccountVC.view.frame = CGRectMake(self.view.frame.origin.x, -self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)
        
        UIView.animateWithDuration(0.5, animations: {
            
            artistAccountVC.view.alpha = 1
            //fanAccountVC.lblfree.alpha = 1
            //fanAccountVC.lblFan.alpha = 1
            //fanAccountVC.fanImgView.alpha = 1
            
            artistAccountVC.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height)
            
            
            },completion:  { (true) in
                //self.imgView.image = UIImage(named: "artist_logo.png")
                //view.alpha = 0
                artistAccountVC.didMoveToParentViewController(self)
                self.btnArtist.userInteractionEnabled  = true
        })
        
    }
    
    func cycleFromViewController(oldViewController: UIViewController, toViewController newViewController: UIViewController) {
        oldViewController.willMoveToParentViewController(nil)
        newViewController.view.alpha = 1
        oldViewController.view.alpha = 1
        newViewController.view.layoutIfNeeded()
        
        //let thisView = oldViewController.view
        //let toView = newViewController.view
        
        let herbView = oldViewController.view
        
        let initialFrame = self.presenting ? self.originFrame : herbView.frame
        
        let finalFrame  = self.presenting ? herbView.frame : self.originFrame//CGRectMake(288, 35, 126, 84)
        
        let xScaleFactor = self.presenting ?
            initialFrame.width / finalFrame.width :
            finalFrame.width / initialFrame.width
        
        let yScaleFactor = self.presenting ?
            initialFrame.height / finalFrame.height :
            finalFrame.height / initialFrame.height
        
        let scaleTransform = CGAffineTransformMakeScale(xScaleFactor, yScaleFactor)
        
        UIView.animateKeyframesWithDuration(0.5, delay: 0.0, options: UIViewKeyframeAnimationOptions.CalculationModeLinear , animations: {
            newViewController.view.alpha = 1
            oldViewController.view.alpha = 0
            
            herbView.transform = self.presenting ?
                CGAffineTransformIdentity : scaleTransform
            
            herbView.center = CGPoint(x: CGRectGetMidX(finalFrame),
                y: CGRectGetMidY(finalFrame))
            
            },
                                            completion: { finished in
                                                
                                                newViewController.didMoveToParentViewController(self)
        })
    }
    
    func cycleFromViewController1(oldViewController: UIViewController, toViewController newViewController: UIViewController) {
        //oldViewController.willMoveToParentViewController(nil)
        self.addChildViewController(newViewController)
        self.addSubview(newViewController.view, toView: self.view)
        newViewController.view.alpha = 0
        oldViewController.view.alpha = 1
        newViewController.view.layoutIfNeeded()
        
        //let thisView = oldViewController.view
        let toView = newViewController.view
        
        let herbView = oldViewController.view
        
        let initialFrame = self.presenting ? self.originFrame : herbView.frame
        
        let finalFrame  = self.presenting ? herbView.frame : self.originFrame//CGRectMake(288, 35, 126, 84)
        
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
            oldViewController.view.alpha = 1
            
            herbView.transform = self.presenting ?
                CGAffineTransformIdentity : scaleTransform
            
            herbView.center = CGPoint(x: CGRectGetMidX(finalFrame),
                y: CGRectGetMidY(finalFrame))
            
            },
                                            completion: { finished in
                                                
                                                //newViewController.didMoveToParentViewController(self)
        })
    }
}
