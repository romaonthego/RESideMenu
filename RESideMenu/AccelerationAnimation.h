//
//  AccelerationAnimation.h
//  AnimationAcceleration
//
//  Created by Matt Gallagher on 8/09/08.
//  Copyright 2008 Matt Gallagher. All rights reserved.
//
//  Permission is given to use this source code file without charge in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//

#import <QuartzCore/CoreAnimation.h>

@protocol Evaluate;

@interface AccelerationAnimation : CAKeyframeAnimation
{
}

+ (id)animationWithKeyPath:(NSString *)keyPath
	startValue:(double)startValue
	endValue:(double)endValue
	evaluationObject:(NSObject<Evaluate> *)evaluationObject
	interstitialSteps:(NSUInteger)steps;

- (void)calculateKeyFramesWithEvaluationObject:(NSObject<Evaluate> *)evaluationObject
	startValue:(double)startValue
	endValue:(double)endValue
	interstitialSteps:(NSUInteger)steps;

@end
