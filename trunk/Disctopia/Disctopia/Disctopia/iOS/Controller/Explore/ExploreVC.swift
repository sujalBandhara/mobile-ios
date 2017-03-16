//
//  ExploreVC.swift
//  Disctopia
//
//  Created by Damini on 06/07/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit
import SwiftyJSON

var categoryArray = [String]()

class ExploreVC: BaseVC {
    
    let duration    = 1.0
    var presenting  = true
    var originFrame = CGRect.zero
    var expY: CGFloat = 0.0
    
    var pagingMenuController : PagingMenuController! = nil
    var options: PagingMenuControllerCustomizable!
    let transition = PopAnimator()
    
    @IBOutlet weak var onOptionClickBtn: UIButton!
    @IBOutlet var exploreView: UIView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let saveExploreCategoryResult : JSON =  BaseVC.sharedInstance.loadJSON("exploreCategoryList")
        //self.DLog("saveExploreCategoryResult = \(saveExploreCategoryResult)")
        if saveExploreCategoryResult != nil
        {
            if saveExploreCategoryResult.count > 0
            {
                categoryArray.append(saveExploreCategoryResult[0]["name"].stringValue)
                categoryArray.append(saveExploreCategoryResult[1]["name"].stringValue)
                categoryArray.append(saveExploreCategoryResult[2]["name"].stringValue)
                categoryArray.append(saveExploreCategoryResult[3]["name"].stringValue)
                categoryArray.append(saveExploreCategoryResult[4]["name"].stringValue)
             }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        BaseVC.sharedInstance.DLog("WillAppear ViewController")
        
        self.originFrame = CGRectMake(self.onOptionClickBtn.frame.origin.x, self.onOptionClickBtn.frame.origin.y, self.onOptionClickBtn.frame.width, self.onOptionClickBtn.frame.height)
        
        
        for subview: UIView in self.view!.subviews
        {
            if subview.tag == 100
            {
                subview.removeFromSuperview()
            }
        }

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ExploreVC.methodOfReceivedNotification1(_:)), name:"NotificationIdentifier1", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ExploreVC.methodOfReceivedNotification2(_:)), name:"NotificationIdentifier2", object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        BaseVC.sharedInstance.DLog("WillDisappear ViewController")
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        BaseVC.sharedInstance.DLog("DidAppear ViewController")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        BaseVC.sharedInstance.DLog("DidDisappear ViewController")
    }
    
    override  func viewDidLayoutSubviews()
    {
        let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC)))
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            // Update UI in Main thread
            if categoryArray.count > 0
            {
                self.loadPageMenu()
            }
        })
    }
    
    class func instantiateFromStoryboard() -> ExploreVC
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier(String(self)) as! ExploreVC
    }
    
    func loadPageMenu()
    {
        if (self.pagingMenuController == nil)
        {
            // Any Large Task
            self.options =  PagingMenuOptionExplore()
            self.pagingMenuController = PagingMenuController(options: self.options)
            //let pagingMenuController = self.childViewControllers.first as! PagingMenuController
            self.pagingMenuController.delegate = self
            self.pagingMenuController.setup(self.options)
            self.addChildViewController(self.pagingMenuController)
            
            let expRact = self.exploreView.frame
            self.expY = expRact.origin.y
            //CGRectMake(0, 100,pagingMenuController.view.frame.size.width, pagingMenuController.view.frame.size.height - 100)
            self.pagingMenuController.view.backgroundColor = UIColor.clearColor()
            // Update UI in Main thread
            self.view.addSubview(self.pagingMenuController.view)
            //pagingMenuController.didMoveToParentViewController(self)
            self.showMenu(false)

        }
    }
    
    func showMenu(isShow : Bool)
    {
        if self.exploreView != nil
        {
            var expRact = self.exploreView.frame
            if isShow
            {
                expRact.origin.y = expY
            }
            else
            {
                expRact.origin.y = expY - 20.0
            }
            
            if self.pagingMenuController != nil
            {
                self.pagingMenuController.view.frame = expRact
            }
        }
    }
    
    @IBAction func btnBackMyMusic(sender: AnyObject)
    {
        appDelegate.pagingMenuController.moveToMenuPage(0, animated: true)
        self.showMenu(false)
        //self.popToRootViewControllerAnimated(true)
        //self.pushToViewControllerIfNotExistWithClassName("MenuVC", animated: true)
    }
    
    @IBAction func onOptionClick(sender: AnyObject)
    {
        
        //        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        //        let vc : OptionMenuVC = storyboard.instantiateViewControllerWithIdentifier("OptionMenuVC") as! OptionMenuVC
        //        let navigationController = UINavigationController(rootViewController: vc)
        //        navigationController.modalPresentationStyle = .OverCurrentContext
        //        self.presentViewController(navigationController, animated: true, completion: nil)
        
//        let vc : OptionMenuVC = storyboard!.instantiateViewControllerWithIdentifier("OptionMenuVC") as! OptionMenuVC
//        //herbDetails.herb = selectedHerb
//        vc.transitioningDelegate = self
//        presentViewController(vc, animated: true, completion: nil)

        let herbDetails = storyboard!.instantiateViewControllerWithIdentifier("OptionMenuVC") as! OptionMenuVC
        herbDetails.view.translatesAutoresizingMaskIntoConstraints = false;
        //presentViewController(herbDetails, animated: true, completion: nil)
        
        herbDetails.beginAppearanceTransition(true, animated: true)
        self.cycleFromViewController(self, toViewController: herbDetails)
        herbDetails.endAppearanceTransition()
        
        // let modalViewController = SearchForMusicVC()
        // modalViewController.modalPresentationStyle = .OverCurrentContext
        // presentViewController(modalViewController, animated: true, completion: nil)
    }
    
    
    func cycleFromViewController(oldViewController: UIViewController, toViewController newViewController: UIViewController) {
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
        
        if self.presenting {
            herbView.transform = scaleTransform
            herbView.center = CGPoint(
                x: CGRectGetMidX(initialFrame),
                y: CGRectGetMidY(initialFrame))
            herbView.clipsToBounds = true
            
            self.view.addSubview(toView)
            self.view.bringSubviewToFront(herbView)
        }
        
        UIView.animateKeyframesWithDuration(0.36, delay: 0.0, options: UIViewKeyframeAnimationOptions.CalculationModeCubic , animations: {
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
                                            
                                            completion: { finished in
                                                
                                                newViewController.didMoveToParentViewController(self)
        })
    }
    
    func methodOfReceivedNotification1(notification: NSNotification){
        //Take Action on Notification
        
        BaseVC.sharedInstance.DLog("methodOfReceivedNotification1 called")
        
        let herbDetails = storyboard!.instantiateViewControllerWithIdentifier("SearchForMusicVC") as! SearchForMusicVC
        herbDetails.view.translatesAutoresizingMaskIntoConstraints = false;
        //herbDetails.beginAppearanceTransition(true, animated: true)
        //herbDetails.endAppearanceTransition()
        
        self.addChildViewController(herbDetails)
        self.addSubview(herbDetails.view, toView: self.view)
        
        UIView.transitionWithView(self.view, duration: 0.3, options: .TransitionCrossDissolve, animations: { _ in
            
            herbDetails.view.alpha = 1
            self.view.alpha = 1
            
            },
                                  completion: { finished in
                                    
                                    //self.willMoveToParentViewController(nil)
                                    //self.view.removeFromSuperview()
                                    //self.removeFromParentViewController()
                                    self.didMoveToParentViewController(self)
        })
        
    }
    
    func methodOfReceivedNotification2(notification: NSNotification){
        //Take Action on Notification
        
        BaseVC.sharedInstance.DLog("methodOfReceivedNotification2 called")
        
        let herbDetails = storyboard!.instantiateViewControllerWithIdentifier("OptionMenuVC") as! OptionMenuVC
        herbDetails.view.translatesAutoresizingMaskIntoConstraints = false;
        //herbDetails.beginAppearanceTransition(true, animated: true)
        //herbDetails.endAppearanceTransition()
        
        self.addChildViewController(herbDetails)
        self.addSubview(herbDetails.view, toView: self.view)
        
        UIView.transitionWithView(self.view, duration: 0.3, options: .TransitionCrossDissolve, animations: { _ in
            
            herbDetails.view.alpha = 1
            self.view.alpha = 1
            
            },
                                  completion: { finished in
                                    
                                    //self.willMoveToParentViewController(nil)
                                    //self.view.removeFromSuperview()
                                    //self.removeFromParentViewController()
                                    //self.didMoveToParentViewController(self)
        })
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
extension ExploreVC: PagingMenuControllerDelegate {
    // MARK: - PagingMenuControllerDelegate
    
    func willMoveToPageMenuController(menuController: UIViewController, previousMenuController: UIViewController) {
        DLog("menuController \(menuController.dynamicType)")
        

    }
    
    func didMoveToPageMenuController(menuController: UIViewController, previousMenuController: UIViewController)
    {
        if menuController.dynamicType == ExploreCategoryVC.self //MyMusicExploreVC.self
        {
            if let aMenuController = menuController as? ExploreCategoryVC
            {
                aMenuController.reloadCategory()
                /*
                if (appDelegate.exploreArray?.count > 0)
                {
                    DLog("aMenuController.categoryName \(aMenuController.categoryName)")
                    aMenuController.exploreArray = self.filterExpolreArrayWithCategory(aMenuController.categoryName)
                    aMenuController.layout.itemCount = Int32(aMenuController.exploreArray.count)
                    aMenuController.collectionView.reloadData()
                }
                else
                {
                    DLog("#######$$$$$$######")
                }
 */
            }
        }

    }
    
    func willMoveToMenuItemView(menuItemView: MenuItemView, previousMenuItemView: MenuItemView)
    {
        //appDelegate.selectedCategoryName = menuItemView.titleLabel.text!
         DLog("menuItemView =  \(menuItemView.titleLabel.text!)")
        DLog("previousMenuItemView = \(previousMenuItemView.titleLabel.text)")
    }
    
    func didMoveToMenuItemView(menuItemView: MenuItemView, previousMenuItemView: MenuItemView) {
    }
}

private var pagingControllers: [BaseVC]
{
    if categoryArray.count > 4
    {
        let verificationCodeViewController1 = ExploreCategoryVC.instantiateFromStoryboard()
        // DLog("categoryArray[0] = \(categoryArray[0])")
        verificationCodeViewController1.categoryName = categoryArray[0]
        
        let verificationCodeViewController2 = ExploreCategoryVC.instantiateFromStoryboard()
        //DLog("categoryArray[1] = \(categoryArray[1])")
        verificationCodeViewController2.categoryName = categoryArray[1]
        
        let verificationCodeViewController3 = ExploreCategoryVC.instantiateFromStoryboard()
        //DLog("categoryArray[2] = \(categoryArray[2])")
        verificationCodeViewController3.categoryName = categoryArray[2]
        
        let verificationCodeViewController4 = ExploreCategoryVC.instantiateFromStoryboard()
        //DLog("categoryArray[3] = \(categoryArray[3])")
        verificationCodeViewController4.categoryName = categoryArray[3]
        
        let verificationCodeViewController5 = ExploreCategoryVC.instantiateFromStoryboard()
        //DLog("categoryArray[4] = \(categoryArray[4])")
        verificationCodeViewController5.categoryName = categoryArray[4]
        
        return [verificationCodeViewController1, verificationCodeViewController2, verificationCodeViewController3, verificationCodeViewController4,verificationCodeViewController5]
    }
    else
    {
        return []
    }
}

struct ExploreItem1: MenuItemViewCustomizable {}
struct ExploreItem2: MenuItemViewCustomizable {}
struct ExploreItem3: MenuItemViewCustomizable {}
struct ExploreItem4: MenuItemViewCustomizable {}
struct ExploreItem5: MenuItemViewCustomizable {}

struct PagingMenuOptionExplore: PagingMenuControllerCustomizable
{
    //self.DLog("saveExploreCategoryResult = \(saveExploreCategoryResult)")
    
    var componentType: ComponentType
    {
        return .All(menuOptions: MenuOptions(), pagingControllers: pagingControllers)
    }
    var lazyLoadingPage: LazyLoadingPage {
        return .Three
    }
    struct MenuOptions: MenuViewCustomizable {
        
        var backgroundColor: UIColor {
            return UIColor.clearColor()
        }
        var selectedBackgroundColor: UIColor
        {
            return UIColor.clearColor()
            //return  UIColor(red: 70.0 / 255, green: 139.0 / 255, blue: 60.0 / 255, alpha: 1.0)
        }
        
        
        var displayMode: MenuDisplayMode {
            return .Infinite(widthMode: .Fixed(width: 60.0), scrollingMode: .ScrollEnabled)
        }
        var itemsOptions: [MenuItemViewCustomizable] {
            return [ExploreItem1(), ExploreItem2(), ExploreItem3(), ExploreItem4(),ExploreItem5()]
        }
        var focusMode: MenuFocusMode
        {
            
             return .RoundRect(radius: 0, horizontalPadding: 0, verticalPadding: 0, selectedColor: UIColor.init(colorLiteralRed: 44.0/255.0, green: 38.0/255.0, blue: 67.0/255.0, alpha: 0.8))
            //return .RoundRect(radius: 0, horizontalPadding: 8, verticalPadding: 0, selectedColor: UIColor(red: 0.0 / 255, green:0.0 / 255, blue: 0.0 / 255, alpha: 0.3))
            //return .RoundRect(radius: 0, horizontalPadding: 8, verticalPadding: 0, selectedColor: UIColor(red: 70.0 / 255, green: 139.0 / 255, blue: 60.0 / 255, alpha: 1.0))
        }
    }
    
    struct ExploreItem1: MenuItemViewCustomizable
    {
        
        //        self.DLog("artistCategoryName = \(saveExploreCategoryResult[0]    ["artistCategoryName"].stringValue)")
        //        self.DLog("artistCategoryId = \(saveExploreCategoryResult[0]["artistCategoryId"].stringValue)")
        var displayMode: MenuItemDisplayMode
        {
            let title = LibraryMenuItemText(text: categoryArray[0])//"exclusive")
            //let description = MenuItemText(text: String(self))
            return .LibraryText(title:title)
            //return .MultilineText(title: title, description: description)
        }
    }
    
    struct ExploreItem2: MenuItemViewCustomizable {
        
        var displayMode: MenuItemDisplayMode {
            let title = LibraryMenuItemText(text: categoryArray[1])// "new")
            //let description = MenuItemText(text: String(self))
            return .LibraryText(title:title)
            //return .MultilineText(title: title, description: description)
        }
    }
    
    struct ExploreItem3: MenuItemViewCustomizable {
        
        var displayMode: MenuItemDisplayMode {
            let title = LibraryMenuItemText(text: categoryArray[2])//"popular")
            //let description = MenuItemText(text: String(self))
            return .LibraryText(title:title)
            //return .MultilineText(title: title, description: description)
        }
    }
    
    struct ExploreItem4: MenuItemViewCustomizable {
        
        var displayMode: MenuItemDisplayMode {
            let title = LibraryMenuItemText(text: categoryArray[3])//"curated")
            //let description = MenuItemText(text: String(self))
            return .LibraryText(title:title)
            //return .MultilineText(title: title, description: description)
        }
    }
    
    struct ExploreItem5: MenuItemViewCustomizable {
        
        var displayMode: MenuItemDisplayMode {
            let title = LibraryMenuItemText(text: categoryArray[4])//"trending")
            //let description = MenuItemText(text: String(self))
            return .LibraryText(title:title)
            //return .MultilineText(title: title, description: description)
        }
        
    }
    
}

extension ExploreVC: UIViewControllerTransitioningDelegate {
    func animationControllerForPresentedController(
        presented: UIViewController,
        presentingController presenting: UIViewController,
                             sourceController source: UIViewController) ->
        UIViewControllerAnimatedTransitioning? {
            
            if (onOptionClickBtn.superview != nil)
            {
                transition.originFrame = onOptionClickBtn.superview!.convertRect(onOptionClickBtn!.frame, toView: nil)
            }
            transition.presenting = true
            
            return transition
            
    }
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = false
        return transition
    }
    
}

