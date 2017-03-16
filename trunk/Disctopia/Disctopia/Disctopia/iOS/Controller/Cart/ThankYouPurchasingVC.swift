//
//  ThankYouPurchasingVC.swift
//  Disctopia
//
//  Created by Brijesh shiroya on 9/23/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit

class ThankYouPurchasingVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet var btnExplore: UIButton!
    @IBOutlet var btnMyMusic: UIButton!
    @IBOutlet var btnBackToShoppingCart: UIButton!
    @IBOutlet var lblThankyou: UILabel!
    @IBOutlet var animationView: UIImageView!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func OnMyMusicClick(sender: AnyObject)
    {
        /*
        if self.btnMyMusic.frame.origin.y == self.animationView.frame.origin.y
        {
            print("MyMusic Click")
            self.dismissViewControllerAnimated(false, completion: { () -> Void in
                //self.pushToViewControllerIfNotExistWithClassName("MyMusicPlaylistVC", animated: true)
                self.popToRootViewController()
                appDelegate.pagingMenuController.moveToMenuPage(0, animated: true)

            })
        }
        else
        {
            UIView.animateWithDuration(0.5)
            {
                self.animationView.frame = CGRectMake(self.btnMyMusic.frame.origin.x, self.btnMyMusic.frame.origin.y, self.btnMyMusic.frame.size.width, self.btnMyMusic.frame.size.height)
            }
        }
 */

                //self.view.removeFromSuperview()
                UIView.animateWithDuration(0.5, animations: {() -> Void in
                    self.animationView.frame = CGRectMake(self.btnMyMusic.frame.origin.x, self.btnMyMusic.frame.origin.y, self.btnMyMusic.frame.size.width, self.btnMyMusic.frame.size.height)
                    }, completion: {(finished: Bool) -> Void in
                           //self.pushToViewControllerIfNotExistWithClassName("MyMusicPlaylistVC", animated: true)
                            self.popToRootViewController()
                           appDelegate.pagingMenuController.moveToMenuPage(0, animated: true)
                           
               })
//        UIView.animateWithDuration(0.5, animations: {() -> Void in
//            self.animationView.frame = CGRectMake(self.btnMyMusic.frame.origin.x, self.btnMyMusic.frame.origin.y, self.btnMyMusic.frame.size.width, self.btnMyMusic.frame.size.height)
//            }, completion: {(finished: Bool) -> Void in
//                self.dismissViewControllerAnimated(false, completion: { () -> Void in
//                    //self.pushToViewControllerIfNotExistWithClassName("MyMusicPlaylistVC", animated: true)
//                    self.popToRootViewController()
//                    appDelegate.pagingMenuController.moveToMenuPage(0, animated: true)
//                    
//                })
//        })
    }
   
    @IBAction func OnBackToShoppinfClick(sender: AnyObject)
    {
        /*
        if self.btnBackToShoppingCart.frame.origin.y == self.animationView.frame.origin.y
        {
            print("BackToShopping Click")
            self.dismissViewControllerAnimated(false, completion: { () -> Void in
                      //  self.pushToViewControllerIfNotExistWithClassName("CartSummaryVC", animated: true)
                 NSNotificationCenter.defaultCenter().postNotificationName("reloadShoppingCart", object: nil)
            })
        }
        else
        {
            UIView.animateWithDuration(0.5)
            {
                self.animationView.frame = CGRectMake(self.btnBackToShoppingCart.frame.origin.x, self.btnBackToShoppingCart.frame.origin.y, self.btnBackToShoppingCart.frame.size.width, self.btnBackToShoppingCart.frame.size.height)
            }
        }
        
 */
        UIView.animateWithDuration(0.5, animations: {() -> Void in
            self.animationView.frame = CGRectMake(self.btnBackToShoppingCart.frame.origin.x, self.btnBackToShoppingCart.frame.origin.y, self.btnBackToShoppingCart.frame.size.width, self.btnBackToShoppingCart.frame.size.height)
            }, completion: {(finished: Bool) -> Void in
                //self.dismissViewControllerAnimated(false, completion: { () -> Void in
                    //  self.pushToViewControllerIfNotExistWithClassName("CartSummaryVC", animated: true)
                self.view.removeFromSuperview()
                    NSNotificationCenter.defaultCenter().postNotificationName("reloadShoppingCart", object: nil)
               // })
        })

        
    }

    @IBAction func OnExploreClick(sender: AnyObject)
    {
        /*
        if self.btnExplore.frame.origin.y == self.animationView.frame.origin.y
        {
            print("Explore Click")
            self.dismissViewControllerAnimated(false, completion: { () -> Void in
               // self.pushToViewControllerIfNotExistWithClassName("MyMusicExploreVC", animated: true)
                self.popToRootViewController()
                appDelegate.pagingMenuController.moveToMenuPage(3, animated: true)
            })
        }
        else
        {
            UIView.animateWithDuration(0.5)
            {
                self.animationView.frame = CGRectMake(self.btnExplore.frame.origin.x, self.btnExplore.frame.origin.y, self.btnExplore.frame.size.width, self.btnExplore.frame.size.height)
            }
        }
        */
        
        UIView.animateWithDuration(0.5, animations: {() -> Void in
            self.animationView.frame = CGRectMake(self.btnExplore.frame.origin.x, self.btnExplore.frame.origin.y, self.btnExplore.frame.size.width, self.btnExplore.frame.size.height)
            }, completion: {(finished: Bool) -> Void in
               // self.dismissViewControllerAnimated(false, completion: { () -> Void in
                    // self.pushToViewControllerIfNotExistWithClassName("MyMusicExploreVC", animated: true)
                    self.popToRootViewController()
                    appDelegate.pagingMenuController.moveToMenuPage(3, animated: true)
                //})
        })
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
