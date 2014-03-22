//
// REFrostedViewController.h
// RESideMenu
//
// Copyright (c) 2013 Roman Efimov (https://github.com/romaonthego)
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

@protocol RESideMenuDelegate;

@interface RESideMenu : UIViewController <UIGestureRecognizerDelegate>

@property (strong, readwrite, nonatomic) UIViewController *contentViewController;
@property (strong, readwrite, nonatomic) UIViewController *leftMenuViewController;
@property (strong, readwrite, nonatomic) UIViewController *tempViewController;
@property (weak, readwrite, nonatomic) id<RESideMenuDelegate> delegate;

@property (assign, readwrite, nonatomic) NSTimeInterval animationDuration; //tested
@property (strong, readwrite, nonatomic) UIImage *backgroundImage; //tested
@property (assign, readwrite, nonatomic) BOOL panGestureEnabled; //tested
@property (assign, readwrite, nonatomic) BOOL panFromEdge; //tested
@property (assign, readwrite, nonatomic) BOOL interactivePopGestureRecognizerEnabled;
@property (assign, readwrite, nonatomic) BOOL scaleContentView; //tested
@property (assign, readwrite, nonatomic) BOOL scaleBackgroundImageView; //tested
@property (assign, readwrite, nonatomic) BOOL contentViewShadowEnabled; //tested
@property (assign, readwrite, nonatomic) UIColor *contentViewShadowColor; //tested
@property (assign, readwrite, nonatomic) CGSize contentViewShadowOffset; //tested
@property (assign, readwrite, nonatomic) CGFloat contentViewShadowOpacity; //tested
@property (assign, readwrite, nonatomic) CGFloat contentViewShadowRadius; //tested
@property (assign, readwrite, nonatomic) CGFloat contentViewScaleValue; //tested
@property (assign, readwrite, nonatomic) CGFloat contentViewInLandscapeOffsetCenterX;
@property (assign, readwrite, nonatomic) CGFloat contentViewInPortraitOffsetCenterX;
@property (assign, readwrite, nonatomic) CGFloat parallaxMenuMinimumRelativeValue; //tested
@property (assign, readwrite, nonatomic) CGFloat parallaxMenuMaximumRelativeValue; //tested
@property (assign, readwrite, nonatomic) CGFloat parallaxContentMinimumRelativeValue; //tested
@property (assign, readwrite, nonatomic) CGFloat parallaxContentMaximumRelativeValue; //tested
@property (assign, readwrite, nonatomic) CGAffineTransform menuViewControllerTransformation; //tested
@property (assign, readwrite, nonatomic) BOOL parallaxEnabled; //tested
@property (assign, readwrite, nonatomic) BOOL bouncesHorizontally; //tested
@property (assign, readwrite, nonatomic) UIStatusBarStyle menuPreferredStatusBarStyle; //tested
@property (assign, readwrite, nonatomic) BOOL menuPrefersStatusBarHidden; //tested

- (id)initWithContentViewController:(UIViewController *)contentViewController leftMenuViewController:(UIViewController *)leftMenuViewController;
- (void)setContentViewController:(UIViewController *)contentViewController animated:(BOOL)animated;
- (void)presentLeftMenuViewController;
- (void)presentTempViewController;
- (void)hideMenuViewController;

@end

@protocol RESideMenuDelegate <NSObject>

@optional
- (void)sideMenu:(RESideMenu *)sideMenu didRecognizePanGesture:(UIPanGestureRecognizer *)recognizer;
- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController;
- (void)sideMenu:(RESideMenu *)sideMenu didShowMenuViewController:(UIViewController *)menuViewController;
- (void)sideMenu:(RESideMenu *)sideMenu willHideMenuViewController:(UIViewController *)menuViewController;
- (void)sideMenu:(RESideMenu *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController;

@end