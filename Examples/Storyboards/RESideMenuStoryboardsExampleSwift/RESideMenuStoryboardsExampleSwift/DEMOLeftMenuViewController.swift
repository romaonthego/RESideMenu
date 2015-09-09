//
//  DEMOLeftMenuViewController.swift
//  RESideMenuStoryboardsExampleSwift
//
//  Created by Lucas Farah on 9/8/15.
//  Copyright (c) 2015 Lucas Farah. All rights reserved.
//

import UIKit

class DEMOLeftMenuViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,RESideMenuDelegate {

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
    return 5
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
    
    let titles = ["Home", "Calendar", "Profile", "Settings", "Log Out"]
    let images = ["IconHome", "IconCalendar", "IconProfile", "IconSettings", "IconEmpty"]
    cell.textLabel!.text = titles[indexPath.row]
    cell.imageView!.image = UIImage(named: images[indexPath.row])
    
    return cell
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
  {
    
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
