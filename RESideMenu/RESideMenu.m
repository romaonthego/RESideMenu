//
//  RESideMenu.m
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
#import "AccelerationAnimation.h"
#import "Evaluate.h"
#import "UIView+ImageSnapshot.h"
#import "UINavigationController+DelegateFixes.h"

const int INTERSTITIAL_STEPS = 99;

@interface RESideMenu ()
{
    BOOL _appIsHidingStatusBar;
    BOOL _isInSubMenu;
}
@property (assign, readwrite, nonatomic) NSInteger initialX;
@property (assign, readwrite, nonatomic) CGSize originalSize;
@property (strong, readonly, nonatomic) REBackgroundView *backgroundView;
@property (strong, readonly, nonatomic) UIImageView *screenshotView;
@property (strong, readonly, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIViewController *topController;

// Array containing menu (which are array of items)
@property (strong, readwrite, nonatomic) NSMutableArray *menuStack;
@property (strong, readwrite, nonatomic) RESideMenuItem *backMenu;

@end

@implementation RESideMenu

- (id)init
{
    self = [super init];
    if (!self)
        return nil;
    
    self.verticalPortraitOffset = self.verticalLandscapeOffset = 100;
    self.horizontalPortraitOffset = self.horizontalLandscapeOffset = 50;
    self.itemHeight = 50;
    self.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:21];
    self.textColor = [UIColor whiteColor];
    self.highlightedTextColor = [UIColor lightGrayColor];
    self.hideStatusBarArea = YES;
    self.openStatusBarStyle = UIStatusBarStyleDefault;
    self.menuStack = [NSMutableArray array];
    
    return self;
}

- (id)initWithItems:(NSArray *)items
{
    self = [self init];
    if (!self)
        return nil;
    
    _items = items;
    [_menuStack addObject:items];
    _backMenu = [[RESideMenuItem alloc] initWithTitle:@"<" action:nil];
    
    return self;
}

- (void) showItems:(NSArray *)items
{
    // Animate to deappear
    __typeof (&*self) __weak weakSelf = self;
    weakSelf.tableView.transform = CGAffineTransformScale(_tableView.transform, 0.9, 0.9);
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.tableView.transform = CGAffineTransformIdentity;
    }];
    [UIView animateWithDuration:0.6 animations:^{
        weakSelf.tableView.alpha = 0;
    }];
    
    // Set items and reload
    _items = items;
    [self.tableView reloadData];
    
    // Animate to reappear once reloaded
    weakSelf.tableView.transform = CGAffineTransformScale(_tableView.transform, 1, 1);
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.tableView.transform = CGAffineTransformIdentity;
    }];
    [UIView animateWithDuration:0.6 animations:^{
        weakSelf.tableView.alpha = 1;
    }];
    
}

- (void)show
{
    if (_isShowing)
        return;
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];

    _isShowing = YES;
    
    // keep track of whether or not it was already hidden
    _appIsHidingStatusBar=[[UIApplication sharedApplication] isStatusBarHidden];
    
    if(!_appIsHidingStatusBar && _hideStatusBarArea)
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    [self updateStatusBar];
    [self performSelector:@selector(showAfterDelay) withObject:nil afterDelay:0.1];
}

- (void)hide
{
    if (!_isShowing)
        return
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [self restoreFromRect:_screenshotView.frame];
}

- (void) displayContentController: (UIViewController*) content;
{
    [self addChildViewController:content];
    content.view.frame = self.view.bounds;
    [self.view addSubview:content.view];
    [content didMoveToParentViewController:self];

    if (self.topController) {
        [self.topController willMoveToParentViewController:nil];
        [self.topController.view removeFromSuperview];
        [self.topController removeFromParentViewController];
    }
    
    self.topController = content;
    
    [self.topController.view setNeedsDisplay];
    [self.view bringSubviewToFront:_backgroundView];
    [self.view bringSubviewToFront:_tableView];
    [self.view bringSubviewToFront:_screenshotView];

    __typeof (&*self) __weak weakSelf = self;
    double delayInSeconds = 0.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        _screenshotView.image = [weakSelf.topController.view snapshotImage];
        if (_isShowing)
            [weakSelf hide];
    });
}

- (void)addAnimation:(NSString *)path view:(UIView *)view startValue:(double)startValue endValue:(double)endValue
{
    AccelerationAnimation *animation = [AccelerationAnimation animationWithKeyPath:path
                                                                        startValue:startValue
                                                                          endValue:endValue
                                                                  evaluationObject:[[ExponentialDecayEvaluator alloc] initWithCoefficient:6.0]
                                                                 interstitialSteps:INTERSTITIAL_STEPS];
    animation.removedOnCompletion = NO;
    [view.layer addAnimation:animation forKey:path];
}

//- (void)animate

- (void)showAfterDelay
{
    // Take a snapshot
    //
    _screenshotView = [[UIImageView alloc] initWithFrame:CGRectNull];
    _screenshotView.image = [self.topController.view snapshotImage];
    _screenshotView.frame = CGRectMake(0, 0, _screenshotView.image.size.width, _screenshotView.image.size.height);
    _screenshotView.userInteractionEnabled = YES;
    _screenshotView.layer.anchorPoint = CGPointMake(0, 0);
    _screenshotView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;

    _originalSize = _screenshotView.frame.size;
    
    // Add views
    //
    _backgroundView = [[REBackgroundView alloc] initWithFrame:CGRectMake(0, -20, self.view.bounds.size.width, self.view.bounds.size.height + 20)];
    _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _backgroundView.backgroundImage = _backgroundImage;
    [self.view addSubview:_backgroundView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = nil;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.verticalOffset)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.alpha = 0;
    [self.view addSubview:_tableView];
    
    [self.view addSubview:_screenshotView];
    
    [self minimizeFromRect:CGRectMake(0, 0, _originalSize.width, _originalSize.height)];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)];
    [_screenshotView addGestureRecognizer:panGestureRecognizer];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognized:)];
    [_screenshotView addGestureRecognizer:tapGestureRecognizer];
}

- (void)minimizeFromRect:(CGRect)rect
{
    CGFloat m = 0.5;
    CGFloat newWidth = _originalSize.width * m;
    CGFloat newHeight = _originalSize.height * m;
    
    CGFloat widthOffset = self.view.bounds.size.width / (UIDeviceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]) ? 3 : 2);
    
    [CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithFloat:0.6] forKey:kCATransactionAnimationDuration];
    
    [self addAnimation:@"position.x" view:_screenshotView startValue:rect.origin.x endValue:self.view.bounds.size.width - widthOffset];
    [self addAnimation:@"position.y" view:_screenshotView startValue:rect.origin.y endValue:(self.view.bounds.size.height - newHeight) / 2.0];
    [self addAnimation:@"bounds.size.width" view:_screenshotView startValue:rect.size.width endValue:newWidth];
    [self addAnimation:@"bounds.size.height" view:_screenshotView startValue:rect.size.height endValue:newHeight];
    
    _screenshotView.layer.position = CGPointMake(self.view.bounds.size.width - widthOffset, (self.view.bounds.size.height - newHeight) / 2.0);
    _screenshotView.layer.bounds = CGRectMake(self.view.bounds.size.width - widthOffset, (self.view.bounds.size.height - newHeight) / 2.0, newWidth, newHeight);
    [CATransaction commit];
    
    if (_tableView.alpha == 0) {
        __typeof (&*self) __weak weakSelf = self;
        weakSelf.tableView.transform = CGAffineTransformScale(_tableView.transform, 0.9, 0.9);
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.tableView.transform = CGAffineTransformIdentity;
        }];
        
        [UIView animateWithDuration:0.6 animations:^{
            weakSelf.tableView.alpha = 1;
        }];
    }
}

- (void)restoreFromRect:(CGRect)rect
{
    _screenshotView.userInteractionEnabled = NO;
    while (_screenshotView.gestureRecognizers.count) {
        [_screenshotView removeGestureRecognizer:[_screenshotView.gestureRecognizers objectAtIndex:0]];
    }
    
    [CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithFloat:0.4] forKey:kCATransactionAnimationDuration];
    [self addAnimation:@"position.x" view:_screenshotView startValue:rect.origin.x endValue:0];
    [self addAnimation:@"position.y" view:_screenshotView startValue:rect.origin.y endValue:0];
    [self addAnimation:@"bounds.size.width" view:_screenshotView startValue:rect.size.width endValue:self.view.bounds.size.width];
    [self addAnimation:@"bounds.size.height" view:_screenshotView startValue:rect.size.height endValue:self.view.bounds.size.height];
    
    _screenshotView.layer.position = CGPointMake(0, 0);
    _screenshotView.layer.bounds = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    [CATransaction commit];
    [self performSelector:@selector(restoreView) withObject:nil afterDelay:0.4];
    
    __typeof (&*self) __weak weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.tableView.alpha = 0;
        weakSelf.tableView.transform = CGAffineTransformScale(_tableView.transform, 0.7, 0.7);
    }];
    
    // restore the status bar to its original state.
    [[UIApplication sharedApplication] setStatusBarHidden:_appIsHidingStatusBar withAnimation:UIStatusBarAnimationFade];
    _isShowing = NO;
    [self updateStatusBar];
}

- (void) updateStatusBar
{
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        __typeof (&*self) __weak weakSelf = self;
        [UIView animateWithDuration:0.3 animations:^{
            [weakSelf performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
        }];
    }
}

- (void)restoreView
{
    __typeof (&*self) __weak weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.screenshotView.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf.screenshotView removeFromSuperview];
    }];
    [_backgroundView removeFromSuperview];
    [_tableView removeFromSuperview];
}

-(CGFloat) verticalOffset
{
    if (UIDeviceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
        return self.verticalPortraitOffset;
    } else {
        return self.verticalLandscapeOffset;
    }
}

-(CGFloat) horizontalOffset
{
    if (UIDeviceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
        return self.horizontalPortraitOffset;
    } else {
        return self.horizontalLandscapeOffset;
    }
}

#pragma mark -
#pragma mark Gestures

- (void)panGestureRecognized:(UIPanGestureRecognizer *)sender
{
    CGPoint translation = [sender translationInView:self.view];
	if (sender.state == UIGestureRecognizerStateBegan) {
		_initialX = _screenshotView.frame.origin.x;
	}
	
    if (sender.state == UIGestureRecognizerStateChanged) {
        CGFloat x = translation.x + _initialX;
        CGFloat m = 1 - ((x / self.view.bounds.size.width) * 210/self.view.bounds.size.width);
        CGFloat y = (self.view.bounds.size.height - _originalSize.height * m) / 2.0;
        
        _tableView.alpha = (x + 80.0) / self.view.bounds.size.width;
        
        if (x < 0 || y < 0) {
            _screenshotView.frame = CGRectMake(0, 0, _originalSize.width, _originalSize.height);
        } else {
            _screenshotView.frame = CGRectMake(x, y, _originalSize.width * m, _originalSize.height * m);
        }
    }
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        if ([sender velocityInView:self.view].x < 0) {
            [self restoreFromRect:_screenshotView.frame];
        } else {
            [self minimizeFromRect:_screenshotView.frame];
        }
    }
}

- (void)tapGestureRecognized:(UITapGestureRecognizer *)sender
{
    [self restoreFromRect:_screenshotView.frame];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.itemHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"RESideMenuCell";
    
    RESideMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[RESideMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
        cell.textLabel.font = self.font;
        cell.textLabel.textColor = self.textColor;
        cell.textLabel.highlightedTextColor = self.highlightedTextColor;
    }
    
    
    RESideMenuItem *item = [_items objectAtIndex:indexPath.row];
    cell.textLabel.text = item.title;
    cell.imageView.image = item.image;
    cell.imageView.highlightedImage = item.highlightedImage;
    cell.horizontalOffset = self.horizontalOffset;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RESideMenuItem *item = [_items objectAtIndex:indexPath.row];
    
    // Case back on subMenu
    if(_isInSubMenu &&
       indexPath.row==0 &&
       indexPath.section == 0){
        
        [_menuStack removeLastObject];
        if(_menuStack.count==1){
            _isInSubMenu = NO;
        }
        [self showItems:_menuStack.lastObject];
        
        return;
    }
        
    // Case menu with subMenu
    if(item.subItems){
        _isInSubMenu = YES;
        
        // Concat back menu to submenus and show
        NSMutableArray * array = [NSMutableArray arrayWithObject:_backMenu];
        [array addObjectsFromArray:item.subItems];
        [self showItems:array];
        
        // Push new menu on stack
        [_menuStack addObject:array];
    }
    
    if (item.action)
        item.action(self, item);
}

#pragma mark - Status bar

#ifdef __IPHONE_7_0
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return _isShowing ? self.openStatusBarStyle : [self.topController preferredStatusBarStyle];
}
#endif

#pragma mark - Rotation

-(void) deviceOrientationDidChange
{
    if (_isShowing) {
        [self performSelector:@selector(hide) withObject:nil afterDelay:0.1];
        [[self class] performSelector:@selector(attemptRotationToDeviceOrientation) withObject:nil afterDelay:0.5];
    }
}

- (BOOL) shouldAutorotate
{
    return !_isShowing;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return !_isShowing;
}


- (NSUInteger)supportedInterfaceOrientations
{
    if (self.topController) {
        return [self.topController supportedInterfaceOrientations];
    } else {
        return [super supportedInterfaceOrientations];
    }
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    if (self.topController) {
        return [self.topController preferredInterfaceOrientationForPresentation];
    } else {
        return [super preferredInterfaceOrientationForPresentation];
    }}


@end
