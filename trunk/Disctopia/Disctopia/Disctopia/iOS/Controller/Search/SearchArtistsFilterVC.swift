//
//  SearchArtistsFilterVC.swift
//  Disctopia
//
//  Created by Damini on 05/07/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MediaPlayer

class SearchArtistsFilterVC: BaseVC,UITableViewDelegate,UITableViewDataSource
{

    // MARK: - Private property
    private var artists: [MPMediaItemCollection] = []
    var artistArray:[JSON] = []
    var syncArtistListArray = NSMutableArray()
    let artistAlbumCountDict = NSMutableDictionary()

    @IBOutlet weak var artistTableView: UITableView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
         BaseVC.sharedInstance.hideLoader()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SearchArtistsFilterVC.reloadTableData(_:)), name: "reloadArtistFilterTbl", object: nil)
    }
    override func viewWillAppear(animated: Bool)
    {
        //initVC()
         NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SearchArtistsFilterVC.reloadTableData(_:)), name: "reloadArtistFilterTbl", object: nil)
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
            self.artistArray.removeAll()
            self.artistTableView.reloadData()
        }

        
//        let dict = notification.object as! NSDictionary
//        txtSearchStr = dict["searchText"] as! String
//        initVC()
    }
    func  initVC()
    {
        if txtSearchStr != ""
        {
            searchArtistsFilterFromAPI()
            
        }
        self.getArtistAlbumArray()

        // Load artists
        let query = MPMediaQuery.artistsQuery()
        query.groupingType = MPMediaGrouping.AlbumArtist
        query.addFilterPredicate(MPMediaPropertyPredicate(value: MPMediaType.Music.rawValue, forProperty: MPMediaItemPropertyMediaType))
        query.addFilterPredicate(MPMediaPropertyPredicate(value: NSNumber(bool: false), forProperty: MPMediaItemPropertyIsCloudItem))
        query.addFilterPredicate(MPMediaPropertyPredicate(value: txtSearchStr, forProperty: MPMediaItemPropertyArtist, comparisonType: MPMediaPredicateComparison.Contains))
        
        if let collections = query.collections {
            self.artists = collections
        }
    }
    
    func searchArtistsFilterFromAPI()
    {
        // API : SearchArtistDetails
        var param = Dictionary<String, String>()
        param["ArtistName"] = txtSearchStr
         //param["isPurchased"] = "1"
        BaseVC.sharedInstance.printAPIURL("SearchArtistDetails", param: param)
        API.searchArtistDetails(param, aViewController: self) { (result: JSON) in
            if ( result != nil )
            {
                BaseVC.sharedInstance.DLog("#### SearchArtistDetails API Response: \(result)")
                self.artistArray = result.arrayValue
                //self.artistTableView.reloadData()
                self.syncArtist()
            }
            else
            {
                self.syncArtist()
            }
        }
    }
    
    func getArtistAlbumArray()
    {
        artistAlbumCountDict.removeAllObjects()
        // Load albums
        let albumQuery = MPMediaQuery.albumsQuery()
        albumQuery.addFilterPredicate(MPMediaPropertyPredicate(value: MPMediaType.Music.rawValue, forProperty: MPMediaItemPropertyMediaType))
        albumQuery.addFilterPredicate(MPMediaPropertyPredicate(value: NSNumber(bool: false), forProperty: MPMediaItemPropertyIsCloudItem))
        if let collections = albumQuery.collections {
            var albumsItemsArray: [MPMediaItemCollection] = collections
            for  i in 0 ..< albumsItemsArray.count
            {
                let album = albumsItemsArray[i]
                
                let artistIdStr = album.representativeItem?.artistPersistentID.description
                
                if let artistCount = artistAlbumCountDict[artistIdStr!] as? Int
                {
                    artistAlbumCountDict[artistIdStr!] = artistCount + 1
                }
                else
                {
                    artistAlbumCountDict[artistIdStr!] = 1
                }
            }
            DLog("artistAlbumCountDict = \(artistAlbumCountDict)")
        }
    }
    func syncArtist()
    {
        syncArtistListArray.removeAllObjects()
        
        //API artist list
        for i in 0 ..< artistArray.count
        {
            var tempdic = self.artistArray[i].dictionaryValue
            let artistFullName = tempdic["artistName"]!.stringValue
            var totalAlbum = "0 Album"
            
            if let albumcount = tempdic["numberOfAlbum"]?.intValue
            {
                if albumcount > 2
                {
                    totalAlbum = "\(albumcount) Albums"
                }
                else
                {
                    totalAlbum = "\(albumcount) Album"
                }
            }
            
            let dic:NSMutableDictionary = NSMutableDictionary()
            
            dic.setValue("0", forKey: "isLocal")
            dic.setValue(self.artistArray[i].rawString(), forKey: "otherData")
            // use for sorting
            dic.setValue(artistFullName, forKey: "artistFullName")
            dic.setValue(totalAlbum, forKey: "totalAlbumStr")
            dic.setValue(tempdic["user_url"]!.stringValue, forKey: "imgURL")
            syncArtistListArray.addObject(dic.mutableCopy())
        }
        
        self.artistTableView.reloadData()

        //Local Music artist list
        for  i in 0 ..< artists.count
        {
            let artist = self.artists[i]
            let dic:NSMutableDictionary = NSMutableDictionary()
            dic.setValue("1", forKey: "isLocal")
            dic.setValue(artist, forKey: "otherData")
            // use for sorting
            if let representativeItem = artist.representativeItem
            {
                let artistFullName = representativeItem.artist
                var totalAlbum = "0 Album"
                
                if let artistAlbumCount = self.artistAlbumCountDict[representativeItem.artistPersistentID.description] as? Int
                {
                    if artistAlbumCount > 2
                    {
                        totalAlbum = "\(artistAlbumCount) Albums"
                    }
                    else
                    {
                        totalAlbum = "\(artistAlbumCount) Album"
                    }
                }
                dic.setValue(artistFullName, forKey: "artistFullName")
                dic.setValue(totalAlbum, forKey: "totalAlbumStr")
                if let artwork = representativeItem.artwork
                {
                    dic.setValue(artwork, forKey: "imgURL")
                }
                else
                {
                    dic.setValue(nil, forKey: "imgURL")
                }
            }
            syncArtistListArray.addObject(dic.mutableCopy())
        }
        self.artistTableView.reloadData()
        DLog("syncArtistListArray = \(syncArtistListArray)")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    class func instantiateFromStoryboard() -> SearchArtistsFilterVC {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier(String(self)) as! SearchArtistsFilterVC
    }

    // MARK: - tableView method
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return syncArtistListArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchArtistCell", forIndexPath: indexPath) as! SearchArtistFilterTableViewCell
        
        let artistListDict = self.syncArtistListArray[indexPath.row]
        self.DLog("artistListDict \(artistListDict)")
        let isLocal = artistListDict["isLocal"] as! String
        cell.lblAlbums.text = artistListDict["totalAlbumStr"] as? String //artistListDict["totalAlbumStr"]!!.stringValue //(artistDic["totalAlbum"].intValue) Albums"

        if isLocal == "0"
        {
            var artistDic = JSON.parse(artistListDict["otherData"] as! String)
            
            cell.lblArtistName.text = artistDic["artistName"].stringValue
            let imageUrl = artistDic["user_url"].stringValue.stringByReplacingOccurrencesOfString(" ", withString: "%20")
            if imageUrl.characters.count > 0
            {
                self.getAlbumImage(imageUrl,imageView: cell.artistImage)
            }
            else
            {
                cell.artistImage.image = UIImage(named: DEFAULT_IMAGE)
            }
            
        }
        else if isLocal == "1"
        {
            cell.lblArtistName.text = artistListDict["artistFullName"] as? String
            //cell.lblAlbums.text = artistListDict["totalAlbumStr"] as? String //"\(artistListDict["totalAlbum"]!.intValue)"
            
            let otherData =  artistListDict["otherData"] as! MPMediaItemCollection
            if let representativeItem = otherData.representativeItem
            {
                if let artwork = representativeItem.artwork
                {
                    let scale = UIScreen.mainScreen().scale
                    if let image =  artwork.imageWithSize(CGSizeMake(80 * scale, 80 * scale))
                    {
                        cell.artistImage.image = image
                    }
                    else
                    {
                        cell.artistImage.image = UIImage(named: DEFAULT_IMAGE)
                    }
                    
                }
                else
                {
                    cell.artistImage.image = UIImage(named: DEFAULT_IMAGE)
                }
            }
        }
        else
        {
            cell.lblAlbums.text = "0 Album"
        }
        
//        let artistDic:JSON = artistArray[indexPath.row]
//        cell.lblArtistName.text = artistDic["artistName"].stringValue
//        cell.lblAlbums.text = "\(artistDic["numberOfAlbum"].intValue) Albums"
//        
//        
//        let imageUrl = artistDic["user_url"].stringValue.stringByReplacingOccurrencesOfString(" ", withString: "%20")
//        
//        if imageUrl.characters.count > 0
//        {
//           self.getAlbumImage(imageUrl,imageView: cell.artistImage)
//        }
//        else
//        {
//            cell.artistImage.image = UIImage(named: "dummy_img2")
//        }
        
        return cell
    }
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    {
        let footerView = UIView(frame: CGRectMake(0, 0, 1, 50))
        footerView.backgroundColor = UIColor.clearColor()
        return footerView
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        NSNotificationCenter.defaultCenter().postNotificationName("removeSearchView", object: nil)//To remove SearchForMusicVC on this Button Click

        if self.syncArtistListArray.count > 0
        {
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc : ArtistAlbumsVC = storyboard.instantiateViewControllerWithIdentifier("ArtistAlbumsVC") as! ArtistAlbumsVC
            vc.isFromLibraryArtist = false
            vc.artistAlbumDict = self.syncArtistListArray[indexPath.row] as? NSMutableDictionary
            print("\(vc.artistAlbumDict)")
            let navigationController = UINavigationController(rootViewController: vc)
            navigationController.modalPresentationStyle = .OverCurrentContext
            appDelegate.navigationController!.presentViewController(navigationController, animated: true, completion: nil)
        }
//        
//        
//        
//        if self.artistArray.count > 0
//        {
////            var artistAlbumListDict = self.artistArray[indexPath.row].dictionaryValue
////            DLog("artistId = \(artistAlbumListDict["userId"]!.stringValue)")
////            
////            appDelegate.artistListDictionary = artistAlbumListDict
//            
//            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            let vc : ArtistAlbumsVC = storyboard.instantiateViewControllerWithIdentifier("ArtistAlbumsVC") as! ArtistAlbumsVC
//            vc.isFromLibraryArtist = true
//            vc.artistAlbumDict = self.syncArtistListArray[indexPath.row] as? NSMutableDictionary
//            let navigationController = UINavigationController(rootViewController: vc)
//            navigationController.modalPresentationStyle = .OverCurrentContext
//            appDelegate.navigationController!.presentViewController(navigationController, animated: true, completion: nil)
//
//            
//            
//            // self.pushToViewControllerIfNotExistWithClassName("SearchForMusicVC", animated: true)
//            
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
