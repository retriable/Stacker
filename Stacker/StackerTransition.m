//
//  StackerTransition.m
//  Stacker
//
//  Created by ouyanghua on 2019/10/16.
//  Copyright © 2019 ouyanghua. All rights reserved.
//

#import "Stacker+StackerPrivate.h"
#import "StackerTransition.h"

@interface StackerTransition()

@property (nonatomic,weak) Stacker          *stacker;
@property (nonatomic,weak) UIViewController *viewController;
@property (nonatomic,weak) UIViewController *fromViewController;
@property (nonatomic,weak) UIViewController *toViewController;

@property (nonatomic,copy) void(^completeBlock)(BOOL finished);
@property (nonatomic,copy) BOOL(^interactionCancelledBlock)(void);
@property (nonatomic,copy) void(^startInteractionBlock)(CFTimeInterval duration);
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

- (BOOL)interactionCancelled{
    return self.interactionCancelledBlock();
}

- (void)startTransition:(CFTimeInterval)duration{
    [self complete:YES];
}

- (void)startInteraction:(CFTimeInterval)duration{
    self.startInteractionBlock(duration);
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

- (void)fixNavigationBarPosition {
    if (self.fromViewController!=self.viewController) return;
    UINavigationController *v=(UINavigationController*)self.viewController;
    BOOL navigationBarHidden=v.navigationBarHidden;
    v.navigationBarHidden=!navigationBarHidden;
    v.navigationBarHidden=navigationBarHidden;
}

@end
