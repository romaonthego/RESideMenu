//
//  DemoViewController.m
//  RESideMenuExample
//
//  Created by Roman Efimov on 6/14/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "DemoViewController.h"
#import "SecondViewController.h"

@interface DemoViewController ()

@end

@implementation DemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"RESideMenu";
    self.view.backgroundColor = [UIColor colorWithWhite:0.902 alpha:1.000];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self action:@selector(showMenu)];
}

#pragma mark -
#pragma mark Button actions

- (void)showMenu
{
    RESideMenuItem *homeItem = [[RESideMenuItem alloc] initWithTitle:@"Home" action:^(RESideMenu *menu, RESideMenuItem *item) {
        [menu hide];
        
        SecondViewController *secondViewController = [[SecondViewController alloc] init];
        secondViewController.title = item.title;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:secondViewController];
        [menu setRootViewController:navigationController];
    }];
    RESideMenuItem *exploreItem = [[RESideMenuItem alloc] initWithTitle:@"Explore" action:^(RESideMenu *menu, RESideMenuItem *item) {
        [menu hide];
        SecondViewController *secondViewController = [[SecondViewController alloc] init];
        secondViewController.title = item.title;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:secondViewController];
        [menu setRootViewController:navigationController];
    }];
    RESideMenuItem *activityItem = [[RESideMenuItem alloc] initWithTitle:@"Activity" action:^(RESideMenu *menu, RESideMenuItem *item) {
        [menu hide];
        SecondViewController *secondViewController = [[SecondViewController alloc] init];
        secondViewController.title = item.title;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:secondViewController];
        [menu setRootViewController:navigationController];
    }];
    RESideMenuItem *profileItem = [[RESideMenuItem alloc] initWithTitle:@"Profile" action:^(RESideMenu *menu, RESideMenuItem *item) {
        [menu hide];
        SecondViewController *secondViewController = [[SecondViewController alloc] init];
        secondViewController.title = item.title;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:secondViewController];
        [menu setRootViewController:navigationController];
    }];
    RESideMenuItem *aroundMeItem = [[RESideMenuItem alloc] initWithTitle:@"Around Me" action:^(RESideMenu *menu, RESideMenuItem *item) {
        [menu hide];
        SecondViewController *secondViewController = [[SecondViewController alloc] init];
        secondViewController.title = item.title;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:secondViewController];
        [menu setRootViewController:navigationController];
    }];
    RESideMenuItem *helpCenterItem = [[RESideMenuItem alloc] initWithTitle:@"Help Center" action:^(RESideMenu *menu, RESideMenuItem *item) {
        [menu hide];
        SecondViewController *secondViewController = [[SecondViewController alloc] init];
        secondViewController.title = item.title;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:secondViewController];
        [menu setRootViewController:navigationController];
    }];
    RESideMenuItem *logOutItem = [[RESideMenuItem alloc] initWithTitle:@"Log out" action:^(RESideMenu *menu, RESideMenuItem *item) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Confirmation" message:@"Are you sure you want to log out?" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Log Out", nil];
        [alertView show];
    }];
    
    _sideMenu = [[RESideMenu alloc] initWithItems:@[homeItem, exploreItem, activityItem, profileItem, aroundMeItem, helpCenterItem, logOutItem]];
    _sideMenu.verticalOffset = IS_WIDESCREEN ? 110 : 76;
    [_sideMenu show];
}

@end
