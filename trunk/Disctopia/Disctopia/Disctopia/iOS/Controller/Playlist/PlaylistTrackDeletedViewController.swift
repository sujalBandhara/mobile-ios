//
//  PlaylistTrackDeletedViewController.swift
//  Disctopia
//
//  Created by Damini on 23/07/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit

class PlaylistTrackDeletedViewController: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(true)
        BaseVC.sharedInstance.DLog("WillAppear PlaylistTrackDeletedViewController")
        
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(true)
        BaseVC.sharedInstance.DLog("WillDisappear PlaylistTrackDeletedViewController")
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(true)
        BaseVC.sharedInstance.DLog("DidAppear PlaylistTrackDeletedViewController")
        
        self.performSelector(#selector(moveToParent), withObject: nil, afterDelay: 2.0)
    }
    
    override func viewDidDisappear(animated: Bool)
    {
        super.viewDidDisappear(true)
        BaseVC.sharedInstance.DLog("DidDisappear PlaylistTrackDeletedViewController")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func moveToParent()
    {
        UIView.transitionWithView(self.view, duration: 0.3, options: .TransitionNone, animations: { _ in
            
            self.view.alpha = 0
            
            },
                                  completion: { finished in
                                    
                                    self.willMoveToParentViewController(nil)
                                    self.view.removeFromSuperview()
                                    self.removeFromParentViewController()
        })
    }
    
    @IBAction func btnTrackDeleted(sender: AnyObject)
    {
        //self.pushToViewControllerIfNotExistWithClassName("PlaylistVC", animated: true)
        self.popToSelf(self)
        appDelegate.pagingMenuController.moveToMenuPage(1, animated: true)
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
