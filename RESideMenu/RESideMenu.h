//
// REFrostedViewController.h
// RESideMenu
//
// Copyright (c) 2013-2014 Roman Efimov (https://github.com/romaonthego)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import <UIKit/UIKit.h>
#import "UIViewController+RESideMenu.h"

#ifndef IBInspectable
#define IBInspectable
#endif

@protocol RESideMenuDelegate;

@interface RESideMenu : UIViewController <UIGestureRecognizerDelegate>

#if __IPHONE_8_0
@property (strong, nonatomic) IBInspectable NSString *contentViewStoryboardID;
@property (strong, nonatomic) IBInspectable NSString *leftMenuViewStoryboardID;
@property (strong, nonatomic) IBInspectable NSString *rightMenuViewStoryboardID;
#endif

@property (strong, nonatomic) UIViewController *contentViewController;
@property (strong, nonatomic) UIViewController *leftMenuViewController;
@property (strong, nonatomic) UIViewController *rightMenuViewController;
@property (weak, nonatomic) id<RESideMenuDelegate> delegate;

@property (assign, nonatomic) NSTimeInterval animationDuration;
@property (strong, nonatomic) UIImage *backgroundImage;
@property (assign, nonatomic) BOOL panGestureEnabled;
@property (assign, nonatomic) BOOL panFromEdge;
@property (assign, nonatomic) NSUInteger panMinimumOpenThreshold;
@property (assign, nonatomic) IBInspectable BOOL interactivePopGestureRecognizerEnabled;
@property (assign, nonatomic) IBInspectable BOOL fadeMenuView;
@property (assign, nonatomic) IBInspectable BOOL scaleContentView;
@property (assign, nonatomic) IBInspectable BOOL scaleBackgroundImageView;
@property (assign, nonatomic) IBInspectable BOOL scaleMenuView;
@property (assign, nonatomic) IBInspectable BOOL contentViewShadowEnabled;
@property (strong, nonatomic) IBInspectable UIColor *contentViewShadowColor;
@property (assign, nonatomic) IBInspectable CGSize contentViewShadowOffset;
@property (assign, nonatomic) IBInspectable CGFloat contentViewShadowOpacity;
@property (assign, nonatomic) IBInspectable CGFloat contentViewShadowRadius;
@property (assign, nonatomic) IBInspectable CGFloat contentViewFadeOutAlpha;
@property (assign, nonatomic) IBInspectable CGFloat contentViewScaleValue;
@property (assign, nonatomic) IBInspectable CGFloat contentViewInLandscapeOffsetCenterX;
@property (assign, nonatomic) IBInspectable CGFloat contentViewInPortraitOffsetCenterX;
@property (assign, nonatomic) IBInspectable CGFloat parallaxMenuMinimumRelativeValue;
@property (assign, nonatomic) IBInspectable CGFloat parallaxMenuMaximumRelativeValue;
@property (assign, nonatomic) IBInspectable CGFloat parallaxContentMinimumRelativeValue;
@property (assign, nonatomic) IBInspectable CGFloat parallaxContentMaximumRelativeValue;
@property (assign, nonatomic) CGAffineTransform menuViewControllerTransformation;
@property (assign, nonatomic) IBInspectable BOOL parallaxEnabled;
@property (assign, nonatomic) IBInspectable BOOL bouncesHorizontally;
@property (assign, nonatomic) UIStatusBarStyle menuPreferredStatusBarStyle;
@property (assign, nonatomic) IBInspectable BOOL menuPrefersStatusBarHidden;

- (id)initWithContentViewController:(UIViewController *)contentViewController
             leftMenuViewController:(UIViewController *)leftMenuViewController
            rightMenuViewController:(UIViewController *)rightMenuViewController;
- (void)presentLeftMenuViewController;
- (void)presentRightMenuViewController;
- (void)hideMenuViewController;
- (void)setContentViewController:(UIViewController *)contentViewController animated:(BOOL)animated;

@end

@protocol RESideMenuDelegate <NSObject>

@optional
- (void)sideMenu:(RESideMenu *)sideMenu didRecognizePanGesture:(UIPanGestureRecognizer *)recognizer;
- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController;
- (void)sideMenu:(RESideMenu *)sideMenu didShowMenuViewController:(UIViewController *)menuViewController;
- (void)sideMenu:(RESideMenu *)sideMenu willHideMenuViewController:(UIViewController *)menuViewController;
- (void)sideMenu:(RESideMenu *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController;

@end
