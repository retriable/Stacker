//
//  StackerTransition.h
//  Stacker
//
//  Created by ouyanghua on 2019/10/16.
//  Copyright © 2019 ouyanghua. All rights reserved.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@class Stacker;
@class StackerTransition;

@interface StackerTransition : NSObject

@property (nonatomic, weak         ) Stacker                *stacker;
@property (nonatomic, weak         ) UIViewController       *viewController;
@property (nonatomic, weak,nullable) UIViewController       *fromViewController;
@property (nonatomic, weak         ) UIViewController       *toViewController;
@property (nonatomic, assign       ) CFTimeInterval         duration;
@property (nonatomic, readonly     ) BOOL                   interactionCancelled;

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
