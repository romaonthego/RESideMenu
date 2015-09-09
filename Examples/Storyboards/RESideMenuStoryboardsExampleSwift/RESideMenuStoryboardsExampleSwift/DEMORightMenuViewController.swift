//
//  DEMORightMenuViewController.swift
//  RESideMenuStoryboardsExampleSwift
//
//  Created by Lucas Farah on 9/8/15.
//  Copyright (c) 2015 Lucas Farah. All rights reserved.
//

import UIKit

class DEMORightMenuViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
  
  @IBOutlet weak var tableView: UITableView!

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor.clearColor()
    
    let table = UITableView(frame: CGRectMake(0, (self.view.frame.size.height-54*5)/2.0, self.view.frame.size.width, 54*5), style: .Plain)
    table.autoresizingMask = UIViewAutoresizing.FlexibleTopMargin | UIViewAutoresizing.FlexibleBottomMargin | UIViewAutoresizing.FlexibleWidth
    table.delegate = self
    table.dataSource = self
    table.opaque = false
    table.backgroundColor = UIColor.clearColor()
    table.backgroundView = nil
    table.separatorStyle = .None
    table.bounces = false
    table.scrollsToTop = false
    
    self.tableView = table
    self.view.addSubview(self.tableView)

  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    return 2
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
  {
    return 54
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
  {
    var cell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell!
    if cell == nil
    {
      cell = UITableViewCell(style:.Default, reuseIdentifier: "cell")
      cell.backgroundColor = UIColor.clearColor()
      cell.textLabel?.font = UIFont(name: "HelveticaNeue", size: 21)
      cell.textLabel?.textColor = UIColor.whiteColor()
      cell.textLabel?.highlightedTextColor = UIColor.lightGrayColor()
      cell.selectedBackgroundView = UIView()
    }
    
    let titles = ["Test 1", "Test 2"]
    cell.textLabel!.text = titles[indexPath.row]
    cell.textLabel?.textAlignment = .Right
    return cell

  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
  {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    switch indexPath.row
    {
    case 0:
      self.sideMenuViewController.setContentViewController(UINavigationController(rootViewController: self.storyboard?.instantiateViewControllerWithIdentifier("firstViewController")as! UIViewController), animated: true)
      self.sideMenuViewController.hideMenuViewController()
      
    case 1:
      self.sideMenuViewController.setContentViewController(UINavigationController(rootViewController: self.storyboard?.instantiateViewControllerWithIdentifier("secondViewController")as! UIViewController), animated: true)
      self.sideMenuViewController.hideMenuViewController()
      
    default:
      break
    }

  }
  
  
}
