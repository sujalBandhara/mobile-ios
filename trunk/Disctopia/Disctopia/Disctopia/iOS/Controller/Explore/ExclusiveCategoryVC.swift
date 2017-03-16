//
//  ExclusiveCategoryVC.swift
//  Disctopia
//
//  Created by Damini on 22/08/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class ExclusiveCategoryVC: BaseVC,UICollectionViewDelegate,UICollectionViewDataSource
{
    var categoryName = ""
    
    var exploreArray : [JSON] = []

    @IBOutlet var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getArtistAlbumListAPI()
        self.exploreArray = self.filterExpolreArrayWithCategory(categoryName)
        DLog("exploreArray = \(exploreArray)")
        DLog("exploreArray count = \(exploreArray.count)")
        self.collectionView.reloadData()

        // Do any additional setup after loading the view.
    }

    // API : GetArtistAlbumList For Explore
    func getArtistAlbumListAPI()
    {
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
                   // self.layout.itemCount = Int32(self.exploreArray.count)
                    self.collectionView.reloadData()
                }
            }
        }
        else
        {
            
            self.DLog(self.filterExpolreArrayWithCategory("1").count)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    class func instantiateFromStoryboard() -> ExclusiveCategoryVC {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier(String(self)) as! ExclusiveCategoryVC
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
        if categoryName == "Exclusive"
        {
            let index = (indexPath.row)%5 + 1
            DLog("----index for cell = \(index)")
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ExploreCell\(index)", forIndexPath: indexPath) as! ExploreCategoryCollectionViewCell
            
            if self.exploreArray.count > 0
            {
                var artistAlbumListDict = self.exploreArray[indexPath.row].dictionaryValue
                
                let timeParts = artistAlbumListDict["year"]!.stringValue.componentsSeparatedByString("-")
                
                cell.lblCoverName.text = artistAlbumListDict["coverName"]!.stringValue
                cell.lblArtistName.text = artistAlbumListDict["artistName"]!.stringValue
                cell.lblTags.text = "\(artistAlbumListDict["tags"]!.stringValue)-\(timeParts[0])"
                
                // for isExplicit
                
                if artistAlbumListDict["isExplicit"] != nil
                {
                    if artistAlbumListDict["isExplicit"]!.stringValue == "true"
                    {
                        cell.lblE.hidden = false
                    }
                    else
                    {
                        cell.lblE.hidden = true
                    }
                    
                }
                
                cell.lblE.text = "E"//artistAlbumListDict["coverName"].stringValue
                
                let imageUrl = artistAlbumListDict["album_url"]!.stringValue.stringByReplacingOccurrencesOfString(" ", withString: "%20")
                
                if imageUrl.characters.count > 0
                {
                    self.getAlbumImage(imageUrl,imageView: cell.coverImage)
                }
                else
                {
                    cell.coverImage.image = UIImage(named: "cloud_img.png")
                }
                
            }
            
            return cell
            
            
        }
        else
        {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ExploreCell2", forIndexPath: indexPath) as! ExploreCategoryCollectionViewCell
            
            if self.exploreArray.count > 0
            {
                var artistAlbumListDict = self.exploreArray[indexPath.row].dictionaryValue
                
                let timeParts = artistAlbumListDict["year"]!.stringValue.componentsSeparatedByString("-")
                
                cell.lblCoverName.text = artistAlbumListDict["coverName"]!.stringValue
                cell.lblArtistName.text = artistAlbumListDict["artistName"]!.stringValue
                cell.lblTags.text = "\(artistAlbumListDict["tags"]!.stringValue)-\(timeParts[0])"
                
                // for isExplicit
                
                if artistAlbumListDict["isExplicit"] != nil
                {
                    if artistAlbumListDict["isExplicit"]!.stringValue == "true"
                    {
                        cell.lblE.hidden = false
                    }
                    else
                    {
                        cell.lblE.hidden = true
                    }
                    
                }
                
                cell.lblE.text = "E"//artistAlbumListDict["coverName"].stringValue
                
                let imageUrl = artistAlbumListDict["album_url"]!.stringValue.stringByReplacingOccurrencesOfString(" ", withString: "%20")
                
                if imageUrl.characters.count > 0
                {
                    self.getAlbumImage(imageUrl,imageView: cell.coverImage)
                }
                else
                {
                    cell.coverImage.image = UIImage(named: "cloud_img.png")
                }
                
            }
            return cell
            
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        
        if self.exploreArray.count > 0
        {
            var artistAlbumListDict = self.exploreArray[indexPath.row].dictionaryValue
            //appDelegate.dictArtistDetails.setObject("1", forKey: "isLocal")
            //appDelegate.dictArtistDetails.setObject(artistAlbumListDict, forKey: "otherData")
            appDelegate.dictArtistDetails.setObject("0", forKey: "isLocal")
            DLog("albumId = \(artistAlbumListDict["albumId"]!.stringValue)")
            // let albumDetailVC = AlbumDetailsVC()
            appDelegate.selectedAlbumId = artistAlbumListDict["albumId"]!.stringValue
            self.pushToViewControllerIfNotExistWithClassName("AlbumDetailsVC", animated: true)
        }
        else
        {
            
        }
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        //return CGSize(width: 200,height: 200)
        //UIScreen.mainScreen().bounds.size.width
        var  randomNumber = CGFloat(arc4random_uniform(2) + 1)
        DLog("randomNumber = \(randomNumber)")
        randomNumber = 2
        if categoryName == "Exclusive"
        {
            let index = (indexPath.row)%5 + 1
            if index == 1
            {
                return CGSize(width: ( UIScreen.mainScreen().bounds.size.width ), height: (self.collectionView.frame.size.height / 3.0))//collectionView.frame.height)
            }
            else
            {
                return CGSize(width: ( UIScreen.mainScreen().bounds.size.width / randomNumber), height: (self.collectionView.frame.size.height / 3.0))//collectionView.frame.height)
            }
        }
        return CGSize(width: ( UIScreen.mainScreen().bounds.size.width / randomNumber), height: (self.collectionView.frame.size.height / 3.0))//collectionView.frame.height)
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSizeMake(0,0)  // Header size
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsetsMake(0, 0, 0, 0)
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
