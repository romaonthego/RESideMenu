//
//  RESideMenu.h
//  RESideMenuExample
//
//  Created by Roman Efimov on 6/14/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "UIWindow+RESideMenuExtensions.h"
#import "REBackgroundView.h"
#import "RESideMenuCell.h"
#import "RESideMenuItem.h"

@interface RESideMenu : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (strong, readonly, nonatomic) NSArray *items;
@property (assign, readwrite, nonatomic) CGFloat verticalOffset;
@property (strong, readwrite, nonatomic) UIFont *font;
@property (strong, readwrite, nonatomic) UIColor *textColor;
@property (strong, readwrite, nonatomic) UIColor *highlightedTextColor;
@property (strong, readwrite, nonatomic) UIImage *backgroundImage;

- (id)initWithItems:(NSArray *)items;
- (void)show;
- (void)hide;
- (void)setRootViewController:(UIViewController *)viewController;

@end
