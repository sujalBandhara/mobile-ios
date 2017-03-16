//
//  GiveFeedbackVC.swift
//  Disctopia
//
//  Created by Mitesh on 3/2/17.
//  Copyright © 2017 'byPeople Technologies'. All rights reserved.
//

import UIKit

class GiveFeedbackVC: BaseVC
{

    
    // MARK: - Variable
    
    // MARK: - Outlet
    
    @IBOutlet var txtLikeAboutApp: UITextView!
    
    @IBOutlet var txtChangeAboutApp: UITextView!
    
    @IBOutlet var imgAnimationView: UIImageView!
    
    @IBOutlet var btnSubmit: UIButton!
   
    @IBOutlet var btnCancel: UIButton!
    
    // MARK: - LifeCycle Method -
   
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.btnSubmit.layer.borderWidth = 1
        self.btnSubmit.layer.borderColor = UIColor.whiteColor().CGColor
        self.btnCancel.layer.borderWidth = 1
        self.btnCancel.layer.borderColor = UIColor.whiteColor().CGColor
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Button Actions
    
    @IBAction func btnOnClickSubmit(sender: AnyObject)
    {
        
    }
    
    
    @IBAction func btnOnClickCancel(sender: AnyObject)
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
