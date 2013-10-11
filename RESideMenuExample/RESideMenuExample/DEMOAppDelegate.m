//
//  DEMOAppDelegate.m
//  RESideMenuExample
//
//  Created by Roman Efimov on 10/10/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "DEMOAppDelegate.h"
#import "DEMONavigationController.h"
#import "DEMOMenuViewController.h"
#import "DEMOFirstViewController.h"

@implementation DEMOAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    DEMONavigationController *navigationController = [[DEMONavigationController alloc] initWithRootViewController:[[DEMOFirstViewController alloc] init]];
    DEMOMenuViewController *menuViewController = [[DEMOMenuViewController alloc] init];
    
    RESideMenu *sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:navigationController menuViewController:menuViewController];
    sideMenuViewController.backgroundImage = [UIImage imageNamed:@"Stars"];
    self.window.rootViewController = sideMenuViewController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
