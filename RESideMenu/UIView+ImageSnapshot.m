//
//  UIView+ImageSnapshot.m
//  RESideMenuExample
//
//  Created by Sam Oakley on 22/07/2013.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "UIView+ImageSnapshot.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (ImageSnapshot)
-(UIImage*) snapshotImage
{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    } else {
        UIGraphicsBeginImageContext(self.bounds.size);
    }

    if ([self respondsToSelector:@selector(drawViewHierarchyInRect:)]) {        
        NSInvocation* invoc = [NSInvocation invocationWithMethodSignature:
                               [self methodSignatureForSelector:
                                @selector(drawViewHierarchyInRect:)]];
        [invoc setTarget:self];
        [invoc setSelector:@selector(drawViewHierarchyInRect:)];
        CGRect arg2 = self.bounds;
        [invoc setArgument:&arg2 atIndex:2];
        [invoc invoke];
    } else {
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    }

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;

}
@end
