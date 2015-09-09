//
//  DEMORootViewController.swift
//  RESideMenuStoryboardsExampleSwift
//
//  Created by Lucas Farah on 9/8/15.
//  Copyright (c) 2015 Lucas Farah. All rights reserved.
//

import UIKit

class DEMORootViewController: RESideMenu,RESideMenuDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
  
  override func awakeFromNib()
  {
    self.menuPreferredStatusBarStyle = .LightContent;
    self.contentViewShadowColor = UIColor.blackColor()
    self.contentViewShadowOffset = CGSizeMake(0, 0)
    self.contentViewShadowOpacity = 0.6
    self.contentViewShadowRadius = 12
    self.contentViewShadowEnabled = true
    
    self.contentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("contentViewController") as! UIViewController
    self.leftMenuViewController = self.storyboard?.instantiateViewControllerWithIdentifier("leftMenuViewController") as! UIViewController
    self.rightMenuViewController = self.storyboard?.instantiateViewControllerWithIdentifier("rightMenuViewController") as! UIViewController
    self.backgroundImage = UIImage(named: "Stars")
    self.delegate = self
  }
  
  //MARK: RESideMenu Delegate
  func sideMenu(sideMenu: RESideMenu!, willShowMenuViewController menuViewController: UIViewController!)
  {
    let str = NSStringFromClass(menuViewController.classForCoder)
    println("willShowMenuViewController: \(str)")
  }
  func sideMenu(sideMenu: RESideMenu!, didShowMenuViewController menuViewController: UIViewController!)
  {
    let str = NSStringFromClass(menuViewController.classForCoder)
    println("didShowMenuViewController: \(str)")

  }
  func sideMenu(sideMenu: RESideMenu!, willHideMenuViewController menuViewController: UIViewController!)
  {
    let str = NSStringFromClass(menuViewController.classForCoder)
    println("willHideMenuViewController: \(str)")

  }
  func sideMenu(sideMenu: RESideMenu!, didHideMenuViewController menuViewController: UIViewController!)
  {
    let str = NSStringFromClass(menuViewController.classForCoder)
    println("didHideMenuViewController: \(str)")

  }

}
