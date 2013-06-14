# REMenu

Dropdown menu inspired by Vine.

![Screenshot of REMenu](https://github.com/romaonthego/REMenu/raw/master/Screenshot.png "REMenu Screenshot")

## Requirements
* Xcode 4.5 or higher
* Apple LLVM compiler
* iOS 5.0 or higher
* ARC

## Demo

Build and run the `REMenuExample` project in Xcode to see `REMenu` in action.

## Installation

### CocoaPods

The recommended approach for installating `REMenu` is via the [CocoaPods](http://cocoapods.org/) package manager, as it provides flexible dependency management and dead simple installation.
For best results, it is recommended that you install via CocoaPods >= **0.15.2** using Git >= **1.8.0** installed via Homebrew.

Install CocoaPods if not already available:

``` bash
$ [sudo] gem install cocoapods
$ pod setup
```

Change to the directory of your Xcode project:

``` bash
$ cd /path/to/MyProject
$ touch Podfile
$ edit Podfile
```

Edit your Podfile and add REMenu:

``` bash
platform :ios, '5.0'
pod 'REMenu', '~> 1.3.4'
```

Install into your Xcode project:

``` bash
$ pod install
```

Open your project in Xcode from the .xcworkspace file (not the usual project file)

``` bash
$ open MyProject.xcworkspace
```

Please note that if your installation fails, it may be because you are installing with a version of Git lower than CocoaPods is expecting. Please ensure that you are running Git >= **1.8.0** by executing `git --version`. You can get a full picture of the installation details by executing `pod install --verbose`.

### Manual Install

All you need to do is drop `REMenu` files into your project, and add `#include "REMenu.h"` to the top of classes that will use it.

## Example Usage

``` objective-c
REMenuItem *homeItem = [[REMenuItem alloc] initWithTitle:@"Home"
                                                  subtitle:@"Return to Home Screen"
                                                     image:[UIImage imageNamed:@"Icon_Home"]
                                          highlightedImage:nil
                                                    action:^(REMenuItem *item) {
                                                        NSLog(@"Item: %@", item);
                                                    }];

REMenuItem *exploreItem = [[REMenuItem alloc] initWithTitle:@"Explore"
                                                   subtitle:@"Explore 47 additional options"
                                                      image:[UIImage imageNamed:@"Icon_Explore"]
                                           highlightedImage:nil
                                                     action:^(REMenuItem *item) {
                                                         NSLog(@"Item: %@", item);
                                                     }];

REMenuItem *activityItem = [[REMenuItem alloc] initWithTitle:@"Activity"
                                                    subtitle:@"Perform 3 additional activities"
                                                       image:[UIImage imageNamed:@"Icon_Activity"]
                                            highlightedImage:nil
                                                      action:^(REMenuItem *item) {
                                                          NSLog(@"Item: %@", item);
                                                      }];

REMenuItem *profileItem = [[REMenuItem alloc] initWithTitle:@"Profile"
                                                      image:[UIImage imageNamed:@"Icon_Profile"]
                                           highlightedImage:nil
                                                     action:^(REMenuItem *item) {
                                                         NSLog(@"Item: %@", item);
                                                     }];

_menu = [[REMenu alloc] initWithItems:@[homeItem, exploreItem, activityItem, profileItem]];
[_menu showFromNavigationController:self.navigationController];
```

You can also present `REMenu` from a custom view, there are 2 specific tasks for that:

``` objective-c
- (void)showFromRect:(CGRect)rect inView:(UIView *)view;
- (void)showInView:(UIView *)view;
```

Since version 1.3 you are able to assign custom view to your items, as show below:

``` objective-c
UIView *customView = [[UIView alloc] init];
customView.backgroundColor = [UIColor blueColor];
customView.alpha = 0.4;
REMenuItem *customViewItem = [[REMenuItem alloc] initWithCustomView:customView action:^(REMenuItem *item) {
    NSLog(@"Tap on customView");
}];
```

## Customization

You can customize the following properties of `REMenu`:

``` objective-c
@property (assign, readwrite, nonatomic) CGFloat cornerRadius;
@property (strong, readwrite, nonatomic) UIColor *shadowColor;
@property (assign, readwrite, nonatomic) CGSize shadowOffset;
@property (assign, readwrite, nonatomic) CGFloat shadowOpacity;
@property (assign, readwrite, nonatomic) CGFloat shadowRadius;
@property (assign, readwrite, nonatomic) CGFloat itemHeight;
@property (strong, readwrite, nonatomic) UIColor *backgroundColor;
@property (strong, readwrite, nonatomic) UIColor *separatorColor;
@property (assign, readwrite, nonatomic) CGFloat separatorHeight;
@property (strong, readwrite, nonatomic) UIFont *font;
@property (strong, readwrite, nonatomic) UIColor *textColor;
@property (strong, readwrite, nonatomic) UIColor *textShadowColor;
@property (assign, readwrite, nonatomic) CGSize imageOffset;
@property (assign, readwrite, nonatomic) CGSize textOffset;
@property (assign, readwrite, nonatomic) CGSize textShadowOffset;
@property (strong, readwrite, nonatomic) UIColor *highligtedBackgroundColor;
@property (strong, readwrite, nonatomic) UIColor *highlightedSeparatorColor;
@property (strong, readwrite, nonatomic) UIColor *highlighedTextColor;
@property (strong, readwrite, nonatomic) UIColor *highlighedTextShadowColor;
@property (assign, readwrite, nonatomic) CGSize highlighedTextShadowOffset;
@property (assign, readwrite, nonatomic) CGFloat borderWidth;
@property (strong, readwrite, nonatomic) UIColor *borderColor;
@property (assign, readwrite, nonatomic) NSTextAlignment textAlignment;
@property (strong, readwrite, nonatomic) UIFont *subtitleFont;
@property (strong, readwrite, nonatomic) UIColor *subtitleTextColor;
@property (strong, readwrite, nonatomic) UIColor *subtitleTextShadowColor;
@property (assign, readwrite, nonatomic) CGSize subtitleTextOffset;
@property (assign, readwrite, nonatomic) CGSize subtitleTextShadowOffset;
@property (strong, readwrite, nonatomic) UIColor *subtitleHighlighedTextColor;
@property (strong, readwrite, nonatomic) UIColor *subtitleHighlighedTextShadowColor;
@property (assign, readwrite, nonatomic) CGSize subtitleHighlighedTextShadowOffset;
@property (assign, readwrite, nonatomic) NSTextAlignment subtitleTextAlignment;
@property (assign, readwrite, nonatomic) NSTimeInterval animationDuration;
@property (assign, readwrite, nonatomic) NSTimeInterval bounceAnimationDuration;
@property (assign, readwrite, nonatomic) BOOL bounce;
```

## Contact

Roman Efimov

- https://github.com/romaonthego
- https://twitter.com/romaonthego
- romefimov@gmail.com

## License

REMenu is available under the MIT license.

Copyright © 2013 Roman Efimov.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
