//
//  LocationUpdateInternal.swift
//  Aamer
//
//  Created by Sujal Bandhara on 03/12/2015.
//  Copyright (c) 2015 byPeople Technologies Pvt Limited. All rights reserved.
//

import Foundation

class LocationUpdateInternal: NSObject {

    static let sharedInstance = LocationUpdateInternal()

    var timerUpdateLocation = NSTimer()

//    func startUpdatingLocationInterval()
//    {
//        self.timerUpdateLocation = NSTimer.scheduledTimerWithTimeInterval(LOCATION_UPDATE_INTERVAL_TIME, target: self, selector: Selector("updateLocation:"), userInfo: nil, repeats: true)
//    }
//    
//    func updateLocation(timer : NSTimer)
//    {
//        appDelegate.sendBackgroundLocationToServer( true)
//    }
//
//    func stopUpdateLocation()
//    {
//        if self.timerUpdateLocation.isKindOfClass(NSTimer)
//        {
//            self.timerUpdateLocation.invalidate()
//        }
//    }
}