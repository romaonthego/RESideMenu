//
//  SecondViewController.m
//  RESideMenuExample
//
//  Created by Roman Efimov on 6/14/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "SecondViewController.h"
#import "DemoViewController.h"
#import "AppDelegate.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.902 green:0.859 blue:0.487 alpha:1.000];
    [self.navigationController.navigationBar setTitleTextAttributes:@{UITextAttributeTextColor: [UIColor whiteColor]}];
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBarTintColor:)]) {
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
        [self.navigationController.navigationBar performSelector:@selector(setBarTintColor:) withObject:[UIColor blueColor]];
    } else {
        [self.navigationController.navigationBar setTintColor:[UIColor blueColor]];
    }
}

#ifdef __IPHONE_7_0
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
#endif

@end
