//
//  RESideMenuItem.m
//  RESideMenuExample
//
//  Created by Roman Efimov on 6/14/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "RESideMenuItem.h"

@implementation RESideMenuItem

- (id)initWithTitle:(NSString *)title action:(void(^)(RESideMenu *menu, RESideMenuItem *item))action
{
    return [self initWithTitle:title image:nil highlightedImage:nil action:action];
}

- (id)initWithTitle:(NSString *)title image:(UIImage *)image highlightedImage:(UIImage *)highlightedImage action:(void(^)(RESideMenu *menu, RESideMenuItem *item))action
{
    self = [super init];
    if (!self)
        return nil;
    
    self.title = title;
    self.action = action;
    self.image = image;
    self.highlightedImage = highlightedImage;
    
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<title: %@ tag: %i>", self.title, self.tag];
}

@end
