//
//  HelpVC.swift
//  Disctopia
//
//  Created by Trainee02 on 26/07/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit
import SwiftyJSON

class HelpVC: BaseVC,CollapseClickDelegate,UITextFieldDelegate
{
    @IBOutlet weak var myCollapseClick: CollapseClick!
    
    var helpArray : [JSON] = []
    
    @IBOutlet var test1View: UIView!
    @IBOutlet var test2View: UIView!
    @IBOutlet var test3View: UIView!
    @IBOutlet var test4View: UIView!
    @IBOutlet var test5View: UIView!
    @IBOutlet var test6View: UIView!
    @IBOutlet var test7View: UIView!
    @IBOutlet var test8View: UIView!
    @IBOutlet var test9View: UIView!
    @IBOutlet var test10View: UIView!
    @IBOutlet var test11View: UIView!
    @IBOutlet var test12View: UIView!
    @IBOutlet var test13View: UIView!
    
    @IBOutlet var web1View: UIWebView!
    @IBOutlet var web2View: UIWebView!
    @IBOutlet var web3View: UIWebView!
    @IBOutlet var web4View: UIWebView!
    @IBOutlet var web5View: UIWebView!
    @IBOutlet var web6View: UIWebView!
    @IBOutlet var web7View: UIWebView!
    @IBOutlet var web8View: UIWebView!
    @IBOutlet var web9View: UIWebView!
    @IBOutlet var web10View: UIWebView!
    @IBOutlet var web11View: UIWebView!
    @IBOutlet var web12View: UIWebView!
    @IBOutlet var web13View: UIWebView!
    
    
    
    @IBOutlet var btnOptions: UIButton!
    @IBOutlet var btnBack: UIButton!
    
    let duration    = 1.0
    var presenting  = true
    var originFrame = CGRect.zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.btnOptions.exclusiveTouch = true
        self.btnBack.exclusiveTouch = true

        myCollapseClick.CollapseClickDelegate = self
        // If you want a cell open on load, run this method:
        //myCollapseClick!.openCollapseClickCellAtIndex(0, animated: false)

        help()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        test1View.frame = CGRectMake(0, test1View.y, test1View.width, 800)
        test2View.frame = CGRectMake(0, test2View.y, test2View.width, 190)
        test3View.frame = CGRectMake(0, test3View.y, test3View.width, 260)
        test6View.frame = CGRectMake(0, test6View.y, test6View.width, 525)
        test7View.frame = CGRectMake(0, test7View.y, test7View.width, 465)
        test8View.frame = CGRectMake(0, test8View.y, test8View.width, 600)
        test12View.frame = CGRectMake(0, test12View.y, test12View.width, 260)
    }
    //MARK: - Help API -
    func help()
    {
        API.help(self, completionHandler: { (result:JSON) in
            
            if result != nil {
                
                //print("Result = \(result)")
                
                if result["articles"].count > 0
                {
                    self.helpArray = result["articles"].arrayValue
                    
                    self.myCollapseClick.reloadCollapseClick()
                }
            }
        })
    }
    
    // The output below is limited by 1 KB.
    // Please Sign Up (Free!) to remove this limitation.
    
    // MARK: - Collapse Click Delegate
    // Required Methods
    
    func numberOfCellsForCollapseClick() -> NSInteger {
        return 13
    }
    
    func titleForCollapseClickAtIndex(index: NSInteger) -> String {
        switch index {
        case 0:
            return self.helpArray[index]["name"].stringValue
        case 1:
            return self.helpArray[index]["name"].stringValue
        case 2:
            return self.helpArray[index]["name"].stringValue
        case 3:
            return self.helpArray[index]["name"].stringValue
        case 4:
            return self.helpArray[index]["name"].stringValue
        case 5:
            return self.helpArray[index]["name"].stringValue
        case 6:
            return self.helpArray[index]["name"].stringValue
        case 7:
            return self.helpArray[index]["name"].stringValue
        case 8:
            return self.helpArray[index]["name"].stringValue
        case 9:
            return self.helpArray[index]["name"].stringValue
        case 10:
            return self.helpArray[index]["name"].stringValue
        case 11:
            return self.helpArray[index]["name"].stringValue
        case 12:
            return self.helpArray[index]["name"].stringValue
        default:
            return ""
        }
        
    }
    
    func viewForCollapseClickContentViewAtIndex(index: NSInteger) ->
        UIView? {
            switch index {
            case 0:
                return test1View!
            case 1:
                return test2View!
            case 2:
                return test3View!
            case 3:
                return test4View!
            case 4:
                return test5View!
            case 5:
                return test6View!
            case 6:
                return test7View!
            case 7:
                return test8View!
            case 8:
                return test9View!
            case 9:
                return test10View!
            case 10:
                return test11View!
            case 11:
                return test12View!
            case 12:
                return test13View!
            default:
                return test1View!
            }
    }
    
    // Optional Methods
    
    func colorForCollapseClickTitleViewAtIndex(index: NSInteger) -> UIColor {
        return UIColor(red: 239 / 255.0, green: 239 / 255.0, blue: 239 / 255.0, alpha: 1.0)
    }
    
    func colorForTitleLabelAtIndex(index: NSInteger) -> UIColor {
        
        return UIColor(red: 139 / 255.0, green: 131 / 255.0, blue: 134 / 255.0, alpha: 1.0)
    }
    
    func colorForTitleArrowAtIndex(index: NSInteger) -> UIColor {
        return UIColor(white: 0.0, alpha: 0.25)
    }
    
    func didClickCollapseClickCellAtIndex(index: NSInteger, isNowOpen open: Bool) {
       // print("\(index) and it's open:\(open ? "YES" : "NO")")
        
        //var plainText : String = ""
        
        let htmlText : String = self.helpArray[index]["body"].stringValue
//        {
//            plainText = htmlText.html2String
//        }
        
        if index == 0 {
            //self.txt1View.text = plainText
            web1View.loadHTMLString(htmlText, baseURL: nil)
        }
        else if index == 1 {
            //self.txt2View.text = plainText
            web2View.loadHTMLString(htmlText, baseURL: nil)
        }
        else if index == 2 {
            //self.txt3View.text = plainText
            web3View.loadHTMLString(htmlText, baseURL: nil)
        }
        else if index == 3 {
            //self.txt4View.text = plainText
            web4View.loadHTMLString(htmlText, baseURL: nil)
        }
        else if index == 4 {
            //self.txt5View.text = plainText
            web5View.loadHTMLString(htmlText, baseURL: nil)
        }
        else if index == 5 {
            //self.txt6View.text = plainText
            web6View.loadHTMLString(htmlText, baseURL: nil)
        }
        else if index == 6 {
            //self.txt7View.text = plainText
            web7View.loadHTMLString(htmlText, baseURL: nil)
        }
        else if index == 7 {
            //self.txt8View.text = plainText
            web8View.loadHTMLString(htmlText, baseURL: nil)
        }
        else if index == 8 {
            //self.txt9View.text = plainText
            web9View.loadHTMLString(htmlText, baseURL: nil)
        }
        else if index == 9 {
            //self.txt10View.text = plainText
            web10View.loadHTMLString(htmlText, baseURL: nil)
        }
        else if index == 10 {
            //self.txt11View.text = plainText
            web11View.loadHTMLString(htmlText, baseURL: nil)
        }
        else if index == 11 {
            //self.txt12View.text = plainText
            web12View.loadHTMLString(htmlText, baseURL: nil)
        }
        else if index == 12 {
            //self.txt13View.text = plainText
            web13View.loadHTMLString(htmlText, baseURL: nil)
        }
    }
    // MARK: - TextField Delegate for Demo
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Example of change content view frame and then update collapseClick layout.
    
    @IBAction func buttonClicked(sender: AnyObject) {
        test1View.frame = CGRectMake(0, 0, test1View.frame.size.width, test1View.frame.size.height + 50)
        myCollapseClick!.setNeedsLayout()
    }
    
    @IBAction func backButtonTapped(sender: AnyObject) {
        
        appDelegate.navigationController!.popViewControllerAnimated(true)
        //self.pushToViewControllerIfNotExistWithClassName("MyMusicPlaylistVC", animated: true)
    }
    
    @IBAction func optionButtonTapped(sender: AnyObject) {
        
        let herbDetails = storyboard!.instantiateViewControllerWithIdentifier("OptionMenuVC") as! OptionMenuVC
        herbDetails.view.translatesAutoresizingMaskIntoConstraints = false;
        //presentViewController(herbDetails, animated: true, completion: nil)
        
        herbDetails.beginAppearanceTransition(true, animated: true)
        self.cycleFromViewController(self, toViewController: herbDetails)
        herbDetails.endAppearanceTransition()
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
        
        UIView.animateKeyframesWithDuration(0.5, delay: 0.0, options: UIViewKeyframeAnimationOptions.CalculationModeCubic , animations: {
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

}

/*
class HelpVC: BaseVC, UITableViewDelegate, UITableViewDataSource     {

    let duration    = 1.0
    var presenting  = true
    var originFrame = CGRect.zero
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var btnOptions: UIButton!
    @IBOutlet var btnBack: UIButton!
    
    struct Section {
        var name: String!
        var items: [String]!
        var collapsed: Bool!
        
        init(name: String, items: [String], collapsed: Bool = true) {
            self.name = name
            self.items = items
            self.collapsed = collapsed
        }
    }

     var sections = [Section]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.originFrame = CGRectMake(self.btnOptions.frame.origin.x, self.btnOptions.frame.origin.y, self.btnOptions.frame.width, self.btnOptions.frame.height)
        
        sections = [
            Section(name: "How do i reset my password?", items: ["Lorem ipsum dolor sit amet, in dolorum meliore postulant nec, ne vidit nihil sis,pri prompta definesbas eu, sint conclusionemque ut enum."]),
            Section(name: "How do i reset my password?", items: ["Lorem ipsum dolor sit amet, in dolorum meliore postulant nec, ne vidit nihil sis,pri prompta definesbas eu, sint conclusionemque ut enum."]),
            Section(name: "How do i reset my password?", items: ["Lorem ipsum dolor sit amet, in dolorum meliore postulant nec, ne vidit nihil sis,pri prompta definesbas eu, sint conclusionemque ut enum."]),
            Section(name: "How do i reset my password?", items: ["Lorem ipsum dolor sit amet, in dolorum meliore postulant nec, ne vidit nihil sis,pri prompta definesbas eu, sint conclusionemque ut enum."]),
            Section(name: "How do i reset my password?", items: ["Lorem ipsum dolor sit amet, in dolorum meliore postulant nec, ne vidit nihil sis,pri prompta definesbas eu, sint conclusionemque ut enum."]),
            Section(name: "How do i reset my password?", items: ["Lorem ipsum dolor sit amet, in dolorum meliore postulant nec, ne vidit nihil sis,pri prompta definesbas eu, sint conclusionemque ut enum."])
        ]
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        BaseVC.sharedInstance.DLog("WillAppear MenuVC")
        
        for subview: UIView in self.view!.subviews
        {
            if subview.tag == 100
            {
                subview.removeFromSuperview()
            }
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MenuVC.methodOfReceivedNotification1(_:)), name:"NotificationIdentifier1", object: nil)//OptionMenuVC to SearchForMusicVC
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MenuVC.methodOfReceivedNotification2(_:)), name:"NotificationIdentifier2", object: nil)//SearchForMusicVC to OptionMenuVC
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        BaseVC.sharedInstance.DLog("WillDisappear MenuVC")
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        BaseVC.sharedInstance.DLog("DidAppear MenuVC")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        BaseVC.sharedInstance.DLog("DidDisappear MenuVC")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (sections[section].collapsed!) ? 0 : sections[section].items.count
    }
    
//   func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        if indexPath.section == 0 {
//            return tableView.rowHeight
//        }
//        
//        // Calculate the real section index and row index
//        let section = getSectionIndex(indexPath.row)
//        let row = getRowIndex(indexPath.row)
//        
//        // Header has fixed height
//        if row == 0 {
//            return 50.0
//        }
//        
//        return sections[section].collapsed! ? 0 : 44.0
//    }

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = tableView.dequeueReusableCellWithIdentifier("Question") as! HelpTableViewCell
        
        header.btnExpand.tag = section
        header.lblQuestion.text = sections[section].name
        //header.btnExpand.rotate(sections[section].collapsed! ? 0.0 : CGFloat(M_PI_2))
        header.btnExpand.addTarget(self, action: #selector(HelpVC.toggleCollapse), forControlEvents: .TouchUpInside)
        
        if sections[section].collapsed == true {
            header.btnExpand.setImage(UIImage(named: "left_button.png"), forState: UIControlState.Normal)
        }else {
            header.btnExpand.setImage(UIImage(named: "down_button.png"), forState: UIControlState.Normal)
        }
        
        
        return header.contentView

    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCellWithIdentifier("Answer") as! HelpTableViewCell
        
        cell.textLabel?.text = sections[indexPath.section].items[indexPath.row]
        
        return cell

    }
    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        
//        let cell = tableView.cellForRowAtIndexPath(indexPath)
//        if cell!.reuseIdentifier == "Question" {
//            return 70
//        } else {// cell.reuseIdentifier == "Answer" {
//            return 130
//        }
//    }
    
    func toggleCollapse(sender: UIButton) {
        let section = sender.tag
        let collapsed = sections[section].collapsed
        
        // Toggle collapse
        sections[section].collapsed = !collapsed
        
        
        // Reload section
        tableView.reloadSections(NSIndexSet(index: section), withRowAnimation: .Automatic)
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        BaseVC.sharedInstance.DLog("\(indexPath.row) cell selected")
    }
   
    @IBAction func optionButtonTapped(sender: AnyObject) {
    
        let herbDetails = storyboard!.instantiateViewControllerWithIdentifier("OptionMenuVC") as! OptionMenuVC
        herbDetails.view.translatesAutoresizingMaskIntoConstraints = false;
        //presentViewController(herbDetails, animated: true, completion: nil)
        
        herbDetails.beginAppearanceTransition(true, animated: true)
        self.cycleFromViewController(self, toViewController: herbDetails)
        herbDetails.endAppearanceTransition()
    }
    
    @IBAction func backButtonTapped(sender: AnyObject) {
        
        appDelegate.navigationController!.popViewControllerAnimated(true)
        //self.pushToViewControllerIfNotExistWithClassName("MyMusicPlaylistVC", animated: true)
    }
    
    override func pushToViewControllerIfNotExistWithClassName(identifier: String, animated : Bool)//
    {
        let object   = appDelegate.AppStoryBoard().instantiateViewControllerWithIdentifier(identifier)
        if (appDelegate.navigationController!.viewControllers.contains(object))
        {
            // move it
            appDelegate.navigationController!.popToViewController(object, animated: animated)
        }
        else
        {
            // push it
            appDelegate.navigationController!.pushViewController(object, animated: animated)
        }
        
        // appDelegate.loadMenuController()
        
        return
        
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
        
        UIView.animateKeyframesWithDuration(0.5, delay: 0.0, options: UIViewKeyframeAnimationOptions.CalculationModeCubic , animations: {
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
 
}
 */
