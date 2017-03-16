//
//  LibraryArtistsViewController.swift
//  Disctopia
//
//  Created by Damini on 28/06/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import MediaPlayer

class LibraryArtistsViewController: BaseVC,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var artistTableView: UITableView!
    
    // MARK: - Private property
    private var artists: [MPMediaItemCollection] = []
    var artistListArray : [JSON] = []
    
    var syncartistListArray = NSMutableArray()
    var sortArtistListArray = NSMutableArray()

    
    
    let artistAlbumCountDict = NSMutableDictionary()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        //print("viewWillAppear LibraryArtists")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        //print("viewDidAppear LibraryArtists")
        
        
        
        self.getArtistAlbumArray()
        self.getArtistListAPI()
    }
    
    func getArtistAlbumArray()
    {
        // Load artists
        let query = MPMediaQuery.artistsQuery()
        query.groupingType = MPMediaGrouping.AlbumArtist
        // Only Media type music
        query.addFilterPredicate(MPMediaPropertyPredicate(value: MPMediaType.Music.rawValue, forProperty: MPMediaItemPropertyMediaType))
        // Include iCloud item
        query.addFilterPredicate(MPMediaPropertyPredicate(value: NSNumber(bool: false), forProperty: MPMediaItemPropertyIsCloudItem))
        
        if let collections = query.collections {
            self.artists = collections
        }

        artistAlbumCountDict.removeAllObjects()
        // Load albums
        let albumQuery = MPMediaQuery.albumsQuery()
        // Only Media type music
        albumQuery.addFilterPredicate(MPMediaPropertyPredicate(value: MPMediaType.Music.rawValue, forProperty: MPMediaItemPropertyMediaType))
        // Include iCloud item
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
    func syncLocalArtist()
    {
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
                dic.setValue(totalAlbum, forKey: "totalAlbum")
                if let artwork = representativeItem.artwork
                {
                    dic.setValue(artwork, forKey: "imgURL")
                }
                else
                {
                    dic.setValue(nil, forKey: "imgURL")
                }
            }
            syncartistListArray.addObject(dic.mutableCopy())
            sortArtistListArray.addObject(dic.mutableCopy())
        }
        
        let artistNameSortDescriptor = NSSortDescriptor(key: "firstName", ascending: true)
        syncartistListArray = NSMutableArray(array: sortArtistListArray.sortedArrayUsingDescriptors([artistNameSortDescriptor]))
        DLog("sortArtistArray before sorted = \(sortArtistListArray)")
        DLog("syncArtistDic (Sorted) = \(syncartistListArray)")
        self.artistTableView.reloadData()
      
    }
    func syncArtist()
    {
        //syncartistListArray.removeAllObjects()
        //API artist list
        for i in 0 ..< artistListArray.count
        {
            var tempdic = self.artistListArray[i].dictionaryValue
            let artistFullName = "\(tempdic["firstName"]!.stringValue) \(tempdic["lastName"]!.stringValue)"
            //let totalAlbum = "\(tempdic["totalAlbum"]!.stringValue) Albums"
            
            var totalAlbum = "0 Album"

            if let albumcount = tempdic["totalAlbum"]?.intValue
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
            dic.setValue(self.artistListArray[i].rawString(), forKey: "otherData")
            // use for sorting
            dic.setValue(artistFullName, forKey: "artistFullName")
            dic.setValue(totalAlbum, forKey: "totalAlbum")
            dic.setValue(tempdic["user_url"]!.stringValue, forKey: "imgURL")
            
            syncartistListArray.addObject(dic.mutableCopy())
            sortArtistListArray.addObject(dic.mutableCopy())
        }
        
        let artistNameSortDescriptor = NSSortDescriptor(key: "artistFullName", ascending: true)
        syncartistListArray = NSMutableArray(array: sortArtistListArray.sortedArrayUsingDescriptors([artistNameSortDescriptor]))
        DLog("sortArtistArray before sorted = \(sortArtistListArray)")
        DLog("syncArtistDic (Sorted) = \(syncartistListArray)")
         self.artistTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    class func instantiateFromStoryboard() -> LibraryArtistsViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier(String(self)) as! LibraryArtistsViewController
    }
    
    // MARK: - getArtistListAPI()
    func getArtistListAPI()
    {
        syncartistListArray.removeAllObjects()
        sortArtistListArray.removeAllObjects()
        syncLocalArtist()
        
         var param = Dictionary<String, String>()
         param["ispurchased"] = "1"

        API.getArtistList(param , aViewController: self) { (result: JSON) in
            if ( result != nil )
            {
                self.artistListArray = result.arrayValue
                
                self.DLog("#### getArtistList API Response: \(result)")
                self.syncArtist()
            }
        }
    }

    // MARK: - table view method
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.syncartistListArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("ArtistCell", forIndexPath: indexPath) as! LibraryArtistsTableViewCell
        
        let artistListDict = self.syncartistListArray[indexPath.row]
        let isLocal = artistListDict["isLocal"] as! String
        
        cell.lblArtistsName.text = artistListDict["artistFullName"] as? String
        cell.lblAlbums.text = artistListDict["totalAlbum"] as? String
        
        if isLocal == "0"
        {
            if (artistListDict["otherData"] != nil)
            {
                if let otherData = artistListDict["otherData"] as? String
                {
                    var artistDict = JSON.parse(otherData)
                    
                    DLog(" artistDict =\(artistDict)")
                    cell.lblArtistsName.text = "\(artistDict["firstName"].stringValue) \(artistDict["lastName"].stringValue)"
                    //cell.lblAlbums.text = "\(artistDict["totalAlbum"].stringValue) albums"
                    let imageUrl = artistDict["user_url"].stringValue.stringByReplacingOccurrencesOfString(" ", withString: "%20")
                    if imageUrl.characters.count > 0
                    {
                        self.getAlbumImage(imageUrl,imageView: cell.artistImage)
                    }
                    else
                    {
                        cell.artistImage.image = UIImage(named: DEFAULT_IMAGE)
                    }
                }
            }
            else
            {
                cell.lblArtistsName.text = ""
                //cell.lblAlbums.text = ""
                cell.artistImage.image = UIImage(named: DEFAULT_IMAGE)
            }
        }
        else if isLocal == "1"
        {
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
        
//        var artistListDict = self.artistListArray[indexPath.row].dictionaryValue
//        DLog(" artistListDict =\(artistListDict)")
//        cell.lblArtistsName.text = "\(artistListDict["firstName"]!.stringValue) \(artistListDict["lastName"]!.stringValue)"
//        cell.lblAlbums.text = "\(artistListDict["totalAlbum"]!.stringValue) albums"
//        let imageUrl = artistListDict["user_url"]!.stringValue.stringByReplacingOccurrencesOfString(" ", withString: "%20")
//        
//        if imageUrl.characters.count > 0
//        {
//            self.getAlbumImage(imageUrl,imageView: cell.artistImage)
//        }
//        else
//        {
//            cell.artistImage.image = UIImage(named: "black.png")
//        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if self.syncartistListArray.count > 0
        {
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc : ArtistAlbumsVC = storyboard.instantiateViewControllerWithIdentifier("ArtistAlbumsVC") as! ArtistAlbumsVC
            vc.isFromLibraryArtist = true
            vc.artistAlbumDict = self.syncartistListArray[indexPath.row] as? NSMutableDictionary
            let navigationController = UINavigationController(rootViewController: vc)
            navigationController.modalPresentationStyle = .OverCurrentContext
            appDelegate.navigationController!.presentViewController(navigationController, animated: true, completion: nil)
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
