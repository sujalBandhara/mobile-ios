//
//  SettingsMenuVC.swift
//
//
//  Created by Dhaval on 30/06/16.
//
//

import UIKit

class SettingsMenuVC: BaseVC
{
    //let transition = PopAnimator()
    
    let duration    = 1.0
    
    var presenting  = true
    var originFrame = CGRect.zero
    var pagingMenuController:PagingMenuController! = nil
    
    // MARK: - Outlets
    @IBOutlet weak var onOptionClickBtn: UIButton!
    @IBOutlet var menuView: UIView!
    
    var options: PagingMenuControllerCustomizable!
    
    
    // MARK: - Methods

    override func viewDidLoad()
    {
      
        super.viewDidLoad()
        self.originFrame = CGRectMake(self.onOptionClickBtn.frame.origin.x, self.onOptionClickBtn.frame.origin.y, self.onOptionClickBtn.frame.width, self.onOptionClickBtn.frame.height)
        self.onOptionClickBtn.exclusiveTouch = true
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SettingsMenuVC.loadPageMenu), name: "loadSettingVC", object: nil)
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(true)
        BaseVC.sharedInstance.DLog("WillAppear SettingsMenuVC")
        
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SettingsMenuVC.methodOfReceivedNotification1(_:)), name:"NotificationIdentifier1", object: nil)
        
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SettingsMenuVC.methodOfReceivedNotification2(_:)), name:"NotificationIdentifier2", object: nil)
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(true)
        BaseVC.sharedInstance.DLog("WillDisappear SettingsMenuVC")
        //NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(true)
       
        BaseVC.sharedInstance.DLog("DidAppear SettingsMenuVC")
    }
    
    override func viewDidDisappear(animated: Bool)
    {
        super.viewDidDisappear(true)
        BaseVC.sharedInstance.DLog("DidDisappear SettingsMenuVC")
    }
    
    class func instantiateFromStoryboard() -> SettingsMenuVC
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier(String(self)) as! SettingsMenuVC
    }
    
    override  func viewDidLayoutSubviews()
    {
        let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC)))
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            self.loadPageMenu()
        })
    }
    
    func manageMenu(isShow:Bool)
    {
        if isShow
        {
            appDelegate.pagingMenuController.menuView!.hidden = false
            appDelegate.pagingMenuController.view.frame = CGRectMake(appDelegate.pagingMenuController.view.frame.origin.x, 60.0, appDelegate.pagingMenuController.view.frame.size.width, UIScreen.mainScreen().bounds.height - 60.0)
            //appDelegate.pagingMenuController.view.frame = CGRectMake(appDelegate.pagingMenuController.view.frame.origin.x, appDelegate.pagingMenuController.menuView!.frame.size.height * 1, appDelegate.pagingMenuController.view.frame.size.width, appDelegate.pagingMenuController.view.frame.size.height - appDelegate.pagingMenuController.menuView!.frame.size.height)
        }
        else
        {
            appDelegate.pagingMenuController.view.frame = CGRectMake(appDelegate.pagingMenuController.view.frame.origin.x, -50.0, appDelegate.pagingMenuController.view.frame.size.width, UIScreen.mainScreen().bounds.height + 50)
            appDelegate.pagingMenuController.menuView!.hidden = true
        }
    }

    // MARK: - Actions
    @IBAction func onBackClick(sender: AnyObject)
    {
        appDelegate.isFromGoSubsription = false
        self.popToRootViewControllerAnimated(false)
        appDelegate.pagingMenuController.moveToMenuPage(0, animated: true)
        //appDelegate.loadFirstViewController("MenuVC")
    }
    
    @IBAction func onOptionClick(sender: AnyObject)
    {
         onOptionClickBtn.exclusiveTouch = true
        NSNotificationCenter.defaultCenter().postNotificationName("SettingsGeneralVCresignFirstResponder", object: nil)
        NSNotificationCenter.defaultCenter().postNotificationName("SettingsSecurityVCresignFirstResponder", object: nil)
        NSNotificationCenter.defaultCenter().postNotificationName("SubscriptionSettingsVCresignFirstResponder", object: nil)
        NSNotificationCenter.defaultCenter().postNotificationName("ProfileSettingVCresignFirstResponder", object: nil)
        NSNotificationCenter.defaultCenter().postNotificationName("CardPaymentSettingsVCresignFirstResponder", object: nil)
        //let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        //let vc : LogoutSeetingViewController = storyboard.instantiateViewControllerWithIdentifier("LogoutSeetingViewController") as! LogoutSeetingViewController
        //let navigationController = UINavigationController(rootViewController: vc)
        //navigationController.modalPresentationStyle = .OverCurrentContext
        //self.presentViewController(navigationController, animated: true, completion: nil)
        //let modalViewController = SearchForMusicVC()
        //modalViewController.modalPresentationStyle = .OverCurrentContext
        //presentViewController(modalViewController, animated: true, completion: nil)
        //let vc : LogoutSeetingViewController = storyboard!.instantiateViewControllerWithIdentifier("LogoutSeetingViewController") as! LogoutSeetingViewController
        ////herbDetails.herb = selectedHerb
        //vc.transitioningDelegate = self
        //presentViewController(vc, animated: true, completion: nil)
        
        let herbDetails = storyboard!.instantiateViewControllerWithIdentifier("LogoutSeetingViewController") as! LogoutSeetingViewController
        
        herbDetails.view.translatesAutoresizingMaskIntoConstraints = false;
        //presentViewController(herbDetails, animated: true, completion: nil)
        
        herbDetails.beginAppearanceTransition(true, animated: true)
        self.cycleFromViewController(self, toViewController: herbDetails)
        herbDetails.endAppearanceTransition()
    }
    
    @IBAction func onOptionMenuClick(sender: AnyObject)
    {
        NSNotificationCenter.defaultCenter().postNotificationName("SettingsGeneralVCresignFirstResponder", object: nil)
        NSNotificationCenter.defaultCenter().postNotificationName("SettingsSecurityVCresignFirstResponder", object: nil)
        NSNotificationCenter.defaultCenter().postNotificationName("SubscriptionSettingsVCresignFirstResponder", object: nil)
        NSNotificationCenter.defaultCenter().postNotificationName("ProfileSettingVCresignFirstResponder", object: nil)
        NSNotificationCenter.defaultCenter().postNotificationName("CardPaymentSettingsVCresignFirstResponder", object: nil)
        
        
        
        let herbDetails = storyboard!.instantiateViewControllerWithIdentifier("OptionMenuVC") as! OptionMenuVC
        herbDetails.view.translatesAutoresizingMaskIntoConstraints = false;
        //presentViewController(herbDetails, animated: true, completion: nil)
        
        herbDetails.beginAppearanceTransition(true, animated: true)
        self.cycleFromViewController(self, toViewController: herbDetails)
        herbDetails.endAppearanceTransition()

    }
    
    // MARK: - Functions

    func loadPageMenu()
    {
        if (pagingMenuController == nil)
        {
            self.showLoader()
            options =  PagingMenuOptionsSetting()
            pagingMenuController = PagingMenuController(options: options)
            //let pagingMenuController = self.childViewControllers.first as! PagingMenuController
            pagingMenuController.delegate = self
            pagingMenuController.setup(options)
            self.addChildViewController(pagingMenuController)
            pagingMenuController.view.frame = self.menuView.frame
            //CGRectMake(0, 100,pagingMenuController.view.frame.size.width, pagingMenuController.view.frame.size.height - 100)
            pagingMenuController.view.backgroundColor = UIColor.clearColor()
            self.view.addSubview(pagingMenuController.view)
            //pagingMenuController.didMoveToParentViewController(self)
            self.hideLoader()

            if appDelegate.isFromGoSubsription
            {
                pagingMenuController.moveToMenuPage(2)
            }
        }
    }
    
    func cycleFromViewController(oldViewController: UIViewController, toViewController newViewController: UIViewController)
    {
        oldViewController.willMoveToParentViewController(nil)
        
        self.addChildViewController(newViewController)
        self.addSubview(newViewController.view, toView:self.view!)
        
        newViewController.view.alpha = 0
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
        
        if self.presenting
        {
            herbView.transform = scaleTransform
            herbView.center = CGPoint(
                x: CGRectGetMidX(initialFrame),
                y: CGRectGetMidY(initialFrame))
            herbView.clipsToBounds = true
            
            self.view.addSubview(toView)
            self.view.bringSubviewToFront(herbView)
        }
        
        UIView.animateKeyframesWithDuration(0.36, delay: 0.0, options: UIViewKeyframeAnimationOptions.CalculationModeCubic , animations:
        {
            newViewController.view.alpha = 1
            oldViewController.view.alpha = 1
            
            herbView.transform = self.presenting ?
                CGAffineTransformIdentity : scaleTransform
            
            herbView.center = CGPoint(x: CGRectGetMidX(finalFrame),
                y: CGRectGetMidY(finalFrame))
            
            /*UIView.animateWithDuration(0.3, delay:0.0,
             usingSpringWithDamping: 0.0,
             initialSpringVelocity: 0.0,
             options: [],
             animations: {
             herbView.transform = self.presenting ?
             CGAffineTransformIdentity : scaleTransform
             
             herbView.center = CGPoint(x: CGRectGetMidX(finalFrame),
             y: CGRectGetMidY(finalFrame))
             
             }, completion:{_ in
             newViewController.didMoveToParentViewController(self)
             })
             }, completion: { finished in
             
             //newViewController.didMoveToParentViewController(self)
             })*/
        },
        completion:
        {
            finished in
            newViewController.didMoveToParentViewController(self)
        })
    }
    
    func methodOfReceivedNotification1(notification: NSNotification)
    {
        BaseVC.sharedInstance.DLog("methodOfReceivedNotification1 called")
        
        let herbDetails = storyboard!.instantiateViewControllerWithIdentifier("LogoutSeetingViewController") as! LogoutSeetingViewController
        
        herbDetails.view.translatesAutoresizingMaskIntoConstraints = false;
        //herbDetails.beginAppearanceTransition(true, animated: true)
        //herbDetails.endAppearanceTransition()
        
        self.addChildViewController(herbDetails)
        self.addSubview(herbDetails.view, toView: self.view)
        
        UIView.transitionWithView(self.view, duration: 0.3, options: .TransitionCrossDissolve, animations: { _ in
            
            herbDetails.view.alpha = 1
            self.view.alpha = 1
        },
        completion:
        {
            finished in
//            self.willMoveToParentViewController(nil)
//            self.view.removeFromSuperview()
//            self.removeFromParentViewController()
        })
    }
    
    func methodOfReceivedNotification2(notification: NSNotification)
    {
        BaseVC.sharedInstance.DLog("methodOfReceivedNotification2 called")
        
        let herbDetails = storyboard!.instantiateViewControllerWithIdentifier("LogoutSeetingViewController") as! LogoutSeetingViewController
        
        herbDetails.view.translatesAutoresizingMaskIntoConstraints = false;
        //herbDetails.beginAppearanceTransition(true, animated: true)
        //herbDetails.endAppearanceTransition()
        
        self.addChildViewController(herbDetails)
        self.addSubview(herbDetails.view, toView: self.view)
        
        UIView.transitionWithView(self.view, duration: 0.3, options: .TransitionCrossDissolve, animations: { _ in
            
            herbDetails.view.alpha = 1
            self.view.alpha = 1
        },
        completion:
        {
            finished in
            //self.willMoveToParentViewController(nil)
            //self.view.removeFromSuperview()
            //self.removeFromParentViewController()
        })
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
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

extension SettingsMenuVC: PagingMenuControllerDelegate
{
    // MARK: - PagingMenuControllerDelegate
    
    func willMoveToPageMenuController(menuController: UIViewController, previousMenuController: UIViewController)
    {
       
        NSNotificationCenter.defaultCenter().postNotificationName("SettingsSecurityVCresignFirstResponder", object: nil)
        NSNotificationCenter.defaultCenter().postNotificationName("SubscriptionSettingsVCresignFirstResponder", object: nil)
        NSNotificationCenter.defaultCenter().postNotificationName("ProfileSettingVCresignFirstResponder", object: nil)
        NSNotificationCenter.defaultCenter().postNotificationName("CardPaymentSettingsVCresignFirstResponder", object: nil)
        
        
        DLog("menuController \(menuController.dynamicType)")
        //        if menuController.dynamicType == "LibraryViewController"
        //        {
        //
        //        }
        //        else if menuController.dynamicType == "LibraryViewController"
        //        {
        //
        //        }
        //        else if menuController.dynamicType == "LibraryViewController"
        //        {
        //
        //        }
        //        else if menuController.dynamicType == "LibraryViewController"
        //        {
        //
        //        }
        
    }
    
    func didMoveToPageMenuController(menuController: UIViewController, previousMenuController: UIViewController)
    {
        
        appDelegate.selectedTextField.resignFirstResponder()
    }
    
    func willMoveToMenuItemView(menuItemView: MenuItemView, previousMenuItemView: MenuItemView)
    {
    }
    
    func didMoveToMenuItemView(menuItemView: MenuItemView, previousMenuItemView: MenuItemView)
    {
        NSNotificationCenter.defaultCenter().postNotificationName("setProfileData", object: nil)
        //NSNotificationCenter.defaultCenter().postNotificationName("hidePicker", object: nil)
    }
}

private var pagingControllers: [BaseVC]
{
    let verificationCodeViewController1 = SettingsGeneralViewController.instantiateFromStoryboard()
    let verificationCodeViewController2 = ProfileSettingVC.instantiateFromStoryboard()
    //let verificationCodeViewController3 = CardPaymentSettingsVC.instantiateFromStoryboard()
    let verificationCodeViewController4 = SubscriptionSettingsVC.instantiateFromStoryboard()
    //let verificationCodeViewController5 = deactivateAccountViewController.instantiateFromStoryboard()
    let verificationCodeViewController6 = SettingsSecurityViewController.instantiateFromStoryboard()
    
    return [verificationCodeViewController1, verificationCodeViewController2, /*verificationCodeViewController3,*/ verificationCodeViewController4, /*verificationCodeViewController5,*/ verificationCodeViewController6]
}

struct General6: MenuItemViewCustomizable {}
struct Profile7: MenuItemViewCustomizable {}
struct Payments8: MenuItemViewCustomizable {}
struct Subscriptions9: MenuItemViewCustomizable {}
//struct DeactivateAccount10: MenuItemViewCustomizable {}
struct Security11: MenuItemViewCustomizable {}

struct PagingMenuOptionsSetting: PagingMenuControllerCustomizable
{
    var componentType: ComponentType
    {
        return .All(menuOptions: MenuOptions(), pagingControllers: pagingControllers)
    }
    
    var lazyLoadingPage: LazyLoadingPage
    {
        return .Three
    }
    
    struct MenuOptions: MenuViewCustomizable
    {
        var backgroundColor: UIColor
        {
            return UIColor.clearColor()
        }
        var selectedBackgroundColor: UIColor
        {
            return UIColor.clearColor()
        }
        var displayMode: MenuDisplayMode
        {
            return .Infinite(widthMode: .Fixed(width: 90.0), scrollingMode: .ScrollEnabled)
        }
        var itemsOptions: [MenuItemViewCustomizable]
        {
            return [General6(), Profile7(), /*Payments8(),*/ Subscriptions9(), /*DeactivateAccount10(),*/ Security11()]
        }
        var focusMode: MenuFocusMode
        {
            return .RoundRect(radius: 0, horizontalPadding: 8, verticalPadding: 0, selectedColor: UIColor(colorLiteralRed: 134.0/255.0, green: 59.0/255.0, blue: 197.0/255.0, alpha: 1.0)
            )
        }
        
    }
    
    struct General6: MenuItemViewCustomizable
    {
        var displayMode: MenuItemDisplayMode
        {
            let title = MenuItemText(text: "General")
            //let description = MenuItemText(text: String(self))
            return .Text(title:title)
            //return .MultilineText(title: title, description: description)
        }
    }
    
    struct Profile7: MenuItemViewCustomizable
    {
        var displayMode: MenuItemDisplayMode
        {
            let title = MenuItemText(text: "Profile")
            //let description = MenuItemText(text: String(self))
            return .Text(title:title)
            //return .MultilineText(title: title, description: description)
        }
    }
    
    struct Payments8: MenuItemViewCustomizable
    {
        var displayMode: MenuItemDisplayMode
        {
            let title = MenuItemText(text: "Payments")
            //let description = MenuItemText(text: String(self))
            return .Text(title:title)
            //return .MultilineText(title: title, description: description)
        }
    }
    
    struct Subscriptions9: MenuItemViewCustomizable
    {
        var displayMode: MenuItemDisplayMode
        {
            let title = MenuItemText(text: "Subscriptions")
            //let description = MenuItemText(text: String(self))
            return .Text(title:title)
            //return .MultilineText(title: title, description: description)
        }
    }
    
//    struct DeactivateAccount10: MenuItemViewCustomizable
//    {
//        var displayMode: MenuItemDisplayMode
//        {
//            let title = MenuItemText(text: "deactivate account")
//            //let description = MenuItemText(text: String(self))
//            return .Text(title:title)
//            //return .MultilineText(title: title, description: description)
//        }
//    }
    
    struct Security11: MenuItemViewCustomizable
    {
        var displayMode: MenuItemDisplayMode
        {
            let title = MenuItemText(text: "Security")
            //let description = MenuItemText(text: String(self))
            return .Text(title:title)
            //return .MultilineText(title: title, description: description)
        }
    }
    
}


//extension SettingsMenuVC: UIViewControllerTransitioningDelegate
//{
//    func animationControllerForPresentedController(
//    presented: UIViewController,
//    presentingController presenting: UIViewController,
//    sourceController source: UIViewController) ->
//    UIViewControllerAnimatedTransitioning?
//    {
//        transition.originFrame = onOptionClickBtn.superview!.convertRect(onOptionClickBtn!.frame, toView: nil)
//        transition.presenting = true
//        return transition
//    }
//    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?
//    {
//        transition.presenting = false
//        return transition
//    }
//}


