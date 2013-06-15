//
//  RESideMenuCell.m
//  RESideMenuExample
//
//  Created by Roman Efimov on 6/14/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "RESideMenuCell.h"

@implementation RESideMenuCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.imageView.image) {
        self.imageView.frame = CGRectMake(self.horizontalOffset, self.imageView.frame.origin.y, self.imageView.frame.size.width, self.imageView.frame.size.height);
        self.textLabel.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame) + 20.0, self.textLabel.frame.origin.y, self.textLabel.frame.size.width, self.textLabel.frame.size.height);
    } else {
        self.textLabel.frame = CGRectMake(self.horizontalOffset, self.textLabel.frame.origin.y, self.textLabel.frame.size.width, self.textLabel.frame.size.height);
    }
}

@end
