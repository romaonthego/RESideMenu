//
//  AccelerationAnimation.m
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

#import "AccelerationAnimation.h"
#import "Evaluate.h"

@implementation AccelerationAnimation

+ (id)animationWithKeyPath:(NSString *)keyPath
	startValue:(double)startValue
	endValue:(double)endValue
	evaluationObject:(NSObject<Evaluate> *)evaluationObject
	interstitialSteps:(NSUInteger)steps
{
	id animation = [self animationWithKeyPath:keyPath];
    
	[animation
		calculateKeyFramesWithEvaluationObject:evaluationObject
		startValue:(double)startValue
		endValue:(double)endValue
		interstitialSteps:steps];
	
	return animation;
}

- (void)calculateKeyFramesWithEvaluationObject:(NSObject<Evaluate> *)evaluationObject
	startValue:(double)startValue
	endValue:(double)endValue
	interstitialSteps:(NSUInteger)steps
{
	NSUInteger count = steps + 2;
	
	NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:count];

	double progress = 0.0;
	double increment = 1.0 / (double)(count - 1);
	NSUInteger i;
	for (i = 0; i < count; i++)
	{
		double value = startValue + [evaluationObject evaluateAt:progress] * (endValue - startValue);
		[valueArray addObject:[NSNumber numberWithDouble:value]];
		
		progress += increment;
	}
	
	[self setValues:valueArray];
}

@end
