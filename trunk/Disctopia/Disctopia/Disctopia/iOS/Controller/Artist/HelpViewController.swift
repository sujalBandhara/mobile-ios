//
//  HelpViewController.swift
//  Disctopia
//
//  Created by iMac03 on 03/10/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit
import SwiftyJSON

class HelpViewController: BaseVC,UITableViewDataSource,UITableViewDelegate
{
    ///
    @IBOutlet var btnOptions: UIButton!
    @IBOutlet var btnBack: UIButton!
    
    let duration    = 1.0
    var presenting  = true
    var originFrame = CGRect.zero
    ///
    
    @IBOutlet var helpView: UITableView!
    
    var helpArray : [JSON] = []
    var selectedIndex = -1
    var lastIndex = -1
    var webHeight: CGFloat = 0.0
    
    var contentHeights : [JSON] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.helpView.tableFooterView = UIView(frame: CGRectZero)
        self.originFrame = CGRectMake(self.btnOptions.frame.origin.x, self.btnOptions.frame.origin.y, self.btnOptions.frame.width, self.btnOptions.frame.height)
        help()
    }
    
    //MARK: - Help API -
    func help()
    {
         BaseVC.sharedInstance.showLoader()
        API.help(self, completionHandler: { (result:JSON) in
            
            if result != nil {
                
               // print("Result = \(result)")
                
                if result["articles"].count > 0
                {
                    self.helpArray = result["articles"].arrayValue
                    
                    self.helpView.reloadData()
                }
            }
        })
    }
    
    //MARK: - Action -
    @IBAction func labelClicked(sender:AnyObject)
    {
        let index : NSIndexPath = NSIndexPath(forRow: sender.tag, inSection: 0)
        
        if let cell = self.helpView.cellForRowAtIndexPath(index) as? webCell
        {
            if lastIndex >=  0
            {
                let index : NSIndexPath = NSIndexPath(forRow: lastIndex, inSection: 0)
                if let aCell = self.helpView.cellForRowAtIndexPath(index) as? webCell
                {
                   //let cell = (self.helpView.cellForRowAtIndexPath(index) as! webCell)
                    aCell.arrowImg.image = UIImage(named: "cal_next_arrow.png")
                }
            }
            
            if self.selectedIndex == index.row
            {
                selectedIndex = -1
                cell.arrowImg.image = UIImage(named: "cal_next_arrow.png")
            }
            else
            {
                self.selectedIndex = index.row
                lastIndex = self.selectedIndex
                cell.arrowImg.image = UIImage(named: "cal_down_arrow.png")
            }
            
            helpView.beginUpdates()
            helpView.reloadRowsAtIndexPaths([index], withRowAnimation: .Automatic)
            helpView.endUpdates()
        }
    }
    
    @IBAction func buttonClicked(sender: AnyObject) {
        //test1View.frame = CGRectMake(0, 0, test1View.frame.size.width, test1View.frame.size.height + 50)
        //myCollapseClick!.setNeedsLayout()
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

    //MARK: - Tableview Methods -
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.helpArray.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        var helpDict : [String:JSON] = [:]
        helpDict = self.helpArray[indexPath.row].dictionaryValue
        
        if self.selectedIndex == indexPath.row
        {
            if helpDict["height"] != nil
            {
                //print("helpDict[height] \(CGFloat(helpDict["height"]!.floatValue))")
                return CGFloat(60+helpDict["height"]!.floatValue)
            }
            //return helpArray[indexPath.row]
        }
        return 40.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("webCell") as! webCell
        
        var helpDict : [String:JSON] = [:]
        helpDict = self.helpArray[indexPath.row].dictionaryValue
        var htmlString = helpDict["body"]!.stringValue
        
        
        
        htmlString = "<font face='Open Sans' size='3.0' color='#8B8386'>\(htmlString)"
      //  webView.loadHTMLString(htmlString, baseURL: nil)
        
        cell.helpLabel.text = helpDict["name"]!.stringValue
        cell.helpDetailView.tag = indexPath.row
        
        //if helpDict["height"] == nil
        //{
            cell.helpDetailView.loadHTMLString(htmlString, baseURL: nil )
            cell.helpDetailView.dataDetectorTypes = .Link
            cell.helpDetailView.userInteractionEnabled = true
        
            cell.helpDetailView.scrollView.backgroundColor = UIColor.clearColor()
            cell.helpDetailView.backgroundColor = UIColor.clearColor()
            //cell.helpDetailView.frame = CGRectMake(0, 0, cell.frame.size.width, htmlHeight)
            //cell.helpDetailView.scrollView.scrollEnabled = true
            cell.bringSubviewToFront(cell.helpDetailView)
        
        if self.selectedIndex == indexPath.row {
            cell.arrowImg.image = UIImage(named: "cal_down_arrow.png")
        }
        else{
            cell.arrowImg.image = UIImage(named: "cal_next_arrow.png")
        }
        //}
       
        cell.lblButton.addTarget(self, action: #selector(labelClicked), forControlEvents: .TouchUpInside)
        cell.lblButton.tag = indexPath.row
        
        if (cell.respondsToSelector(Selector("setPreservesSuperviewLayoutMargins:"))){
            cell.layoutMargins = UIEdgeInsetsZero
            cell.preservesSuperviewLayoutMargins = false
        }
        
        return cell
    }
    
    
    /*func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if self.selectedIndex == indexPath.row {
            selectedIndex = -1
        }
        else{
            self.selectedIndex = indexPath.row
        }
        
        tableView.beginUpdates()
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        tableView.endUpdates()
    }*/
    
    //MARK: - Webview Methods -
    func webViewDidFinishLoad(webView: UIWebView)
    {
        webView.frame.size.height = 1
        webView.frame.size = webView.sizeThatFits(CGSizeZero)
        
        //print(webView)
        //webHeight = webView.//webView.frame.size.height
        
        let index : NSIndexPath = NSIndexPath(forRow: webView.tag, inSection: 0)
        
        var helpDict : [String:JSON] = [:]
        helpDict = self.helpArray[index.row].dictionaryValue
        let result = webView.stringByEvaluatingJavaScriptFromString("document.body.offsetHeight")
        if result != nil
        {
            //print("helpDict[height] \(result)")
            helpDict["height"] = JSON(result!)
            self.helpArray[index.row] = JSON(helpDict)
            //self.helpView.reloadRowsAtIndexPaths([NSIndexPath(forRow: webView.tag, inSection: 0)], withRowAnimation: .Automatic)
            //contentHeights.append(helpDict)
        }
    }
    
    
    /*
 
 Use the Delegate to Determine the Navigation Type!
 
 My Snippet
 
 - (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
 
 
 if (navigationType == UIWebViewNavigationTypeLinkClicked){
 
 NSURL *url = request.URL;
 [self openExternalURL:url];//Handle External URL here
 
 }
 
 return YES;
 
 }
 */
    
 
    //MARK: - Animation -
    
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
