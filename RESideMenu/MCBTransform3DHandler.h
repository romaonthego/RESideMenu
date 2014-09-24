//
//  MCBTransform3DHandler.h
//  Minicabster
//
//  Created by Matic Oblak on 9/23/14.
//  Copyright (c) 2014 D·Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCBTransform3DHandler : NSObject
- (CATransform3D)interpolatedTransformWithScale:(CGFloat)scale;
@end

@interface MCBTransform3DPerspectiveRotation : MCBTransform3DHandler
@property (nonatomic) CGFloat perspectiveStrength; // default -500
@property (nonatomic) CGFloat rotationY; // default -M_PI/6
@property (nonatomic) CGFloat translationX; // default 170
@property (nonatomic) CGFloat scaleXY; // default 0.62f
@end
