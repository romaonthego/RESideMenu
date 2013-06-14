//
//  RESideMenuItem.h
//  RESideMenuExample
//
//  Created by Roman Efimov on 6/14/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RESideMenu;

@interface RESideMenuItem : NSObject

@property (copy, readwrite, nonatomic) NSString *title;
@property (assign, readwrite, nonatomic) NSInteger tag;
@property (copy, readwrite, nonatomic) void (^action)(RESideMenu *menu, RESideMenuItem *item);

- (id)initWithTitle:(NSString *)title action:(void(^)(RESideMenu *menu, RESideMenuItem *item))action;

@end
