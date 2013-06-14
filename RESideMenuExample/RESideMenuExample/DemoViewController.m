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
    RESideMenuItem *homeItem = [[RESideMenuItem alloc] initWithTitle:@"Home" action:^(RESideMenu *menu, RESideMenuItem *item) {
        [menu hide];
        NSLog(@"Item: %@", item);
    }];
    RESideMenuItem *exploreItem = [[RESideMenuItem alloc] initWithTitle:@"Explore" action:^(RESideMenu *menu, RESideMenuItem *item) {
        [menu hide];
        NSLog(@"Item: %@", item);
    }];
    RESideMenuItem *activityItem = [[RESideMenuItem alloc] initWithTitle:@"Activity" action:^(RESideMenu *menu, RESideMenuItem *item) {
        [menu hide];
        NSLog(@"Item: %@", item);
    }];
    RESideMenuItem *profileItem = [[RESideMenuItem alloc] initWithTitle:@"Profile" action:^(RESideMenu *menu, RESideMenuItem *item) {
        [menu hide];
        NSLog(@"Item: %@", item);
    }];
    RESideMenuItem *aroundMeItem = [[RESideMenuItem alloc] initWithTitle:@"Around Me" action:^(RESideMenu *menu, RESideMenuItem *item) {
        [menu hide];
        NSLog(@"Item: %@", item);
    }];
    RESideMenuItem *helpCenterItem = [[RESideMenuItem alloc] initWithTitle:@"Help Center" action:^(RESideMenu *menu, RESideMenuItem *item) {
        [menu hide];
        NSLog(@"Item: %@", item);
    }];
    RESideMenuItem *logOutItem = [[RESideMenuItem alloc] initWithTitle:@"Log out" action:^(RESideMenu *menu, RESideMenuItem *item) {
        [menu hide];
        NSLog(@"Item: %@", item);
    }];
    
    _sideMenu = [[RESideMenu alloc] initWithItems:@[homeItem, exploreItem, activityItem, profileItem, aroundMeItem, helpCenterItem, logOutItem]];
    _sideMenu.verticalOffset = 110;
    [_sideMenu show];
}

@end
