//
//  LibraryVC.swift
//  Disctopia
//
//  Created by Damini on 28/06/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit

class UploadVC: BaseVC{
    
    
    @IBOutlet var txtDescription: UITextView!
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet var PlayViewYConstraint: NSLayoutConstraint!
    @IBOutlet var myScrollView: UIScrollView!
    var pagingMenuController : PagingMenuController! = nil
    var options: PagingMenuControllerCustomizable!
    
    @IBOutlet var libraryMenuView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        myScrollView.contentSize.height = 3000
        self.hideShowPlayView(false) // for hiding playview
        self.txtDescription.selectable = true
        self.txtDescription.dataDetectorTypes = .Link

       /*
        "if you would like to upload music,
        please visit www.disctopia.com on your desktop and/or laptop"*/
        
        
        let str1 = "if you would like to upload music,\nplease visit "
        let str2 = "www.disctopia.com"
        let str3 = " on your desktop and/or laptop"
       self.lblDescription.attributedText = self.SetDescriptionLabel(str1, second: str2, third: str3)
//        let attributedString = NSMutableAttributedString(string: "Want to learn iOS? You should visit the best source of free iOS tutorials!")
//        attributedString.addAttribute(NSLinkAttributeName, value: "https://www.hackingwithswift.com", range: NSRange(location: 19, length: 55))
//        
        
        //PlayViewYConstraint.constant = -216
        
        // Do any additional setup after loading the view.
    }
    
    class func instantiateFromStoryboard() -> UploadVC {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier(String(self)) as! UploadVC
    }
   
    override func viewWillAppear(animated: Bool)
    {
        appDelegate.isFromUpload = true

    }
    override  func viewDidLayoutSubviews()
    {
        let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC)))
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            self.loadPageMenu()
        })
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        appDelegate.isFromUpload = false
    }
   
    @IBAction func btnMostRecentPlay(sender: AnyObject)
    {
        self.hideShowPlayView(true) // for showing play view
        //PlayViewYConstraint.constant = 0
    }
    
    @IBAction func btnMostPlayedPlay(sender: AnyObject)
    {
        //PlayViewYConstraint.constant = 0
       self.hideShowPlayView(true) // for showing play view
    }
    
    func SetDescriptionLabel(first: String, second: String, third: String) -> NSAttributedString
    {
        //  let multipleAttributes = [NSForegroundColorAttributeName: UIColor.redColor(),
        //     NSFontAttributeName: UIFont(name: "Avenir Medium", size: 16.0)!]
        
     //   let textSize = self.lblDescription.font.pointSize
        
      //  let multipleAttributes = [NSFontAttributeName : UIFont.boldSystemFontOfSize(textSize)]

        
        let attributedString = NSMutableAttributedString(string: second)
        attributedString.addAttribute(NSLinkAttributeName, value: "https://www.disctopia.com", range: NSRange(location: 0, length: 17))
        

        let myAttrString1 = NSAttributedString(string: first, attributes:nil)
      //  let myAttrString2 = NSAttributedString(string: second, attributes: nil)
        let myAttrString3 = NSAttributedString(string: third, attributes: nil)
        
        let result = NSMutableAttributedString()
        
        result.appendAttributedString(myAttrString1)
        result.appendAttributedString(attributedString)
        result.appendAttributedString(myAttrString3)
        
        return result
    }

   
    func loadPageMenu()
    {
        if ( pagingMenuController == nil )
        {
            options =  PagingUploadOptionsLibrary()
            pagingMenuController = PagingMenuController(options: options)
            //let pagingMenuController = self.childViewControllers.first as! PagingMenuController
            pagingMenuController.delegate = self
            pagingMenuController.setup(options)
            self.addChildViewController(pagingMenuController)
            pagingMenuController.view.frame = CGRectMake(0, 0,libraryMenuView.frame.size.width, libraryMenuView.frame.size.height)
            pagingMenuController.view.backgroundColor = UIColor.clearColor()
            self.libraryMenuView.addSubview(pagingMenuController.view)
            //        pagingMenuController.didMoveToParentViewController(self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // for hide/show play view
    func hideShowPlayView(hideStatus : Bool)
    {
            // hide - pass false
            // show - pass true 
//        if hideStatus == true
//        {
//             PlayViewYConstraint.constant = 0
//        }
//        else
//        {
//            PlayViewYConstraint.constant = -216
//        }
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


extension UploadVC: PagingMenuControllerDelegate {
    // MARK: - PagingMenuControllerDelegate
    
    func willMoveToPageMenuController(menuController: UIViewController, previousMenuController: UIViewController)
    {
        DLog("menuController \(menuController.dynamicType)")
        if menuController.dynamicType == LibraryTracksViewController.self //MyMusicExploreVC.self
        {
            if let aMenuController = menuController as? LibraryTracksViewController
            {
                aMenuController.trackBy = TrackBy.Artist
                aMenuController.setTrackData("", isLocal: "0",isFromEditPlaylist: false)
            }
        }
        if menuController.dynamicType == LibraryAlbumsViewController.self //MyMusicExploreVC.self
        {
            if let aMenuController = menuController as? LibraryAlbumsViewController
            {
                appDelegate.isFromUpload = true
                aMenuController.syncLocalAlbums()
            }
        }
    }
    
    func didMoveToPageMenuController(menuController: UIViewController, previousMenuController: UIViewController) {
    }
    
    func willMoveToMenuItemView(menuItemView: MenuItemView, previousMenuItemView: MenuItemView) {
    }
    
    func didMoveToMenuItemView(menuItemView: MenuItemView, previousMenuItemView: MenuItemView) {
    }
}

private var pagingControllers: [BaseVC]
{
    let verificationCodeViewController1 = LibraryAlbumsViewController.instantiateFromStoryboard()
    let verificationCodeViewController2 = LibraryTracksViewController.instantiateFromStoryboard()
    
    return [verificationCodeViewController1, verificationCodeViewController2]
}

struct UploadItem1: MenuItemViewCustomizable {}
struct UploadItem2: MenuItemViewCustomizable {}

struct PagingUploadOptionsLibrary: PagingMenuControllerCustomizable {
    var componentType: ComponentType {
        return .All(menuOptions: MenuOptions(), pagingControllers: pagingControllers)
    }
    var lazyLoadingPage: LazyLoadingPage {
        return .Three
    }
    struct MenuOptions: MenuViewCustomizable
    {
        
        var backgroundColor: UIColor {
            return UIColor.clearColor()
        }
        var selectedBackgroundColor: UIColor {
            return UIColor.clearColor()
        }
        
        var displayMode: MenuDisplayMode {
            return .Standard(widthMode: .Fixed(width: UIScreen.mainScreen().bounds.width/2.49), centerItem: false, scrollingMode: .PagingEnabled)
            //return .Infinite(widthMode: .Flexible, scrollingMode: .ScrollEnabled)
        }
        
        var itemsOptions: [MenuItemViewCustomizable] {
            return [UploadItem1(), UploadItem2()]
        }
        var focusMode: MenuFocusMode {
        
            //return .RoundRect(radius: 0, horizontalPadding: 8, verticalPadding: 0, selectedColor: UIColor(red: 0.0 / 255, green:0.0 / 255, blue: 0.0 / 255, alpha: 0.3))
            return .RoundRect(radius: 0, horizontalPadding: 0, verticalPadding: 0, selectedColor: UIColor.init(colorLiteralRed: 44.0/255.0, green: 38.0/255.0, blue: 67.0/255.0, alpha: 0.8))
        }
    }
    
    struct UploadItem1: MenuItemViewCustomizable
    {
        
        var displayMode: MenuItemDisplayMode {
            let title = LibraryMenuItemText(text: "Albums")
            //let description = MenuItemText(text: String(self))
            return .LibraryText(title:title)
            //return .MultilineText(title: title, description: description)
        }
    }
    
    struct UploadItem2: MenuItemViewCustomizable {
        
        var displayMode: MenuItemDisplayMode {
            let title = LibraryMenuItemText(text: "Tracks")
            //let description = MenuItemText(text: String(self))
            return .LibraryText(title:title)
            //return .MultilineText(title: title, description: description)
        }
        
//              var menuItemText: MenuItemText {
//                  return MenuItemText(text: "tracks", color: UIColor.redColor(), selectedColor: UIColor.whiteColor(), font: UIFont.systemFontOfSize(16), selectedFont: UIFont.boldSystemFontOfSize(16))
//              }
    }
    
//    struct UploadItem2: MenuItemViewCustomizable {
//        
//        var displayMode: MenuItemDisplayMode {
//            let title = LibraryMenuItemText(text: "artists")
//            //let description = MenuItemText(text: String(self))
//            return .LibraryText(title:title)
//            //return .MultilineText(title: title, description: description)
//        }
//        
//    }
    
}

