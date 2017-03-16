//
//  PlaylistCategoryTableViewCell.swift
//  Disctopia
//
//  Created by Damini on 12/07/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit
import SwiftyJSON

class PlaylistCategoryTableViewCell3: UITableViewCell
{

    @IBOutlet weak var cellButton: UIButton!
    
    @IBOutlet var myView: UIView!
    
    
    @IBOutlet var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.delegate = self
        collectionView.dataSource = self
        BaseVC.sharedInstance.changeAllFontinView(self.contentView)
    }
    
    @IBOutlet var lblPlaylistTitle: CustomLabel!
    @IBOutlet var img1: UIImageView!
    @IBOutlet var btnPlaylistOption: UIButton!
    var playListDict : [String : JSON]!
    var playListDictionary : NSMutableDictionary!
    @IBAction func btnPlaylistView(sender: AnyObject)
    {
        
//        let isLocal = playListDictionary["isLocal"] as! String
//        appDelegate.isFromPlaylist = true
//        if isLocal == "0"
//        {
//            appDelegate.selectedPlayListDictionary = playListDictionary
//            let aplayListDict = JSON.parse(playListDictionary["otherData"] as! String)
//            appDelegate.selectedPlaylistId = aplayListDict.dictionary!
//            BaseVC.sharedInstance.pushToViewControllerIfNotExistWithClassName("Playlist1VC", animated: true)
//        }
//        else if isLocal == "1"
//        {
//            appDelegate.selectedPlayListDictionary = playListDictionary
//            BaseVC.sharedInstance.pushToViewControllerIfNotExistWithClassName("Playlist1VC", animated: true)
//        }
        
    }
    
    @IBAction func btnPlaylistOptionTapped(sender: AnyObject)
    {
        //BaseVC.sharedInstance.pushToViewControllerIfNotExistWithClassName("PlaylistOptionListVC", animated: true)
        
        appDelegate.selectedPlaylistId = self.playListDict //String(sender.tag)
        
        DLog("appDelegate.selectedPlaylistId = \(appDelegate.selectedPlaylistId)")
               NSNotificationCenter.defaultCenter().postNotificationName("openPlaylistOption\(appDelegate.selectedPlaylistId["playlistId"]!.stringValue)", object: cellButton)

    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    //MARK:- Setup collectionView datasource and delegate
    
    func setCollectionViewDataSourceDelegate
        <D: protocol<UICollectionViewDataSource, UICollectionViewDelegate>>
        (dataSourceDelegate: D, forRow row: Int) {
        
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        collectionView.reloadData()
    }

}
extension PlaylistCategoryTableViewCell3: UICollectionViewDelegate, UICollectionViewDataSource
{
   
    
    // MARK: - collection view method
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionCell", forIndexPath: indexPath) as! CustomHomePlaylistCollectionCell
        //cell.translatesAutoresizingMaskIntoConstraints = false
        cell.lblArtistName.text = "test"
        cell.backgroundColor = UIColor.redColor()
        return cell
        
        
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        
    }
    
}
