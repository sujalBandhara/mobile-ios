//
//  createNewPlaylistVC.swift
//  Disctopia
//
//  Created by Dhaval on 30/08/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit

class createNewPlaylistVC: BaseVC
{

    @IBAction func btnCreateNewPlaylist(sender: AnyObject)
    {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc : NewPlaylistVC = storyboard.instantiateViewControllerWithIdentifier("NewPlaylistVC") as! NewPlaylistVC
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.modalPresentationStyle = .OverCurrentContext
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
        // Do any additional setup after loading the view.
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
