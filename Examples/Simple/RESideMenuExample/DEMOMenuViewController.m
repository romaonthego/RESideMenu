//
//  DEMOMenuViewController.m
//  RESideMenuExample
//
//  Created by Roman Efimov on 10/10/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "DEMOMenuViewController.h"
#import "DEMOFirstViewController.h"
#import "DEMOSecondViewController.h"

static const int CELL_HEIGHT = 54 ;
static const int ROWS = 5 ;
static const int ICON_WIDTH = 64 ;
static const int PADDING = 20 ;

@interface DEMOMenuViewController ()

@property (strong, readwrite, nonatomic) UITableView *tableView;
@property (assign, readwrite, nonatomic) MenuAligment alignment;

@end

@implementation DEMOMenuViewController
- (id)init
{
    self = [super init];
    if (self) {
        _alignment = MenuAligmentLeft; //default 
    }
    return self;
}
- (id)initWithAlignment:(MenuAligment)position
{
    self = [super init];
    if (self) {
        _alignment = position;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView = ({
       UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake([self getTableViewOriginXForOrientation:[UIDevice currentDevice].orientation], (self.view.frame.size.height - CELL_HEIGHT * ROWS) / 2.0f, self.view.frame.size.width, CELL_HEIGHT * ROWS) style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.backgroundColor = [UIColor clearColor];
        
        tableView.backgroundView = nil;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.bounces = NO;
        tableView;
    });
    [self.view addSubview:self.tableView];
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            self.sideMenuViewController.contentViewController = [[UINavigationController alloc] initWithRootViewController:[[DEMOFirstViewController alloc] init]];
            [self.sideMenuViewController hideMenuViewController];
            break;
        case 1:
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[[DEMOSecondViewController alloc] init]]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return ROWS;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
    }
    
    NSArray *titles = @[@"Home", @"Calendar", @"Profile", @"Settings", @"Log Out"];
    NSArray *images = @[@"IconHome", @"IconCalendar", @"IconProfile", @"IconSettings", @"IconEmpty"];
    cell.textLabel.text = titles[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:images[indexPath.row]];
    
    return cell;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (float)getTableViewOriginXForOrientation:(UIInterfaceOrientation)orientation {
    //calculates starting position of menu
    if (self.alignment == MenuAligmentLeft)
        return 0;
    
    NSArray *titles = @[@"Home", @"Calendar", @"Profile", @"Settings", @"Log Out"];
    NSString *longestTitle = nil;
    //finds width of longest title
    for(NSString *str in titles)
        if (longestTitle == nil || [str length] > [longestTitle length])
            longestTitle = str;
    CGRect titleFrame = [longestTitle boundingRectWithSize:self.view.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:21] } context:nil];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    float screenWidth = UIDeviceOrientationIsLandscape(orientation) ? screenRect.size.height : screenRect.size.width;
    return screenWidth - (titleFrame.size.width + ICON_WIDTH + PADDING); //approximately length of pic + text
    
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    self.tableView.frame = CGRectMake([self getTableViewOriginXForOrientation:toInterfaceOrientation], self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height);
}

@end
