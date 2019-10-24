//
//  StackerTransition.h
//  Stacker
//
//  Created by ouyanghua on 2019/10/16.
//  Copyright © 2019 ouyanghua. All rights reserved.
//

#import <UIKIt/UIKIt.h>

NS_ASSUME_NONNULL_BEGIN

@class Stacker;

typedef NS_ENUM(NSInteger,StackerTransitionStyle) {
    StackerTransitionStyleCurrentContext,
    StackerTransitionStyleOverCurrentContext
};

@interface StackerTransition : NSObject

@property (nonatomic,assign) CFTimeInterval           duration;
@property (nonatomic,assign) StackerTransitionStyle   style;
@property (readonly,weak   ) Stacker                  *stacker;
@property (readonly,weak   ) UIViewController         *viewController;
@property (readonly,weak   ) UIViewController         *fromViewController;
@property (readonly,weak   ) UIViewController         *toViewController;
@property (readonly,assign ) BOOL                     interactionCancelled;

- (void)complete:(BOOL)finished;

/// start transition
/// @param duration duration
- (void)startTransition:(CFTimeInterval)duration;

#pragma mark
#pragma mark -- percent driven interaction
- (void)startInteraction:(CFTimeInterval)duration;
- (void)updateInteraction:(CGFloat)progress;
- (void)cancelInteraction:(CGFloat)speed;
- (void)finishInteraction:(CGFloat)speed;
@end

NS_ASSUME_NONNULL_END
