//
//  SearchForMusicVC.swift
//  Disctopia
//
//  Created by Mitesh on 28/06/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit

class SearchForMusicVC: BaseVC,UITextFieldDelegate
{
   
    @IBOutlet var searchView: UIView!
    var pagingMenuController : PagingMenuController! = nil
    var options: PagingMenuControllerCustomizable!
    
    @IBOutlet var btnCloseOutlet: UIButton!
    @IBOutlet weak var yOfSearchView: NSLayoutConstraint!

    @IBOutlet weak var txtSearch: UITextField!
    
    ////////////
    let duration    = 1.0
    var presenting  = false
    var originFrame = CGRect.zero
    /////////////
    
    override func viewDidLoad()
    {
        // Do any additional setup after loading the view.
        
        super.viewDidLoad()
        
        appDelegate.isLoderRequired = false
        BaseVC.sharedInstance.hideLoader()
        
        txtSearch.delegate = self
      
        appDelegate.navigationController?.view.backgroundColor = UIColor.clearColor()
        self.navigationController?.navigationBarHidden = true
        
         self.searchView.backgroundColor = UIColor.clearColor()
        self.searchView.translatesAutoresizingMaskIntoConstraints = false
        yOfSearchView.constant = self.searchView.frame.origin.y + self.searchView.frame.height
        
      
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        BaseVC.sharedInstance.DLog("WillAppear SearchForMusicVC")
        
        self.originFrame = CGRectMake(288, 35, 126, 84)
        ////To remove this view on PlusBtnClick of SearchTracksFilterVC
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SearchForMusicVC.removeSearch(_:)), name:"removeSearchView", object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        BaseVC.sharedInstance.DLog("WillDisappear SearchForMusicVC")
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        BaseVC.sharedInstance.DLog("DidAppear SearchForMusicVC")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        BaseVC.sharedInstance.DLog("DidDisappear SearchForMusicVC")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override  func viewDidLayoutSubviews() {
        
//        let paddingView = UIView(frame: CGRectMake(0, 15, 20, self.txtSearch.frame.height))
//        paddingView.backgroundColor = UIColor.redColor()
//        txtSearch.leftView = paddingView
//        txtSearch.leftViewMode = UITextFieldViewMode.Always
        let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC)))
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            self.loadPageMenu()
        })

    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
         BaseVC.sharedInstance.hideLoader()
        if self.txtSearch.text?.isEmpty == true {
            
            UIView.animateWithDuration(1.0, animations:
                {
                    
                    self.yOfSearchView.constant = self.searchView.frame.origin.y + self.searchView.frame.height
                    self.view.layoutIfNeeded()
                }, completion: nil)
        }
    }
    func textFieldDidBeginEditing(textField: UITextField)
    {
         BaseVC.sharedInstance.hideLoader()
        if self.txtSearch.text?.isEmpty == true {
            
            UIView.animateWithDuration(1.0, animations:
                {
                    self.yOfSearchView.constant = self.searchView.frame.origin.y + self.searchView.frame.height
                    self.view.layoutIfNeeded()
                }, completion: nil)
        }
    }
    @IBAction func btnDoneSearch(sender: AnyObject)
    {
        
        //NSNotificationCenter.defaultCenter().postNotificationName("NotificationIdentifier2", object: nil)
        
//        if self.parentViewController != nil
//        {
//            self.cycleFromViewController(self, toViewController: self.parentViewController!)
//        }
//
       
        if self.parentViewController != nil
        {
            self.cycleFromViewController2(self, toViewController: self.parentViewController!)
        }

//         NSNotificationCenter.defaultCenter().postNotificationName("removeSearchView", object: nil)//To remove SearchForMusicVC on this Button Click
    }
    func loadPageMenu()
    {
         BaseVC.sharedInstance.hideLoader()
        if ( pagingMenuController == nil )
        {
            options =  PagingMenuOptionsSearch()
            pagingMenuController = PagingMenuController(options: options)
            //let pagingMenuController = self.childViewControllers.first as! PagingMenuController
            pagingMenuController.delegate = self
            pagingMenuController.setup(options)
            self.addChildViewController(pagingMenuController)
            pagingMenuController.view.frame = CGRectMake(0, 0,searchView.frame.size.width, searchView.frame.size.height)
            pagingMenuController.view.backgroundColor = UIColor.clearColor()
            
            
            self.searchView.addSubview(pagingMenuController.view)
            //        pagingMenuController.didMoveToParentViewController(self)
        }
    }


    func ButtonPluseTapped(sender:UIButton)
    {
        let index = sender.tag
        BaseVC.sharedInstance.DLog("index :\(index)")
        
        //self.dismissViewControllerAnimated(true, completion: {
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc : AddTrackVC = storyboard.instantiateViewControllerWithIdentifier("AddTrackVC") as! AddTrackVC
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.modalPresentationStyle = .OverCurrentContext
        appDelegate.navigationController!.presentViewController(navigationController, animated: true, completion: nil)
       // })
        
    }

    @IBAction func btnGoSearch(sender: AnyObject)
    {
         BaseVC.sharedInstance.hideLoader()
        if txtSearch.isFirstResponder()
        {
            txtSearch.resignFirstResponder()
        }
        if let txt = txtSearch.text?.stringByReplacingOccurrencesOfString(" ", withString: "")
        {
            if txt != ""
            {
                reloadSearchData()
            }
            else
            {
                self.DAlert(ALERT_TITLE, message: "Please enter text", action: ALERT_OK, sender: self)
            }
           
        }
    }
    
    func reloadSearchData()
    {
        if txtSearch.text?.isEmpty == true
        {
            self.DAlert(ALERT_TITLE, message: "Please enter text", action: ALERT_OK, sender: self)
            
            UIView.animateWithDuration(1.0, animations:
                {
                    self.yOfSearchView.constant = self.searchView.frame.origin.y + self.searchView.frame.height
                    self.view.layoutIfNeeded()
                }, completion: nil)
            
            NSNotificationCenter.defaultCenter().postNotificationName("reloadAlbumsFilterTbl", object: nil)
            NSNotificationCenter.defaultCenter().postNotificationName("reloadArtistFilterTbl", object: nil)
            NSNotificationCenter.defaultCenter().postNotificationName("reloadTrackFilterTbl", object: nil)

        }
        else
        {
            let myDict = ["searchText":txtSearch.text!]
            
            UIView.animateWithDuration(1.0, animations:
                {
                    self.yOfSearchView.constant = 0
                    self.view.layoutIfNeeded()
                }, completion: nil)
            
            NSNotificationCenter.defaultCenter().postNotificationName("reloadAlbumsFilterTbl", object: myDict)
            NSNotificationCenter.defaultCenter().postNotificationName("reloadArtistFilterTbl", object: myDict)
            NSNotificationCenter.defaultCenter().postNotificationName("reloadTrackFilterTbl", object: myDict)

            /*
            if pagingMenuController.currentPage == 0
            {
                NSNotificationCenter.defaultCenter().postNotificationName("reloadAlbumsFilterTbl", object: myDict)
            }
            else if pagingMenuController.currentPage == 1
            {
                NSNotificationCenter.defaultCenter().postNotificationName("reloadArtistFilterTbl", object: myDict)
            }
            else if pagingMenuController.currentPage == 2
            {
                NSNotificationCenter.defaultCenter().postNotificationName("reloadTrackFilterTbl", object: myDict)
            }
             */
        }
    }
    
    func removeSearch(notification: NSNotification)
    {
        //Take Action on Notification
         BaseVC.sharedInstance.hideLoader()
        BaseVC.sharedInstance.DLog("removeSearch of SearchForMusicVC called")
        
        self.willMoveToParentViewController(nil)
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
    func cycleFromViewController2(oldViewController: UIViewController, toViewController newViewController: UIViewController)
    {
         BaseVC.sharedInstance.hideLoader()
        oldViewController.willMoveToParentViewController(nil)
        newViewController.view.alpha = 1
        oldViewController.view.alpha = 1
        newViewController.view.layoutIfNeeded()
        //let thisView = oldViewController.view
        //let toView = newViewController.view
        let herbView = oldViewController.view
        let initialFrame = self.presenting ? self.originFrame : herbView.frame
        var finalFrame = CGRectMake(0, 0, 0, 0)
        var myTimeInterval = NSTimeInterval()
       
        finalFrame  = self.presenting ? herbView.frame : self.originFrame//CGRectMake(288, 35, 126, 84)
        myTimeInterval = 0.3
      
        
        let xScaleFactor = self.presenting ?
            initialFrame.width / finalFrame.width :
            finalFrame.width / initialFrame.width
        
        let yScaleFactor = self.presenting ?
            initialFrame.height / finalFrame.height :
            finalFrame.height / initialFrame.height
        
        let scaleTransform = CGAffineTransformMakeScale(xScaleFactor, yScaleFactor)
        
        UIView.animateKeyframesWithDuration(0.15, delay: myTimeInterval, options: UIViewKeyframeAnimationOptions.CalculationModeCubic , animations:
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
                
        })
    }

    func cycleFromViewController(oldViewController: UIViewController, toViewController newViewController: UIViewController) {
        //self.beginAppearanceTransition(true, animated: true)
        //self.endAppearanceTransition()
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
        
        /*UIView.transitionWithView(self.view, duration: 0.5, options: .TransitionFlipFromTop, animations: { _ in
         
         newViewController.view.alpha = 1
         oldViewController.view.alpha = 0
         
         },
         completion: { finished in
         
         self.willMoveToParentViewController(nil)
         self.view.removeFromSuperview()
         self.removeFromParentViewController()
         })*/
        
        UIView.animateKeyframesWithDuration(0.1, delay: 0.0, options: UIViewKeyframeAnimationOptions.CalculationModeCubic , animations: {
            newViewController.view.alpha = 1
            oldViewController.view.alpha = 1
            
            herbView.transform = self.presenting ?
                CGAffineTransformIdentity : scaleTransform
            
            herbView.center = CGPoint(x: CGRectGetMidX(finalFrame), y: CGRectGetMidY(finalFrame))
            herbView.clipsToBounds = true
            
            },
                                            
                                            completion: { finished in
                                                self.dismissViewControllerAnimated(true, completion: nil)
                                                self.willMoveToParentViewController(nil)
                                                self.view.removeFromSuperview()
                                                self.removeFromParentViewController()
        })
    }
}

extension SearchForMusicVC: PagingMenuControllerDelegate {
    // MARK: - PagingMenuControllerDelegate -
    
    func willMoveToPageMenuController(menuController: UIViewController, previousMenuController: UIViewController) {
       // previousMenuController.view.backgroundColor = UIColor.clearColor()
       // menuController.view.backgroundColor = UIColor.clearColor()
        DLog("menuController \(menuController.dynamicType)")
        
    }
    
    func didMoveToPageMenuController(menuController: UIViewController, previousMenuController: UIViewController) {
       // previousMenuController.view.backgroundColor = UIColor.clearColor()
        //menuController.view.backgroundColor = UIColor.clearColor()
        reloadSearchData()
    }
    
    func willMoveToMenuItemView(menuItemView: MenuItemView, previousMenuItemView: MenuItemView)
    {
    }
    
    func didMoveToMenuItemView(menuItemView: MenuItemView, previousMenuItemView: MenuItemView) {
    }
}

private var pagingControllers: [BaseVC]
{
    let verificationCodeViewController1 = SearchAlbumsFilterVC.instantiateFromStoryboard()
    let verificationCodeViewController2 = SearchArtistsFilterVC.instantiateFromStoryboard()
    let verificationCodeViewController3 = SearchTracksFilterVC.instantiateFromStoryboard()
    
    return [verificationCodeViewController1, verificationCodeViewController2, verificationCodeViewController3]
}

struct SearchItem1: MenuItemViewCustomizable {}
struct SearchItem2: MenuItemViewCustomizable {}
struct SearchItem3: MenuItemViewCustomizable {}

struct PagingMenuOptionsSearch: PagingMenuControllerCustomizable {
    var componentType: ComponentType {
        return .All(menuOptions: MenuOptions(), pagingControllers: pagingControllers)
    }
    var lazyLoadingPage: LazyLoadingPage {
        return .Three
    }
    
    var backgroundColor: UIColor {
        return UIColor.clearColor()
    }
    
    struct MenuOptions: MenuViewCustomizable {
        
        var backgroundColor: UIColor {
            return UIColor.clearColor()
        }
        var selectedBackgroundColor: UIColor {
            return UIColor.clearColor()
        }
        
        var displayMode: MenuDisplayMode {
            return .SegmentedControl
            //return .Infinite(widthMode: .Flexible, scrollingMode: .ScrollEnabled)
        }
        var itemsOptions: [MenuItemViewCustomizable] {
            return [SearchItem1(), SearchItem2(), SearchItem3()]
        }
        var focusMode: MenuFocusMode {
            return .RoundRect(radius: 0, horizontalPadding: 8, verticalPadding: 0, selectedColor: UIColor.blackColor())
        }
    }
    
    struct SearchItem1: MenuItemViewCustomizable {
        
        var displayMode: MenuItemDisplayMode {
            let title = MenuItemText(text: "albums")
            //let description = MenuItemText(text: String(self))
            
            return .Text(title:title)
            //return .MultilineText(title: title, description: description)
        }
        
    }
    
    struct SearchItem2: MenuItemViewCustomizable {
        
        var displayMode: MenuItemDisplayMode {
            let title = MenuItemText(text: "artists")
            //let description = MenuItemText(text: String(self))
            return .Text(title:title)
            //return .MultilineText(title: title, description: description)
        }
        
    }
    
    struct SearchItem3: MenuItemViewCustomizable {
        
        var displayMode: MenuItemDisplayMode {
            let title = MenuItemText(text: "tracks")
            //let description = MenuItemText(text: String(self))
            return .Text(title:title)
            //return .MultilineText(title: title, description: description)
        }
        
        //              var menuItemText: MenuItemText {
        //                  return MenuItemText(text: "tracks", color: UIColor.redColor(), selectedColor: UIColor.whiteColor(), font: UIFont.systemFontOfSize(16), selectedFont: UIFont.boldSystemFontOfSize(16))
        //              }
    }
    
    
    
}


