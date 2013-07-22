//
//  UIView+ImageSnapshot.m
//  RESideMenuExample
//
//  Created by Sam Oakley on 22/07/2013.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "UIView+ImageSnapshot.h"

@implementation UIView (ImageSnapshot)
-(UIImage*) snapshotImage
{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, [UIScreen mainScreen].scale);
    } else {
        UIGraphicsBeginImageContext(self.window.bounds.size);
    }

    if ([self respondsToSelector:@selector(snapshotView)]) {
        [self drawViewHierarchyInRect:self.frame];
    } else {
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    
    __block UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;

}
@end
