//
//  CartSummaryVC.swift
//  Disctopia
//
//  Created by Mitesh on 09/09/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class CartSummaryVC: BaseVC,UITableViewDelegate,UITableViewDataSource
{
    
    let duration    = 1.0
    var presenting  = true
    var originFrame = CGRect.zero
    
    // MARK: - Variable
    var cartArray:[JSON] = []
    
    // MARK: - Outlet
    
    @IBOutlet var tblCardDetails: UITableView!
    @IBOutlet var lblItemsInCart: UILabel!
    @IBOutlet var btnPurchaseAll: UIButton!
    
    
    // MARK: - LifeCycle Method
    override func viewDidLoad()
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "reloadShoppingCart", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "inAppSongPayment", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.viewshoppingcartData), name: "reloadShoppingCart", object: nil)
         NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CartSummaryVC.inAppPayment), name:"inAppSongPayment", object: nil)
        super.viewDidLoad()
        btnPurchaseAll.exclusiveTouch = true
        self.lblItemsInCart.text = "items in cart: 0"
    }
    
    override func viewWillAppear(animated: Bool)
    {
       // viewshoppingcartData()
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(true)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
    }
    
    // MARK: - table view method
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0
        {
            return self.cartArray.count - 1
        }
        else
        {
           
            if self.cartArray.count > 0
            {
                return 0  //return 3
            }
            else
            {
                return 0
            }
        }
    }
    
    // track id is nil then pass album id
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("CartSummaryCell", forIndexPath: indexPath) as! CartSummaryCell
        if indexPath.section == 0
        {
            cell.btnPurchase.hidden = true
            cell.imgTrack.hidden = false
            cell.btnRemove.hidden = false
            //cell.btnBuyTrack.hidden = false
            cell.btnBuyTrack.hidden = true
            //cell.btnPurchase.hidden = false
           // cell.lblDescriptionAmount.hidden = true
            cell.lblAmount.hidden = true
            cell.btnPurchase.addTarget(self, action:#selector(CartSummaryVC.btnBuyClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            cell.btnPurchase.tag = indexPath.row
            
            cell.btnRemove.addTarget(self, action:#selector(CartSummaryVC.btnRemoveClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            cell.btnRemove.tag = indexPath.row
            cell.lblTrackTitle.hidden = false
            cell.lblTrackTitle.text = self.cartArray[indexPath.row]["name"].stringValue
            
            let price = self.cartArray[indexPath.row]["iosPrice"].floatValue
            
            
            let newPrice = price

            if newPrice >= 1
            {
                cell.btnBuyTrack.setTitle("$\(newPrice)", forState: .Normal)
            }
            else
            {   cell.btnBuyTrack.setTitle("¢\(newPrice * 100)", forState: .Normal)
            }
            
            
            let imageUrl = self.cartArray[indexPath.row]["album_url"].stringValue.stringByReplacingOccurrencesOfString(" ", withString: "%20")
            if imageUrl.characters.count > 0
            {
                self.getAlbumImage(imageUrl,imageView: cell.imgTrack)
            }
            else
            {
                cell.imgTrack.image = UIImage(named: DEFAULT_IMAGE)
            }
            cell.lblArtistName.hidden = false
            cell.lblArtistName.text = self.cartArray[indexPath.row]["artistName"].stringValue
            // cell.lblPrice.text =  String(self.cartArray[indexPath.row]["price"].doubleValue)
        }
        else
        {
            cell.lblAmount.hidden = false
            cell.lblArtistName.hidden = true
            cell.imgTrack.hidden = true
            cell.btnRemove.hidden = true
            cell.btnBuyTrack.hidden = true
            cell.lblTrackTitle.hidden = true
           // cell.lblDescriptionAmount.hidden = false
            if indexPath.row == 0   // "processingFees"
            {
                //cell.lblTrackTitle.text = "SubTotal"
                //cell.lblCartTotal.text = "SubTotal:\(String(self.cartArray[self.cartArray.count - 1]["subTotal"].doubleValue))"
               // cell.lblDescriptionAmount.text = "SubTotal:  "
                cell.lblAmount.text = " $\((String(self.cartArray[self.cartArray.count - 1]["subTotal"].doubleValue)))"
                
                //\(String(self.cartArray[self.cartArray.count - 1]["subTotal"].doubleValue))  "
                
            }
            else if  indexPath.row == 1  //"subTotal"
            {
                // cell.lblTrackTitle.text = "Processing Fee"
                //cell.lblCartTotal.text =  "Processing Fee: \(String(format:"%.2f",self.cartArray[self.cartArray.count - 1]["processingFees"].doubleValue))"
               // cell.lblDescriptionAmount.text =  "Processing Fee:  "
                cell.lblAmount.text = " $\((String(format:"%.2f",self.cartArray[self.cartArray.count - 1]["processingFees"].doubleValue)))"
                
                //\(String(format:"%.2f",self.cartArray[self.cartArray.count - 1]["processingFees"].doubleValue))  "
            }
            else //"total"
            {
                //  cell.lblTrackTitle.text =  "Total"
                //cell.lblCartTotal.text = "Total:\(String(format:"%.2f",self.cartArray[self.cartArray.count - 1]["total"].doubleValue))"
               // cell.lblDescriptionAmount.text = "Total:  "
                cell.lblAmount.text = " $\((String(format:"%.2f",self.cartArray[self.cartArray.count - 1]["total"].doubleValue)))"
                
                
                //\(String(format:"%.2f",self.cartArray[self.cartArray.count - 1]["total"].doubleValue)) "
            }
        }
        return cell
    }
    // "processingFees" : 0.5299999999999994,
    //"subTotal" : 7.5,
    //"total" : 8.029999999999999
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(indexPath.section == 0)
        {
            return 76
        }
        else
        {
            return 35
        }
        
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 100.0
    }
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    {
        let footerView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 50))
        footerView.backgroundColor = UIColor.clearColor()
        return footerView
    }

    // MARK: - Action
    
    @IBAction func continueShopping(sender: AnyObject)
    {
        self.popToSelf(self)
    }
    
    @IBAction func checkout(sender: AnyObject)
    {
        self.btnPurchaseAll.enabled = false
        if(self.cartArray.count > 0)
        {
            
            getCreditCardList()
        }
        else
        {
            self.DAlert(ALERT_TITLE, message: "There No Song in Cart.", action: ALERT_OK, sender: self)
            self.btnPurchaseAll.enabled = true

        }
        //getCreditCardList()
        //paymentNow()
    }
    
    func checkout1()
    {
        let herbDetails = storyboard!.instantiateViewControllerWithIdentifier("ConfirmShoppingViewController") as! ConfirmShoppingViewController
        herbDetails.view.translatesAutoresizingMaskIntoConstraints = false;
        //presentViewController(herbDetails, animated: true, completion: nil)
        herbDetails.beginAppearanceTransition(true, animated: true)
        self.cycleFromViewController(self, toViewController: herbDetails)
        herbDetails.endAppearanceTransition()
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
                
                           },
                                            completion:
            {
                finished in
                newViewController.didMoveToParentViewController(self)
                
                if let aConfirmShoppingViewController = newViewController as? ConfirmShoppingViewController
                {
                    if self.cartArray.count > 0
                    {
                        aConfirmShoppingViewController.lblConfirmPrice.text =  "Purchase this track for $\(String(format:"%.2f",self.cartArray[self.cartArray.count - 1]["total"].doubleValue))?"
                    }
                    else
                    {
                        aConfirmShoppingViewController.lblConfirmPrice.text =  "Purchase this track?"
                    }
                }
        })
    }
    
    func btnRemoveClick(sender: AnyObject)
    {
        let index = sender.tag
        if self.cartArray.count > index
        {
            var id = ""
            
            let isAlbum = self.cartArray[index]["isAlbum"].boolValue
            if isAlbum
            {
                id = self.cartArray[index]["albumId"].stringValue
                self.deleteShoppingCart(id,isAlbum: isAlbum)
            }
            else
            {
                id = self.cartArray[index]["trackId"].stringValue
                self.deleteShoppingCart(id,isAlbum: isAlbum)
            }
        }
    }
    func btnBuyClick(sender: AnyObject)
    {
        let index = sender.tag
        
        if self.cartArray[index]["isAlbum"].boolValue == true
        {
            let id = self.cartArray[index]["albumId"].stringValue
            appDelegate.selectedCartId = id
            appDelegate.isAlbumCart = true
        }
        else
        {
            let id = self.cartArray[index]["cartId"].stringValue
            appDelegate.selectedCartId = id
            appDelegate.isAlbumCart = false
        }
        let price = self.cartArray[index]["iosPrice"].floatValue
        let tierStem = self.cartArray[index]["tierStem"].stringValue
        let purchaseTier = "com.disctopia.disctopia.\(tierStem)"
        
        //getInfo(purchaseTier)
        if price <= 1000.00
        {
            purchase(purchaseTier)
        }
        else
        {
            self.DAlert(ALERT_TITLE, message: "Sorry , you can not purchase this song", action: ALERT_OK, sender: self)
        }
    }
    func inAppPayment()
    {
        
        //getInfo
        // print("countryId : \(appDelegate.countryId)")
        
        var param = Dictionary<String, String>()
        
        if appDelegate.isAlbumCart
        {
            param["albumId"] = appDelegate.selectedCartId
        }
        else
        {
            param["cartId"] = appDelegate.selectedCartId
        }
        API.PaymentIOS(param, aViewController: self) { (result: JSON) in
            if ( result != nil )
            {
                BaseVC.sharedInstance.DLog("#### PaymentIOS API Response: \(result)")
                //self.DAlert(ALERT_TITLE, message: "Payment done succeessfully", action: ALERT_OK, sender: self)
                //self.tblCardDetails.reloadData()
                //self.viewshoppingcartData()
                //self.tblCardDetails.reloadData()
                self.loadThankyouScreen()
            }
        }
    }
    // MARK: - Viewshoppingcart API
    func paymentNow()
    {
        API.createPayment(nil, aViewController: self) { (result: JSON) in
            if ( result != nil )
            {
                BaseVC.sharedInstance.DLog("#### createPayment API Response: \(result)")
                self.DAlert(ALERT_TITLE, message: "Payment done succeessfully", action: ALERT_OK, sender: self)
                self.tblCardDetails.reloadData()
            }
        }
    }
    
    func viewshoppingcartData()
    {
        API.getViewshoppingcart(nil, aViewController: self) { (result: JSON) in
            if ( result != nil )
            {
                BaseVC.sharedInstance.DLog("#### getViewshoppingcart API Response: \(result)")
                self.cartArray = result.arrayValue
                if self.cartArray.count == 0
                {
                    self.lblItemsInCart.text = "items in cart: \(self.cartArray.count)"
                }
                else
                {
                    self.lblItemsInCart.text = "items in cart: \(self.cartArray.count - 1)"
                }
                
                appDelegate.shoppingCartItemCount = self.cartArray.count
                self.tblCardDetails.reloadData()
            }
        }
    }
    
    // MARK: - Addshoppingcart API
    func deleteShoppingCart(Id:String,isAlbum:Bool)
    {
        var param = Dictionary<String, String>()
        if isAlbum
        {
            param["albumid"] = Id
        }
        else
        {
            param["trackId"] = Id
        }
        API.deleteShoppingCart(param, aViewController: self) { (result: JSON) in
            if ( result != nil )
            {
                BaseVC.sharedInstance.DLog("#### deleteShoppingCart API Response: \(result)")
                self.viewshoppingcartData()
                self.tblCardDetails.reloadData()
            }
        }
    }
    func loadThankyouScreen()
    {
        let herbDetails = storyboard!.instantiateViewControllerWithIdentifier("ThankYouPurchasingVC") as! ThankYouPurchasingVC
        herbDetails.view.translatesAutoresizingMaskIntoConstraints = false;
        //presentViewController(herbDetails, animated: true, completion: nil)
        herbDetails.beginAppearanceTransition(true, animated: true)
        self.cycleFromViewController(self, toViewController: herbDetails)
        herbDetails.endAppearanceTransition()
        
//self.view.removeFromSuperview()
//        let vc : ThankYouPurchasingVC = STORY_BOARD_MAIN.instantiateViewControllerWithIdentifier("ThankYouPurchasingVC") as! ThankYouPurchasingVC
//        let navigationController = UINavigationController(rootViewController: vc)
//        navigationController.modalPresentationStyle = .OverCurrentContext
//        navigationController.navigationBarHidden = true
//        self.presentViewController(navigationController, animated: true, completion: nil)
    }

//    cartArray [{
//    "trackId" : 687,
//    "price" : 2,
//    "isAlbum" : false,
//    "id" : 687,
//    "artistName" : "NiGE HOOD",
//    "albumId" : 135,
//    "userId" : "a0c5faa2-3714-487a-810b-ef55955b1ce0",
//    "artistId" : "a8e5f4b3-17f6-4481-97cb-4e365f691f16",
//    "album_url" : "https:\/\/s3-us-west-2.amazonaws.com\/disctopia-audio\/NiGE-HOOD\/This-is-Folk-Rap\/THIS-IS-FOLK-RAP-ALBUM-COVER.png",
//    "name" : "WORLD ASHTRAY"
//}, {

    func getCreditCardList()
    {
        API.getCreditCardList2(nil,aViewController: self) { (result:JSON) in
            
            if ( result != nil )
            {
                self.btnPurchaseAll.enabled = true
                var name = ""
                for dicCardList in result.arrayValue
                {
                    name = dicCardList["name"].stringValue
                }
                if name.characters.count > 0
                {
                    self.checkout1()
                    //self.paymentNow()
                }
                else
                {
                    self.btnPurchaseAll.enabled = true
                    let vc : CreditCardRequireVC = STORY_BOARD_MAIN.instantiateViewControllerWithIdentifier("CreditCardRequireVC") as! CreditCardRequireVC
                    let navigationController = UINavigationController(rootViewController: vc)
                    navigationController.modalPresentationStyle = .OverCurrentContext
                    navigationController.navigationBarHidden = true
                    self.presentViewController(navigationController, animated: true, completion: nil)
                    //self.DAlert(ALERT_TITLE, message: "Add credit card to make payment", action: ALERT_OK, sender: self)
                    // self.pushToViewControllerIfNotExistWithClassName("SettingsMenuVC", animated: true)
                }
            }
        }
    }
}
