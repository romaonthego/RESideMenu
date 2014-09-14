# RESideMenu

iOS 7/8 style side menu with parallax effect inspired by Dribbble shots ([first](http://dribbble.com/shots/1116265-Instasave-iPhone-App) and [second](http://dribbble.com/shots/1114754-Social-Feed-iOS7)).

Since version 4.0 you can add menu view controllers on both left and right sides of your content view controller.

<img src="https://github.com/romaonthego/RESideMenu/raw/master/Screenshot.png" alt="RESideMenu Screenshot" width="400" height="568" />
<img src="https://raw.githubusercontent.com/romaonthego/RESideMenu/master/Demo.gif?2" alt="RESideMenu Screenshot" width="320" height="568" />

## Requirements
* Xcode 5 or higher
* Apple LLVM compiler
* iOS 6.0 or higher
* ARC

## Demo

Build and run the `RESideMenuExample` project in Xcode to see `RESideMenu` in action. For storyboards integration demo, build and run `RESideMenuStoryboardsExample`.

## Installation

### CocoaPods

The recommended approach for installating `RESideMenu` is via the [CocoaPods](http://cocoapods.org/) package manager, as it provides flexible dependency management and dead simple installation.
For best results, it is recommended that you install via CocoaPods >= **0.28.0** using Git >= **1.8.0** installed via Homebrew.

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

Edit your Podfile and add RESideMenu:

``` bash
platform :ios, '6.0'
pod 'RESideMenu', '~> 4.0.7'
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

All you need to do is drop `RESideMenu` files into your project, and add `#include "RESideMenu.h"` to the top of classes that will use it.

## Example Usage

In your AppDelegate's `- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions` create the view controller and assign content and menu view controllers.

``` objective-c
// Create content and menu controllers
//
DEMONavigationController *navigationController = [[DEMONavigationController alloc] initWithRootViewController:[[DEMOHomeViewController alloc] init]];
DEMOLeftMenuViewController *leftMenuViewController = [[DEMOLeftMenuViewController alloc] init];
DEMORightMenuViewController *rightMenuViewController = [[DEMORightMenuViewController alloc] init];

// Create side menu controller
//
RESideMenu *sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:navigationController
                                                                leftMenuViewController:leftMenuViewController
                                                               rightMenuViewController:rightMenuViewController];
sideMenuViewController.backgroundImage = [UIImage imageNamed:@"Stars"];

// Make it a root controller
//
self.window.rootViewController = sideMenuViewController;
```

Present the menu view controller:

```objective-c
[self.sideMenuViewController presentLeftMenuViewController];
```

or

```objective-c
[self.sideMenuViewController presentRightMenuViewController];
```

Switch content view controllers:

```objective-c
#import <RESideMenu/RESideMenu.h>

....

[self.sideMenuViewController setContentViewController:viewController animated:YES];
[self.sideMenuViewController hideMenuViewController];
```

## Storyboards Example

1. Create a subclass of `RESideMenu`. In this example we call it `DEMORootViewController`.
2. In the Storyboard designate the root view's owner as `DEMORootViewController`.
3. Make sure to `#import "RESideMenu.h"` in `DEMORootViewController.h`.
4. Add more view controllers to your Storyboard, and give them identifiers "leftMenuViewController", "rightMenuViewController" and "contentViewController". Note that in the new XCode the identifier is called "Storyboard ID" and can be found in the Identity inspector.
5. Add a method `awakeFromNib` to `DEMORootViewController.m` with the following code:

```objective-c
- (void)awakeFromNib
{
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentViewController"];
    self.leftMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"leftMenuController"];
    self.rightMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"rightMenuController"];
}
```

## Customization

You can customize the following properties of `RESideMenu`:

``` objective-c
@property (assign, readwrite, nonatomic) NSTimeInterval animationDuration;
@property (strong, readwrite, nonatomic) UIImage *backgroundImage;
@property (assign, readwrite, nonatomic) BOOL panGestureEnabled;
@property (assign, readwrite, nonatomic) BOOL panFromEdge;
@property (assign, readwrite, nonatomic) NSUInteger panMinimumOpenThreshold;
@property (assign, readwrite, nonatomic) BOOL interactivePopGestureRecognizerEnabled;
@property (assign, readwrite, nonatomic) BOOL scaleContentView;
@property (assign, readwrite, nonatomic) BOOL scaleBackgroundImageView;
@property (assign, readwrite, nonatomic) BOOL scaleMenuView;
@property (assign, readwrite, nonatomic) BOOL contentViewShadowEnabled;
@property (assign, readwrite, nonatomic) UIColor *contentViewShadowColor;
@property (assign, readwrite, nonatomic) CGSize contentViewShadowOffset;
@property (assign, readwrite, nonatomic) CGFloat contentViewShadowOpacity;
@property (assign, readwrite, nonatomic) CGFloat contentViewShadowRadius;
@property (assign, readwrite, nonatomic) CGFloat contentViewScaleValue;
@property (assign, readwrite, nonatomic) CGFloat contentViewInLandscapeOffsetCenterX;
@property (assign, readwrite, nonatomic) CGFloat contentViewInPortraitOffsetCenterX;
@property (assign, readwrite, nonatomic) CGFloat parallaxMenuMinimumRelativeValue;
@property (assign, readwrite, nonatomic) CGFloat parallaxMenuMaximumRelativeValue;
@property (assign, readwrite, nonatomic) CGFloat parallaxContentMinimumRelativeValue;
@property (assign, readwrite, nonatomic) CGFloat parallaxContentMaximumRelativeValue;
@property (assign, readwrite, nonatomic) CGAffineTransform menuViewControllerTransformation;
@property (assign, readwrite, nonatomic) BOOL parallaxEnabled;
@property (assign, readwrite, nonatomic) BOOL bouncesHorizontally;
@property (assign, readwrite, nonatomic) UIStatusBarStyle menuPreferredStatusBarStyle;
@property (assign, readwrite, nonatomic) BOOL menuPrefersStatusBarHidden;
```

If you set a backgroundImage, don't forget to set the Menu View Controller's background color to clear color.

You can implement `RESideMenuDelegate` protocol to receive the following messages:

```objective-c
- (void)sideMenu:(RESideMenu *)sideMenu didRecognizePanGesture:(UIPanGestureRecognizer *)recognizer;
- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController;
- (void)sideMenu:(RESideMenu *)sideMenu didShowMenuViewController:(UIViewController *)menuViewController;
- (void)sideMenu:(RESideMenu *)sideMenu willHideMenuViewController:(UIViewController *)menuViewController;
- (void)sideMenu:(RESideMenu *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController;
```

## Contact

Roman Efimov

- https://github.com/romaonthego
- https://twitter.com/romaonthego
- romefimov@gmail.com

## License

RESideMenu is available under the MIT license.

Copyright © 2013 Roman Efimov.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
