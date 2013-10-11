//
// REFrostedViewController.m
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

#import "RESideMenu.h"
#import "UIViewController+RESideMenu.h"

@interface RESideMenu ()

@property (assign, readwrite, nonatomic) CGFloat imageViewWidth;
@property (strong, readwrite, nonatomic) UIImageView *backgroundImageView;
@property (assign, readwrite, nonatomic) BOOL visible;
@property (assign, readwrite, nonatomic) UIViewAutoresizing contentViewAutoresizingMask;
@property (assign, readwrite, nonatomic) CGPoint originalPoint;

@end

@implementation RESideMenu

- (id)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    self.wantsFullScreenLayout = YES;
    _animationDuration = 0.35f;
    _panGestureEnabled = YES;
}

- (id)initWithContentViewController:(UIViewController *)contentViewController menuViewController:(UIViewController *)menuViewController
{
    self = [self init];
    if (self) {
        _contentViewController = contentViewController;
        _menuViewController = menuViewController;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.backgroundImageView = ({
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        imageView.image = self.backgroundImage;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        imageView;
    });
    
    [self.view addSubview:self.backgroundImageView];
    [self re_displayController:self.menuViewController frame:self.view.frame];
    [self re_displayController:self.contentViewController frame:self.view.frame];
    
    if (self.panGestureEnabled) {
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)];
        [self.view addGestureRecognizer:panGestureRecognizer];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.contentViewController beginAppearanceTransition:YES animated:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.contentViewController endAppearanceTransition];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.contentViewController beginAppearanceTransition:NO animated:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.contentViewController endAppearanceTransition];
}

#pragma mark -

- (void)presentMenuViewController
{
    self.contentViewController.view.userInteractionEnabled = NO;
    self.menuViewController.view.transform = CGAffineTransformIdentity;
    self.backgroundImageView.transform = CGAffineTransformIdentity;
    self.backgroundImageView.frame = self.view.bounds;
    self.menuViewController.view.frame = self.view.bounds;
    self.menuViewController.view.transform = CGAffineTransformMakeScale(1.5f, 1.5f);
    self.menuViewController.view.alpha = 0;
    self.backgroundImageView.transform = CGAffineTransformMakeScale(1.7f, 1.7f);
    [self showMenuViewController];
}

- (void)showMenuViewController
{
    [UIView animateWithDuration:self.animationDuration animations:^{
        self.contentViewController.view.transform = CGAffineTransformMakeScale(0.7f, 0.7f);
        self.contentViewController.view.center = CGPointMake((UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) ? self.view.frame.size.height : self.view.frame.size.width) + 30.0f, self.contentViewController.view.center.y);
        self.menuViewController.view.alpha = 1.0f;
        self.menuViewController.view.transform = CGAffineTransformIdentity;
        self.backgroundImageView.transform = CGAffineTransformIdentity;
    }];
    self.visible = YES;
    [self updateStatusBar];
}

- (void)hideMenuViewController
{
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [UIView animateWithDuration:self.animationDuration animations:^{
        self.contentViewController.view.transform = CGAffineTransformIdentity;
        self.contentViewController.view.frame = self.view.bounds;
        self.menuViewController.view.transform = CGAffineTransformMakeScale(1.5f, 1.5f);
        self.menuViewController.view.alpha = 0;
        self.backgroundImageView.transform = CGAffineTransformMakeScale(1.7f, 1.7f);
    } completion:^(BOOL finished) {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }];
    self.visible = NO;
    self.contentViewController.view.userInteractionEnabled = YES;
    [self updateStatusBar];
}

- (void)panGestureRecognized:(UIPanGestureRecognizer *)recognizer
{
    if (!self.panGestureEnabled)
        return;
    
    CGPoint point = [recognizer translationInView:self.view];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.originalPoint = self.contentViewController.view.frame.origin;
        self.menuViewController.view.transform = CGAffineTransformIdentity;
        self.backgroundImageView.transform = CGAffineTransformIdentity;
        self.backgroundImageView.frame = self.view.bounds;
        self.menuViewController.view.frame = self.view.bounds;
    }
    
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat delta = self.visible ? (point.x + self.originalPoint.x) / self.originalPoint.x : point.x / self.view.frame.size.width;
        
        CGFloat contentViewScale = 1 - (0.3f * delta);
        CGFloat backgroundViewScale = 1.7f - (0.7f * delta);
        CGFloat menuViewScale = 1.5f - (0.5f * delta);
        
        self.menuViewController.view.alpha = delta;
        self.contentViewController.view.userInteractionEnabled = NO;
        self.contentViewController.view.transform = CGAffineTransformMakeScale(contentViewScale, contentViewScale);
        self.backgroundImageView.transform = CGAffineTransformMakeScale(backgroundViewScale, backgroundViewScale);
        self.menuViewController.view.transform = CGAffineTransformMakeScale(menuViewScale, menuViewScale);
        
        if (backgroundViewScale < 1) {
            self.backgroundImageView.transform = CGAffineTransformIdentity;
        }
        
        if (contentViewScale > 1) {
            self.contentViewController.view.transform = CGAffineTransformIdentity;
            CGRect frame = self.contentViewController.view.frame;
            frame.origin.x = 0;
            self.contentViewController.view.frame = frame;
        } else {
            CGRect frame = self.contentViewController.view.frame;
            frame.origin.x = point.x + self.originalPoint.x;
            self.contentViewController.view.frame = frame;
        }
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if ([recognizer velocityInView:self.view].x > 0) {
            [self showMenuViewController];
        } else {
            [self hideMenuViewController];
        }
    }
}

- (void)updateStatusBar
{
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [UIView animateWithDuration:0.3f animations:^{
            [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
        }];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return self.visible ? self.menuViewController.preferredStatusBarStyle : self.contentViewController.preferredStatusBarStyle;
}

#pragma mark -
#pragma mark Rotation handler

- (BOOL)shouldAutorotate
{
    if (self.visible)
        return NO;
    
    return self.contentViewController.shouldAutorotate;
}

@end
