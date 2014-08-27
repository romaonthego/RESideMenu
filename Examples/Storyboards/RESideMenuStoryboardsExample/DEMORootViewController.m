//
//  DEMOViewController.m
//  RESideMenuStoryboards
//
//  Created by Roman Efimov on 10/9/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "DEMORootViewController.h"
#import "DEMOLeftMenuViewController.h"

@interface DEMORootViewController ()

@end

@implementation DEMORootViewController

- (void)awakeFromNib
{
    self.menuPreferredStatusBarStyle = UIStatusBarStyleLightContent;
    self.contentViewShadowColor = [UIColor blackColor];
    self.contentViewShadowOffset = CGSizeMake(0, 0);
    self.contentViewShadowOpacity = 0.6;
    self.contentViewShadowRadius = 12;
    self.contentViewShadowEnabled = YES;
    
    self.contentViewScaleValue = 0.6;
    self.contentViewInPortraitOffsetCenterX = -220;
    
    //Enable 3D transformations
    self.use3DTransform = YES;
    
    
    //
    // 3D transformation
    // right menu
    //
    CATransform3D rotationAndPerspectiveTransformRight = CATransform3DIdentity;
    rotationAndPerspectiveTransformRight.m34 = 1.0 / -500;
    rotationAndPerspectiveTransformRight = CATransform3DRotate(rotationAndPerspectiveTransformRight, 25 * M_PI / 180.0f, 0.0f, 1.0f, 0.0f);
    rotationAndPerspectiveTransformRight = CATransform3DTranslate(rotationAndPerspectiveTransformRight, -200, 0, 50);
    rotationAndPerspectiveTransformRight = CATransform3DScale(rotationAndPerspectiveTransformRight, self.contentViewScaleValue, self.contentViewScaleValue, 1);
    self.rightMenu3DTransform = rotationAndPerspectiveTransformRight;
    
    
    //
    // 3D transformation
    // left menu
    //
    CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
    rotationAndPerspectiveTransform.m34 = 1.0 / -500;
    rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, -25 * M_PI / 180.0f, 0.0f, 1.0f, 0.0f);
    rotationAndPerspectiveTransform = CATransform3DTranslate(rotationAndPerspectiveTransform, 170, 0, 0);
    rotationAndPerspectiveTransform = CATransform3DScale(rotationAndPerspectiveTransform, self.contentViewScaleValue, self.contentViewScaleValue, 1);
    self.leftMenu3DTransform = rotationAndPerspectiveTransform;
    
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentViewController"];
    self.leftMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"leftMenuViewController"];
    self.rightMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"rightMenuViewController"];
    self.backgroundImage = [UIImage imageNamed:@"Stars"];
    self.delegate = self;
}

#pragma mark -
#pragma mark RESideMenu Delegate

- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"willShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu didShowMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"didShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu willHideMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"willHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"didHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

@end
