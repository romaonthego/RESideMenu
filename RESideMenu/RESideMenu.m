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
#import "RECommonFunctions.h"

@interface RESideMenu ()

@property (strong, readwrite, nonatomic) UIImageView *backgroundImageView;
@property (assign, readwrite, nonatomic) BOOL visible;
@property (assign, readwrite, nonatomic) CGPoint originalPoint;
@property (strong, readwrite, nonatomic) UIButton *contentButton;
@property (assign, readwrite, nonatomic) BOOL inMotion;
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
    _animationDuration = 0.35f;
    _panGestureEnabled = YES;
    _interactivePopGestureRecognizerEnabled = YES;
    
    _scaleContentView      = YES;
    _contentViewScaleValue = 0.7f;
    
    _scaleBackgroundImageView = YES;
    
    _parallaxEnabled = YES;
    _parallaxMenuMinimumRelativeValue = @(-15);
    _parallaxMenuMaximumRelativeValue = @(15);
    
    _parallaxContentMinimumRelativeValue = @(-25);
    _parallaxContentMaximumRelativeValue = @(25);
}

- (id)initWithContentViewController:(UIViewController *)contentViewController menuViewController:(UIViewController *)menuViewController
{
    self = [self init];
    if (self) {
        _contentViewController = contentViewController;
        _menuViewController = menuViewController;
        _leftMenuViewController = menuViewController;
    }
    return self;
}

- (id)initWithContentViewController:(UIViewController *)contentViewController leftMenuViewController:(UIViewController *)leftMenu rightMenuViewController:(UIViewController *)rightMenu {
    
    self = [self init];
    if (self) {
        _contentViewController = contentViewController;
        _leftMenuViewController = leftMenu;
        _rightMenuViewController = rightMenu;
        
        if (leftMenu) //menu defaults to left for status bar setup unless no left menu passed
            _menuViewController = _leftMenuViewController;
        else
            _menuViewController = _rightMenuViewController;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!_contentViewInLandscapeOffsetCenterX)
        _contentViewInLandscapeOffsetCenterX = (_menuViewController == _leftMenuViewController ? CGRectGetHeight(self.view.frame) + 30.0f : -30.0f);
    
    if (!_contentViewInPortraitOffsetCenterX)
        _contentViewInPortraitOffsetCenterX = (_menuViewController == _leftMenuViewController ? CGRectGetWidth(self.view.frame) + 30.0f : -30.0f);
    
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.backgroundImageView = ({
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        imageView.image = self.backgroundImage;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        imageView;
    });
    self.contentButton = ({
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectNull];
        [button addTarget:self action:@selector(hideMenuViewController) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    
    [self.view addSubview:self.backgroundImageView];
    
    if (self.scaleBackgroundImageView)
        self.backgroundImageView.transform = CGAffineTransformMakeScale(1.7f, 1.7f);
    
    if (self.leftMenuViewController) {
        [self re_displayController:self.leftMenuViewController frame:self.view.bounds];
        self.leftMenuViewController.view.alpha = 0;
        [self addMenuViewControllerMotionEffectsToMenu:self.leftMenuViewController];
        
    }
    if (self.rightMenuViewController) { //TODO: can create single method to setup left and right
        [self re_displayController:self.rightMenuViewController frame:self.view.bounds];
        self.rightMenuViewController.view.alpha = 0;
        [self addMenuViewControllerMotionEffectsToMenu:self.rightMenuViewController];
    }
    
    [self re_displayController:self.contentViewController frame:self.view.bounds];
    
    if (self.panGestureEnabled) {
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)];
        panGestureRecognizer.delegate = self;
        [self.view addGestureRecognizer:panGestureRecognizer];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

#pragma mark -
- (void)presentMenuViewControllerOnSide:(MenuAligment)side
{
    if ((side == MenuAligmentLeft && !self.leftMenuViewController) || (side == MenuAligmentRight && !self.rightMenuViewController))
        return;
    
    [self setMenuControllerToController:side];
    [self presentMenuViewController];
}

- (void)presentMenuViewController
{
    self.menuViewController.view.transform = CGAffineTransformIdentity;
    if (self.scaleBackgroundImageView) {
        self.backgroundImageView.transform = CGAffineTransformIdentity;
        self.backgroundImageView.frame = self.view.bounds;
    }
    self.menuViewController.view.frame = self.view.bounds;
    self.menuViewController.view.transform = CGAffineTransformMakeScale(1.5f, 1.5f);
    self.menuViewController.view.alpha = 0;
    if (self.scaleBackgroundImageView)
        self.backgroundImageView.transform = CGAffineTransformMakeScale(1.7f, 1.7f);
    
    if ([self.delegate conformsToProtocol:@protocol(RESideMenuDelegate)] && [self.delegate respondsToSelector:@selector(sideMenu:willShowMenuViewController:)]) {
        [self.delegate sideMenu:self willShowMenuViewController:self.menuViewController];
    }
    
    [self showMenuViewController];
}

- (void)showMenuViewController
{
    [self.view.window endEditing:YES];
    [self addContentButton];
    
    [UIView animateWithDuration:self.animationDuration animations:^{
        if (self.scaleContentView) {
            self.contentViewController.view.transform = CGAffineTransformMakeScale(self.contentViewScaleValue, self.contentViewScaleValue);
        }
        self.contentViewController.view.center = CGPointMake((UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]) ? self.contentViewInLandscapeOffsetCenterX : self.contentViewInPortraitOffsetCenterX), self.contentViewController.view.center.y);
        
        self.menuViewController.view.alpha = 1.0f;
        self.menuViewController.view.transform = CGAffineTransformIdentity;
        if (self.scaleBackgroundImageView)
            self.backgroundImageView.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        [self addContentViewControllerMotionEffects];
        
        if (!self.visible && [self.delegate conformsToProtocol:@protocol(RESideMenuDelegate)] && [self.delegate respondsToSelector:@selector(sideMenu:didShowMenuViewController:)]) {
            [self.delegate sideMenu:self didShowMenuViewController:self.menuViewController];
        }
        
        self.visible = YES;
    }];
    
    [self updateStatusBar];
}

- (void)hideMenuViewController
{
    if ([self.delegate conformsToProtocol:@protocol(RESideMenuDelegate)] && [self.delegate respondsToSelector:@selector(sideMenu:willHideMenuViewController:)]) {
        [self.delegate sideMenu:self willHideMenuViewController:self.menuViewController];
    }
    
    [self.contentButton removeFromSuperview];
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [UIView animateWithDuration:self.animationDuration animations:^{
        self.contentViewController.view.transform = CGAffineTransformIdentity;
        self.contentViewController.view.frame = self.view.bounds;
        self.menuViewController.view.transform = CGAffineTransformMakeScale(1.5f, 1.5f);
        self.menuViewController.view.alpha = 0;
        if (self.scaleBackgroundImageView) {
            self.backgroundImageView.transform = CGAffineTransformMakeScale(1.7f, 1.7f);
        }
        if (self.parallaxEnabled) {
            IF_IOS7_OR_GREATER(
                               for (UIMotionEffect *effect in self.contentViewController.view.motionEffects) {
                                   [self.contentViewController.view removeMotionEffect:effect];
                               }
                               );
        }
    } completion:^(BOOL finished) {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        
        if (!self.visible && [self.delegate conformsToProtocol:@protocol(RESideMenuDelegate)] && [self.delegate respondsToSelector:@selector(sideMenu:didHideMenuViewController:)]) {
            [self.delegate sideMenu:self didHideMenuViewController:self.menuViewController];
        }
    }];
    self.visible = NO;
    [self updateStatusBar];
}

- (void)addContentButton
{
    if (self.contentButton.superview)
        return;
    
    self.contentButton.autoresizingMask = UIViewAutoresizingNone;
    self.contentButton.frame = self.contentViewController.view.bounds;
    self.contentButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.contentViewController.view addSubview:self.contentButton];
}

#pragma mark -
#pragma mark Motion effects

- (void)addMenuViewControllerMotionEffectsToMenu:(UIViewController *)menuVC
{
    if (self.parallaxEnabled) {
        IF_IOS7_OR_GREATER(
                           for (UIMotionEffect *effect in menuVC.view.motionEffects) {
                               [menuVC.view removeMotionEffect:effect];
                           }
                           UIInterpolatingMotionEffect *interpolationHorizontal = [[UIInterpolatingMotionEffect alloc]initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
                           interpolationHorizontal.minimumRelativeValue = self.parallaxMenuMinimumRelativeValue;
                           interpolationHorizontal.maximumRelativeValue = self.parallaxMenuMaximumRelativeValue;
                           
                           UIInterpolatingMotionEffect *interpolationVertical = [[UIInterpolatingMotionEffect alloc]initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
                           interpolationVertical.minimumRelativeValue = self.parallaxMenuMinimumRelativeValue;
                           interpolationVertical.maximumRelativeValue = self.parallaxMenuMaximumRelativeValue;
                           
                           [menuVC.view addMotionEffect:interpolationHorizontal];
                           [menuVC.view addMotionEffect:interpolationVertical];
                           );
    }
}

- (void)addContentViewControllerMotionEffects
{
    if (self.parallaxEnabled) {
        IF_IOS7_OR_GREATER(
                           for (UIMotionEffect *effect in self.contentViewController.view.motionEffects) {
                               [self.contentViewController.view removeMotionEffect:effect];
                           }
                           [UIView animateWithDuration:0.2 animations:^{
            UIInterpolatingMotionEffect *interpolationHorizontal = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
            interpolationHorizontal.minimumRelativeValue = self.parallaxContentMinimumRelativeValue;
            interpolationHorizontal.maximumRelativeValue = self.parallaxContentMaximumRelativeValue;
            
            UIInterpolatingMotionEffect *interpolationVertical = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
            interpolationVertical.minimumRelativeValue = self.parallaxContentMinimumRelativeValue;
            interpolationVertical.maximumRelativeValue = self.parallaxContentMaximumRelativeValue;
            
            [self.contentViewController.view addMotionEffect:interpolationHorizontal];
            [self.contentViewController.view addMotionEffect:interpolationVertical];
        }];
                           );
    }
}

#pragma mark -
#pragma mark Gesture recognizer

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (self.interactivePopGestureRecognizerEnabled && [self.contentViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)self.contentViewController;
        if (navigationController.viewControllers.count > 1 && navigationController.interactivePopGestureRecognizer.enabled) {
            return NO;
        }
    }
    
    if (self.panFromEdge && [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && !self.visible) {
        CGPoint point = [touch locationInView:gestureRecognizer.view];
        if (point.x < 30) {
            return YES;
        } else {
            return NO;
        }
    }
    return YES;
}

- (void)panGestureRecognized:(UIPanGestureRecognizer *)recognizer
{
    if ([self.delegate conformsToProtocol:@protocol(RESideMenuDelegate)] && [self.delegate respondsToSelector:@selector(sideMenu:didRecognizePanGesture:)])
        [self.delegate sideMenu:self didRecognizePanGesture:recognizer];
    
    if (!self.panGestureEnabled) {
        return;
    }
    
    CGPoint point = [recognizer translationInView:self.view];
    bool hasPositiveVelocity = [recognizer velocityInView:self.view].x > 0;
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        if (!self.visible && [self.delegate conformsToProtocol:@protocol(RESideMenuDelegate)] && [self.delegate respondsToSelector:@selector(sideMenu:willShowMenuViewController:)]) {
            [self.delegate sideMenu:self willShowMenuViewController:self.menuViewController];
        }
        
        if (!self.visible && self.leftMenuViewController && self.rightMenuViewController) //only call if using two menus
            [self setMenuControllerToController:(hasPositiveVelocity ? MenuAligmentLeft: MenuAligmentRight)];
        
        self.originalPoint = CGPointMake(self.contentViewController.view.center.x - CGRectGetWidth(self.contentViewController.view.bounds) / 2.0,
                                         self.contentViewController.view.center.y - CGRectGetHeight(self.contentViewController.view.bounds) / 2.0);
        self.menuViewController.view.transform = CGAffineTransformIdentity;
        if (self.scaleBackgroundImageView) {
            self.backgroundImageView.transform = CGAffineTransformIdentity;
            self.backgroundImageView.frame = self.view.bounds;
        }
        self.menuViewController.view.frame = self.view.bounds;
        [self addContentButton];
        [self.view.window endEditing:YES];
    }
    
    if (recognizer.state == UIGestureRecognizerStateBegan || recognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat delta = self.visible ? (point.x + self.originalPoint.x) / self.originalPoint.x : abs(point.x) / self.view.frame.size.width;
        CGFloat contentViewScale = self.scaleContentView ? 1 - ((1 - self.contentViewScaleValue) * delta) : 1;
        CGFloat backgroundViewScale = 1.7f - (0.7f * delta);
        CGFloat menuViewScale = 1.5f - (0.5f * delta);
        self.menuViewController.view.alpha = delta;
        if (self.scaleBackgroundImageView) {
            self.backgroundImageView.transform = CGAffineTransformMakeScale(backgroundViewScale, backgroundViewScale);
        }
        self.menuViewController.view.transform = CGAffineTransformMakeScale(menuViewScale, menuViewScale);
        
        if (self.scaleBackgroundImageView) {
            if (backgroundViewScale < 1) {
                self.backgroundImageView.transform = CGAffineTransformIdentity;
            }
        }
      
        self.contentViewController.view.transform = CGAffineTransformMakeScale(contentViewScale, contentViewScale);
        self.contentViewController.view.transform = CGAffineTransformTranslate(self.contentViewController.view.transform, point.x, 0);
        float x = self.contentViewController.view.frame.origin.x ;
        if ((x >= 0 && self.menuViewController != self.leftMenuViewController) || (x <= 0 && self.menuViewController != self.rightMenuViewController)) {
            self.contentViewController.view.transform = CGAffineTransformIdentity;
            self.contentViewController.view.frame = self.view.bounds;
            self.visible = false;
            [recognizer setTranslation:CGPointMake(0, point.y) inView:self.view];
        }
             [self updateStatusBar];
    }
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if ((hasPositiveVelocity && self.menuViewController == self.leftMenuViewController) || (!hasPositiveVelocity && self.menuViewController == self.rightMenuViewController))
            [self showMenuViewController];
        else
            [self hideMenuViewController];
    }
    
}

#pragma mark -
#pragma mark Setters

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    _backgroundImage = backgroundImage;
    if (self.backgroundImageView)
        self.backgroundImageView.image = backgroundImage;
}

- (void)setContentViewController:(UIViewController *)contentViewController
{
    if (!_contentViewController) {
        _contentViewController = contentViewController;
        return;
    }
    CGRect frame = _contentViewController.view.frame;
    CGAffineTransform transform = _contentViewController.view.transform;
    [self re_hideController:_contentViewController];
    _contentViewController = contentViewController;
    [self re_displayController:contentViewController frame:self.view.bounds];
    contentViewController.view.transform = transform;
    contentViewController.view.frame = frame;
    
    [self addContentViewControllerMotionEffects];
}

- (void)setContentViewController:(UIViewController *)contentViewController animated:(BOOL)animated
{
    if (!animated) {
        [self setContentViewController:contentViewController];
    } else {
        contentViewController.view.alpha = 0;
        contentViewController.view.frame = self.contentViewController.view.bounds;
        [self.contentViewController.view addSubview:contentViewController.view];
        [UIView animateWithDuration:self.animationDuration animations:^{
            contentViewController.view.alpha = 1;
        } completion:^(BOOL finished) {
            [contentViewController.view removeFromSuperview];
            [self setContentViewController:contentViewController];
        }];
    }
}

- (void)setMenuViewController:(UIViewController *)menuViewController
{   // if menu vc not set OR if using menu on both sides
    if (!_menuViewController || (_leftMenuViewController && _rightMenuViewController)) {
        _menuViewController = menuViewController;
        return;
    }
    
    [self re_hideController:_menuViewController];
    _menuViewController = menuViewController;
    [self re_displayController:menuViewController frame:self.view.frame];
    
    [self addMenuViewControllerMotionEffectsToMenu:menuViewController];
    [self.view bringSubviewToFront:self.contentViewController.view];
    
}

#pragma mark -
#pragma mark Rotation handler

- (BOOL)shouldAutorotate
{
    return self.contentViewController.shouldAutorotate;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (self.visible) {
        self.contentViewController.view.transform = CGAffineTransformIdentity;
        self.contentViewController.view.frame = self.view.bounds;
        self.contentViewController.view.transform = CGAffineTransformMakeScale(self.contentViewScaleValue, self.contentViewScaleValue);
        self.contentViewController.view.center = CGPointMake((UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) ? self.contentViewInLandscapeOffsetCenterX : self.contentViewInPortraitOffsetCenterX), self.contentViewController.view.center.y);
    }
}

#pragma mark -
#pragma mark Status bar appearance management

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
    UIStatusBarStyle statusBarStyle = UIStatusBarStyleDefault;
    IF_IOS7_OR_GREATER(
                       statusBarStyle = self.visible ? self.menuViewController.preferredStatusBarStyle : self.contentViewController.preferredStatusBarStyle;
                       if (self.contentViewController.view.frame.origin.y > 10) {
                           statusBarStyle = self.menuViewController.preferredStatusBarStyle;
                       } else {
                           statusBarStyle = self.contentViewController.preferredStatusBarStyle;
                       }
                       );
    return statusBarStyle;
}

- (BOOL)prefersStatusBarHidden
{
    BOOL statusBarHidden = NO;
    IF_IOS7_OR_GREATER(
                       statusBarHidden = self.visible ? self.menuViewController.prefersStatusBarHidden : self.contentViewController.prefersStatusBarHidden;
                       if (self.contentViewController.view.frame.origin.y > 10) {
                           statusBarHidden = self.menuViewController.prefersStatusBarHidden;
                       } else {
                           statusBarHidden = self.contentViewController.prefersStatusBarHidden;
                       }
                       );
    return statusBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    UIStatusBarAnimation statusBarAnimation = UIStatusBarAnimationNone;
    IF_IOS7_OR_GREATER(
                       statusBarAnimation = self.visible ? self.menuViewController.preferredStatusBarUpdateAnimation : self.contentViewController.preferredStatusBarUpdateAnimation;
                       if (self.contentViewController.view.frame.origin.y > 10) {
                           statusBarAnimation = self.menuViewController.preferredStatusBarUpdateAnimation;
                       } else {
                           statusBarAnimation = self.contentViewController.preferredStatusBarUpdateAnimation;
                       }
                       );
    return statusBarAnimation;
}

# pragma mark -- Switching Left and Right Menu

- (void) setMenuControllerToController:(MenuAligment)alignment
{
    // set menuViewController and adjust contentView offsets
    if (alignment == MenuAligmentLeft) {
        self.menuViewController = self.leftMenuViewController;
        _contentViewInLandscapeOffsetCenterX = CGRectGetHeight(self.view.frame) + 30.0f;
        _contentViewInPortraitOffsetCenterX = CGRectGetWidth(self.view.frame) + 30.0f;
    }
    
    else {
        self.menuViewController = self.rightMenuViewController;
        _contentViewInLandscapeOffsetCenterX = _contentViewInPortraitOffsetCenterX = - 30.0f;
    }
}
@end
