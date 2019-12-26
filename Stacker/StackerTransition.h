//
//  StackerTransition.h
//  Stacker
//
//  Created by ouyanghua on 2019/10/16.
//  Copyright © 2019 ouyanghua. All rights reserved.
//

@import UIKit;

@class Stacker;


typedef NS_ENUM(NSInteger,StackerTransitionStyle) {
    StackerTransitionStyleCurrentContext,
    StackerTransitionStyleOverCurrentContext
};

NS_ASSUME_NONNULL_BEGIN

@interface StackerTransition : NSObject

@property (nonatomic, weak, readonly          ) Stacker                *stacker;
@property (nonatomic, weak, readonly          ) UIViewController       *viewController;
@property (nonatomic, weak, readonly, nullable) UIViewController       *fromViewController;
@property (nonatomic, weak, readonly          ) UIViewController       *toViewController;
@property (nonatomic, readonly                ) BOOL                   interactionCancelled;
@property (nonatomic, assign                  ) StackerTransitionStyle style;

- (void)complete:(BOOL)finished;

- (void)startTransition:(CFTimeInterval)duration;

- (void)restoreTransition;

- (void)layoutView:(UIView*)view;

#pragma mark
#pragma mark -- percent driven interaction
- (void)startInteraction;
- (void)updateInteraction:(CGFloat)progress;
- (void)cancelInteraction:(CGFloat)speed;
- (void)finishInteraction:(CGFloat)speed;
@end

NS_ASSUME_NONNULL_END
