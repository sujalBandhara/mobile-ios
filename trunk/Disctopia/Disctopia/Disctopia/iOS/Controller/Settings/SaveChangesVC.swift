//
//  SaveChangesVC.swift
//  Disctopia
//
//  Created by Brijesh shiroya on 10/12/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit

class SaveChangesVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: #selector(SaveChangesVC.onCloseSaveChangeView(_:)), userInfo: nil, repeats: false)
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
