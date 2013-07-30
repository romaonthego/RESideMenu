//
//  AppDelegate.m
//  RESideMenuExample
//
//  Created by Roman Efimov on 6/14/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "AppDelegate.h"
#import "DemoViewController.h"
#import "DemoViewController.h"
#import "SecondViewController.h"

#define IS_WIDESCREEN ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@implementation AppDelegate

+ (NSInteger)OSVersion
{
    static NSUInteger _deviceSystemMajorVersion = -1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _deviceSystemMajorVersion = [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
    });
    return _deviceSystemMajorVersion;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
    RESideMenuItem *homeItem = [[RESideMenuItem alloc] initWithTitle:@"Home" action:^(RESideMenu *menu, RESideMenuItem *item) {
        DemoViewController *viewController = [[DemoViewController alloc] init];
        viewController.title = item.title;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
        [menu displayContentController:navigationController];
    }];
    RESideMenuItem *exploreItem = [[RESideMenuItem alloc] initWithTitle:@"Explore" action:^(RESideMenu *menu, RESideMenuItem *item) {
        SecondViewController *secondViewController = [[SecondViewController alloc] init];
        secondViewController.title = item.title;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:secondViewController];
        [menu displayContentController:navigationController];
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
    
    RESideMenuItem *helpCenterItem = [[RESideMenuItem alloc] initWithTitle:@"Help +" action:^(RESideMenu *menu, RESideMenuItem *item) {
        NSLog(@"Item %@", item);
    }];
    helpCenterItem.subItems  = @[helpPlus1,helpPlus2];
    
    RESideMenuItem *itemWithSubItems = [[RESideMenuItem alloc] initWithTitle:@"Sub items +" action:^(RESideMenu *menu, RESideMenuItem *item) {
        NSLog(@"Item %@", item);
    }];
    itemWithSubItems.subItems = @[aroundMeItem,helpCenterItem];
    
    RESideMenuItem *logOutItem = [[RESideMenuItem alloc] initWithTitle:@"Log out" action:^(RESideMenu *menu, RESideMenuItem *item) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Confirmation" message:@"Are you sure you want to log out?" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Log Out", nil];
        [alertView show];
    }];
    
    _sideMenu = [[RESideMenu alloc] initWithItems:@[homeItem, exploreItem, activityItem, profileItem,itemWithSubItems, logOutItem]];
    
    _sideMenu.verticalPortraitOffset = IS_WIDESCREEN ? 110 : 76;
    _sideMenu.verticalLandscapeOffset = 16;
    
    _sideMenu.hideStatusBarArea = [AppDelegate OSVersion] < 7;
    
    _sideMenu.openStatusBarStyle = UIStatusBarStyleBlackTranslucent;
    
    // Call the home action rather than duplicating the initialisation
    homeItem.action(_sideMenu, homeItem);
    
    self.window.rootViewController = _sideMenu;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
