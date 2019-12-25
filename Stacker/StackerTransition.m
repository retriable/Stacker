//
//  StackerTransition.m
//  Stacker
//
//  Created by ouyanghua on 2019/10/16.
//  Copyright © 2019 ouyanghua. All rights reserved.
//

#import "StackerTransition.h"
#import "Stacker.h"

@interface StackerTransition()

@property (nonatomic,copy) void(^completeBlock)(BOOL finished);
@property (nonatomic,copy) BOOL(^interactionCancelledBlock)(void);
@property (nonatomic,copy) void(^startInteractionBlock)(void);
@property (nonatomic,copy) void(^updateInteractionBlock)(CGFloat progress);
@property (nonatomic,copy) void(^cancelInteractionBlock)(CGFloat speed);
@property (nonatomic,copy) void(^finishInteractionBlock)(CGFloat speed);

@end

@implementation StackerTransition

- (instancetype)init{
    self=[super init];
    if (!self) return nil;
    self.duration=0.25;
    return self;
}

- (void)complete:(BOOL)finished{
    if (@available(iOS 9, *)) {
        
    } else {
        [self fixNavigationBarPosition];
    }
    self.completeBlock(finished);
}

- (void)restoreTransition{

}

- (void)layoutView:(UIView*)view{
    view.superview.translatesAutoresizingMaskIntoConstraints = NO;
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [view.superview addConstraints:@[
        [NSLayoutConstraint constraintWithItem:view.superview attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTop multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:view.superview attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeading multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:view.superview attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeBottom multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:view.superview attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0],
    ]];
}

- (void)startTransition:(CFTimeInterval)duration{
    [self complete:YES];
}

- (void)startInteraction{
    self.startInteractionBlock();
}

- (void)updateInteraction:(CGFloat)progress{
    self.updateInteractionBlock(progress);
}

- (void)cancelInteraction:(CGFloat)speed{
    self.cancelInteractionBlock(speed);
}

- (void)finishInteraction:(CGFloat)speed{
    self.finishInteractionBlock(speed);
}

- (BOOL)interactionCancelled{
    return self.interactionCancelledBlock();
}
- (void)fixNavigationBarPosition{
    if (self.fromViewController!=self.viewController) return;
    UINavigationController *v=(UINavigationController*)self.viewController;
    BOOL navigationBarHidden=v.navigationBarHidden;
    v.navigationBarHidden=!navigationBarHidden;
    v.navigationBarHidden=navigationBarHidden;
}

@end
