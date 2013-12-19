//
//  DEMOSecondViewController.m
//  RESideMenuExample
//
//  Created by Roman Efimov on 10/10/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "DEMOSecondViewController.h"

@implementation DEMOSecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.title = @"Second Controller";
    self.view.backgroundColor = [UIColor orangeColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Left Menu"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(showLeftMenu)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Right Menu"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(showRightMenu)];
}

- (void)showLeftMenu
{
    [self.sideMenuViewController presentMenuViewControllerOnSide:MenuAligmentLeft];
}

- (void)showRightMenu
{
    [self.sideMenuViewController presentMenuViewControllerOnSide:MenuAligmentRight];
}
@end
