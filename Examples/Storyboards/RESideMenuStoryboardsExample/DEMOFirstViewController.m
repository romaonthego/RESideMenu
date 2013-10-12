//
//  DEMOFirstViewController.m
//  RESideMenuStoryboards
//
//  Created by Roman Efimov on 10/9/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "DEMOFirstViewController.h"

@interface DEMOFirstViewController ()

@end

@implementation DEMOFirstViewController

- (IBAction)showMenu
{
    [self.sideMenuViewController presentMenuViewController];
}

@end
