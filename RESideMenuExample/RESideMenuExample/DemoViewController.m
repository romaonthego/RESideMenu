//
//  DemoViewController.m
//  RESideMenuExample
//
//  Created by Roman Efimov on 6/14/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "DemoViewController.h"
#import "REBackgroundView.h"
#import "RESideMenu.h"

@interface DemoViewController ()

@end

@implementation DemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	//REBackgroundView *view = [[REBackgroundView alloc] initWithFrame:self.view.bounds];
    //[self.view addSubview:view];
    self.title = @"RESideMenu";
    self.view.backgroundColor = [UIColor colorWithWhite:0.902 alpha:1.000];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self action:@selector(showMenu)];
}

#pragma mark -
#pragma mark Button actions

- (void)showMenu
{
    _sideMenu = [[RESideMenu alloc] init];
    [_sideMenu show];
}

@end
