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

const int INTERSTITIAL_STEPS = 99;

@interface RESideMenu () {
    BOOL _appIsHidingStatusBar;
    BOOL _isInSubMenu;
    BOOL _showFromPan;
}

@property (assign, readwrite, nonatomic) CGFloat initialX;
@property (assign, readwrite, nonatomic) CGSize originalSize;
@property (strong, readonly, nonatomic) REBackgroundView *backgroundView;
@property (strong, readonly, nonatomic) UIImageView *screenshotView;
@property (strong, readonly, nonatomic) UITableView *tableView;

// Array containing menu (which are array of items)
@property (strong, readwrite, nonatomic) NSMutableArray *menuStack;
@property (strong, readwrite, nonatomic) RESideMenuItem *backMenu;

@end

@implementation RESideMenu

- (id)init
{
    if (self = [super init]) {
        self.verticalOffset = 100;
        self.horizontalOffset = 50;
        self.itemHeight = 50;
        self.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:21];
        self.textColor = [UIColor whiteColor];
        self.highlightedTextColor = [UIColor lightGrayColor];
        self.hideStatusBarArea = YES;
        self.menuStack = [NSMutableArray array];
        
        CGRect screen = [UIScreen mainScreen].bounds;
        
        // Back
        _backgroundView = [[REBackgroundView alloc] initWithFrame:screen];
        _backgroundView.backgroundImage = _backgroundImage;
        
        
        // Table
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen.size.width, screen.size.height)];
        [_tableView setShowsVerticalScrollIndicator:NO];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen.size.width, self.verticalOffset)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
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

- (void)reloadWithItems:(NSArray *)items
{
    // Animate to disappear
    //
    __typeof (&*self) __weak weakSelf = self;
    weakSelf.tableView.transform = CGAffineTransformScale(_tableView.transform, 0.9, 0.9);
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.tableView.transform = CGAffineTransformIdentity;
        weakSelf.tableView.alpha = 0;
    }];
    
    // Set items and reload
    //
    RESideMenuItem * firstItem = items[0];
    if (_isInSubMenu && firstItem!=_backMenu){
        NSMutableArray * array = [NSMutableArray arrayWithObject:_backMenu];
        [array addObjectsFromArray:items];
        _items = array;
    } else {
        _items = items;
    }
    
    [self.tableView reloadData];
    
    // Animate to reappear once reloaded
    //
    weakSelf.tableView.transform = CGAffineTransformScale(_tableView.transform, 1, 1);
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.tableView.transform = CGAffineTransformIdentity;
        weakSelf.tableView.alpha = 1;
    }];
}

#pragma mark -
#pragma markPublic API

- (void)show
{
    if (_isShowing)
        return;
    
    _isShowing = YES;
    _showFromPan = NO;
    
    // Keep track of whether or not it was already hidden
    //
    _appIsHidingStatusBar=[[UIApplication sharedApplication] isStatusBarHidden];
    
    if(!_appIsHidingStatusBar)
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    [self performSelector:@selector(showAfterDelay) withObject:nil afterDelay:0.01];
}

- (void)showFromPanGesture:(UIPanGestureRecognizer *)sender
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    CGPoint translation = [sender translationInView:window];
    
    _showFromPan = YES;
	if (sender.state == UIGestureRecognizerStateBegan) {
        if (_isShowing || translation.x<=0)
            return;
        
        _isShowing = YES;
        
        if(!_appIsHidingStatusBar)
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
        
        [self updateViews];
	}
    [self panGestureRecognized:sender];
}


- (void)hide
{
    if (_isShowing)
        [self restoreFromRect:_screenshotView.frame];
}

- (void)setRootViewController:(UIViewController *)viewController
{
    if (_isShowing)
        [self hide];
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    window.rootViewController = viewController;
    _screenshotView.image = [window re_snapshotWithStatusBar:!self.hideStatusBarArea];
    [window bringSubviewToFront:_backgroundView];
    [window bringSubviewToFront:_tableView];
    [window bringSubviewToFront:_screenshotView];
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

#pragma mark -
#pragma mark Private API

- (void)showAfterDelay
{
    [self updateViews];
    [self minimizeFromRect:CGRectMake(0, 0, _originalSize.width, _originalSize.height)];
}

- (void) updateViews
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    // Screenshot
    //
    _screenshotView = [[UIImageView alloc] initWithFrame:window.frame];
    _screenshotView.userInteractionEnabled = YES;
    _screenshotView.image = [window re_snapshotWithStatusBar:!self.hideStatusBarArea];
    _screenshotView.frame = CGRectMake(0, 0, _screenshotView.image.size.width, _screenshotView.image.size.height);
    _originalSize = _screenshotView.frame.size;
    
    _tableView.alpha = 0;
    
    [window addSubview:_backgroundView];
    [window addSubview:_tableView];
    [window addSubview:_screenshotView];
    
    // Gestures
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)];
    [_screenshotView addGestureRecognizer:panGestureRecognizer];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognized:)];
    [_screenshotView addGestureRecognizer:tapGestureRecognizer];
}

- (void)minimizeFromRect:(CGRect)rect
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    CGFloat m = 0.5;
    CGFloat newWidth = _originalSize.width * m;
    CGFloat newHeight = _originalSize.height * m;
    
    [CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithFloat:0.6] forKey:kCATransactionAnimationDuration];
    [self addAnimation:@"position.x" view:_screenshotView startValue:rect.origin.x endValue:window.frame.size.width - 80.0];
    [self addAnimation:@"position.y" view:_screenshotView startValue:rect.origin.y endValue:(window.frame.size.height - newHeight) / 2.0];
    [self addAnimation:@"bounds.size.width" view:_screenshotView startValue:rect.size.width endValue:newWidth];
    [self addAnimation:@"bounds.size.height" view:_screenshotView startValue:rect.size.height endValue:newHeight];
    
    _screenshotView.layer.anchorPoint = CGPointMake(0, 0);
    _screenshotView.layer.position = CGPointMake(window.frame.size.width - 80.0, (window.frame.size.height - newHeight) / 2.0);
    _screenshotView.layer.bounds = CGRectMake(window.frame.size.width - 80.0, (window.frame.size.height - newHeight) / 2.0, newWidth, newHeight);
    [CATransaction commit];
    
    if (_tableView.alpha  != 1 ) {
        __typeof (&*self) __weak weakSelf = self;
        
        if(_tableView.alpha == 0){
            weakSelf.tableView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
        }
        
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
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithFloat:0.4] forKey:kCATransactionAnimationDuration];
    [self addAnimation:@"position.x" view:_screenshotView startValue:rect.origin.x endValue:0];
    [self addAnimation:@"position.y" view:_screenshotView startValue:rect.origin.y endValue:0];
    [self addAnimation:@"bounds.size.width" view:_screenshotView startValue:rect.size.width endValue:window.frame.size.width];
    [self addAnimation:@"bounds.size.height" view:_screenshotView startValue:rect.size.height endValue:window.frame.size.height];
    
    _screenshotView.layer.position = CGPointMake(0, 0);
    _screenshotView.layer.bounds = CGRectMake(0, 0, window.frame.size.width, window.frame.size.height);
    [CATransaction commit];
    [self performSelector:@selector(restoreView) withObject:nil afterDelay:0.4];
    
    __typeof (&*self) __weak weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.tableView.alpha = 0;
        weakSelf.tableView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
    }];
    
    // Restore the status bar to its original state
    //
    [[UIApplication sharedApplication] setStatusBarHidden:_appIsHidingStatusBar withAnimation:UIStatusBarAnimationFade];
}

- (void)restoreView
{
    [_backgroundView removeFromSuperview];
    [_tableView removeFromSuperview];
    
    __typeof (&*self) __weak weakSelf = self;
    [UIView animateWithDuration:0.1 animations:^{
        weakSelf.screenshotView.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf.screenshotView removeFromSuperview];
        _isShowing = NO;
    }];
}

#pragma mark -
#pragma mark Gestures

- (void)panGestureRecognized:(UIPanGestureRecognizer *)sender
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    CGPoint translation = [sender translationInView:window];
	if (sender.state == UIGestureRecognizerStateBegan) {
        if (_showFromPan){
            _initialX = 0;
        } else {
            _initialX = _screenshotView.frame.origin.x;
        }
        _tableView.transform = CGAffineTransformIdentity;
	}
	
    if (sender.state == UIGestureRecognizerStateChanged) {
        _screenshotView.layer.anchorPoint = CGPointMake(0, 0);
        
        CGFloat x = translation.x + _initialX ;
        CGFloat m = 1 - ((x / window.frame.size.width) * 210/window.frame.size.width);
        CGFloat y = (window.frame.size.height - _originalSize.height * m) / 2.0;
        
        float alphaOffset = (x + 80.0) / window.frame.size.width;
        _tableView.alpha = alphaOffset;
        float scaleOffset = 0.6 +(alphaOffset*0.4);
        _tableView.transform = CGAffineTransformScale(CGAffineTransformIdentity, scaleOffset, scaleOffset);
        
        if (x < 0 || y < 0) {
            _screenshotView.frame = CGRectMake(0, 0, _originalSize.width, _originalSize.height);
        } else {
            _screenshotView.frame = CGRectMake(x, y, _originalSize.width * m, _originalSize.height * m);
        }
        
    }
    
    if (sender.state == UIGestureRecognizerStateEnded && _screenshotView) {
        if ([sender velocityInView:window].x < 0) {
            [self restoreFromRect:_screenshotView.frame];
        } else {
            _showFromPan = NO;
            [self minimizeFromRect:_screenshotView.frame];
        }
    }
}

- (void)tapGestureRecognized:(UITapGestureRecognizer *)sender
{
    [self restoreFromRect:_screenshotView.frame];
}

#pragma mark -
#pragma mark Table view data source

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
    
    RESideMenuItem *item = [_items objectAtIndex:indexPath.row];
    
    RESideMenuCell *cell = [[RESideMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = [[UIView alloc] init];
    cell.textLabel.font = self.font;
    cell.textLabel.textColor = self.textColor;
    cell.textLabel.highlightedTextColor = self.highlightedTextColor;
    
    UITapGestureRecognizer *tapped;
    UITextField *field;
    
    switch (item.type) {
        case RESideMenuItemTypeField:
            cell.textLabel.text = @"";
            field = [[UITextField alloc] initWithFrame:CGRectMake(self.horizontalOffset, 12, 200, cell.frame.size.height)];
            field.delegate = self;
            [field setAutocapitalizationType:UITextAutocapitalizationTypeNone];
            [field setAutocorrectionType:UITextAutocorrectionTypeNo];
            [field setFont:self.font];
            [field setTextColor:self.textColor];
            [field setPlaceholder:item.title];
            [field setReturnKeyType:UIReturnKeyDone];
            field.tag = indexPath.row;
            [cell addSubview:field];
            break;
            
        default:
            cell.textLabel.text = item.title;
            cell.imageView.userInteractionEnabled = YES;
            cell.imageView.tag = indexPath.row;

            break;
    }
    cell.imageView.image = item.image;
    cell.imageView.highlightedImage = item.highlightedImage;
    tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageAction:)];
    [cell.imageView addGestureRecognizer:tapped];
    cell.horizontalOffset = self.horizontalOffset;
    
    return cell;
}

#pragma mark - 
#pragma mark User Interaction

- (void)imageAction:(UITapGestureRecognizer *)sender
{
    UITapGestureRecognizer *gesture = (UITapGestureRecognizer *)sender;
    RESideMenuItem * item = _items[gesture.view.tag];
    if (item.imageAction) {
        item.imageAction(self, item);
    }
}

#pragma mark - 
#pragma mark Text Field

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    NSString *s = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (s.length > 0) {
        RESideMenuItem *item = [_items objectAtIndex:textField.tag];
        _lastFieldInput = textField.text;
        if (item.action) {
            item.action(self, item);
        }
    } else {
        textField.text = @"";
    }
    return YES;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RESideMenuItem *item = [_items objectAtIndex:indexPath.row];
    
    if (item.type == RESideMenuItemTypeField) {
        return;
    }
    
    // Prioritize action in case user want to interact with submenu in it
    //
    if (item.action) {
        item.action(self, item);
    }
    
    // Case back on subMenu
    //
    if (_isInSubMenu && indexPath.row==0 && indexPath.section == 0) {
        
        [_menuStack removeLastObject];
        if (_menuStack.count == 1) {
            _isInSubMenu = NO;
        }
        [self reloadWithItems:_menuStack.lastObject];
        
        return;
    }
    
    // Case menu with subMenu
    //
    if (item.subItems) {
        _isInSubMenu = YES;
        [self reloadWithItems:item.subItems];
        
        // Push new menu on stack
        //
        [_menuStack addObject:item.subItems];
    }
}

@end
