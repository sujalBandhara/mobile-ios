//
//  ArtistAlbumsVC.swift
//  Disctopia
//
//  Created by Mitesh on 18/07/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MediaPlayer
import Branch
class ArtistAlbumsVC: BaseVC,UITableViewDataSource,UITableViewDelegate
    
{
    
    var albumArray:[JSON] = []
    var localAlbumArray:[MPMediaItemCollection] = []
    var isFromLibraryArtist = false
    var artistName = ""
    var artistAlbumDict: NSMutableDictionary?
    var branchUniversalObject: BranchUniversalObject!
    
    @IBOutlet weak var lblArtistName: UILabel!
    @IBOutlet weak var imgArtistPic: UIImageView!
    @IBOutlet weak var albumTableView: UITableView!
    @IBOutlet weak var btnDoneOutlet: UIButton!
    
    @IBOutlet var btnDoneUIView: UIView!
    @IBOutlet var bottomLayoutofDoneView: NSLayoutConstraint!
    
    override func viewDidLoad()
    {
        self.navigationController?.navigationBarHidden = true
        super.viewDidLoad()
    }
    override func viewWillAppear(animated: Bool)
    {
        self.initVC()
        btnDoneOutlet.layer.borderWidth = 1.0
        btnDoneOutlet.layer.borderColor = UIColor(white: 1.0, alpha: 1).CGColor
        albumTableView.contentSize.width = 90
    }
    
    override func viewDidAppear(animated: Bool)
    {
        
        //        if (appDelegate.playerView != nil)
        //        {
        //            if (appDelegate.playerView.hidden == false)
        //            {
        //                self.bottomLayoutofDoneView.constant = 40.0
        //            }
        //            else
        //            {
        //                self.bottomLayoutofDoneView.constant = 0.0
        //            }
        //        }
        
        self.albumTableView.contentSize.width = 100
    }
    
    func  initVC()
    {
       // self.addShareAlbumBtn()
        if artistAlbumDict != nil
        {
            // isLocal = 0;
            /* otherData = "{\n  \"city\" : \"alg\",\n  \"state\" : \"CA\",\n  \"aboutMe\" : \"my story\",\n  \"contactMe\" : null,\n  \"country\" : \"US\",\n  \"totalAlbum\" : 3,\n  \"artistNameSEO\" : \"dinesh\",\n  \"middleInitial\" : null,\n  \"firstName\" : \"dinesh\",\n  \"artistCategoryId\" : null,\n  \"lastName\" : \"m\",\n  \"instagram\" : \"INS\",\n  \"userId\" : \"24ab6913-f62e-42ea-95f9-dd358490f201\",\n  \"address2\" : \"california\",\n  \"user_image\" : \"dinesh\\/color-taj-sample-colorize(1).jpg\",\n  \"dateOfBirth\" : \"1989-10-12T00:00:00\",\n  \"artistName\" : \"dinesh\",\n  \"zipCode\" : \"7896\",\n  \"twitter\" : \"TWitt\",\n  \"address1\" : \"california\",\n  \"user_url\" : \"https:\\/\\/s3-us-west-2.amazonaws.com\\/devdisctopia-audio\\/dinesh\\/color-taj-sample-colorize(1).jpg\",\n  \"inBand\" : null,\n  \"disctopiaID\" : \"D673236153\",\n  \"sex\" : null\n}"*/
            
            let isLocal = artistAlbumDict!["isLocal"] as! String
            if isLocal == "0"
            {
                var artistDict = JSON.parse(artistAlbumDict!["otherData"] as! String)
                //JSON.parse
                self.artistName = artistDict["artistName"].stringValue
                lblArtistName.text = "\(artistDict["firstName"].stringValue) \(artistDict["lastName"].stringValue)" //artistName
                let imageUrl = artistDict["user_url"].stringValue
                if  imageUrl.characters.count > 0
                {
                    self.getAlbumImage(imageUrl.stringByReplacingOccurrencesOfString(" ", withString: "%20"),imageView:imgArtistPic)
                }
                else
                {
                    imgArtistPic.image = UIImage(named: DEFAULT_IMAGE)
                }
                searchAlbumsFilterFromAPI()
            }
            else if isLocal == "1"
            {
                let otherData =  artistAlbumDict!["otherData"] as! MPMediaItemCollection
                
                if let representativeItem = otherData.representativeItem
                {
                    if let artwork = representativeItem.artwork
                    {
                        let scale = UIScreen.mainScreen().scale
                        
                        if let image =  artwork.imageWithSize(CGSizeMake(80 * scale, 80 * scale))
                        {
                            imgArtistPic.image = image
                        }
                        else
                        {
                            imgArtistPic.image = UIImage(named: DEFAULT_IMAGE)
                        }
                    }
                    else
                    {
                        imgArtistPic.image = UIImage(named: DEFAULT_IMAGE)
                    }
                    
                    lblArtistName.text = representativeItem.artist
                    
                    getLocalArtistAlbum(representativeItem.artistPersistentID.description)
                }
            }
        }
    }
    
    func getLocalArtistAlbum(artistID:String)
    {
        // Load albums
        let albumQuery = MPMediaQuery.albumsQuery()
        // Only Media type music
        albumQuery.addFilterPredicate(MPMediaPropertyPredicate(value: MPMediaType.Music.rawValue, forProperty: MPMediaItemPropertyMediaType))
        // Include iCloud item
        albumQuery.addFilterPredicate(MPMediaPropertyPredicate(value: NSNumber(bool: false), forProperty: MPMediaItemPropertyIsCloudItem))
        if let collections = albumQuery.collections {
            
            let artistAlbumCountDict = NSMutableDictionary()
            
            var albumsItemsArray: [MPMediaItemCollection] = collections
            for  i in 0 ..< albumsItemsArray.count
            {
                let album = albumsItemsArray[i]
                
                let artistIdStr = album.representativeItem?.artistPersistentID.description
                
                if (artistID == artistIdStr)
                {
                    
                    let albumIdStr = album.representativeItem?.albumPersistentID.description
                    
                    if let artistCount = artistAlbumCountDict[albumIdStr!] as? Int
                    {
                        artistAlbumCountDict[artistIdStr!] = artistCount + 1
                    }
                    else
                    {
                        artistAlbumCountDict[albumIdStr!] = 1
                        localAlbumArray.append(album)
                    }
                }
            }
            
            DLog("localAlbumArray = \(localAlbumArray)")
            self.albumTableView.reloadData()
            self.animateTable()
        }
    }
    
    func searchAlbumsFilterFromAPI()
    {
        // API : GetArtistAlbumList
        var param = Dictionary<String, String>()
        
        param["artistName"] = self.artistName
        
        //        if  let artistcategoryIdstr = appDelegate.artistListDictionary["artistCategoryId"]?.stringValue
        //        {
        //            param["artistcategoryId"] = artistcategoryIdstr
        //        }
        //        else
        //        {
        //            param["artistcategoryId"] = "0"
        //        }
        
        param["artistcategoryId"] = "0"
        
        if isFromLibraryArtist
        {
            param["isPurchased"] = "1"
        }
        else
        {
            param["isPurchased"] = "0"
        }
        
        API.getArtistAlbumList(param, aViewController: self) { (result: JSON) in
            if ( result != nil )
            {
                BaseVC.sharedInstance.DLog("#### GetArtistAlbumList API Response: \(result)")
                self.albumArray = result.arrayValue
                self.albumTableView.reloadData()
                self.animateTable()
            }
        }
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    class func instantiateFromStoryboard() -> SearchAlbumsFilterVC {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier(String(self)) as! SearchAlbumsFilterVC
    }
    // MARK: - TableView Methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let isLocal = artistAlbumDict!["isLocal"] as! String
        
        if isLocal == "0"
        {
            return albumArray.count
        }
        else if isLocal == "1"
        {
            return localAlbumArray.count
        }
        else
        {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchAlbumCell") as! SearchAlbumsFilterTableViewCell
        
        let isLocal = artistAlbumDict!["isLocal"] as! String
        
        if isLocal == "0"
        {
            let albumDic:JSON = albumArray[indexPath.row]
            
            cell.lblAlbumTitle.text =  albumDic["coverName"].stringValue
            
            let dateStr = "\(albumDic["year"].stringValue)"
            let dateArr = dateStr.componentsSeparatedByString("T")
            let date: String = dateArr[0]
            //  let time: String = dateArr[1]
            
            let aDate:String = self.convertDateFormater(date, inputDateFormate: "yyyy-MM-dd", outputDateFormate: "yyyy")
            cell.lblTags.text = "\(aDate)" // trackDic["year"].stringValue
            
            
            let imageUrl = albumDic["album_url"].stringValue.stringByReplacingOccurrencesOfString(" ", withString: "%20")
            
            if imageUrl.characters.count > 0
            {
                self.getAlbumImage(imageUrl,imageView: cell.albumImage)
            }
            else
            {
                cell.albumImage.image = UIImage(named: "dummy_img2")
            }
            
        }
        else if isLocal == "1"
        {
            let otherData =  localAlbumArray[indexPath.row]
            
            if let representativeItem = otherData.representativeItem
            {
                cell.lblAlbumTitle.text =  representativeItem.albumTitle
                
                cell.lblTags.text = ""
                
                if representativeItem.releaseDate != nil
                {
                    let aDate = self.convertDateToString(representativeItem.releaseDate!, dateformat: "yyyy")
                    cell.lblTags.text = "\(aDate)"
                }
                
                if let artwork = representativeItem.artwork
                {
                    let scale = UIScreen.mainScreen().scale
                    if let image =  artwork.imageWithSize(CGSizeMake(80 * scale, 80 * scale))
                    {
                        cell.albumImage.image = image
                    }
                    else
                    {
                        cell.albumImage.image = UIImage(named: DEFAULT_IMAGE)
                    }
                }
                else
                {
                    cell.albumImage.image = UIImage(named: DEFAULT_IMAGE)
                }
            }
        }
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        appDelegate.isFromPlaylist = false
        let isLocal = artistAlbumDict!["isLocal"] as! String
        appDelegate.dictArtistDetails = artistAlbumDict!
        if isLocal == "0"
        {
            appDelegate.dictArtistDetails.setObject("0", forKey: "isLocal")
            
            if self.albumArray.count > 0
            {
                var artistAlbumListDict = self.albumArray[indexPath.row].dictionaryValue
                DLog("albumId = \(artistAlbumListDict["albumId"]!.stringValue)")
                
                appDelegate.dictArtistDetails.setValue(artistAlbumListDict["albumId"]!.stringValue, forKey: "albumId")
                //                appDelegate.selectedAlbumId = appDelegate.dictArtistDetails["albumId"] as! String
                appDelegate.selectedAlbumId = artistAlbumListDict["albumId"]!.stringValue
                
            }
        }
        else if isLocal == "1"
        {
            let otherData =  localAlbumArray[indexPath.row]
            
            appDelegate.dictArtistDetails.setObject("1", forKey: "isLocal")
            
            if let representativeItem = otherData.representativeItem
            {
                appDelegate.dictArtistDetails.setValue(representativeItem.albumTitle!, forKey: "albumName")
                appDelegate.dictArtistDetails.setValue(representativeItem.artist!, forKey: "artistName")
                appDelegate.dictArtistDetails.setValue("", forKey: "desc")
                appDelegate.dictArtistDetails.setValue("\(representativeItem.albumPersistentID)", forKey: "albumId")
                
            }
            appDelegate.selectedAlbumId = ""
            appDelegate.dictArtistDetails.setObject(otherData, forKey: "otherData")
            DLog(otherData)
        }
        
        self.dismissViewControllerAnimated(true, completion: {
            self.pushToViewControllerIfNotExistWithClassName("AlbumDetailsVC", animated: true)
        })
    }
    
    @IBAction func btnDoneAction(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func animateTable()
    {
        albumTableView.reloadData()
        
        let cells = albumTableView.visibleCells
        let tableHeight: CGFloat = albumTableView.bounds.size.height
        
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransformMakeTranslation(0, tableHeight)
        }
        
        var index = 0
        
        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
            UIView.animateWithDuration(1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                cell.transform = CGAffineTransformMakeTranslation(0, 0);
                }, completion: nil)
            
            index += 1
        }
    }
    // Branch.io Code
    func addShareAlbumBtn()
    {
        
        
        let button = UIButton(frame: CGRect(x: 80.0, y: 210.0, width: 160.0, height: 40.0))
        button.addTarget(self, action: #selector(initiateSharing), forControlEvents: .TouchUpInside)
        button.setTitle("Share Link", forState: .Normal)
        button.center = self.view.center
        button.backgroundColor = .grayColor()
        self.view.addSubview(button)
        //Initialize a Branch Universal Object for the page the user is viewing
        
        branchUniversalObject = BranchUniversalObject(canonicalIdentifier: "item_id_12345")
        // Define the content that the object represents
        branchUniversalObject.title = "Disctopia Artist"
        branchUniversalObject.contentDescription = "Check out this awesome Artist Album  content"
        branchUniversalObject.imageUrl  =  "https://example.com/mycontent-12345.png"
        
        branchUniversalObject.addMetadataKey("isAlbum", value: "0")
        
        // Trigger a view on the content for analytics tracking
        branchUniversalObject.registerView()
        // List on Apple Spotlight
        branchUniversalObject.listOnSpotlight()
        
        
    }
    
    
    
    // This is the function to handle sharing when a user clicks the share button
    func initiateSharing() {
        // Create your link properties
        // More link properties available at https://dev.branch.io/getting-started/configuring-links/guide/#link-control-parameters
        let linkProperties = BranchLinkProperties ()
        linkProperties.feature = "sharing"
        // Show the share sheet for the content you want the user to share. A link will be automatically created and put in the message.
        branchUniversalObject.showShareSheetWithLinkProperties(linkProperties,
                                                               andShareText: "Hey friend - Checkout my new Album",
                                                               fromViewController: self,
                                                               completion: { (activityType, completed) in
                                                                if (completed)
                                                                {
                                                                    
                                                                    // This code path is executed if a successful share occurs
                                                                 }
        })
    }
    
}

    

