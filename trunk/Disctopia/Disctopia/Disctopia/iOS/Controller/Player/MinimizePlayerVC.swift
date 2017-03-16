//
//  MinimizePlayerVC.swift
//  Disctopia
//
//  Created by Mitesh on 26/08/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import MediaPlayer

class MinimizePlayerVC: BaseVC
{
    
    // MARK: - LifeCycle Method -
    class var sharedPlayerInstance2: MinimizePlayerVC
    {
        struct Static
        {
            static let instance = MinimizePlayerVC.instantiateFromStoryboard()
        }
        return Static.instance
    }
    
    class func instantiateFromStoryboard() -> MinimizePlayerVC
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier(String(self)) as! MinimizePlayerVC
    }
    
    override func viewWillAppear(animated: Bool)
    {
        if appDelegate.minimizePlayerView == nil
        {
            if let aPlayderView =  self.view.viewWithTag(555) as? PlayerBaseVC
            {
                appDelegate.minimizePlayerView = aPlayderView
            }
        }
        
        self.isMiniPlayerVisible()
        super.viewWillAppear(animated)
        if appDelegate.playerView != nil
        {
            //appDelegate.playerView.btnPlay.selected = LocalSongPlayer.sharedPlayerInstance1.btnPlaySelected
        }
        //setupPlayer()
    }
    
    func setupPlayer()
    {
        
        self.navigationController?.navigationBarHidden = true
        appDelegate.playerView.isLocal = LocalSongPlayer.sharedPlayerInstance1.isLocal
        appDelegate.playerView.currTrackIndex = LocalSongPlayer.sharedPlayerInstance1.currTrackIndex
        
        //appDelegate.playerView.trackArrayPlayer = LocalSongPlayer.sharedPlayerInstance1.trackArrayPlayer
        appDelegate.playerView.addTracksToPlayer()
        appDelegate.playerView.btnPlay.selected = false
        if appDelegate.playerView.viewPlayer != nil
        {
            appDelegate.playerView.viewPlayer.layer.cornerRadius = 3.0
        }
        appDelegate.playerView.parentVC = self
    }
}
