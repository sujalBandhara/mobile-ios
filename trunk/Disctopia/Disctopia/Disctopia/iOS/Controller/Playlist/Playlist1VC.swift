
//
//  Playlist1VC.swift
//  Disctopia
//
//  Created by Damini on 12/07/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit
import MediaPlayer
import SwiftyJSON
import Crashlytics

class Playlist1VC: BaseVC
{
    var pagingMenuController : PagingMenuController! = nil
    var options: PagingMenuControllerCustomizable!
    let transition = PopAnimator()
    let duration    = 1.0
    var presenting  = true
    var originFrame = CGRect.zero
    var playlistFrame = CGRect.zero
    var deletePlaylistFrame = CGRect.zero
    var isFromSettingBtn = true
    var albumsArray = []
    var isLocal = "0"
    var aTracksVC: LibraryTracksViewController? = nil
    var playlistDict : [String : JSON]? = nil
    var PlayListDictionary : NSMutableDictionary = [:]
    
    @IBOutlet var musicView: UIView!
    @IBOutlet var lblNumberOfTracks: UILabel!
    @IBOutlet var playlistTitle: UILabel!
    @IBOutlet var btnSettingClick: UIButton!
    @IBOutlet var btnOption: UIButton!
    @IBOutlet var playlistImage: UIImageView!
    @IBOutlet var trackView: UIView!
    
    
    @IBOutlet var btnDownload: UIButton!
    
    
    @IBOutlet var trackViewBottomLayout: NSLayoutConstraint!
    override func viewDidLoad()
    {
        super.viewDidLoad()
       // btnOption.exclusiveTouch = true
        btnSettingClick.exclusiveTouch = true
//        Do any additional setup after loading the view.
//        playlistTitle.text = appDelegate.selectedPlaylistId["playlistname"]!.stringValue
//        playlistTitle.sizeToFit()
//        let imageUrl = appDelegate.selectedPlaylistId["album_url"]!.stringValue.stringByReplacingOccurrencesOfString(" ", withString: "%20")
//        
//        if imageUrl.characters.count > 0
//        {
//            self.getAlbumImage(imageUrl,imageView: playlistImage)
//        }
//        else
//        {
//            playlistImage.image = UIImage(named: "black.png")
//        }

    }
    
    // MARK: - getAllTrackByPlaylistIdAPI For Explore
    func getAllTrackByPlaylistIdAPI(playlistId: String)
    {
        if (playlistId.characters.count > 0)
        {
            var param = Dictionary<String, String>()
            
            param["playlistId"] = playlistId
            
         
            DLog("getAllTrackByPlaylistIdAPI param = \(param)")
            API.GetAllTrackByPlayListId(param, aViewController: self) { (result: JSON) in
                
                if ( result != nil )
                {
                    //self.DLog("Response for getAllTrackByPlaylistIdAPI for Playlist = \(result)")
                    //self.DLog("trackListArray  count = \(self.trackArray.count)")
                    dispatch_async(dispatch_get_main_queue()) {
                        self.lblNumberOfTracks.text = "number of tracks (\(result.arrayValue.count))"
                    }
                }
            }
        }
    }
    
    func initVC()
    {
        self.lblNumberOfTracks.text = ""
        //let isLocal =  appDelegate.selectedPlayListDictionary["isLocal"] as! String
        if self.aTracksVC != nil
        {
            if (self.playlistDict != nil) //playlistDict = API && PlayListDictionary = Local music
            {
                //btnOption.hidden = false //Option button for add and delete playlist
                // mergeImages of API song
                
                /*
                * Created Date: 16 Jan 2017 s
                * Updated Date:
                * Ticket No: PMT Task 11061 Edit Playlist: editing name of playlist
                * Description : There edit dots for edit playlist is now missing (bug)
                 You should be able to edit, but not delete, as you may want to reorder the tracks...
                 
                * Logic:
                */
                /*if (self.playlistDict!["playlistname"]!.stringValue != "Disctopia Favs") //"Favourite"
                {
                    btnOption.hidden = false
                }
                else
                {
                    btnOption.hidden = true
                }*/
                btnOption.hidden = false

                if self.playlistDict!["album_images"] != nil
                {
                    self.albumsArray = self.playlistDict!["album_images"]!.arrayObject!
                    
                    if self.albumsArray.count > 0
                    {
                        //let imageUrl1 = albumsArray[0].stringByReplacingOccurrencesOfString(" ", withString: "%20")
                        //self.setAlbumImage(imageUrl1, imageView: playlistImage, placeholderImage: DEFAULT_IMAGE)
                        self.playlistImage.image = UIImage(named: DEFAULT_IMAGE)!
                        if self.albumsArray.count > 0
                        {
                            self.mergeImages(self.albumsArray, imageHeight: Float(self.playlistImage.superview!.frame.size.height))
                        }
//                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
//                        {
//                            if self.albumsArray.count > 0
//                            {
//                                let mergedAlbumImage = self.mergeImages(self.albumsArray, imageHeight: Float(self.playlistImage.superview!.frame.size.height))
//                                dispatch_async(dispatch_get_main_queue(),
//                                    {
//                                                self.playlistImage.image = mergedAlbumImage
//                                });
//                                
////                                if let urlString = self.albumsArray[0] as? String
////                                {
////                                     self.setAlbumImage(urlString, imageView: self.playlistImage, placeholderImage: UIImage(named: DEFAULT_IMAGE)!)
////                                }
//                            }
//                            /*
//                            self.setAlbumImage(imageUrl1, imageView: UIImageView(image: image1), placeholderImage: images[0])
//                          let mergedAlbumImage = self.mergeImages(self.albumsArray, imageHeight: Float(self.playlistImage.superview!.frame.size.height))
//                            dispatch_async(dispatch_get_main_queue(),
//                                {
//                                    self.playlistImage.image = mergedAlbumImage
//                            });
//                          */
//                        }
                    }
                    else
                    {
                        playlistImage.image =  UIImage(named : DEFAULT_IMAGE)
                    }
                }
                else
                {
                    playlistImage.image =  UIImage(named : DEFAULT_IMAGE)
                }
                // set Playlist track
                if let playlistId = self.playlistDict!["playlistId"]?.int
                {
                    self.getAllTrackByPlaylistIdAPI("\(playlistId)")
                    self.DLog("playlistDict[playlistId] \(playlistId)")
                    Crashlytics.sharedInstance().setObjectValue(playlistId, forKey: "playlistId")
                    self.aTracksVC!.trackBy = TrackBy.Playlist
                    
                    self.aTracksVC!.setTrackData("\(playlistId)", isLocal: "0",isFromEditPlaylist: false)
                }
                else
                {
                     self.DLog("#### playlistDict[playlistId] ")
                }
            }
            else if self.PlayListDictionary.count > 0
            {
                btnOption.hidden = true
                if let aOtherData = self.PlayListDictionary["otherData"]
                {
                    if let playlistObj : MPMediaPlaylist = aOtherData as? MPMediaPlaylist
                    {
                        
                        var artworks = [UIImage]()
                        var ID = [UInt64]()
                        for  i in 0 ..< playlistObj.items.count
                        {
                            let id = playlistObj.items[i].albumPersistentID
                            
                            
                            if let artwork = playlistObj.items[i].artwork
                            {
                                let scale = UIScreen.mainScreen().scale
                                let img = artwork.imageWithSize(CGSizeMake(80 * scale, 80 * scale))
                                
                                if ID.contains(id)
                                {
                                }
                                else
                                {
                                    ID.append(id)
                                    if img != nil
                                    {
                                        artworks.append(img!)
                                    }
                                }
                            }
                            else
                            {
                                 self.playlistImage.image = UIImage(named: DEFAULT_IMAGE)
                            }
                        }
                        
                        if artworks.count > 0
                        {
                            self.mergeImagesLocal(artworks, imageHeightIn: Float(self.playlistImage.superview!.frame.size.height))
                        }
                        else
                        {
                            self.playlistImage.image = UIImage(named: DEFAULT_IMAGE)
                        }
                        
                        self.aTracksVC!.trackBy = TrackBy.Playlist
                        self.aTracksVC!.localTrackObjects = playlistObj
                        self.aTracksVC!.setTrackData("", isLocal: "1",isFromEditPlaylist: false)
                        self.lblNumberOfTracks.text = "number of tracks (\(playlistObj.count))"
                        /*
                         
                         //mergeImagesLocal
                         if (true) //
                         {
                         var artworks = [UIImage]()
                         for  i in 0 ..< playlistObj.items.count
                         {
                         if let artwork = playlistObj.items[i].artwork
                         {
                         let scale = UIScreen.mainScreen().scale
                         let img = artwork.imageWithSize(CGSizeMake(80 * scale, 80 * scale))
                         artworks.append(img!)
                         }
                         }
                         
                         let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(0.2 * Double(NSEC_PER_SEC)))
                         let mergeImages = self.mergeImagesLocal(artworks, imageHeightIn: Float(self.playlistImage.superview!.frame.size.height))
                         dispatch_after(dispatchTime, dispatch_get_main_queue(),
                         {
                         if (self.playlistImage.superview != nil)
                         {
                         if (artworks.count > 0)
                         {
                         self.playlistImage.image = mergeImages
                         }
                         }
                         })
                         
                         }
                         else
                         {
                         self.playlistImage.image = UIImage(named: DEFAULT_IMAGE)
                         }
                         */
                        
                        //                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
                        //                        {
                        //                            if let representativeItem = playlistObj.representativeItem
                        //                            {
                        //                                if let artwork = representativeItem.artwork
                        //                                {
                        //                                    let scale = UIScreen.mainScreen().scale
                        //                                    self.playlistImage.image = artwork.imageWithSize(CGSizeMake(80 * scale, 80 * scale))
                        //                                }
                        //                                else
                        //                                {
                        //                                    self.playlistImage.image = UIImage(named: DEFAULT_IMAGE)
                        //                                }
                        //                            }
                        //                            else
                        //                            {
                        //                                self.playlistImage.image = UIImage(named: DEFAULT_IMAGE)
                        //                            }
                        //
                        //                            dispatch_async(dispatch_get_main_queue(),
                        //
                        //                                           {
                        //                                            // set Playlist track
                        //                                            self.aTracksVC!.trackBy = TrackBy.Playlist
                        //                                            self.aTracksVC!.localTrackObjects = playlistObj
                        //                                            self.aTracksVC!.setTrackData("", isLocal: self.isLocal)
                        //                                            self.lblNumberOfTracks.text = "number of tracks (\(playlistObj.count))"
                        //                            });
                        //                        }
                    }
                }
            }
        }
       
/*
        if isLocal == "0"
        {
            if (appDelegate.selectedPlaylistId["playlistname"]!.stringValue != "Favourite")
            {
                btnOption.hidden = false
            }
            else
            {
                btnOption.hidden = true
            }
            playlistTitle.text = appDelegate.selectedPlaylistId["playlistname"]!.stringValue
            playlistTitle.sizeToFit()
            if appDelegate.selectedPlaylistId["album_images"] != nil
            {
                albumsArray = appDelegate.selectedPlaylistId["album_images"]!.arrayObject!
                playlistImage.image = mergeImages(albumsArray, imageHeight: Float(playlistImage.superview!.frame.size.height))
            }
            else
            {
                playlistImage.image =  UIImage(named : DEFAULT_IMAGE)
            }
            // let imageUrl = appDelegate.selectedPlaylistId["album_url"]!.stringValue.stringByReplacingOccurrencesOfString(" ", withString: "%20")
            //
            // if imageUrl.characters.count > 0
            // {
            //     self.getAlbumImage(imageUrl,imageView: playlistImage)
            // }
            // else
            // {
            //     playlistImage.image = UIImage(named: DEFAULT_IMAGE)
            // }
        }
        else if isLocal == "1"
        {
            btnOption.hidden = true
            if let playlistObj : MPMediaPlaylist = appDelegate.selectedPlayListDictionary["otherData"] as? MPMediaPlaylist
            {
                playlistTitle.text = ""
                if let playlistName = playlistObj.name
                {
                    playlistTitle.text = playlistName
                }
                var artworks = [UIImage]()
                for  i in 0 ..< playlistObj.items.count
                {
                    if let artwork = playlistObj.items[i].artwork
                    {
                        let scale = UIScreen.mainScreen().scale
                        let img = artwork.imageWithSize(CGSizeMake(80 * scale, 80 * scale))
                        artworks.append(img!)
                    }
                }
                if (self.playlistImage.superview != nil)
                {
                    if (artworks.count > 0)
                    {
                         dispatch_async(dispatch_get_main_queue()) {
                         self.playlistImage.image = self.mergeImagesLocal(artworks, imageHeightIn: Float(self.playlistImage.superview!.frame.size.height))
                        }
                    }
                    else
                    {
                        Crashlytics.sharedInstance().setObjectValue("artworks count 0", forKey:"issue1" )
                    }
                }
                else
                {
                    Crashlytics.sharedInstance().setObjectValue("playlistImage Not Found", forKey:"issue2" )

                }
                BaseVC.sharedInstance.DLog("playlistObj \(playlistObj)")
            }
        }
 */
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(true)
        //initVC()
        
        BaseVC.sharedInstance.DLog("WillAppear ViewController")
        
        if (appDelegate.playerView != nil)
        {
            if appDelegate.playerView.hidden == true
            {
                 self.trackViewBottomLayout.constant = -20
            }
            else
            {
                self.trackViewBottomLayout.constant = 50
            }
        }
        
        
        
        self.originFrame = self.btnSettingClick.frame
        self.playlistFrame = self.btnOption.convertRect(self.btnOption.frame, toView: self.view)
        
        for subview: UIView in self.view!.subviews
        {
            if subview.tag == 100
            {
                subview.removeFromSuperview()
            }
        }
       
        if (self.playlistDict != nil)
        {
            if let playlistId = self.playlistDict!["playlistId"]?.int
            {
                NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PlaylistVC.methodOfReceivedNotification1(_:)), name:"NotificationIdentifier1", object: nil)//OptionMenuVC to SearchForMusicVC
                
                NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PlaylistVC.methodOfReceivedNotification2(_:)), name:"NotificationIdentifier2", object: nil)//SearchForMusicVC to OptionMenuVC
                
                NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PlaylistVC.methodOfReceivedNotification3(_:)), name:"openPlaylistOption\(playlistId)", object: nil)//Open PlaylistOptionListVC on PlaylistCategoryTableViewCell3
                
               
                
                
//                if let playlistId = self.playlistDict!["playlistId"]?.int
//                {
//                    self.getAllTrackByPlaylistIdAPI("\(playlistId)")
//                    self.DLog("playlistDict[playlistId] \(playlistId)")
//                    Crashlytics.sharedInstance().setObjectValue(playlistId, forKey: "playlistId")
//                    self.aTracksVC!.trackBy = TrackBy.Playlist
//                    
//                    self.aTracksVC!.setTrackData("\(playlistId)", isLocal: "0")
//                }
//                else
//                {
//                    self.DLog("#### playlistDict[playlistId] ")
//                }

              //  NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PlaylistVC.deletePlaylistClicked(_:)), name:"deletePlaylistClicked\(playlistId)", object: nil)//Open deleteYesNoViewController when deletePlaylistClicked Clicked
                
//                NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PlaylistVC.deletePlayistOptionNoClicked(_:)), name:"deletePlayistOptionNoClicked\(playlistId)", object: nil)//Open PlaylistOptionListVC when No Clicked
//                
//                NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PlaylistVC.deletePlayistOptionYesClicked(_:)), name:"deletePlayistOptionYesClicked\(playlistId)", object: nil)//Open PlaylistOptionListVC when No Clicked
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        
        super.viewWillDisappear(true)
        DLog("WillDisappear ViewController")
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(true)
        DLog("DidAppear ViewController")
    }
    
    override func viewDidDisappear(animated: Bool)
    {
        super.viewDidDisappear(true)
        BaseVC.sharedInstance.DLog("DidDisappear ViewController")
    }
    func isButtonDownloadShow()
    {
        
    }
    /*
     * Created Date: 17 Jan 2016 S
     * Updated Date:
     * Ticket No:
     * Description : Playlists do not load or load very slowly after navigating away from area Playlists
     * Logic:
     When go to other tab and back to playlist tab new data loaded : Done
     */

    func refreshCurrentPlaylistTrack(isFromEditPlaylist : Bool)

    {
        //print("\n\n\n\n\n\n\n refreshCurrentPlaylistTrack \n\n\n\n\n\n\n\n\n")
        //self.aTracksVC!.setTrackData("\(playlistId)", isLocal: "0")
        btnDownload.hidden = true
        if (self.playlistDict != nil)
        {
                if let playlistId = self.playlistDict!["playlistId"]?.int
                {
                    //self.getAllTrackByPlaylistIdAPI("\(playlistId)")
                    self.DLog("playlistDict[playlistId] \(playlistId)")
                    Crashlytics.sharedInstance().setObjectValue(playlistId, forKey: "playlistId")
                    self.aTracksVC!.trackBy = TrackBy.Playlist
                    
                    self.aTracksVC!.setTrackData("\(playlistId)", isLocal: "0",isFromEditPlaylist: isFromEditPlaylist)
                    if self.aTracksVC!.isTrackDownloadRequired
                    {
                        self.btnDownload.hidden = false
                    }
                    else
                    {
                        self.btnDownload.hidden = true
                    }
                }
                else
                {
                    self.DLog("#### playlistDict[playlistId] ")
                }
        }
        else
        {
            self.aTracksVC!.setTrackData("", isLocal: "1",isFromEditPlaylist: false)
        }
    }
    //MARK: - Action -
    @IBAction func btnBackPlaylistTapped(sender: AnyObject)
    {
        //self.pushToViewControllerIfNotExistWithClassName("PlaylistVC", animated: true)
        self.popToSelf(self)
        appDelegate.pagingMenuController.moveToMenuPage(1, animated: true)
    }
    
    @IBAction func btnOptionTapped(sender: AnyObject)
    {
        isFromSettingBtn = true
        if (self.playlistDict != nil)
        {
            appDelegate.selectedPlaylistId = self.playlistDict!
        }
        
        let herbDetails = storyboard!.instantiateViewControllerWithIdentifier("OptionMenuVC") as! OptionMenuVC
        herbDetails.view.translatesAutoresizingMaskIntoConstraints = false;
        
        herbDetails.beginAppearanceTransition(true, animated: true)
        self.cycleFromViewController(self, toViewController: herbDetails)
        herbDetails.endAppearanceTransition()
    }
    
    @IBAction func btnTrackOptionTapped(sender: AnyObject)
    {
        //BaseVC.sharedInstance.pushToViewControllerIfNotExistWithClassName("PlaylistOptionListVC", animated: true)
        isFromSettingBtn = true
        if (self.playlistDict != nil)
        {
            appDelegate.selectedPlaylistId = self.playlistDict!
        }
        
        isFromSettingBtn = false
        
        appDelegate.playlistFrame = self.playlistFrame
        
        NSNotificationCenter.defaultCenter().postNotificationName("addOptionEditPlaylist", object: nil)
        
//        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc : PlaylistOptionListVC = storyboard.instantiateViewControllerWithIdentifier("PlaylistOptionListVC") as! PlaylistOptionListVC
//        
//        let navigationController = UINavigationController(rootViewController: vc)
//         navigationController.modalPresentationStyle = .OverCurrentContext
//        self.presentViewController(navigationController, animated: true, completion: nil)
        
        
//        let herbDetails = storyboard!.instantiateViewControllerWithIdentifier("PlaylistOptionListVC") as! PlaylistOptionListVC
//        herbDetails.view.translatesAutoresizingMaskIntoConstraints = false;
//        
//        herbDetails.beginAppearanceTransition(true, animated: true)
//        self.cycleFromViewController2(self, toViewController: herbDetails)
//        herbDetails.endAppearanceTransition()
    }
    
    @IBAction func btnDownloadClick(sender: AnyObject)
    {
        for i in 0 ..< aTracksVC!.trackArray.count
        {
            let trackDic:JSON = aTracksVC!.trackArray[i]
            let selectedTrack = Track(trackJSON: trackDic)
            selectedTrack.updateTrackURLWithDownload(true)
        }
    }
    func getImageFromURL(urlString : String)-> UIImage
    {
        var bgImage = UIImage(named: DEFAULT_IMAGE)!
        let aURLString = urlString.stringByReplacingOccurrencesOfString(" ", withString: "%20")
        let url = NSURL(string: aURLString)

        if url != nil
        {
            let imageData = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
            
            if imageData != nil
            {
                bgImage = UIImage(data:imageData!)!
            }
        }
        return bgImage
    }
    // MARK: - Merging Image
    
    func mergeImages(playlistArray : NSArray, imageHeight : Float) //-> UIImage
    {
//        /*
//        let bottomImage = UIImage(named: "black.png")
//        let image1 = UIImage(named: "dummy_img7.png")!
//        let image2 = UIImage(named: "dummy_img5.png")!
//        let image3 = UIImage(named: "dummy_img6.png")!
//        let image4 = UIImage(named: "dummy_img7.png")!
//        let image5 = UIImage(named: "dummy_img5.png")!
//        let image6 = UIImage(named: "dummy_img4.png")!
//         */
//        
//        let bottomImage = UIImage(named: "black.png")
////        var image1 = UIImage(named: DEFAULT_IMAGE)!
////        var image2 = UIImage(named: DEFAULT_IMAGE)!
////        var image3 = UIImage(named: DEFAULT_IMAGE)!
////        var image4 = UIImage(named: DEFAULT_IMAGE)!
////        var image5 = UIImage(named: DEFAULT_IMAGE)!
////        var image6 = UIImage(named: DEFAULT_IMAGE)!
//       
//        
//        //let topImage = UIImage(named: "play_playlist_btn.png")
//        
        let outPutImageWidth = CGFloat(UIScreen.mainScreen().bounds.width)
//        
        let outPutImageHeight = CGFloat(imageHeight)
//        
//        let ratio = outPutImageWidth / outPutImageHeight
//        
//        let size = CGSize(width: outPutImageWidth, height: outPutImageHeight)
//        
//        UIGraphicsBeginImageContext(size)
//        
//        bottomImage!.drawInRect(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        //let images = [image1,image2,image3,image4,image5,image6]
        
        if self.musicView != nil
        {
            //let imageSuperView = self.playlistImage.superview
            self.playlistImage.hidden = true
            if ( playlistArray.count == 1 )
                
            {
                //            let playLitsSongDict1  = NSMutableDictionary(dictionary: playlistArray[0] as! Dictionary)
                //            let myDict1 = JSON.parse(playLitsSongDict1["otherData"] as! String)
                //let imageUrl1 = playlistArray[0].stringByReplacingOccurrencesOfString(" ", withString: "%20")
                
                //myDict1["album_url"].stringValue.stringByReplacingOccurrencesOfString(" ", withString: "%20")
                //self.setAlbumImage(imageUrl1, imageView: UIImageView(image: image1), placeholderImage: images[0])
                let imgView = UIImageView()
                imgView.contentMode = .ScaleAspectFill

                imgView.frame = CGRect(x: outPutImageWidth * 0.0, y: outPutImageHeight * 0.0 , width: outPutImageWidth * 1.0, height: outPutImageHeight * 1.0 )
                self.getExploreImage(playlistArray[0] as! String, imageView: imgView)
                self.musicView.addSubview(imgView)
                
                //self.drawImage(self.getImageFromURL(playlistArray[0] as! String), rect: CGRect(x: outPutImageWidth * 0.0, y: outPutImageHeight * 0.0 , width: outPutImageWidth * 1.0, height: outPutImageHeight * 1.0 ))
                
            }
            else if ( playlistArray.count <= 3 )
            {
                //            let playLitsSongDict1  = NSMutableDictionary(dictionary: playlistArray[0] as! Dictionary)
                //            let myDict1 = JSON.parse(playLitsSongDict1["otherData"] as! String)
                //            let imageUrl1 = myDict1["album_url"].stringValue.stringByReplacingOccurrencesOfString(" ", withString: "%20")
                
                //let imageUrl1 = playlistArray[0].stringByReplacingOccurrencesOfString(" ", withString: "%20")
                //self.setAlbumImage(imageUrl1, imageView: UIImageView(image: image1), placeholderImage: images[0])
                
                
                let imgView = UIImageView()
                 imgView.contentMode = .ScaleAspectFill
                imgView.frame = CGRect(x: outPutImageWidth * 0.0, y: outPutImageHeight * 0.0 , width: outPutImageWidth * 0.50, height: outPutImageHeight * 1.0 )
                self.getExploreImage(playlistArray[0] as! String, imageView: imgView)
                
                self.musicView.addSubview(imgView)

                
                //self.drawImage(self.getImageFromURL(playlistArray[0] as! String), rect: CGRect(x: outPutImageWidth * 0.0, y: outPutImageHeight * 0.0 , width: outPutImageWidth * 0.50, height: outPutImageHeight * 1.0 ))
                
                
                
                
                //            let playLitsSongDict2  = NSMutableDictionary(dictionary: playlistArray[1] as! Dictionary)
                //            let myDict2 = JSON.parse(playLitsSongDict2["otherData"] as! String)
                //            let imageUrl2 = myDict2["album_url"].stringValue.stringByReplacingOccurrencesOfString(" ", withString: "%20")
                //let imageUrl2 = playlistArray[1].stringByReplacingOccurrencesOfString(" ", withString: "%20")
                //self.setAlbumImage(imageUrl2, imageView: UIImageView(image: image2), placeholderImage: images[1])
                
                
                let imgView2 = UIImageView()
                 imgView2.contentMode = .ScaleAspectFill
                imgView2.frame = CGRect(x: outPutImageWidth * 0.50, y: outPutImageHeight * 0.0 , width: outPutImageWidth * 0.50, height: outPutImageHeight * 1.00 )
                self.getExploreImage(playlistArray[1] as! String, imageView: imgView2)
                self.musicView.addSubview(imgView2)

                
                
                //self.drawImage(self.getImageFromURL(playlistArray[1] as! String), rect: CGRect(x: outPutImageWidth * 0.50, y: outPutImageHeight * 0.0 , width: outPutImageWidth * 0.50, height: outPutImageHeight * 1.00 ))
                
            }
                /*
                 else if ( playlistArray.count == 3 )
                 {
                 
                 //            let playLitsSongDict1  = NSMutableDictionary(dictionary: playlistArray[0] as! Dictionary)
                 //            let myDict1 = JSON.parse(playLitsSongDict1["otherData"] as! String)
                 //            let imageUrl1 = myDict1["album_url"].stringValue.stringByReplacingOccurrencesOfString(" ", withString: "%20")
                 //let imageUrl1 = playlistArray[0].stringByReplacingOccurrencesOfString(" ", withString: "%20")
                 //self.setAlbumImage(imageUrl1, imageView: UIImageView(image: image1), placeholderImage: images[0])
                 self.drawImage(self.getImageFromURL(playlistArray[0] as! String), rect: CGRect(x: outPutImageWidth * 0.0, y: outPutImageHeight * 0.0 , width: outPutImageWidth * 0.50, height: outPutImageHeight * 0.50 ))
                 
                 
                 
                 //            let playLitsSongDict2  = NSMutableDictionary(dictionary: playlistArray[1] as! Dictionary)
                 //            let myDict2 = JSON.parse(playLitsSongDict2["otherData"] as! String)
                 //            let imageUrl2 = myDict2["album_url"].stringValue.stringByReplacingOccurrencesOfString(" ", withString: "%20")
                 
                 //let imageUrl2 = playlistArray[1].stringByReplacingOccurrencesOfString(" ", withString: "%20")
                 //self.setAlbumImage(imageUrl2, imageView: UIImageView(image: image2), placeholderImage: images[1])
                 self.drawImage(self.getImageFromURL(playlistArray[1] as! String), rect: CGRect(x: outPutImageWidth * 0.50, y: outPutImageHeight * 0.0 , width: outPutImageWidth * 0.50, height: outPutImageHeight * 0.50 ))
                 
                 
                 //  let playLitsSongDict3  = NSMutableDictionary(dictionary: playlistArray[2] as! Dictionary)
                 //  let myDict3 = JSON.parse(playLitsSongDict3["otherData"] as! String)
                 //  let imageUrl3 = myDict3["album_url"].stringValue.stringByReplacingOccurrencesOfString(" ", withString: "%20")
                 //let imageUrl3 = playlistArray[2].stringByReplacingOccurrencesOfString(" ", withString: "%20")
                 //self.setAlbumImage(imageUrl3, imageView: UIImageView(image: image3), placeholderImage: images[2])
                 self.drawImage(self.getImageFromURL(playlistArray[2] as! String), rect: CGRect(x: outPutImageWidth * 0.0, y: outPutImageHeight * 0.50 , width: outPutImageWidth * 1.0, height: outPutImageHeight * 0.50 ))
                 
                 }
                 */
            else if ( playlistArray.count <= 5 )
                
            {
                
                //            let playLitsSongDict1  = NSMutableDictionary(dictionary: playlistArray[0] as! Dictionary)
                //            let myDict1 = JSON.parse(playLitsSongDict1["otherData"] as! String)
                //            let imageUrl1 = myDict1["album_url"].stringValue.stringByReplacingOccurrencesOfString(" ", withString: "%20")
                //let imageUrl1 = playlistArray[0].stringByReplacingOccurrencesOfString(" ", withString: "%20")
                //self.setAlbumImage(imageUrl1, imageView: UIImageView(image: image1), placeholderImage: images[0])
                
                let imgView = UIImageView()
                imgView.contentMode = .ScaleAspectFill
                imgView.frame = CGRect(x: outPutImageWidth * 0.0, y: outPutImageHeight * 0.0 , width: outPutImageWidth * 0.50, height: outPutImageHeight * 0.50 )
                self.getExploreImage(playlistArray[0] as! String, imageView: imgView)
                self.musicView.addSubview(imgView)
                
                
                //self.drawImage(self.getImageFromURL(playlistArray[0] as! String), rect: CGRect(x: outPutImageWidth * 0.0, y: outPutImageHeight * 0.0 , width: outPutImageWidth * 0.50, height: outPutImageHeight * 0.50 ))
                
                
                
                
                //            let playLitsSongDict2  = NSMutableDictionary(dictionary: playlistArray[1] as! Dictionary)
                //            let myDict2 = JSON.parse(playLitsSongDict2["otherData"] as! String)
                //            let imageUrl2 = myDict2["album_url"].stringValue.stringByReplacingOccurrencesOfString(" ", withString: "%20")
                //let imageUrl2 = playlistArray[1].stringByReplacingOccurrencesOfString(" ", withString: "%20")
                //self.setAlbumImage(imageUrl2, imageView: UIImageView(image: image2), placeholderImage: images[1])
                
                
                let imgView2 = UIImageView()
                imgView2.contentMode = .ScaleAspectFill
                imgView2.frame = CGRect(x: outPutImageWidth * 0.50, y: outPutImageHeight * 0.0 , width: outPutImageWidth * 0.50, height: outPutImageHeight * 0.50 )
                self.getExploreImage(playlistArray[1] as! String, imageView: imgView2)
                

                self.musicView.addSubview(imgView2)
                
                //self.drawImage(self.getImageFromURL(playlistArray[1] as! String), rect: CGRect(x: outPutImageWidth * 0.50, y: outPutImageHeight * 0.0 , width: outPutImageWidth * 0.50, height: outPutImageHeight * 0.50 ))
                
                
                
                
                //            let playLitsSongDict3  = NSMutableDictionary(dictionary: playlistArray[2] as! Dictionary)
                //            let myDict3 = JSON.parse(playLitsSongDict3["otherData"] as! String)
                //            let imageUrl3 = myDict3["album_url"].stringValue.stringByReplacingOccurrencesOfString(" ", withString: "%20")
                //let imageUrl3 = playlistArray[2].stringByReplacingOccurrencesOfString(" ", withString: "%20")
                //self.setAlbumImage(imageUrl3, imageView: UIImageView(image: image3), placeholderImage: images[2])
               
                let imgView3 = UIImageView()
                imgView3.frame = CGRect(x: outPutImageWidth * 0.0, y: outPutImageHeight * 0.50 , width: outPutImageWidth * 0.50, height: outPutImageHeight * 0.50 )
                self.getExploreImage(playlistArray[2] as! String, imageView: imgView3)
                imgView3.contentMode = .ScaleAspectFill

                self.musicView.addSubview(imgView3)
                
                
                //self.drawImage(self.getImageFromURL(playlistArray[1] as! String), rect: CGRect(x: outPutImageWidth * 0.0, y: outPutImageHeight * 0.50 , width: outPutImageWidth * 0.50, height: outPutImageHeight * 0.50 ))
                
                
                //            let playLitsSongDict4  = NSMutableDictionary(dictionary: playlistArray[3] as! Dictionary)
                //            let myDict4 = JSON.parse(playLitsSongDict4["otherData"] as! String)
                //            let imageUrl4 = myDict4["album_url"].stringValue.stringByReplacingOccurrencesOfString(" ", withString: "%20")
                //let imageUrl4 = playlistArray[3].stringByReplacingOccurrencesOfString(" ", withString: "%20")
                //self.setAlbumImage(imageUrl4, imageView: UIImageView(image: image4), placeholderImage: images[3])
               
                let imgView4 = UIImageView()
                imgView4.frame = CGRect(x: outPutImageWidth * 0.50, y: outPutImageHeight * 0.50 , width: outPutImageWidth * 0.50, height: outPutImageHeight * 0.50 )
                self.getExploreImage(playlistArray[3] as! String, imageView: imgView4)
                imgView4.contentMode = .ScaleAspectFill

                self.musicView.addSubview(imgView4)
                
                //self.drawImage(self.getImageFromURL(playlistArray[3] as! String), rect: CGRect(x: outPutImageWidth * 0.50, y: outPutImageHeight * 0.50 , width: outPutImageWidth * 0.50, height: outPutImageHeight * 0.50 ))
                
                
            }
                /*
                 else if ( playlistArray.count == 5 )
                 {
                 
                 //            let playLitsSongDict1  = NSMutableDictionary(dictionary: playlistArray[0] as! Dictionary)
                 //            let myDict1 = JSON.parse(playLitsSongDict1["otherData"] as! String)
                 //            let imageUrl1 = myDict1["album_url"].stringValue.stringByReplacingOccurrencesOfString(" ", withString: "%20")
                 //let imageUrl1 = playlistArray[0].stringByReplacingOccurrencesOfString(" ", withString: "%20")
                 //self.setAlbumImage(imageUrl1, imageView: UIImageView(image: image1), placeholderImage: images[0])
                 self.drawImage(self.getImageFromURL(playlistArray[0] as! String), rect: CGRect(x: outPutImageWidth * 0.0, y: outPutImageHeight * 0.0 , width: outPutImageWidth * 0.33, height: outPutImageHeight * 0.50 ))
                 
                 
                 
                 
                 //            let playLitsSongDict2  = NSMutableDictionary(dictionary: playlistArray[1] as! Dictionary)
                 //            let myDict2 = JSON.parse(playLitsSongDict2["otherData"] as! String)
                 //            let imageUrl2 = myDict2["album_url"].stringValue.stringByReplacingOccurrencesOfString(" ", withString: "%20")
                 //let imageUrl2 = playlistArray[1].stringByReplacingOccurrencesOfString(" ", withString: "%20")
                 //self.setAlbumImage(imageUrl2, imageView: UIImageView(image: image2), placeholderImage: images[1])
                 self.drawImage(self.getImageFromURL(playlistArray[1] as! String), rect: CGRect(x: outPutImageWidth * 0.33, y: outPutImageHeight * 0.0 , width: outPutImageWidth * 0.34, height: outPutImageHeight * 0.50 ))
                 
                 
                 
                 
                 //            let playLitsSongDict3  = NSMutableDictionary(dictionary: playlistArray[2] as! Dictionary)
                 //            let myDict3 = JSON.parse(playLitsSongDict3["otherData"] as! String)
                 //            let imageUrl3 = myDict3["album_url"].stringValue.stringByReplacingOccurrencesOfString(" ", withString: "%20")
                 //let imageUrl3 = playlistArray[2].stringByReplacingOccurrencesOfString(" ", withString: "%20")
                 //self.setAlbumImage(imageUrl3, imageView: UIImageView(image: image3), placeholderImage: images[2])
                 self.drawImage(self.getImageFromURL(playlistArray[2] as! String), rect: CGRect(x: outPutImageWidth * 0.67, y: outPutImageHeight * 0.0 , width: outPutImageWidth * 0.33, height: outPutImageHeight * 0.50 ))
                 
                 
                 
                 
                 //            let playLitsSongDict4  = NSMutableDictionary(dictionary: playlistArray[3] as! Dictionary)
                 //            let myDict4 = JSON.parse(playLitsSongDict4["otherData"] as! String)
                 //            let imageUrl4 = myDict4["album_url"].stringValue.stringByReplacingOccurrencesOfString(" ", withString: "%20")
                 //let imageUrl4 = playlistArray[3].stringByReplacingOccurrencesOfString(" ", withString: "%20")
                 //self.setAlbumImage(imageUrl4, imageView: UIImageView(image: image4), placeholderImage: images[3])
                 self.drawImage(self.getImageFromURL(playlistArray[3] as! String), rect: CGRect(x: outPutImageWidth * 0.0, y: outPutImageHeight * 0.50 , width: outPutImageWidth * 0.50, height: outPutImageHeight * 0.50 ))
                 
                 
                 
                 
                 //            let playLitsSongDict5  = NSMutableDictionary(dictionary: playlistArray[4] as! Dictionary)
                 //            let myDict5 = JSON.parse(playLitsSongDict5["otherData"] as! String)
                 //            let imageUrl5 = myDict5["album_url"].stringValue.stringByReplacingOccurrencesOfString(" ", withString: "%20")
                 //let imageUrl5 = playlistArray[4].stringByReplacingOccurrencesOfString(" ", withString: "%20")
                 //self.setAlbumImage(imageUrl5, imageView: UIImageView(image: image5), placeholderImage: images[4])
                 self.drawImage(self.getImageFromURL(playlistArray[4] as! String), rect: CGRect(x: outPutImageWidth * 0.5, y: outPutImageHeight * 0.50 , width: outPutImageWidth * 0.50, height: outPutImageHeight * 0.50 ))
                 
                 
                 
                 }
                 */
            else if ( playlistArray.count >= 6 )
                
            {
                
                //            let playLitsSongDict1  = NSMutableDictionary(dictionary: playlistArray[0] as! Dictionary)
                //            DLog("playLitsSongDict1 = \(playLitsSongDict1)")
                //            let myDict1 = JSON.parse(playLitsSongDict1["otherData"] as! String)
                //            let imageUrl1 = myDict1["album_url"].stringValue.stringByReplacingOccurrencesOfString(" ", withString: "%20")
                //let imageUrl1 = playlistArray[0].stringByReplacingOccurrencesOfString(" ", withString: "%20")
                //self.setAlbumImage(imageUrl1, imageView: UIImageView(image: image1), placeholderImage: images[0])
               
                let imgView = UIImageView()
                imgView.frame = CGRect(x: outPutImageWidth * 0.0, y: outPutImageHeight * 0.0 , width: outPutImageWidth * 0.33, height: outPutImageHeight * 0.50 )
                self.getExploreImage(playlistArray[0] as! String, imageView: imgView)
                imgView.contentMode = .ScaleAspectFill
                self.musicView.addSubview(imgView)
                
                
               // self.drawImage(self.getImageFromURL(playlistArray[0] as! String), rect: CGRect(x: outPutImageWidth * 0.0, y: outPutImageHeight * 0.0 , width: outPutImageWidth * 0.33, height: outPutImageHeight * 0.50 ))
                
                
                
                //            let playLitsSongDict2  = NSMutableDictionary(dictionary: playlistArray[1] as! Dictionary)
                //            let myDict2 = JSON.parse(playLitsSongDict2["otherData"] as! String)
                //            let imageUrl2 = myDict2["album_url"].stringValue.stringByReplacingOccurrencesOfString(" ", withString: "%20")
                //let imageUrl2 = playlistArray[1].stringByReplacingOccurrencesOfString(" ", withString: "%20")
                //self.setAlbumImage(imageUrl2, imageView: UIImageView(image: image2), placeholderImage: images[1])
                
                
                let imgView1 = UIImageView()
                imgView1.frame = CGRect(x: outPutImageWidth * 0.33, y: outPutImageHeight * 0.0 , width: outPutImageWidth * 0.34, height: outPutImageHeight * 0.50 )
                self.getExploreImage(playlistArray[1] as! String, imageView: imgView1)
                imgView1.contentMode = .ScaleAspectFill

                self.musicView.addSubview(imgView1)
                
                //self.drawImage(self.getImageFromURL(playlistArray[1] as! String), rect: CGRect(x: outPutImageWidth * 0.33, y: outPutImageHeight * 0.0 , width: outPutImageWidth * 0.34, height: outPutImageHeight * 0.50 ))
                
                
                
                
                //let playLitsSongDict3  = NSMutableDictionary(dictionary: playlistArray[2] as! Dictionary)
                //DLog("playLitsSongDict1 = \(playLitsSongDict3)")
                //let local = playLitsSongDict3["isLocal"] as! String
                //DLog("local = \(local) ")
                //let myDict3 = JSON.parse(playLitsSongDict3["otherData"] as! String)
                // DLog("myDict3 = \(myDict3)")
                //let imageUrl3 = myDict3["album_url"].stringValue.stringByReplacingOccurrencesOfString(" ", withString: "%20")
                //let imageUrl3 = playlistArray[2].stringByReplacingOccurrencesOfString(" ", withString: "%20")
                //self.setAlbumImage(imageUrl3, imageView: UIImageView(image: image3), placeholderImage: images[2])
               
                let imgView2 = UIImageView()
                imgView2.frame = CGRect(x: outPutImageWidth * 0.67, y: outPutImageHeight * 0.0 , width: outPutImageWidth * 0.33, height: outPutImageHeight * 0.50 )
                self.getExploreImage(playlistArray[2] as! String, imageView: imgView2)
                imgView2.contentMode = .ScaleAspectFill

                self.musicView.addSubview(imgView2)
                
               // self.drawImage(self.getImageFromURL(playlistArray[2] as! String), rect: CGRect(x: outPutImageWidth * 0.67, y: outPutImageHeight * 0.0 , width: outPutImageWidth * 0.33, height: outPutImageHeight * 0.50 ))
                
                
                
                
                //            let playLitsSongDict4  = NSMutableDictionary(dictionary: playlistArray[3] as! Dictionary)
                //            let myDict4 = JSON.parse(playLitsSongDict4["otherData"] as! String)
                //            let imageUrl4 = myDict4["album_url"].stringValue.stringByReplacingOccurrencesOfString(" ", withString: "%20")
                //let imageUrl4 = playlistArray[3].stringByReplacingOccurrencesOfString(" ", withString: "%20")
                //self.setAlbumImage(imageUrl4, imageView: UIImageView(image: image4), placeholderImage: images[3])
               
                let imgView3 = UIImageView()
                imgView3.frame = CGRect(x: outPutImageWidth * 0.0, y: outPutImageHeight * 0.50 , width: outPutImageWidth * 0.33, height: outPutImageHeight * 0.50 )
                self.getExploreImage(playlistArray[3] as! String, imageView: imgView3)
                imgView3.contentMode = .ScaleAspectFill

                self.musicView.addSubview(imgView3)
                
               // self.drawImage(self.getImageFromURL(playlistArray[3] as! String), rect: CGRect(x: outPutImageWidth * 0.0, y: outPutImageHeight * 0.50 , width: outPutImageWidth * 0.33, height: outPutImageHeight * 0.50 ))
                
                
                
                
                //            let playLitsSongDict5  = NSMutableDictionary(dictionary: playlistArray[4] as! Dictionary)
                //            let myDict5 = JSON.parse(playLitsSongDict5["otherData"] as! String)
                //            let imageUrl5 = myDict5["album_url"].stringValue.stringByReplacingOccurrencesOfString(" ", withString: "%20")
                //let imageUrl5 = playlistArray[4].stringByReplacingOccurrencesOfString(" ", withString: "%20")
                //self.setAlbumImage(imageUrl5, imageView: UIImageView(image: image5), placeholderImage: images[4])
               
                let imgView4 = UIImageView()
                imgView4.frame = CGRect(x: outPutImageWidth * 0.33, y: outPutImageHeight * 0.50 , width: outPutImageWidth * 0.34, height: outPutImageHeight * 0.50 )
                self.getExploreImage(playlistArray[4] as! String, imageView: imgView4)
                imgView4.contentMode = .ScaleAspectFill

                self.musicView.addSubview(imgView4)
                
                //self.drawImage(self.getImageFromURL(playlistArray[4] as! String), rect: CGRect(x: outPutImageWidth * 0.33, y: outPutImageHeight * 0.50 , width: outPutImageWidth * 0.34, height: outPutImageHeight * 0.50 ))
                
                
                
                //            let playLitsSongDict6  = NSMutableDictionary(dictionary: playlistArray[5] as! Dictionary)
                //            let myDict6 = JSON.parse(playLitsSongDict6["otherData"] as! String)
                //            let imageUrl6 = myDict6["album_url"].stringValue.stringByReplacingOccurrencesOfString(" ", withString: "%20")
                //let imageUrl6 = playlistArray[5].stringByReplacingOccurrencesOfString(" ", withString: "%20")
                //self.setAlbumImage(imageUrl6, imageView: UIImageView(image: image6), placeholderImage: images[5])
               
                let imgView5 = UIImageView()
                imgView5.frame = CGRect(x: outPutImageWidth * 0.67, y: outPutImageHeight * 0.50 , width: outPutImageWidth * 0.33, height: outPutImageHeight * 0.50 )
                self.getExploreImage(playlistArray[5] as! String, imageView: imgView5)
                imgView5.contentMode = .ScaleAspectFill

                self.musicView.addSubview(imgView5)
                
               // self.drawImage(self.getImageFromURL(playlistArray[5] as! String), rect: CGRect(x: outPutImageWidth * 0.67, y: outPutImageHeight * 0.50 , width: outPutImageWidth * 0.33, height: outPutImageHeight * 0.50 ))
            }
            
            /*
             if ( playlistArray.count > 0)
             {
             self.drawImage(topImage!, rect: CGRect(x: outPutImageWidth * 0.33, y: outPutImageHeight * 0.33/2 , width: outPutImageWidth * 0.33, height: outPutImageHeight * 0.33 * ratio))
             }
             */
            
            
           // let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
            
            //UIGraphicsEndImageContext()
            
            
            //return newImage
        }
    }
    
    
    func mergeImagesLocal(playlistArray : [UIImage], imageHeightIn : Float) //-> UIImage
    {
        let imageHeight = imageHeightIn
        
//        let bottomImage = UIImage(named: "black.png")
//        
//        let image1 = UIImage(named: DEFAULT_IMAGE)!
//        let image2 = UIImage(named: DEFAULT_IMAGE)!
//        let image3 = UIImage(named: DEFAULT_IMAGE)!
//        let image4 = UIImage(named: DEFAULT_IMAGE)!
//        let image5 = UIImage(named: DEFAULT_IMAGE)!
//        let image6 = UIImage(named: DEFAULT_IMAGE)!
        
        //let topImage = UIImage(named: "play_playlist_btn.png")
        
        let outPutImageWidth = CGFloat(UIScreen.mainScreen().bounds.width)
        
        let outPutImageHeight = CGFloat(imageHeight)
        
        
        if self.musicView != nil
        {
            //let imageSuperView = self.playlistImage.superview
            //imageSuperView!.frame = CGRectMake(0, 0, outPutImageWidth,CGFloat(imageHeightIn))
            self.playlistImage.hidden = true
        
            if ( playlistArray.count == 1 )
                
            {
                let imgView = UIImageView()
                imgView.frame = CGRect(x: outPutImageWidth * 0.0, y: outPutImageHeight * 0.0 , width: outPutImageWidth * 1.0, height: outPutImageHeight * 1.0 )
                imgView.image = playlistArray[0]
                imgView.contentMode = .ScaleAspectFill
                self.musicView.addSubview(imgView)
            }
            else if ( playlistArray.count <= 3 )
            {
                
                let imgView = UIImageView()
                imgView.frame = CGRect(x: outPutImageWidth * 0.0, y: outPutImageHeight * 0.0 , width: outPutImageWidth * 0.50, height: outPutImageHeight * 1.0 )
                imgView.image = playlistArray[0]
                imgView.contentMode = .ScaleAspectFill

                self.musicView.addSubview(imgView)
                
                
                
                let imgView2 = UIImageView()
                imgView2.frame = CGRect(x: outPutImageWidth * 0.50, y: outPutImageHeight * 0.0 , width: outPutImageWidth * 0.50, height: outPutImageHeight * 1.00 )
               imgView2.image = playlistArray[1]
                imgView2.contentMode = .ScaleAspectFill

                self.musicView.addSubview(imgView2)
                
            }
            else if ( playlistArray.count <= 5 )
            {
                
                let imgView = UIImageView()
                imgView.frame = CGRect(x: outPutImageWidth * 0.0, y: outPutImageHeight * 0.0 , width: outPutImageWidth * 0.50, height: outPutImageHeight * 0.50 )
                imgView.image = playlistArray[0]
                imgView.contentMode = .ScaleAspectFill

                self.musicView.addSubview(imgView)
                
               
                let imgView2 = UIImageView()
                imgView2.frame = CGRect(x: outPutImageWidth * 0.50, y: outPutImageHeight * 0.0 , width: outPutImageWidth * 0.50, height: outPutImageHeight * 0.50 )
               imgView2.image = playlistArray[1]
                imgView2.contentMode = .ScaleAspectFill

                self.musicView.addSubview(imgView2)
                
              
                
                let imgView3 = UIImageView()
                imgView3.frame = CGRect(x: outPutImageWidth * 0.0, y: outPutImageHeight * 0.50 , width: outPutImageWidth * 0.50, height: outPutImageHeight * 0.50 )
               imgView3.image = playlistArray[2]
                imgView3.contentMode = .ScaleAspectFill

               self.musicView.addSubview(imgView3)
                
                
                let imgView4 = UIImageView()
                imgView4.frame = CGRect(x: outPutImageWidth * 0.50, y: outPutImageHeight * 0.50 , width: outPutImageWidth * 0.50, height: outPutImageHeight * 0.50 )
               imgView4.image = playlistArray[3]
                imgView4.contentMode = .ScaleAspectFill

                self.musicView.addSubview(imgView4)
                
            }
            else if ( playlistArray.count >= 6 )
            {
                let imgView = UIImageView()
                imgView.frame = CGRect(x: outPutImageWidth * 0.0, y: outPutImageHeight * 0.0 , width: outPutImageWidth * 0.33, height: outPutImageHeight * 0.50 )
                imgView.image = playlistArray[0]
                imgView.contentMode = .ScaleAspectFill

                self.musicView.addSubview(imgView)
                
                
                let imgView1 = UIImageView()
                imgView1.frame = CGRect(x: outPutImageWidth * 0.33, y: outPutImageHeight * 0.0 , width: outPutImageWidth * 0.34, height: outPutImageHeight * 0.50 )
               imgView1.image = playlistArray[1]
                imgView1.contentMode = .ScaleAspectFill

               self.musicView.addSubview(imgView1)
                
                let imgView2 = UIImageView()
                imgView2.frame = CGRect(x: outPutImageWidth * 0.67, y: outPutImageHeight * 0.0 , width: outPutImageWidth * 0.33, height: outPutImageHeight * 0.50 )
               imgView2.image = playlistArray[2]
                imgView2.contentMode = .ScaleAspectFill

                self.musicView.addSubview(imgView2)
                
                let imgView3 = UIImageView()
                imgView3.frame = CGRect(x: outPutImageWidth * 0.0, y: outPutImageHeight * 0.50 , width: outPutImageWidth * 0.33, height: outPutImageHeight * 0.50 )
                imgView3.image = playlistArray[3]
                imgView3.contentMode = .ScaleAspectFill

                self.musicView.addSubview(imgView3)
                
                let imgView4 = UIImageView()
                imgView4.frame = CGRect(x: outPutImageWidth * 0.33, y: outPutImageHeight * 0.50 , width: outPutImageWidth * 0.34, height: outPutImageHeight * 0.50 )
                imgView4.image = playlistArray[4]
                imgView4.contentMode = .ScaleAspectFill

               self.musicView.addSubview(imgView4)
                
                let imgView5 = UIImageView()
                imgView5.frame = CGRect(x: outPutImageWidth * 0.67, y: outPutImageHeight * 0.50 , width: outPutImageWidth * 0.33, height: outPutImageHeight * 0.50 )
                imgView5.image = playlistArray[5]
                imgView5.contentMode = .ScaleAspectFill

                self.musicView.addSubview(imgView5)
            }
        }
        
        
//        let ratio = outPutImageWidth / outPutImageHeight
        
//        let size = CGSize(width: outPutImageWidth, height: outPutImageHeight)
        
//        UIGraphicsBeginImageContext(size)
        
//        bottomImage!.drawInRect(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
//        let images = [image1,image2,image3,image4,image5,image6]

/*
        if ( playlistArray.count == 1 )
        {
            
            self.drawImage(playlistArray[0], rect: CGRect(x: outPutImageWidth * 0.0, y: outPutImageHeight * 0.0 , width: outPutImageWidth * 1.0, height: outPutImageHeight * 1.0 ))
            
        }
        else if ( playlistArray.count == 2 )
        {
            
            self.drawImage(playlistArray[0], rect: CGRect(x: outPutImageWidth * 0.0, y: outPutImageHeight * 0.0 , width: outPutImageWidth * 0.50, height: outPutImageHeight * 1.00 ))
           
            self.drawImage(playlistArray[1], rect: CGRect(x: outPutImageWidth * 0.50, y: outPutImageHeight * 0.0 , width: outPutImageWidth * 0.50, height: outPutImageHeight * 1.00 ))
        }
        else if ( playlistArray.count == 3 )
        {
            self.drawImage(playlistArray[0], rect: CGRect(x: outPutImageWidth * 0.0, y: outPutImageHeight * 0.0 , width: outPutImageWidth * 0.50, height: outPutImageHeight * 0.50 ))
            self.drawImage(playlistArray[1], rect: CGRect(x: outPutImageWidth * 0.50, y: outPutImageHeight * 0.0 , width: outPutImageWidth * 0.50, height: outPutImageHeight * 0.50 ))
            self.drawImage(playlistArray[2], rect: CGRect(x: outPutImageWidth * 0.0, y: outPutImageHeight * 0.5 , width: outPutImageWidth * 1.0, height: outPutImageHeight * 0.50 ))
        }
            
        else if ( playlistArray.count == 4 )
        {
            self.drawImage(playlistArray[0], rect: CGRect(x: outPutImageWidth * 0.0, y: outPutImageHeight * 0.0 , width: outPutImageWidth * 0.50, height: outPutImageHeight * 0.50 ))
            
            self.drawImage(playlistArray[1], rect: CGRect(x: outPutImageWidth * 0.50, y: outPutImageHeight * 0.0 , width: outPutImageWidth * 0.50, height: outPutImageHeight * 0.50 ))
            
            self.drawImage(playlistArray[2], rect: CGRect(x: outPutImageWidth * 0.0, y: outPutImageHeight * 0.50 , width: outPutImageWidth * 0.50, height: outPutImageHeight * 0.50 ))
            
            self.drawImage(playlistArray[3], rect: CGRect(x: outPutImageWidth * 0.50, y: outPutImageHeight * 0.50 , width: outPutImageWidth * 0.50, height: outPutImageHeight * 0.50 ))
        }
            
        else if ( playlistArray.count == 5 )
        {
            self.drawImage(playlistArray[0], rect: CGRect(x: outPutImageWidth * 0.0, y: outPutImageHeight * 0.0 , width: outPutImageWidth * 0.33, height: outPutImageHeight * 0.50 ))
            
            
            self.drawImage(playlistArray[1], rect: CGRect(x: outPutImageWidth * 0.33, y: outPutImageHeight * 0.0 , width: outPutImageWidth * 0.34, height: outPutImageHeight * 0.50 ))
            
            
         
            self.drawImage(playlistArray[2], rect: CGRect(x: outPutImageWidth * 0.67, y: outPutImageHeight * 0.0 , width: outPutImageWidth * 0.33, height: outPutImageHeight * 0.50 ))
            
            
         
            self.drawImage(playlistArray[3], rect: CGRect(x: outPutImageWidth * 0.0, y: outPutImageHeight * 0.50 , width: outPutImageWidth * 0.50, height: outPutImageHeight * 0.50 ))
            
            
            self.drawImage(playlistArray[4], rect: CGRect(x: outPutImageWidth * 0.5, y: outPutImageHeight * 0.50 , width: outPutImageWidth * 0.50, height: outPutImageHeight * 0.50 ))
            
            
        }
            
        else if ( playlistArray.count >= 6 )
            
        {
            
         
            self.drawImage(playlistArray[0], rect: CGRect(x: outPutImageWidth * 0.0, y: outPutImageHeight * 0.0 , width: outPutImageWidth * 0.33, height: outPutImageHeight * 0.50 ))
            
            
            
         
            self.drawImage(playlistArray[1], rect: CGRect(x: outPutImageWidth * 0.33, y: outPutImageHeight * 0.0 , width: outPutImageWidth * 0.34, height: outPutImageHeight * 0.50 ))
            
            
            
          
            self.drawImage(playlistArray[2], rect: CGRect(x: outPutImageWidth * 0.67, y: outPutImageHeight * 0.0 , width: outPutImageWidth * 0.33, height: outPutImageHeight * 0.50 ))
            
            
            
            
         
            self.drawImage(playlistArray[3], rect: CGRect(x: outPutImageWidth * 0.0, y: outPutImageHeight * 0.50 , width: outPutImageWidth * 0.33, height: outPutImageHeight * 0.50 ))
            
            
            
            
       
            self.drawImage(playlistArray[4], rect: CGRect(x: outPutImageWidth * 0.33, y: outPutImageHeight * 0.50 , width: outPutImageWidth * 0.34, height: outPutImageHeight * 0.50 ))
            
            
          
            self.drawImage(playlistArray[5], rect: CGRect(x: outPutImageWidth * 0.67, y: outPutImageHeight * 0.50 , width: outPutImageWidth * 0.33, height: outPutImageHeight * 0.50 ))
        }
        
        /*
        if ( playlistArray.count > 0)
        {
            self.drawImage(topImage!, rect: CGRect(x: outPutImageWidth * 0.33, y: outPutImageHeight * 0.33/2 , width: outPutImageWidth * 0.33, height: outPutImageHeight * 0.33 * ratio))
        }
        */
        
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
        */
        
    }

    func drawImage(let image: UIImage, let rect: CGRect)
    {
        
        let outputImage = self.imageWithSize(image, aSize: rect.size)
        image.drawInRect(rect, blendMode: CGBlendMode.Normal, alpha: 1.0)
    }
    
    func imageWithSize(let image: UIImage, let aSize:CGSize) -> UIImage
    {
        let size = CGSizeMake(aSize.width * 1.0,aSize.height * 1.0)
        var scaledImageRect = CGRect.zero;
        
        let aspectWidth:CGFloat = size.width / image.size.width;
        
        let aspectHeight:CGFloat = size.height / image.size.height;
        
        let aspectRatio:CGFloat = min(aspectWidth, aspectHeight);
        
        
        
        scaledImageRect.size.width = image.size.width * aspectRatio;
        
        scaledImageRect.size.height = image.size.height * aspectRatio;
        
        scaledImageRect.origin.x = (size.width - scaledImageRect.size.width) / 2.0;
        
        scaledImageRect.origin.y = (size.height - scaledImageRect.size.height) / 2.0;
        
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0);
        
        image.drawInRect(scaledImageRect);
        
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        
        return scaledImage;
    }
    
    func setAlbumImage(imageUrl: String,imageView : UIImageView,placeholderImage : UIImage)
    {
        let imageUrlStr = imageUrl.stringByReplacingOccurrencesOfString(" ", withString: "%20")
        let URL: NSURL? = NSURL(string:imageUrl)
        if URL != nil
        {
            imageView.af_setImageWithURL(
                URL!,
                placeholderImage: placeholderImage,
                filter: nil,
                imageTransition: .CrossDissolve(0.2),
                completion: { response in
                    // BaseVC.sharedInstance.DLog(response.result.value!) //# UIImage
                    // BaseVC.sharedInstance.DLog(response.result.error!) //# NSError
                }
            )
        }
        
    }

       
    // MARK: - Animation -
    
    func cycleFromViewController(oldViewController: UIViewController, toViewController newViewController: UIViewController) {
        oldViewController.willMoveToParentViewController(nil)
        self.addChildViewController(newViewController)
        self.addSubview(newViewController.view, toView:self.view!)
        newViewController.view.alpha = 0
        newViewController.view.layoutIfNeeded()
        
        
        //let thisView = oldViewController.view
        let toView = newViewController.view
        
        let herbView = newViewController.view
        
        var frame = CGRect.zero
        
        if isFromSettingBtn
        {
            frame = self.originFrame
        }
        else
        {
            frame = self.playlistFrame
        }
        
        let initialFrame = self.presenting ? frame : herbView.frame
        let finalFrame = self.presenting ? herbView.frame : frame
        
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
    func cycleFromViewController2(oldViewController: UIViewController, toViewController newViewController: UIViewController)
    {
        oldViewController.willMoveToParentViewController(nil)
        
        self.addChildViewController(newViewController)
        
        self.addSubview(newViewController.view, toView:self.view!)
        newViewController.view.alpha = 0
        newViewController.view.layoutIfNeeded()
        
        
        //let thisView = oldViewController.view
        let toView = newViewController.view
        
        let herbView = newViewController.view
        
        var frame = CGRect.zero
        
        if isFromSettingBtn
        {
            frame = self.originFrame
        }
        else
        {
            frame = self.playlistFrame
        }
        
        let initialFrame = self.presenting ? frame : herbView.frame
        let finalFrame = self.presenting ? herbView.frame : frame
        
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
    
    func methodOfReceivedNotification3(notification: NSNotification){
        //Take Action on Notification
        
        BaseVC.sharedInstance.DLog("methodOfReceivedNotification3 called")
        
        isFromSettingBtn = false
        
        appDelegate.playlistFrame = (notification.object?.convertRect(notification.object!.frame, toView: self.view))!
        
        let herbDetails = storyboard!.instantiateViewControllerWithIdentifier("PlaylistOptionListVC") as! PlaylistOptionListVC
        herbDetails.view.translatesAutoresizingMaskIntoConstraints = false;
        self.cycleFromViewController(self, toViewController: herbDetails)
        
    }
    
    func deletePlaylistClicked(notification: NSNotification){
        //Take Action on Notification
        
        BaseVC.sharedInstance.DLog("deletePlaylistClicked called")
        
        let optionVC = storyboard!.instantiateViewControllerWithIdentifier("deleteYesNoViewController") as! deleteYesNoViewController
        optionVC.view.translatesAutoresizingMaskIntoConstraints = false;
        
        self.addChildViewController(optionVC)
        self.addSubview(optionVC.view, toView: self.view)
        
        self.deletePlaylistFrame = (notification.object?.frame)!
        
        UIView.transitionWithView(self.view, duration: 0.3, options: .TransitionCrossDissolve, animations: { _ in
            
            optionVC.view.alpha = 1
            self.view.alpha = 1
            
            },
                                  completion: { finished in
                                    
                                    //self.willMoveToParentViewController(nil)
                                    //self.view.removeFromSuperview()
                                    //self.removeFromParentViewController()
        })
        
    }
    
    func deletePlayistOptionNoClicked(notification: NSNotification){
        //Take Action on Notification
        
        BaseVC.sharedInstance.DLog("deletePlayistOptionNoClicked called")
        
        let optionVC = storyboard!.instantiateViewControllerWithIdentifier("PlaylistOptionListVC") as! PlaylistOptionListVC
        optionVC.view.translatesAutoresizingMaskIntoConstraints = false;
        optionVC.deletePlaylistFrame = self.deletePlaylistFrame
        optionVC.isFromNo = true
        
        self.addChildViewController(optionVC)
        self.addSubview(optionVC.view, toView: self.view)
        
        
        
        UIView.transitionWithView(self.view, duration: 0.3, options: .TransitionCrossDissolve, animations: { _ in
            
            optionVC.view.alpha = 1
            self.view.alpha = 1
            
            },
                                  completion: { finished in
                                    
                                    //NSNotificationCenter.defaultCenter().postNotificationName("animationViewOnDeletePlaylist", object: nil)
                                    //self.willMoveToParentViewController(nil)
                                    //self.view.removeFromSuperview()
                                    //self.removeFromParentViewController()
        })
        
    }
    
    func deletePlayistOptionYesClicked(notification: NSNotification){
        //Take Action on Notification
        
        BaseVC.sharedInstance.DLog("deletePlayistOptionYesClicked called")
        
        let playlistDeletedVC = storyboard!.instantiateViewControllerWithIdentifier("PlaylistDeletedVC") as! PlaylistDeletedVC
        playlistDeletedVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        self.addChildViewController(playlistDeletedVC)
        self.addSubview(playlistDeletedVC.view, toView: self.view)
        
        UIView.transitionWithView(self.view, duration: 0.3, options: .TransitionCrossDissolve, animations: { _ in
            
            playlistDeletedVC.view.alpha = 1
            self.view.alpha = 1
            
            },
                                  completion: { finished in
                                    
                                    //NSNotificationCenter.defaultCenter().postNotificationName("animationViewOnDeletePlaylist", object: nil)
                                    //self.willMoveToParentViewController(nil)
                                    //self.view.removeFromSuperview()
                                    //self.removeFromParentViewController()
        })
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "playlistTrack")
        {
            if let tracksVC = segue.destinationViewController as? LibraryTracksViewController
            {
                self.aTracksVC = tracksVC
                appDelegate.aTempLibraryVC = self.aTracksVC
                self.aTracksVC!.trackBy = TrackBy.Playlist

            }
        }
    }
}

