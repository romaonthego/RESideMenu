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
    self = [super init];
    if (!self)
        return nil;
    
    self.title = title;
    self.action = action;
    
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<title: %@ tag: %i>", self.title, self.tag];
}

@end
