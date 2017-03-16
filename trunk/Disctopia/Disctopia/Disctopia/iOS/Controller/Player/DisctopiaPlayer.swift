//
//  DisctopiaPlayer.swift
//  Disctopia
//
//  Created by Sujal on 05/10/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

protocol errorMessageDelegate {
    func errorMessageChanged(newVal: String)
}

protocol sharedInstanceDelegate {
    func sharedInstanceChanged(newVal: Bool)
}

class DisctopiaPlayer : NSObject {
    
    static let sharedInstance = DisctopiaPlayer()
    var instanceDelegate:sharedInstanceDelegate? = nil
    var sharedInstanceBool = false {
        didSet {
            if let delegate = self.instanceDelegate {
                delegate.sharedInstanceChanged(self.sharedInstanceBool)
            }
        }
    }
    private var player = AVPlayer(URL: NSURL(string: (""/*Globals.radioURL*/))!)
    private var playerItem = AVPlayerItem?()
    private var isPlaying = false
    
    var errorDelegate:errorMessageDelegate? = nil
    var errorMessage = "" {
        didSet {
            if let delegate = self.errorDelegate {
                delegate.errorMessageChanged(self.errorMessage)
            }
        }
    }
    
    override init() {
        super.init()
        
        errorMessage = ""
        
        let asset: AVURLAsset = AVURLAsset(URL: NSURL(string: ""/*Globals.radioURL*/)!, options: nil)
        
        let statusKey = "tracks"
        
        asset.loadValuesAsynchronouslyForKeys([statusKey], completionHandler: {
            var error: NSError? = nil
            
            dispatch_async(dispatch_get_main_queue(), {
                let status: AVKeyValueStatus = asset.statusOfValueForKey(statusKey, error: &error)
                
                if status == AVKeyValueStatus.Loaded{
                    
                    let playerItem = AVPlayerItem(asset: asset)
                    
                    self.player = AVPlayer(playerItem: playerItem)
                    self.sharedInstanceBool = true
                    
                } else {
                    self.errorMessage = error!.localizedDescription
                    print(error!)
                }
                
            })
            
            
        })
        
        NSNotificationCenter.defaultCenter().addObserverForName(
            AVPlayerItemFailedToPlayToEndTimeNotification,
            object: nil,
            queue: nil,
            usingBlock: { notification in
                print("Status: Failed to continue")
                self.errorMessage = "Stream was interrupted"
        })
        
        print("Initializing new player")
        
    }
    
    func resetPlayer() {
        errorMessage = ""
        
        let asset: AVURLAsset = AVURLAsset(URL: NSURL(string: ""/*Globals.radioURL*/)!, options: nil)
        
        let statusKey = "tracks"
        
        asset.loadValuesAsynchronouslyForKeys([statusKey], completionHandler: {
            var error: NSError? = nil
            
            dispatch_async(dispatch_get_main_queue(), {
                let status: AVKeyValueStatus = asset.statusOfValueForKey(statusKey, error: &error)
                
                if status == AVKeyValueStatus.Loaded{
                    
                    let playerItem = AVPlayerItem(asset: asset)
                    //playerItem.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.New, context: &ItemStatusContext)
                    
                    self.player = AVPlayer(playerItem: playerItem)
                    self.sharedInstanceBool = true
                    
                } else {
                    self.errorMessage = error!.localizedDescription
                    print(error!)
                }
                
            })
        })
    }
    
    func bufferFull() -> Bool {
        return bufferAvailableSeconds() > 45.0
    }
    
    func bufferAvailableSeconds() -> NSTimeInterval {
        // Check if there is a player instance
        if ((player.currentItem) != nil) {
            
            // Get current AVPlayerItem
            let item: AVPlayerItem = player.currentItem!
            if (item.status == AVPlayerItemStatus.ReadyToPlay) {
                
                let timeRangeArray: NSArray = item.loadedTimeRanges
                if timeRangeArray.count < 1 { return(CMTimeGetSeconds(kCMTimeInvalid)) }
                let aTimeRange: CMTimeRange = timeRangeArray.objectAtIndex(0).CMTimeRangeValue
                //let startTime = CMTimeGetSeconds(aTimeRange.end)
                let loadedDuration = CMTimeGetSeconds(aTimeRange.duration)
                
                return (NSTimeInterval)(loadedDuration);
            }
            else {
                return(CMTimeGetSeconds(kCMTimeInvalid))
            }
        }
        else {
            return(CMTimeGetSeconds(kCMTimeInvalid))
        }
    }
    
    func play() {
        player.play()
        isPlaying = true
        print("Radio is \(isPlaying ? "" : "not ")playing")
    }
    
    func pause() {
        player.pause()
        isPlaying = false
        print("Radio is \(isPlaying ? "" : "not ")playing")
    }
    
    func currentlyPlaying() -> Bool {
        return isPlaying
    }
    
}