//
//  LibraryAlbumViewController.swift
//  Disctopia
//
//  Created by Damini on 24/06/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import MediaPlayer

class LibraryAlbumsViewController: BaseVC,UITableViewDelegate,UITableViewDataSource
{

    @IBOutlet var lblDataAlert: UILabel!
    @IBOutlet var albumTableView: UITableView!

    var albumListArray : [JSON] = []
    
   
    var syncAlbumsDic = NSMutableArray()
    var sortAlbumArray = NSMutableArray()
    
    private var albums: [MPMediaItemCollection] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
     
        BaseVC.sharedInstance.showLoader()
        appDelegate.isLoderRequired = true
        
       
        
        self.lblDataAlert.hidden = true
        if appDelegate.isFromUpload == true
        {
            self.GetArtistAlbumListAPI()
        }
        else
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
            {
                           // Any Large Task
                            self.getAlbumsListAPI()
                            dispatch_async(dispatch_get_main_queue(),
                            {
                               // Update UI in Main thread
                            });
                        }
        }
         print("viewDidLoad LibraryAlbums")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
      
        
        print("viewWillAppear LibraryAlbums")
        
        albumTableView.delegate = self
        albumTableView.dataSource = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        albumTableView.delegate = self
        albumTableView.dataSource = self
//        if appDelegate.isFromUpload == true
//        {
//            self.GetArtistAlbumListAPI()
//        }
//        else
//        {
//                self.getAlbumsListAPI()
//        }

        print("viewDidAppear LibraryAlbums")
        
    }
    override func viewWillDisappear(animated: Bool)
    {
         print("viewWillDisappear LibraryAlbums")
        albumTableView.delegate = nil
        albumTableView.dataSource = nil
    }
    
    func syncLocalAlbums()
    {
        //syncAlbumsDic.removeAllObjects()
        if appDelegate.isFromUpload == true
        {
            self.GetArtistAlbumListAPI()
        }
        else if appDelegate.isFromUpload != true
        {
            //Local Music album list
            for  i in 0 ..< albums.count
            {
                let album = self.albums[i]
                let dic:NSMutableDictionary = NSMutableDictionary()
                dic.setValue("1", forKey: "isLocal")
                dic.setValue(album, forKey: "otherData")
                
                if let representativeItem = album.representativeItem
                {
                    let albumName = representativeItem.albumTitle
                    let artistName = representativeItem.artist
                    let albumPersistentID = "\(representativeItem.albumPersistentID)"
                    
                    let releaseDate = representativeItem.releaseDate
                    
                    var desc = ""
                    
                    if releaseDate != nil
                    {
                        let strDate = self.convertGivenDateToString(releaseDate!, dateformat: "yyyy")
                        
                        if let tagsStr = representativeItem.genre
                        {
                            desc = "\(tagsStr)-\(strDate)"
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
                    dic.setValue(artistName, forKey: "artistName")
                    dic.setValue(desc, forKey: "desc")
                    dic.setValue(albumPersistentID, forKey: "albumId")
                    
                    if let artwork = representativeItem.artwork
                    {
                        dic.setValue(artwork, forKey: "imgURL")
                    }
                    else
                    {
                        dic.setValue(nil, forKey: "imgURL")
                    }
                }
                syncAlbumsDic.addObject(dic.mutableCopy())
                sortAlbumArray.addObject(dic.mutableCopy())
            }
           
            
            let albumNameSortDescriptor = NSSortDescriptor(key: "albumName", ascending: true)
            syncAlbumsDic = NSMutableArray(array: sortAlbumArray.sortedArrayUsingDescriptors([albumNameSortDescriptor]))
            DLog("sortAlbumArray before sorted = \(sortAlbumArray)")
            DLog("syncAlbumsDic (Sorted) = \(syncAlbumsDic)")
            self.albumTableView.reloadData()
            
        }
        
    }
    
    func syncAlbums()
    {
        
        //syncAlbumsDic.removeAllObjects()
        //API Albums list
        for i in 0 ..< albumListArray.count
        {
            var tempdic = self.albumListArray[i].dictionaryValue
            let timeParts = tempdic["year"]!.stringValue.componentsSeparatedByString("-")
            
            let tagsStr = tempdic["tags"]!.stringValue
            var desc = ""
            //            self.validate(tagsStr)
            if (!tagsStr.isEmpty)
            {
                desc = "\(tagsStr)-\(timeParts[0])"
            }
            else
            {
                desc = "\(timeParts[0])"
            }
            let dic:NSMutableDictionary = NSMutableDictionary()
            dic.setValue("0", forKey: "isLocal")
            dic.setValue(self.albumListArray[i].rawString(), forKey: "otherData")
            
            // use for sorting
            dic.setValue(tempdic["coverName"]!.stringValue, forKey: "albumName")
            dic.setValue(tempdic["artistName"]!.stringValue, forKey: "artistName")
            dic.setValue(desc, forKey: "desc")
            dic.setValue(tempdic["albumId"]!.stringValue, forKey: "albumId")
            
            let albumURL_str = tempdic["album_url"]!.stringValue
            if albumURL_str.characters.count > 0
            {
                let imageUrlStr = albumURL_str.stringByReplacingOccurrencesOfString(" ", withString: "%20")
                dic.setValue(tempdic["album_url"]!.stringValue, forKey: "imgURL")
            }
            else
            {
                dic.setValue("", forKey: "imgURL")
            }
            
            syncAlbumsDic.addObject(dic.mutableCopy())
            sortAlbumArray.addObject(dic.mutableCopy())
        }
        
        let albumNameSortDescriptor = NSSortDescriptor(key: "albumName", ascending: true)
        syncAlbumsDic = NSMutableArray(array: sortAlbumArray.sortedArrayUsingDescriptors([albumNameSortDescriptor]))
        DLog("sortAlbumArray before sorted = \(sortAlbumArray)")
        DLog("syncAlbumsDic (Sorted) = \(syncAlbumsDic)")
        
        self.albumTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    class func instantiateFromStoryboard() -> LibraryAlbumsViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier(String(self)) as! LibraryAlbumsViewController
    }
    
     // MARK: - getAlbumsListAPI For Explore
    func getAlbumsListAPI()
    {
       // self.showLoader()
        appDelegate.isLoderRequired = false
        // Load albums
        let query = MPMediaQuery.albumsQuery()
        // Only Media type music
        query.addFilterPredicate(MPMediaPropertyPredicate(value: MPMediaType.Music.rawValue, forProperty: MPMediaItemPropertyMediaType))
        query.addFilterPredicate(MPMediaPropertyPredicate(value: NSNumber(bool: false), forProperty: MPMediaItemPropertyIsCloudItem))
        // Include iCloud item
        //query.addFilterPredicate(MPMediaPropertyPredicate(value: NSNumber(bool: false), forProperty: MPMediaItemPropertyIsCloudItem))
        if let collections = query.collections {
            self.albums = collections
        }

        syncAlbumsDic.removeAllObjects()
        albumListArray.removeAll()
        sortAlbumArray.removeAllObjects()
        
        self.syncLocalAlbums()

        var param = Dictionary<String, String>()
        
        param["ispurchased"] = "1"
        
        DLog("param = \(param)")
            API.getAlbumsList(param , aViewController: self) { (result: JSON) in
                         if ( result != nil )
            {
                self.albumListArray = result.arrayValue
                self.DLog("#### getAlbumsList API Response: \(result)")
                //self.albumTableView.reloadData()
                 self.syncAlbums()
            }
        }
     }
    
     // MARK: -  GetArtistAlbumListAPI For Explore
    func GetArtistAlbumListAPI()
    {
//        albumTableView.delegate = self
//        albumTableView.dataSource = self
        
        syncAlbumsDic.removeAllObjects()
        sortAlbumArray.removeAllObjects()
        
        var param = Dictionary<String, String>()
        let saveResult : JSON =  BaseVC.sharedInstance.loadJSON(Constants.userDefault.loginInfo)
        if saveResult != nil
        {
            //param["artistName"] =  saveResult["userName"].stringValue
        }
        //param["artistcategoryId"] = "0"
        
        DLog("param = \(param)")
        API.GetArtistAlbumList(param , aViewController: self) { (result: JSON) in
            if ( result != nil )
            {
                self.DLog("#### GetArtistAlbumListAPI API Response: \(result)")
                self.albumListArray = result.arrayValue
                if self.albumListArray.count == 0
                {
                    self.albumTableView.hidden = true
                    self.lblDataAlert.hidden = false
                }
                self.albumTableView.reloadData()
                 self.syncAlbums()
            }
        }
     }
    // MARK: - table view method
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        //return self.albumListArray.count
        
        if self.syncAlbumsDic.count <= 0
        {
            appDelegate.isLoderRequired = false
            BaseVC.sharedInstance.hideLoader()
           
        }
        
        return self.syncAlbumsDic.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("AlbumCell", forIndexPath: indexPath) as! LibraryAlbumsTableViewCell
        
        let albumListDict = self.syncAlbumsDic[indexPath.row]
        let isLocal = albumListDict["isLocal"] as! String
        
        cell.lblCoverName.text = albumListDict["albumName"] as? String
        cell.lblArtistName.text = albumListDict["artistName"] as? String
        cell.lblTags.text = albumListDict["desc"] as? String
        
        //isApproved
        
        if isLocal == "0"
        {
            var albumDict = JSON.parse(albumListDict["otherData"] as! String)
             let isApprove = albumDict["isApproved"].boolValue
            
                if isApprove == false
                {
                    cell.lblCoverName.textColor = UIColor.redColor()
                    cell.lblArtistName.textColor =  UIColor.redColor()
                    cell.lblTags.textColor =   UIColor.redColor()
                }
                else
                {
                    cell.lblCoverName.textColor = UIColor(red: 139/255, green: 131/255, blue: 134/255, alpha: 1)
                    cell.lblArtistName.textColor =  UIColor(red: 139/255, green: 131/255, blue: 134/255, alpha: 1)
                    cell.lblTags.textColor =   UIColor(red: 139/255, green: 131/255, blue: 134/255, alpha: 1)
                }
                
            
            // crash here  some time
            if  let imageUrlStr = albumListDict["imgURL"] as? String
            {
                let imageUrl = imageUrlStr.stringByReplacingOccurrencesOfString(" ", withString: "%20")
                if imageUrl.characters.count > 0
                {
                    self.getAlbumImage(imageUrl,imageView: cell.coverImage)
                }
                
            }
            else
            {
                cell.coverImage.image = UIImage(named: DEFAULT_IMAGE)
            }
        }
        else if isLocal == "1"
        {
            let otherData =  albumListDict["otherData"] as! MPMediaItemCollection
            
            if let representativeItem = otherData.representativeItem
            {
                if let artwork = representativeItem.artwork
                {
                    let scale = UIScreen.mainScreen().scale
                    if let image =  artwork.imageWithSize(CGSizeMake(80 * scale, 80 * scale))
                    {
                        cell.coverImage.image = image
                    }
                    else
                    {
                        cell.coverImage.image = UIImage(named: DEFAULT_IMAGE)
                    }
                    
                }
                else
                {
                    cell.coverImage.image = UIImage(named: DEFAULT_IMAGE)
                }
            }
        }
        
        if self.syncAlbumsDic.count - 1 == indexPath.row
        {
            appDelegate.isLoderRequired = false
            BaseVC.sharedInstance.hideLoader()
            
        }
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
//        if self.albumListArray.count > 0
//        {
//            var artistAlbumListDict = self.albumListArray[indexPath.row].dictionaryValue
//            DLog("albumId = \(artistAlbumListDict["albumId"]!.stringValue)")
//            appDelegate.selectedAlbumId = artistAlbumListDict["albumId"]!.stringValue
//            self.pushToViewControllerIfNotExistWithClassName("AlbumDetailsVC", animated: true)
//        }
//        if self.syncAlbumsDic.count > 0
//        {
//            let albumListDict = self.syncAlbumsDic[indexPath.row]
//            let isLocal = albumListDict["isLocal"] as! String
//            appDelegate.dictArtistDetails.setObject(isLocal, forKey: "isLocal")
//            let artistAlbumListDict = self.syncAlbumsDic[indexPath.row]
//            appDelegate.isFromPlaylist = false
//            appDelegate.dictArtistDetails = artistAlbumListDict as! NSMutableDictionary
//            appDelegate.selectedAlbumId = artistAlbumListDict["albumId"] as! String
//            self.pushToViewControllerIfNotExistWithClassName("AlbumDetailsVC", animated: true)
//        }
        
        if self.syncAlbumsDic.count > 0
        {
            let artistAlbumListDict = self.syncAlbumsDic[indexPath.row]
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
