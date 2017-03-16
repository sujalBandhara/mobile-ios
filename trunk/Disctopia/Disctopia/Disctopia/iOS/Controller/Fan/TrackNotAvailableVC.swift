//
//  TrackNotAvailableVC.swift
//  Disctopia
//
//  Created by Brijesh shiroya on 9/30/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit

class TrackNotAvailableVC: BaseVC {

    @IBOutlet weak var trackFavAddNotificatioView: UIView!
    @IBOutlet weak var trackAddRemoveLabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: #selector(TrackNotAvailableVC.onCloseSaveChangeView(_:)), userInfo: nil, repeats: false)
    }
    @IBAction func onCloseSaveChangeView(sender: UIButton)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
        
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
