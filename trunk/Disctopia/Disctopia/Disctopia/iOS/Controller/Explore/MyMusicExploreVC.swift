//
//  MyMusicExploreVC.swift
//  Disctopia
//
//  Created by Damini on 06/07/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit

class MyMusicExploreVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.pushToViewControllerIfNotExistWithClassName("ExploreVC", animated: false)
        // Do any additional setup after loading the view.
    }
    class func instantiateFromStoryboard() -> MyMusicExploreVC {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier(String(self)) as! MyMusicExploreVC
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
