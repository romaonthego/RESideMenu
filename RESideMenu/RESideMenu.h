//
//  RESideMenu.h
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
#import <QuartzCore/QuartzCore.h>
#import "REBackgroundView.h"
#import "RESideMenuCell.h"
#import "RESideMenuItem.h"

@interface RESideMenu : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, readonly, nonatomic) NSArray *items;
@property (assign, readwrite, nonatomic) CGFloat verticalLandscapeOffset;
@property (assign, readwrite, nonatomic) CGFloat horizontalLandscapeOffset;
@property (assign, readwrite, nonatomic) CGFloat verticalPortraitOffset;
@property (assign, readwrite, nonatomic) CGFloat horizontalPortraitOffset;
@property (assign, readwrite, nonatomic) CGFloat itemHeight;
@property (strong, readwrite, nonatomic) UIFont *font;
@property (strong, readwrite, nonatomic) UIColor *textColor;
@property (strong, readwrite, nonatomic) UIColor *highlightedTextColor;
@property (strong, readwrite, nonatomic) UIImage *backgroundImage;
@property (assign, readwrite, nonatomic) UIStatusBarStyle openStatusBarStyle;
@property (assign, readwrite, nonatomic) BOOL hideStatusBarArea;
@property (assign, readwrite, nonatomic) BOOL isShowing;

- (id)initWithItems:(NSArray *)items;
- (void)show;
- (void)hide;
- (void) displayContentController: (UIViewController*) content;

@end
