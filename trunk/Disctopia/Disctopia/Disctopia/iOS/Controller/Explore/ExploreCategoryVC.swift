//
//  ExploreCategoryVC.swift
//  Disctopia
//
//  Created by Damini on 06/07/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class ExploreCategoryVC: BaseVC,UICollectionViewDelegate,UICollectionViewDataSource{
    
    var categoryName = ""
    
    var exploreArray : [JSON] = []

    //@IBOutlet var collectionView: MagazineCollectionView!
    @IBOutlet var layout: MagazineLayout!

    
    @IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet var collectionViewBottomLayout: NSLayoutConstraint!
     override func viewDidLoad()
    {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "reloadCategory\(categoryName)", object: self)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ExploreCategoryVC.reloadCategory), name:"reloadCategory\(categoryName)", object: nil)
        
       
        //        let flow = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        //        flow.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        //        let width = UIScreen.mainScreen().bounds.size.width - 6
        //        flow.itemSize = CGSizeMake(width/2, width/2)
        //        flow.minimumInteritemSpacing = 0
        //        flow.minimumLineSpacing = 0
        //        self.collectionView.collectionViewLayout = flow
        
        if categoryName == "Trending"
        {
            self.layout = MagazineLayout(nibName:"MagazineLayout\(categoryName)")
        }
        else
        {
            self.layout = MagazineLayout(nibName:"MagazineLayout\(categoryName)")
        }
        self.layout.layoutView.translatesAutoresizingMaskIntoConstraints = false
        
        //self.collectionView.collectionViewLayout = self.layout
        
        // Do any additional setup after loading the view.
        self.getArtistAlbumListAPI()
        //DLog("mainScreen = \(UIScreen.mainScreen().bounds.size.width)")
        //DLog("after collectionView = \(collectionView.frame.size.width)")
        

    }
    
    override func viewWillAppear(animated: Bool)
    {
        //        let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(3.0 * Double(NSEC_PER_SEC)))
        //        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
        //
        //            // Do your task here
        //        })
        
//        if (appDelegate.minimizePlayerView != nil)
//        {
//            if (appDelegate.isMinimisePlayerVisible)
//            {
//                self.collectionViewBottomLayout.constant = MINIMIZE_PLAYER_HEIGHT
//                
//            }
//            else
//            {
//                self.collectionViewBottomLayout.constant = 0.0
//            }
//        }
    }
   
    func reloadCategory()
    {
//        if (appDelegate.minimizePlayerView != nil)
//        {
//            if (appDelegate.isMinimisePlayerVisible)
//            {
//                self.collectionViewBottomLayout.constant = MINIMIZE_PLAYER_HEIGHT
//                
//            }
//            else
//            {
//                self.collectionViewBottomLayout.constant = 0.0
//            }
//        }
        
        var param = Dictionary<String, String>()
        param["exploreid"] = self.getCategoryId(self.categoryName)
        DLog("exploreid \(self.categoryName) param = \(param)")
        appDelegate.isFromPlaylist = false
        API.getExplorer(param, aViewController: self) { (result: JSON) in
            
            if ( result != nil )
            {
                self.exploreArray = result.arrayValue
                //appDelegate.exploreArray = result.arrayObject
                //self.DLog("appDelegate.exploreArray = \(self.categoryName) count\(appDelegate.exploreArray!.count)")
                self.DLog("#### GetArtistAlbumList API Response: \(result)")
                self.layout.itemCount = Int32(self.exploreArray.count)
                //self.reloadCategory()
                self.collectionView.reloadData()
            }
        }
        /*
        self.exploreArray = self.filterExpolreArrayWithCategory(categoryName)
        DLog("exploreArray = \(self.exploreArray)")
        DLog("exploreArray count = \(self.exploreArray.count)")
        
        self.layout.itemCount = Int32(self.exploreArray.count)
        self.collectionView.reloadData()*/
    }
    
    // API : GetArtistAlbumList For Explore
    func getArtistAlbumListAPI()
    {
        self.reloadCategory()
        /*
        var param = Dictionary<String, String>()
        param["exploreid"] = self.getCategoryId(categoryName)
        DLog("param = \(param)")
        appDelegate.isFromPlaylist = false
        API.getExplorer(param, aViewController: self) { (result: JSON) in
            
            if ( result != nil )
            {
                appDelegate.exploreArray = result.arrayObject
                self.DLog("appDelegate.exploreArray = \(appDelegate.exploreArray!.count)")
                self.DLog("#### GetArtistAlbumList API Response: \(result)")
                self.layout.itemCount = Int32(self.exploreArray.count)
                //self.reloadCategory()
            }
        }
        */
        /*
        
        appDelegate.isFromPlaylist = false
        if (appDelegate.exploreArray == nil)
        {
            var param = Dictionary<String, String>()
            
            param["artistcategoryId"] = "0" //self.getCategoryId(categoryName)
            DLog("param = \(param)")
            
            API.getArtistAlbumList(param, aViewController: self) { (result: JSON) in
                
                if ( result != nil )
                {
                    appDelegate.exploreArray = result.arrayObject
                    self.DLog("appDelegate.exploreArray = \(appDelegate.exploreArray!.count)")
                    self.DLog("#### GetArtistAlbumList API Response: \(result)")
                    self.layout.itemCount = Int32(self.exploreArray.count)
                    self.reloadCategory()
                }
            }
        }
        else
        {
            self.DLog(self.filterExpolreArrayWithCategory("1").count)
            reloadCategory()
        }
         */
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    class func instantiateFromStoryboard() -> ExploreCategoryVC
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier(String(self)) as! ExploreCategoryVC
    }
    
    // MARK: - collection view method
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
         return self.exploreArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ExploreCell1", forIndexPath: indexPath) as! ExploreCategoryCollectionViewCell
            //cell.translatesAutoresizingMaskIntoConstraints = false
            if self.exploreArray.count > 0
            {
                var artistAlbumListDict = self.exploreArray[indexPath.row].dictionaryValue
                
                let timeParts = artistAlbumListDict["year"]!.stringValue.componentsSeparatedByString("-")
                
                //cell.lblCoverName.text = artistAlbumListDict["coverName"]!.stringValue
                cell.lblArtistName.text = artistAlbumListDict["artistName"]!.stringValue
                cell.lblTags.text = "\(artistAlbumListDict["tags"]!.stringValue)-\(timeParts[0])"
                
                // for isExplicit
                let lblE: UILabel! = UILabel()
                
                if artistAlbumListDict["isExplicit"] != nil
                {
                    lblE.frame.size = CGSizeMake(15, cell.lblCoverName.font.pointSize)
                    lblE.text = "E"
                    lblE.textColor = UIColor.blackColor()
                    lblE.font = UIFont(name: "OpenSans-Semibold", size: cell.lblCoverName.font.pointSize)
                    lblE.backgroundColor = UIColor.whiteColor()
                    lblE.textAlignment = .Center
                    lblE.layer.cornerRadius = 3.0
                    lblE.layer.masksToBounds = true
                    
                    if artistAlbumListDict["isExplicit"]!.stringValue == "true"
                    {
                        //cell.lblE.hidden = false
                        lblE.hidden = false
                    }
                    else
                    {
                        //cell.lblE.hidden = true
                        lblE.hidden = true
                    }
                    
                }
                
                let image = UIImage.imageWithLabel(lblE)
                

                let attachment = NSTextAttachment()
                attachment.image = image
                let attachmentString = NSAttributedString(attachment: attachment)
                let myString = NSMutableAttributedString(string: artistAlbumListDict["coverName"]!.stringValue + " ")
                myString.appendAttributedString(attachmentString)
                
                cell.lblCoverName.attributedText = myString
                
                //cell.lblE.text = "E"
                
                let imageUrl = artistAlbumListDict["coverImageUrl"]!.stringValue.stringByReplacingOccurrencesOfString(" ", withString: "%20")

                if imageUrl.characters.count > 0
                {
                    self.getExploreImage(imageUrl,imageView: cell.coverImage)
                }
                else
                {
                    cell.coverImage.image = UIImage(named: DEFAULT_IMAGE)
                }
                
            }
        
        cell.contentView.layer.cornerRadius = 2.0;
        cell.contentView.layer.borderWidth = 1.0;
        cell.contentView.layer.borderColor = UIColor.clearColor().CGColor;
        cell.contentView.layer.masksToBounds = true;
        
        cell.layer.shadowColor = UIColor.grayColor().CGColor;
        cell.layer.shadowOffset = CGSizeMake(0, 2.0);
        cell.layer.shadowRadius = 2.0;
        cell.layer.shadowOpacity = 1.0;
        cell.layer.masksToBounds = false;
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).CGPath;

       
        
        return cell

    
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        appDelegate.isSelectFromPlaylist = false
//        if self.exploreArray.count > 0
//        {
//            var artistAlbumListDict = self.exploreArray[indexPath.row].dictionaryValue
//            //appDelegate.dictArtistDetails.setObject("1", forKey: "isLocal")
//            //appDelegate.dictArtistDetails.setObject(artistAlbumListDict, forKey: "otherData")
//            appDelegate.dictArtistDetails.setObject("0", forKey: "isLocal")
//            DLog("albumId = \(artistAlbumListDict["albumId"]!.stringValue)")
//            // let albumDetailVC = AlbumDetailsVC()
//            appDelegate.selectedAlbumId = artistAlbumListDict["albumId"]!.stringValue
//            self.pushToViewControllerIfNotExistWithClassName("AlbumDetailsVC", animated: true)
//        }
//        else
//        {
//            
//        }
        
        if self.exploreArray.count > 0
        {
            BaseVC.sharedInstance.DLog("Cell \(indexPath.row) is selected")
            appDelegate.dictArtistDetails.setObject("0", forKey: "isLocal")
            let albumDic:JSON = self.exploreArray[indexPath.row]
            //let albumId = albumDic["albumId"].stringValue
            let albumId = albumDic["id"].stringValue
            appDelegate.selectedAlbumId = albumId
            appDelegate.isFromExplore = true
            self.pushToViewControllerIfNotExistWithClassName("AlbumDetailsVC", animated: true)
            //let object   = appDelegate.AppStoryBoard().instantiateViewControllerWithIdentifier("AlbumDetailsVC")
            //self.addChildViewController(object)
            //self.view.addSubview(object.view)
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        return CGSizeMake((collectionView.frame.size.width / 2) - 20, (collectionView.frame.size.width / 2) - 20)
    }
    // MARK: UICollectionViewDelegateFlowLayout
    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
//    {
//        //return CGSize(width: 200,height: 200)
//        //UIScreen.mainScreen().bounds.size.width
//        var  randomNumber = CGFloat(arc4random_uniform(2) + 1)
//        DLog("randomNumber = \(randomNumber)")
//        randomNumber = 2
//        return CGSize(width: ( UIScreen.mainScreen().bounds.size.width / randomNumber), height: (self.collectionView.frame.size.height / 3.0))//collectionView.frame.height)
//    }
//    
//    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSizeMake(0,0)  // Header size
//    }
//    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets
//    {
//        return UIEdgeInsetsMake(0, 0, 0, 0)
//    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
