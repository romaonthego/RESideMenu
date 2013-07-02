//
//  RootViewController.m
//  RESideMenuExample
//
//  Created by Roman Efimov on 6/26/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "RootViewController.h"
#import "DemoViewController.h"
#import "SecondViewController.h"
#import "AppDelegate.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self action:@selector(showMenu)];
}

#pragma mark -
#pragma mark Button actions

- (void)showMenu
{
    if (!_sideMenu) {
        RESideMenuItem *homeItem = [[RESideMenuItem alloc] initWithTitle:@"Home" action:^(RESideMenu *menu, RESideMenuItem *item) {
            [menu hide];
            
            DemoViewController *viewController = [[DemoViewController alloc] init];
            viewController.title = item.title;
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
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
            NSLog(@"Item %@", item);
        }];
        RESideMenuItem *profileItem = [[RESideMenuItem alloc] initWithTitle:@"Profile" action:^(RESideMenu *menu, RESideMenuItem *item) {
            [menu hide];
            NSLog(@"Item %@", item);
        }];
        RESideMenuItem *aroundMeItem = [[RESideMenuItem alloc] initWithTitle:@"Around Me" action:^(RESideMenu *menu, RESideMenuItem *item) {
            [menu hide];
            NSLog(@"Item %@", item);
        }];
        
        RESideMenuItem *helpPlus1 = [[RESideMenuItem alloc] initWithTitle:@"How to use" action:^(RESideMenu *menu, RESideMenuItem *item) {
            NSLog(@"Item %@", item);
            [menu hide];
        }];
        
        RESideMenuItem *helpPlus2 = [[RESideMenuItem alloc] initWithTitle:@"Helpdesk" action:^(RESideMenu *menu, RESideMenuItem *item) {
            NSLog(@"Item %@", item);
            [menu hide];
        }];
        
        RESideMenuItem *helpCenterItem = [[RESideMenuItem alloc] initWithTitle:@"Help+" action:^(RESideMenu *menu, RESideMenuItem *item) {
            NSLog(@"Item %@", item);
        }];
        helpCenterItem.subItems  = @[helpPlus1,helpPlus2];
        
        RESideMenuItem *itemWithSubItems = [[RESideMenuItem alloc] initWithTitle:@"Others+" action:^(RESideMenu *menu, RESideMenuItem *item) {
            NSLog(@"Item %@", item);
        }];
        itemWithSubItems.subItems = @[aroundMeItem,helpCenterItem];
        
        RESideMenuItem *logOutItem = [[RESideMenuItem alloc] initWithTitle:@"Log out" action:^(RESideMenu *menu, RESideMenuItem *item) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Confirmation" message:@"Are you sure you want to log out?" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Log Out", nil];
            [alertView show];
        }];
        
        _sideMenu = [[RESideMenu alloc] initWithItems:@[homeItem, exploreItem, activityItem, profileItem,itemWithSubItems, logOutItem]];
        _sideMenu.verticalOffset = IS_WIDESCREEN ? 110 : 76;
        _sideMenu.hideStatusBarArea = [AppDelegate OSVersion] < 7;
    }
    
    [_sideMenu show];
}

@end
