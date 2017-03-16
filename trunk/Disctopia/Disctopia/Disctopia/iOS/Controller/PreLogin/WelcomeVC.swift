//
//  WelcomeVC.swift
//  Disctopia
//
//  Created by Brijesh shiroya on 9/30/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit

class WelcomeVC: BaseVC,UIScrollViewDelegate,UIGestureRecognizerDelegate {
    
    //MARK: Outlets -
    @IBOutlet var btnStartNow: UIButton!
    
    //MARK: variables
    
    let scrollView = UIScrollView(frame: CGRectMake(0, 0, ScreenSize.SCREEN_WIDTH,ScreenSize.SCREEN_HEIGHT))
    var colors:[UIColor] = [UIColor.redColor(), UIColor.blueColor(), UIColor.greenColor(), UIColor.yellowColor()]
    var frame: CGRect = CGRectMake(0, 0, 0, 0)
    var pageControl : UIPageControl = UIPageControl(frame: CGRectMake(0, 0, ScreenSize.SCREEN_WIDTH,ScreenSize.SCREEN_HEIGHT))
    var imageNameArray = ["Onboarding-1.png","Onboarding-2.png","Onboarding-3.png","Onboarding-4.png"]
    
    //MARK: view LifeCycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnStartNow.hidden = true
        
        configurePageControl()
        
        scrollView.delegate = self
        self.view.addSubview(scrollView)
        for index in 0..<imageNameArray.count {
            
            frame.origin.x = self.scrollView.frame.size.width * CGFloat(index)
            frame.size = self.scrollView.frame.size
            self.scrollView.pagingEnabled = true
            //  let subView = UIView(frame: frame)
            let imgView:UIImageView = UIImageView(frame: frame)
            imgView.contentMode = UIViewContentMode.ScaleAspectFit
            imgView.image = UIImage(named: imageNameArray[index])
            //             self.scrollView .addSubview(imgView)
            //
            //            subView.backgroundColor = colors[index]
            //            if(index == 3)
            //            {
            //                let btn:UIButton = UIButton(frame: subView.frame)
            //                btn.addTarget(self, action:  #selector(WelcomeVC.onLastClick), forControlEvents: .TouchUpInside)
            //                subView.addSubview(btn)
            //            }
            self.scrollView .addSubview(imgView)
        }
        
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * CGFloat(imageNameArray.count), self.scrollView.frame.size.height)
        pageControl.addTarget(self, action: #selector(WelcomeVC.changePage(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Button Actions -
    
    func onLastClick()
    {
        
    }
    
    @IBAction func OnStartClick(sender: AnyObject)
    {
    
        if((NSUserDefaults.standardUserDefaults().valueForKey("isFirstTime") == nil))
        {
            NSUserDefaults.standardUserDefaults().setValue("1", forKey: "isFirstTime")
        }
       // self.pushToViewControllerIfNotExistWithClassName("LoginVC", animated: true)
        appDelegate.loadFirstViewController("LoginVC")
    }
    
    //MARK: pageControl Delegates -
    func configurePageControl() {
        // The total number of pages that are available is based on how many available colors we have.
        self.pageControl.numberOfPages = colors.count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.redColor()
        self.pageControl.pageIndicatorTintColor = UIColor.blackColor()
        self.pageControl.currentPageIndicatorTintColor = UIColor.greenColor()
        self.view.addSubview(pageControl)
        
    }
    
    
    func changePage(sender: AnyObject) -> () {
        let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPointMake(x, 0), animated: true)
    }
    
    //MARK: ScrollView Delegates -
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
        //        for uiview in self.view.subviews
        //        {
        //            if uiview is UIButton
        //            {
        //                uiview.removeFromSuperview()
        //            }
        //        }
        //self.btnStartNow.hidden = true
        if pageControl.currentPage == 2
        {
            //            self.btnStartNow.superview!.removeFromSuperview()
            //                  UIView.animateWithDuration(0.1,
            //                                   animations: {
            //                                  //  self.btnStartNow.layoutIfNeeded()
            //                                    self.btnStartNow.transform = CGAffineTransformMakeScale(1, 0)
            //            },
            //                                   completion: { finish in
            //                                    UIView.animateWithDuration(0.4){
            //                                       self.btnStartNow.transform = CGAffineTransformIdentity
            ////                                        self.btnStartNow.transform = CGAffineTransformMakeScale(0, 1)
            //                                    }
            //        })
        }
        
        if pageControl.currentPage == 3
        {
            self.ShowStartNow()
            // let btn:UIButton = UIButton(frame: CGRectMake(0,0,414,736))
            // btn.addTarget(self, action:  #selector(WelcomeVC.onLastClick), forControlEvents: .TouchUpInside)
            // self.view.addSubview(btn)
        }
    }
    
    //MARK: Other Functions -
    func ShowStartNow()
    {
        if self.btnStartNow.hidden == true
        {
            self.btnStartNow.hidden = false
            
            if self.btnStartNow.superview != nil
            {
                self.btnStartNow.superview!.layoutIfNeeded()
                self.view.addSubview(self.btnStartNow.superview!)
                //            btnSignin.transform = CGAffineTransformMakeScale(0.6, 0.6)
                UIView.animateWithDuration(0.1,
                                           animations: {
                                            self.btnStartNow.layoutIfNeeded()
                                            self.btnStartNow.transform = CGAffineTransformMakeScale(0, 1)
                    },
                                           completion: { finish in
                                            UIView.animateWithDuration(0.4){
                                                self.btnStartNow.transform = CGAffineTransformIdentity
                                            }
                })
            }
        }
        
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
