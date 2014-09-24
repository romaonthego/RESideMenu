//
//  MCBTransform3DHandler.m
//  Minicabster
//
//  Created by Matic Oblak on 9/23/14.
//  Copyright (c) 2014 D·Labs. All rights reserved.
//

#import "MCBTransform3DHandler.h"

@implementation MCBTransform3DHandler

+ (CATransform3D)interpolateMatrices:(CATransform3D)source to:(CATransform3D)target scale:(CGFloat)scale
{
    CATransform3D result;
    
    result.m11 = [self interpolateLinear:source.m11 to:target.m11 scale:scale];
    result.m12 = [self interpolateLinear:source.m12 to:target.m12 scale:scale];
    result.m13 = [self interpolateLinear:source.m13 to:target.m13 scale:scale];
    result.m14 = [self interpolateLinear:source.m14 to:target.m14 scale:scale];
    
    result.m21 = [self interpolateLinear:source.m21 to:target.m21 scale:scale];
    result.m22 = [self interpolateLinear:source.m22 to:target.m22 scale:scale];
    result.m23 = [self interpolateLinear:source.m23 to:target.m23 scale:scale];
    result.m24 = [self interpolateLinear:source.m24 to:target.m24 scale:scale];
    
    result.m31 = [self interpolateLinear:source.m31 to:target.m31 scale:scale];
    result.m32 = [self interpolateLinear:source.m32 to:target.m32 scale:scale];
    result.m33 = [self interpolateLinear:source.m33 to:target.m33 scale:scale];
    result.m34 = [self interpolateLinear:source.m34 to:target.m34 scale:scale];
    
    result.m41 = [self interpolateLinear:source.m41 to:target.m41 scale:scale];
    result.m42 = [self interpolateLinear:source.m42 to:target.m42 scale:scale];
    result.m43 = [self interpolateLinear:source.m43 to:target.m43 scale:scale];
    result.m44 = [self interpolateLinear:source.m44 to:target.m44 scale:scale];

    return result;
}

- (CATransform3D)interpolatedTransformWithScale:(CGFloat)scale
{
    return CATransform3DIdentity;
}

+ (CGFloat)interpolateLinear:(CGFloat)a to:(CGFloat)b scale:(CGFloat)scale
{
    return a + (b-a)*scale;
}


@end

@implementation MCBTransform3DPerspectiveRotation

- (instancetype)init
{
    if((self = [super init]))
    {
        // set defaults
        self.perspectiveStrength = -500.0f;
        self.rotationY = (CGFloat)(-M_PI_2/3.0);
        self.translationX = 170.0f;
        self.scaleXY = .62f;
    }
    return self;
}

- (CATransform3D)interpolatedTransformWithScale:(CGFloat)scale
{
    CGFloat interpolatedPerspective = self.perspectiveStrength;
    CGFloat interpolatedRotationY = [self interpolate:.0f to:self.rotationY scale:1.0f];
    CGFloat interpolatedTranslation = [self interpolate:.0f to:self.translationX scale:1.0f];
    CGFloat interpolatedScaleXY = [self interpolate:1.0f to:self.scaleXY scale:1.0f];
    
    //NSLog(@"Scale: %g, irotation: %g", scale, interpolatedRotationY);
    
    CATransform3D interpolatedTransformation = CATransform3DIdentity;
    interpolatedTransformation.m34 = 1.0f / interpolatedPerspective;
    interpolatedTransformation = CATransform3DRotate(interpolatedTransformation, interpolatedRotationY, 0.0f, 1.0f, 0.0f);
    interpolatedTransformation = CATransform3DTranslate(interpolatedTransformation, interpolatedTranslation, 0, 0);
    interpolatedTransformation = CATransform3DScale(interpolatedTransformation, interpolatedScaleXY, interpolatedScaleXY, 1);
    
    return [MCBTransform3DPerspectiveRotation interpolateMatrices:CATransform3DIdentity to:interpolatedTransformation scale:scale];
}


//- (CATransform3D)interpolatedTransformWithScale:(CGFloat)scale
//{
//    CGFloat interpolatedPerspective = self.perspectiveStrength;
//    CGFloat interpolatedRotationY = [self interpolate:.0f to:self.rotationY scale:scale];
//    CGFloat interpolatedTranslation = [self interpolate:.0f to:self.translationX scale:scale];
//    CGFloat interpolatedScaleXY = [self interpolate:1.0f to:self.scaleXY scale:scale];
//
//    NSLog(@"Scale: %g, irotation: %g", scale, interpolatedRotationY);
//    
//    CATransform3D interpolatedTransformation = CATransform3DIdentity;
//    interpolatedTransformation.m34 = 1.0f / interpolatedPerspective;
//    interpolatedTransformation = CATransform3DRotate(interpolatedTransformation, interpolatedRotationY, 0.0f, 1.0f, 0.0f);
//    interpolatedTransformation = CATransform3DTranslate(interpolatedTransformation, interpolatedTranslation, 0, 0);
//    interpolatedTransformation = CATransform3DScale(interpolatedTransformation, interpolatedScaleXY, interpolatedScaleXY, 1);
//    
//    return interpolatedTransformation;
//}

- (CGFloat)interpolate:(CGFloat)a to:(CGFloat)b scale:(CGFloat)scale
{
    return a + (b-a)*scale;
}


@end
