//
//  PlaylistCategoryVC.swift
//  Disctopia
//
//  Created by Damini on 08/07/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit
import SwiftyJSON
import MediaPlayer

class PlaylistCategoryVC: BaseVC,UITableViewDataSource,UITableViewDelegate
{
    
    // MARK: - Variable
    var playlists: [MPMediaPlaylist] = []
   // private var playlists: [MPMediaItemCollection] = []
     var syncPlaylistArray = NSMutableArray()
    var playlistDictionary : NSMutableDictionary = NSMutableDictionary()
    var playListArray : [JSON] = []
    var albumsArray = []

    // MARK: - Outlet
  
    @IBOutlet var myTableView: UITableView!
    
   // MARK: - LifeCycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        initVC()
        // Do any additional setup after loading the view.
    }
    class func instantiateFromStoryboard() -> PlaylistCategoryVC {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier(String(self)) as! PlaylistCategoryVC
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func initVC()
    {
        appDelegate.selectedPlaylistId = Dictionary()
        self.getPlayListAPI()
        // Load playlists
        let query = MPMediaQuery.playlistsQuery()
        query.addFilterPredicate(MPMediaPropertyPredicate(value: MPMediaType.Music.rawValue, forProperty: MPMediaItemPropertyMediaType))
        query.addFilterPredicate(MPMediaPropertyPredicate(value: NSNumber(bool: false), forProperty: MPMediaItemPropertyIsCloudItem))
        if let collections = query.collections
        {
            self.playlists = collections as? [MPMediaPlaylist] ?? []
        }
        
    }
    func syncPlayList()
    {
        syncPlaylistArray.removeAllObjects()
        
        
        //Local Music album list
        for  i in 0 ..< playlists.count
        {
            let playlist = self.playlists[i]
            
            let dic:NSMutableDictionary = NSMutableDictionary()
            dic.setValue("1", forKey: "isLocal")
            dic.setValue(playlist, forKey: "otherData")
            syncPlaylistArray.addObject(dic.mutableCopy())
        }
        
        //API Albums list
        for i in 0 ..< playListArray.count
        {
           // let tempdic = self.playListArray[i].dictionaryValue
            let dic:NSMutableDictionary = NSMutableDictionary()
            dic.setValue("0", forKey: "isLocal")
            dic.setValue(self.playListArray[i].rawString(), forKey: "otherData")
            syncPlaylistArray.addObject(dic.mutableCopy())
        }
       
        self.myTableView.reloadData()
        DLog("syncPlaylistArray = \(syncPlaylistArray)")
    }
    
   // MARK: - getPlayList API For Playlist
    func getPlayListAPI()
    {
        API.getPlaylist(nil , aViewController: self) { (result: JSON) in
            if ( result != nil )
            {
                BaseVC.sharedInstance.DLog("#### getPlayList API Response: \(result)")
                
                if (result["playlistDict"] != nil)
                {
                    self.playListArray = result["playlistDict"].array!
                    BaseVC.sharedInstance.DLog("#### playListArray: \(self.playListArray)")
                    self.myTableView.reloadData()
                   
                }
                
             }
             self.syncPlayList()
           
        }
    }
    
    // MARK: - table view method
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.syncPlaylistArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
         let cell = tableView.dequeueReusableCellWithIdentifier("PlaylistCell3", forIndexPath: indexPath) as! PlaylistCategoryTableViewCell3
        
        
        let playListDictionary = self.syncPlaylistArray[indexPath.row]
        let isLocal = playListDictionary["isLocal"] as! String

        cell.playListDictionary = playListDictionary as! NSMutableDictionary

        if isLocal == "0"
        {
            cell.btnPlaylistOption.hidden = false
             cell.myView.hidden = true
            var playListDict = JSON.parse(playListDictionary["otherData"] as! String)
            cell.lblPlaylistTitle.text = playListDict["playlistname"].stringValue
            
            if playListDict["album_images"] != nil
            {
                albumsArray = playListDict["album_images"].arrayObject!
                cell.img1.image = mergeImages(albumsArray, imageHeight: 138)
            }
            else
            {
                cell.img1.image =  UIImage(named : DEFAULT_IMAGE)
            }
 
            
            
            DLog("albumsArray = \(albumsArray)")
            
          
//            let imageUrl = playListDict["album_url"].stringValue.stringByReplacingOccurrencesOfString(" ", withString: "%20")
//            if imageUrl.characters.count > 0
//            {
//                self.getAlbumImage(imageUrl,imageView: cell.img1)
//            }
//            else
//            {
//                cell.img1.image = UIImage(named: DEFAULT_IMAGE)
//            }
            cell.playListDict = playListDict.dictionary
            cell.btnPlaylistOption.tag = Int(playListDict["playlistId"].stringValue)!
            if cell.btnPlaylistOption.tag == Int(playListDict["playlistId"].stringValue)!
            {
                appDelegate.newPlaylist = cell.lblPlaylistTitle.text!
                DLog("appDelegate.newPlaylist = \(appDelegate.newPlaylist)")
            }
        }
        else if isLocal == "1"
        {
            //cell.cellButton.hidden = true
            cell.btnPlaylistOption.hidden = true
            cell.myView.hidden = false
            //let dict:NSMutableDictionary = self.syncPlaylistArray[indexPath.row] as! NSMutableDictionary
            let playlistObj : MPMediaPlaylist = playListDictionary["otherData"] as! MPMediaPlaylist
            cell.lblPlaylistTitle.text = playlistObj.name
            localImageSet(playlistObj, cell: cell)
            /*if let representativeItem = playlistObj.representativeItem
            {
                if let artwork = representativeItem.artwork
                {
                    let scale = UIScreen.mainScreen().scale
                    if let image =  artwork.imageWithSize(CGSizeMake(80 * scale, 80 * scale))
                    {
                        cell.img1.image = image
                    }
                    else
                    {
                       cell.img1.image = UIImage(named: DEFAULT_IMAGE)
                    }
                }
                else
                {
                    cell.img1.image = UIImage(named: DEFAULT_IMAGE)
                }
            }*/
        }
        return cell
        
        
/*        if playListArray.count > 0
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("PlaylistCell3", forIndexPath: indexPath) as! PlaylistCategoryTableViewCell3
            
            let playListDict = self.playListArray[indexPath.row].dictionaryValue
            
            cell.lblPlaylistTitle.text = playListDict["playlistname"]!.stringValue
            let imageUrl = playListDict["album_url"]!.stringValue.stringByReplacingOccurrencesOfString(" ", withString: "%20")
            
            if imageUrl.characters.count > 0
            {
                self.getAlbumImage(imageUrl,imageView: cell.img1)
            }
            else
            {
                cell.img1.image = UIImage(named: "black.png")
            }
            cell.playListDict = playListDict
            cell.btnPlaylistOption.tag = Int(playListDict["playlistId"]!.stringValue)!
            if cell.btnPlaylistOption.tag == Int(playListDict["playlistId"]!.stringValue)!
            {
                appDelegate.newPlaylist = cell.lblPlaylistTitle.text!
                DLog("appDelegate.newPlaylist = \(appDelegate.newPlaylist)")
            }
           return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("PlaylistCell3", forIndexPath: indexPath) as! PlaylistCategoryTableViewCell3
            cell.lblPlaylistTitle.text = ""
            cell.img1.image = UIImage(named: "black.png")
            return cell
        }
 */
    }
    func localImageSet(aOtherData:MPMediaPlaylist,cell:PlaylistCategoryTableViewCell3)
    {
        if let playlistObj : MPMediaPlaylist = aOtherData
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
                    {}
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
                    cell.img1.image = UIImage(named: DEFAULT_IMAGE)
                }
            }
            
            if artworks.count > 0
            {
                self.mergeImagesLocal(artworks, imageHeightIn: Float(cell.myView.frame.size.height),cell: cell)
            }
            else
            {
                cell.img1.image = UIImage(named: DEFAULT_IMAGE)
            }
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
    }
    
    
    // MARK: - Merging Image

    
    func mergeImages(playlistArray : NSArray, imageHeight  : Float) -> UIImage
        
    {
        let bottomImage = UIImage(named: "black.png")
        
        let image1 = UIImage(named: DEFAULT_IMAGE)!
        let image2 = UIImage(named: DEFAULT_IMAGE)!
        let image3 = UIImage(named: DEFAULT_IMAGE)!
        //        let image4 = UIImage(named: "dummy_img2.png")!
        //        let image5 = UIImage(named: "dummy_img6.png")!
        //        let image6 = UIImage(named: "dummy_img3.png")!
        
        //   let topImage = UIImage(named: "play_playlist_btn.png")
        
        let outPutImageWidth = CGFloat(UIScreen.mainScreen().bounds.width)
        
        let outPutImageHeight = CGFloat(imageHeight)
        
        let ratio = outPutImageWidth / outPutImageHeight
        
        let size = CGSize(width: outPutImageWidth, height: outPutImageHeight)
        
        UIGraphicsBeginImageContext(size)

       // bottomImage!.drawInRect(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        let images = [image1,image2,image3]
        
        if ( playlistArray.count == 1 )
        {
            let imageUrl1 = playlistArray[0].stringByReplacingOccurrencesOfString(" ", withString: "%20")
            self.setAlbumImage(imageUrl1, imageView: UIImageView(image: image1), placeholderImage: images[0])
            self.drawImage(images[0], rect: CGRect(x: outPutImageWidth * 0.0, y: outPutImageHeight * 0.0 , width: outPutImageWidth * 1.0, height: outPutImageHeight * 1.0 ))
            
        }
            
        else if ( playlistArray.count == 2 )
            
        {
            let imageUrl1 = playlistArray[0].stringByReplacingOccurrencesOfString(" ", withString: "%20")
            self.setAlbumImage(imageUrl1, imageView: UIImageView(image: image1), placeholderImage: images[0])
            self.drawImage(images[0], rect: CGRect(x: outPutImageWidth * 0.0, y: outPutImageHeight * 0.0 , width: outPutImageWidth * 0.50, height: outPutImageHeight * 1.0 ))
            
            
            let imageUrl2 = playlistArray[1].stringByReplacingOccurrencesOfString(" ", withString: "%20")
            self.setAlbumImage(imageUrl2, imageView: UIImageView(image: image2), placeholderImage: images[1])
            self.drawImage(images[1], rect: CGRect(x: outPutImageWidth * 0.50, y: outPutImageHeight * 0.0 , width: outPutImageWidth * 0.50, height: outPutImageHeight * 1.0 ))
            
        }
            
        else if ( images.count >= 3 )
            
        {
            let imageUrl1 = playlistArray[0].stringByReplacingOccurrencesOfString(" ", withString: "%20")
            self.setAlbumImage(imageUrl1, imageView: UIImageView(image: image1), placeholderImage: images[0])
            self.drawImage(images[0], rect: CGRect(x: outPutImageWidth * 0.0, y: outPutImageHeight * 0.0 , width: outPutImageWidth * 0.33, height: outPutImageHeight * 1.0 ))
            
            
            let imageUrl2 = playlistArray[1].stringByReplacingOccurrencesOfString(" ", withString: "%20")
            self.setAlbumImage(imageUrl2, imageView: UIImageView(image: image2), placeholderImage: images[1])
            self.drawImage(images[1], rect: CGRect(x: outPutImageWidth * 0.33, y: outPutImageHeight * 0.0 , width: outPutImageWidth * 0.34, height: outPutImageHeight * 1.0 ))
            
            
            let imageUrl3 = playlistArray[2].stringByReplacingOccurrencesOfString(" ", withString: "%20")
            self.setAlbumImage(imageUrl3, imageView: UIImageView(image: image3), placeholderImage: images[2])
            self.drawImage(images[2], rect: CGRect(x: outPutImageWidth * 0.66, y: outPutImageHeight * 0.0 , width: outPutImageWidth * 0.33, height: outPutImageHeight * 1.0 ))
            
        }
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    

    func drawImage(let image: UIImage, let rect: CGRect)
    {
        let outputImage = self.imageWithSize(image, size: rect.size)
        outputImage.drawInRect(rect, blendMode: CGBlendMode.Normal, alpha: 1.0)
    }
    
    
    func imageWithSize(let image: UIImage, let size:CGSize) -> UIImage
        
    {
        
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
    
    func mergeImagesLocal(playlistArray : [UIImage], imageHeightIn : Float,cell:PlaylistCategoryTableViewCell3) //-> UIImage
    {
        let imageHeight = imageHeightIn
        let outPutImageWidth = CGFloat(UIScreen.mainScreen().bounds.width)
        let outPutImageHeight = CGFloat(imageHeight)
        if cell.myView != nil
        {
            if ( playlistArray.count == 1 )
            {
                let imgView = UIImageView()
                imgView.frame = CGRect(x: outPutImageWidth * 0.0, y: outPutImageHeight * 0.0 , width: outPutImageWidth * 1.0, height: outPutImageHeight * 1.0 )
                imgView.image = playlistArray[0]
                imgView.contentMode = .ScaleAspectFill
                cell.myView.addSubview(imgView)
            }
            else if ( playlistArray.count <= 3 )
            {
                
                let imgView = UIImageView()
                imgView.frame = CGRect(x: outPutImageWidth * 0.0, y: outPutImageHeight * 0.0 , width: outPutImageWidth * 0.50, height: outPutImageHeight * 1.0 )
                imgView.image = playlistArray[0]
                imgView.contentMode = .ScaleAspectFill
                
                cell.myView.addSubview(imgView)
                
                
                
                let imgView2 = UIImageView()
                imgView2.frame = CGRect(x: outPutImageWidth * 0.50, y: outPutImageHeight * 0.0 , width: outPutImageWidth * 0.50, height: outPutImageHeight * 1.00 )
                imgView2.image = playlistArray[1]
                imgView2.contentMode = .ScaleAspectFill
                
                cell.myView.addSubview(imgView2)
                
            }
            else if ( playlistArray.count <= 5 )
            {
                
                let imgView = UIImageView()
                imgView.frame = CGRect(x: outPutImageWidth * 0.0, y: outPutImageHeight * 0.0 , width: outPutImageWidth * 0.50, height: outPutImageHeight * 0.50 )
                imgView.image = playlistArray[0]
                imgView.contentMode = .ScaleAspectFill
                
               cell.myView.addSubview(imgView)
                
                
                let imgView2 = UIImageView()
                imgView2.frame = CGRect(x: outPutImageWidth * 0.50, y: outPutImageHeight * 0.0 , width: outPutImageWidth * 0.50, height: outPutImageHeight * 0.50 )
                imgView2.image = playlistArray[1]
                imgView2.contentMode = .ScaleAspectFill
                
               cell.myView.addSubview(imgView2)
                
                
                
                let imgView3 = UIImageView()
                imgView3.frame = CGRect(x: outPutImageWidth * 0.0, y: outPutImageHeight * 0.50 , width: outPutImageWidth * 0.50, height: outPutImageHeight * 0.50 )
                imgView3.image = playlistArray[2]
                imgView3.contentMode = .ScaleAspectFill
                
               cell.myView.addSubview(imgView3)
                
                
                let imgView4 = UIImageView()
                imgView4.frame = CGRect(x: outPutImageWidth * 0.50, y: outPutImageHeight * 0.50 , width: outPutImageWidth * 0.50, height: outPutImageHeight * 0.50 )
                imgView4.image = playlistArray[3]
                imgView4.contentMode = .ScaleAspectFill
                
               cell.myView.addSubview(imgView4)
                
            }
            else if ( playlistArray.count >= 6 )
            {
                let imgView = UIImageView()
                imgView.frame = CGRect(x: outPutImageWidth * 0.0, y: outPutImageHeight * 0.0 , width: outPutImageWidth * 0.33, height: outPutImageHeight * 0.50 )
                imgView.image = playlistArray[0]
                imgView.contentMode = .ScaleAspectFill
                
                cell.myView.addSubview(imgView)
                
                
                let imgView1 = UIImageView()
                imgView1.frame = CGRect(x: outPutImageWidth * 0.33, y: outPutImageHeight * 0.0 , width: outPutImageWidth * 0.34, height: outPutImageHeight * 0.50 )
                imgView1.image = playlistArray[1]
                imgView1.contentMode = .ScaleAspectFill
                
                cell.myView.addSubview(imgView1)
                
                let imgView2 = UIImageView()
                imgView2.frame = CGRect(x: outPutImageWidth * 0.67, y: outPutImageHeight * 0.0 , width: outPutImageWidth * 0.33, height: outPutImageHeight * 0.50 )
                imgView2.image = playlistArray[2]
                imgView2.contentMode = .ScaleAspectFill
                
               cell.myView.addSubview(imgView2)
                
                let imgView3 = UIImageView()
                imgView3.frame = CGRect(x: outPutImageWidth * 0.0, y: outPutImageHeight * 0.50 , width: outPutImageWidth * 0.33, height: outPutImageHeight * 0.50 )
                imgView3.image = playlistArray[3]
                imgView3.contentMode = .ScaleAspectFill
                
               cell.myView.addSubview(imgView3)
                
                let imgView4 = UIImageView()
                imgView4.frame = CGRect(x: outPutImageWidth * 0.33, y: outPutImageHeight * 0.50 , width: outPutImageWidth * 0.34, height: outPutImageHeight * 0.50 )
                imgView4.image = playlistArray[4]
                imgView4.contentMode = .ScaleAspectFill
                
               cell.myView.addSubview(imgView4)
                
                let imgView5 = UIImageView()
                imgView5.frame = CGRect(x: outPutImageWidth * 0.67, y: outPutImageHeight * 0.50 , width: outPutImageWidth * 0.33, height: outPutImageHeight * 0.50 )
                imgView5.image = playlistArray[5]
                imgView5.contentMode = .ScaleAspectFill
                
                cell.myView.addSubview(imgView5)
            }
        }
    }
    func setAlbumImage(imageUrl: String,imageView : UIImageView,placeholderImage : UIImage)
   {
    
        let URL:NSURL = NSURL(string:imageUrl)!
    
        imageView.af_setImageWithURL(
        URL,
        placeholderImage: placeholderImage,
        filter: nil,
        imageTransition: .CrossDissolve(0.2),
        completion: { response in
            //BaseVC.sharedInstance.DLog(response.result.value!) //# UIImage
            //BaseVC.sharedInstance.DLog(response.result.error!) //# NSError
        }
    )

    }
    
    // MARK: - button
    @IBAction func addNewPlaylistClick(sender: AnyObject)
    {
        //self.pushToViewControllerIfNotExistWithClassName("NewPlaylistVC", animated: false)
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc : NewPlaylistVC = storyboard.instantiateViewControllerWithIdentifier("NewPlaylistVC") as! NewPlaylistVC
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.modalPresentationStyle = .OverCurrentContext
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    
    func addPlaylistAlert()
    {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "PlayList", message: "Enter new Playlist Name", preferredStyle: .Alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            //textField.text = "Some default text."
        })
        
        //3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            let textField = alert.textFields![0] as UITextField
            BaseVC.sharedInstance.DLog("Text field: \(textField.text)")
            if textField.text! != ""
            {
                appDelegate.newPlaylist = textField.text!
                self.CreatePlayListAPI(textField.text!)
            }
           else
            {
                self.addPlaylistAlert()
            }
           
        }))
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in }
        alert.addAction(cancelAction)
        
        
        // 4. Present the alert.
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    // MARK: - create Playlist API 
    func CreatePlayListAPI(playListName : String)
    {
        var param = Dictionary<String, String>()
       
        param["PlayListName"] = playListName
       
        API.CreatePlayList(param , aViewController: self) { (result: JSON) in
            if ( result != nil )
            {
                BaseVC.sharedInstance.DLog("#### getPlayList API Response: \(result)")
                 self.pushToViewControllerIfNotExistWithClassName("AddNewPlaylistVC", animated: false)
                appDelegate.isFromNewPlaylist = true
            }
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
