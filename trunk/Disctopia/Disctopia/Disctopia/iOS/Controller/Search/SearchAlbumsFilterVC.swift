//
//  SearchAlbumsFilterVC.swift
//  Disctopia
//
//  Created by Damini on 05/07/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MediaPlayer

class SearchAlbumsFilterVC: BaseVC,UITableViewDataSource,UITableViewDelegate
{

 // MARK: - Variable     
    var albumArray:[JSON] = []
     private var artists: [MPMediaItemCollection] = []
    private var albums: [MPMediaItemCollection] = []
    var syncAlbumsArray = NSMutableArray()
    var albumPersistentIDArray = NSMutableArray()
 // MARK: - Outlet
    @IBOutlet weak var albumTableView: UITableView!
    
 // MARK: - LifeCycle Method
    override func viewDidLoad()
    {
        super.viewDidLoad()
         BaseVC.sharedInstance.hideLoader()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SearchAlbumsFilterVC.reloadTableData(_:)), name: "reloadAlbumsFilterTbl", object: nil)
    }
    override func viewWillAppear(animated: Bool)
    {
        //initVC()
         NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SearchAlbumsFilterVC.reloadTableData(_:)), name: "reloadAlbumsFilterTbl", object: nil)
        self.view.backgroundColor = UIColor.clearColor()
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        BaseVC.sharedInstance.DLog("WillDisappear SearchAlbumsFilterVC")
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        BaseVC.sharedInstance.DLog("DidAppear SearchAlbumsFilterVC")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        BaseVC.sharedInstance.DLog("DidDisappear SearchAlbumsFilterVC")
    }
    
    func reloadTableData(notification: NSNotification)
    {
        if let dict = notification.object as? NSDictionary
        {
            txtSearchStr = dict["searchText"] as! String
            initVC()

        }
        else
        {
            txtSearchStr = ""
            self.albumArray.removeAll()
            self.albumTableView.reloadData()
        }
    }
    
    func  initVC()
    {
        
        if txtSearchStr != ""
        {
            searchAlbumsFilterFromAPI()
        }
        let query = MPMediaQuery.albumsQuery()
        query.addFilterPredicate(MPMediaPropertyPredicate(value: MPMediaType.Music.rawValue, forProperty: MPMediaItemPropertyMediaType))
        query.addFilterPredicate(MPMediaPropertyPredicate(value: NSNumber(bool: false), forProperty: MPMediaItemPropertyIsCloudItem))
        query.addFilterPredicate(MPMediaPropertyPredicate(value: txtSearchStr, forProperty: MPMediaItemPropertyAlbumTitle, comparisonType: MPMediaPredicateComparison.Contains))
        
        if let collections = query.collections {
            self.albums = collections
        }
        
        let queryArtist = MPMediaQuery.artistsQuery()
        queryArtist.groupingType = MPMediaGrouping.AlbumArtist
        queryArtist.addFilterPredicate(MPMediaPropertyPredicate(value: MPMediaType.Music.rawValue, forProperty: MPMediaItemPropertyMediaType))
        queryArtist.addFilterPredicate(MPMediaPropertyPredicate(value: NSNumber(bool: false), forProperty: MPMediaItemPropertyIsCloudItem))
        queryArtist.addFilterPredicate(MPMediaPropertyPredicate(value: txtSearchStr, forProperty: MPMediaItemPropertyArtist, comparisonType: MPMediaPredicateComparison.Contains))
        
        if let collections = queryArtist.collections
        {
            self.artists = collections
        }
        
    }
    func searchAlbumsFilterFromAPI()
    {
        // API : SearchTrackDetails
        var param = Dictionary<String, String>()
        param["AlbumName"] = txtSearchStr
        API.searchAlbumDetails(param, aViewController: self) { (result: JSON) in
            if ( result != nil )
            {
                BaseVC.sharedInstance.DLog("#### searchAlbumDetails API Response: \(result)")
                self.albumArray = result.arrayValue
                self.syncAlbumsData()
            }
            else
            {
                self.syncAlbumsData()
            }
        }
    }
    func syncAlbumsData()
    {
        syncAlbumsArray.removeAllObjects()
        
        //API Albums list
        for i in 0 ..< albumArray.count
        {
            var tempdic = self.albumArray[i].dictionaryValue
            let dateStr = "\(tempdic["year"]!.stringValue)"
            let dateArr = dateStr.componentsSeparatedByString("T")
            let date: String = dateArr[0]
            let aDate:String = self.convertDateFormater(date, inputDateFormate: "yyyy-MM-dd", outputDateFormate: " yyyy")
            
            let dic:NSMutableDictionary = NSMutableDictionary()
            dic.setValue("0", forKey: "isLocal")
            dic.setValue(self.albumArray[i].rawString(), forKey: "otherData")
           
            // use for sorting
            dic.setValue(tempdic["coverName"]!.stringValue, forKey: "albumName")
            dic.setValue(aDate, forKey: "year")
            dic.setValue(tempdic["albumId"]!.stringValue, forKey: "albumId")
            dic.setValue(tempdic["album_url"]!.stringValue, forKey: "imgURL")
           
            syncAlbumsArray.addObject(dic.mutableCopy())
        }
         self.albumTableView.reloadData()
        
        
        //Local Music album list
        for  i in 0 ..< albums.count
        {
            albumPersistentIDArray.removeAllObjects()
            let album = self.albums[i]
            let dic:NSMutableDictionary = NSMutableDictionary()
            dic.setValue("1", forKey: "isLocal")
            dic.setValue(album, forKey: "otherData")
            
            if let representativeItem = album.representativeItem
            {
                let albumName = representativeItem.albumTitle
                let albumPersistentID = "\(representativeItem.albumPersistentID)"
                
                albumPersistentIDArray.addObject(albumPersistentID)
                
                let tagsStr = representativeItem.genre
                let releaseDate = representativeItem.releaseDate
               
                var desc = ""
                if releaseDate != nil
                {
                    if let tagsStr = representativeItem.genre
                    {
                        desc = "\(tagsStr)-\(releaseDate)"
                    }
                    else
                    {
                        desc = "\(tagsStr)"
                    }
                }
                else
                {
                    if let tagsStr = representativeItem.genre
                    {
                        desc = "\(tagsStr)"
                    }
                    
                }
                dic.setValue(albumName, forKey: "albumName")
                dic.setValue(desc, forKey: "desc")
                dic.setValue(albumPersistentID, forKey: "albumId")
            }
            syncAlbumsArray.addObject(dic.mutableCopy())
        }
        //Local Music artist list
        for  i in 0 ..< artists.count
        {
            let album = self.artists[i]
            let dic:NSMutableDictionary = NSMutableDictionary()
            dic.setValue("1", forKey: "isLocal")
            dic.setValue(album, forKey: "otherData")
            
            if let representativeItem = album.representativeItem
            {
               
                let albumPersistentID: String = "\(representativeItem.albumPersistentID)"
                if albumPersistentIDArray.containsObject(albumPersistentID)
                {
                    
                }
                else
                {
                    let albumName = representativeItem.albumTitle
                    let tagsStr = representativeItem.genre
                    let releaseDate = representativeItem.releaseDate
                    var desc = ""
                    if releaseDate != nil
                    {
                        if let tagsStr = representativeItem.genre
                        {
                            desc = "\(tagsStr)-\(releaseDate)"
                        }
                        else
                        {
                            desc = "\(tagsStr)"
                        }
                    }
                    else
                    {
                        if let tagsStr = representativeItem.genre
                        {
                            desc = "\(tagsStr)"
                        }
                    }
                    dic.setValue(albumName, forKey: "albumName")
                    dic.setValue(desc, forKey: "desc")
                    dic.setValue(albumPersistentID, forKey: "albumId")
                    syncAlbumsArray.addObject(dic.mutableCopy())
                }
            }
        }

        self.albumTableView.reloadData()
        DLog("syncAlbumsArray = \(syncAlbumsArray)")
    }
   
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    class func instantiateFromStoryboard() -> SearchAlbumsFilterVC
    {
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
        return syncAlbumsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchAlbumCell") as! SearchAlbumsFilterTableViewCell
        
        let albumListDict = self.syncAlbumsArray[indexPath.row]
       
        let isLocal = albumListDict["isLocal"] as! String
        
        if isLocal == "0"
        {
            var albumDic = JSON.parse(albumListDict["otherData"] as! String)
            let dateStr = "\(albumDic["year"].stringValue)"
            let dateArr = dateStr.componentsSeparatedByString("T")
            let date: String = dateArr[0]
            //  let time: String = dateArr[1]
            let aDate:String = self.convertDateFormater(date, inputDateFormate: "yyyy-MM-dd", outputDateFormate: " yyyy")
           
            cell.lblAlbumTitle.text =  albumDic["coverName"].stringValue
            cell.lblTags.text = "\(aDate)"
            
            let imageUrl = albumDic["album_url"].stringValue.stringByReplacingOccurrencesOfString(" ", withString: "%20")
            if imageUrl.characters.count > 0
            {
                self.getAlbumImage(imageUrl,imageView: cell.albumImage)
            }
            else
            {
                cell.albumImage.image = UIImage(named:DEFAULT_IMAGE)
            }
        }
        else if isLocal == "1"
        {
            let otherData =  albumListDict["otherData"] as! MPMediaItemCollection
            
            if let representativeItem = otherData.representativeItem
            {
                cell.lblAlbumTitle.text =  representativeItem.albumTitle
                let releaseDate = representativeItem.releaseDate
                if releaseDate != nil
                {
                    cell.lblTags.text = "\(representativeItem.releaseDate)"
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
                    
                } else
                {
                    cell.albumImage.image = UIImage(named: DEFAULT_IMAGE)
                }
            }
        }
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if self.syncAlbumsArray.count > 0
        {
            let artistAlbumListDict = self.syncAlbumsArray[indexPath.row]
            appDelegate.isFromPlaylist = false
            
            let isLocal = artistAlbumListDict["isLocal"] as! String
            let albumId = artistAlbumListDict["albumId"] as! String
            if isLocal == "0"
            {
                appDelegate.selectedAlbumId = albumId
            }
            else if isLocal == "1"
            {
                let otherData =  artistAlbumListDict["otherData"] as! MPMediaItemCollection
                if let representativeItem = otherData.representativeItem
                {
                    appDelegate.dictArtistDetails.setValue(representativeItem.albumTitle!, forKey: "albumName")
                    appDelegate.dictArtistDetails.setValue(representativeItem.artist!, forKey: "artistName")
                    appDelegate.dictArtistDetails.setValue("", forKey: "desc")
                    appDelegate.dictArtistDetails.setValue("\(representativeItem.albumPersistentID)", forKey: "albumId")
                    appDelegate.dictArtistDetails.setObject(otherData, forKey: "otherData")
                }
                appDelegate.selectedAlbumId = ""
            }
            
            appDelegate.isFromPlaylist = false
            appDelegate.dictArtistDetails.setObject(isLocal, forKey: "isLocal")
            appDelegate.dictArtistDetails = artistAlbumListDict as! NSMutableDictionary
            self.pushToViewControllerIfNotExistWithClassName("AlbumDetailsVC", animated: true)
        }
    }
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    {
        let footerView = UIView(frame: CGRectMake(0, 0, 1, 50))
        footerView.backgroundColor = UIColor.clearColor()
        return footerView
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


