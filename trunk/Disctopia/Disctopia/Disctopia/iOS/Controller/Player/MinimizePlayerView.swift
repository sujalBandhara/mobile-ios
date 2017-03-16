//
//  MinimizePlayerVC.swift
//  Disctopia
//
//  Created by Mitesh on 02/08/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MediaPlayer

class MinimizePlayerView: PlayerBaseVC
{
    /*
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
     
    override func viewWillAppear(animated: Bool)
    {
        syncPlayerFromSingleton()
        super.viewWillAppear(true)
        //self.reloadArray()
//        if (aExpandedPlayerVC.seekSlider != nil)
//        {
//            self.seekSlider = aExpandedPlayerVC.seekSlider
//        }
        BaseVC.sharedInstance.DLog("WillAppear SearchForMusicVC")
//        if (aExpandedPlayerVC.seekSlider != nil)
//        {
//            aExpandedPlayerVC.seekSlider.setThumbImage(UIImage(named: "green_slider_bar"), forState: UIControlState.Normal)
//            aExpandedPlayerVC.seekSlider.setMaximumTrackImage(UIImage(named: "seekbar_grey.png"), forState: UIControlState.Normal)
//            aExpandedPlayerVC.seekSlider.setMinimumTrackImage(UIImage(named: "seekbar_color.png"), forState: UIControlState.Normal)
//            aExpandedPlayerVC.seekSlider.setThumbImage(UIImage(named: "green_slider_bar"), forState: UIControlState.Highlighted)
//        }
//        else
//        {
//            
//        }
       
        self.seekSlider.setThumbImage(UIImage(named: "green_slider_bar"), forState: UIControlState.Normal)
        self.seekSlider.setMaximumTrackImage(UIImage(named: "seekbar_grey.png"), forState: UIControlState.Normal)
        self.seekSlider.setMinimumTrackImage(UIImage(named: "seekbar_color.png"), forState: UIControlState.Normal)
        self.seekSlider.setThumbImage(UIImage(named: "green_slider_bar"), forState: UIControlState.Highlighted)
        
        if trackArrayPlayer.count > 0
        {
            aExpandedPlayerVC.btnPlay.selected = true
            //onPlayClick(nil)
        }
    }
    
     override func viewWillDisappear(animated: Bool)
     {
     super.viewWillDisappear(true)
     }

    func syncPlayerFromSingleton()
    {
        self.isLocal = aExpandedPlayerVC.isLocal
        if /**/self.isLocal == "0"
        {
            if (aExpandedPlayerVC.trackObjArray.count > aExpandedPlayerVC.currTrackIndex && aExpandedPlayerVC.currTrackIndex > 0)
            {
                self.trackObjArray = aExpandedPlayerVC.trackObjArray
                self.currTrackIndex = aExpandedPlayerVC.currTrackIndex
                self.trackDurationInSecond = aExpandedPlayerVC.trackDurationInSecond
                
                let trackObj = trackObjArray[aExpandedPlayerVC.currTrackIndex]
                //var dictTrackDetails = /**/self.trackArrayPlayer[/**/self.currTrackIndex].dictionaryValue
                let trackName = trackObj.name
                let artistName = trackObj.albumName
                if self.lblTrackTitle != nil
                {
                    /**/self.lblTrackTitle.text = trackName
                }
                
                if self.lblArtistTitle != nil
                {
                    /**/self.lblArtistTitle.text = artistName
                }
            }
        }
        else
        {
            if (aExpandedPlayerVC.trackObjArray.count > aExpandedPlayerVC.currTrackIndex && aExpandedPlayerVC.currTrackIndex > 0)
            {
                self.trackObjArray = aExpandedPlayerVC.trackObjArray
                self.currTrackIndex = aExpandedPlayerVC.currTrackIndex
                self.trackDurationInSecond = aExpandedPlayerVC.trackDurationInSecond
                
                self.lblTrackTitle.text = aExpandedPlayerVC.lblTrackTitle.text
                /**/self.lblArtistTitle.text =  aExpandedPlayerVC.lblArtistTitle.text
            }
            
        }
        
        if aExpandedPlayerVC.seekSlider != nil
        {
            self.seekSlider = aExpandedPlayerVC.seekSlider
        }
        if aExpandedPlayerVC.btnPlay != nil
        {
            self.btnPlay = aExpandedPlayerVC.btnPlay
        }
        if aExpandedPlayerVC.pauseTime != nil
        {
            self.pauseTime = aExpandedPlayerVC.pauseTime
        }
        if aExpandedPlayerVC.timer != nil
        {
            self.timer = aExpandedPlayerVC.timer
            aExpandedPlayerVC.startTrackProgress()
        }
    }

    

    @IBAction func btnPlayAction(sender: AnyObject)
    {
        let aExpandedPlayerVC = LocalSongPlayer.sharedPlayerInstance1
        let navigationController = UINavigationController(rootViewController: aExpandedPlayerVC)
        navigationController.modalPresentationStyle = .OverCurrentContext
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
  */
}
//http://supereasyapps.com/blog/2014/12/15/create-an-ibdesignable-uiview-subclass-with-code-from-an-xib-file-in-xcode-6
// http://stackoverflow.com/questions/32342145/custom-uiview-subclass-with-xib-in-swift