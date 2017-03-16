//
//  SubscriptionExpirePopUpVC.swift
//  Disctopia
//
//  Created by Mitesh on 23/11/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit

class SubscriptionExpirePopUpVC: UIViewController
{

    
    @IBOutlet var btnOk: UIButton!
    // MARK: - LifeCycle Method
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
      
        
        btnOk.layer.borderColor = UIColor.whiteColor().CGColor
        btnOk.layer.borderWidth = 1
        btnOk.exclusiveTouch = true
       
    }
    override func viewWillAppear(animated: Bool)
    {
       
    }
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(true)
        
    }
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(true)
    }
    override func viewDidDisappear(animated: Bool)
    {
        super.viewDidDisappear(true)
    }
    

    @IBAction func btnOkClick(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: {
           
            let vc : UpdateSubscriptionVC = self.storyboard!.instantiateViewControllerWithIdentifier("UpdateSubscriptionVC") as! UpdateSubscriptionVC
            let navigationController = UINavigationController(rootViewController: vc)
            navigationController.modalPresentationStyle = .OverCurrentContext
            appDelegate.navigationController!.presentViewController(navigationController, animated: true, completion: nil)
        })
    }
}
