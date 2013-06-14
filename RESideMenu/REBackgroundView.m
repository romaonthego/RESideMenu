//
//  REBackgroundView.m
//  RESideMenuExample
//
//  Created by Roman Efimov on 6/14/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "REBackgroundView.h"

@interface REBackgroundView ()

@property (strong, readonly, nonatomic) UIImageView *imageView;

@end

@implementation REBackgroundView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return self;
}

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    _backgroundImage = backgroundImage;
    _imageView.image = backgroundImage;
}

- (void)drawRect:(CGRect)rect
{
    if (self.backgroundImage)
        return;
    
    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* fillColor = [UIColor colorWithRed: 0.294 green: 0.2 blue: 0.353 alpha: 1];
    UIColor* strokeColor = [UIColor colorWithRed: 0.294 green: 0.2 blue: 0.353 alpha: 1];
    UIColor* gradientColor = [UIColor colorWithRed: 0.514 green: 0.333 blue: 0.4 alpha: 1];
    UIColor* gradientColor2 = [UIColor colorWithRed: 0.667 green: 0.533 blue: 0.467 alpha: 1];
    UIColor* gradientColor3 = [UIColor colorWithRed: 0.667 green: 0.467 blue: 0.467 alpha: 1];
    
    //// Gradient Declarations
    NSArray* gradientColors = [NSArray arrayWithObjects:
                               (id)strokeColor.CGColor,
                               (id)[UIColor colorWithRed: 0.404 green: 0.267 blue: 0.376 alpha: 1].CGColor,
                               (id)gradientColor.CGColor,
                               (id)gradientColor2.CGColor,
                               (id)gradientColor3.CGColor,
                               (id)fillColor.CGColor, nil];
    CGFloat gradientLocations[] = {0, 0.16, 0.29, 0.58, 0.8, 1};
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradientColors, gradientLocations);
    
    //// Rectangle Drawing
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(0, 0, rect.size.width, rect.size.height)];
    CGContextSaveGState(context);
    [rectanglePath addClip];
    CGContextDrawLinearGradient(context, gradient, CGPointMake(rect.size.width / 2.0, 0), CGPointMake(rect.size.width / 2.0, rect.size.height), 0);
    CGContextRestoreGState(context);
    
    
    //// Cleanup
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

@end
