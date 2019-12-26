//
//  StackerDefaultTransition.h
//  Stacker
//
//  Created by ouyanghua on 2019/10/16.
//  Copyright © 2019 ouyanghua. All rights reserved.
//

#import "StackerTransition.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, StackerDefaultTransitionDirection) {
    StackerDefaultTransitionDirectionRightToLeft,
    StackerDefaultTransitionDirectionBottomToTop
};

@interface StackerDefaultTransition : StackerTransition

@property (nonatomic, assign          ) StackerDefaultTransitionDirection direction;
@property (nonatomic, assign          ) CGFloat                           percentParallax;
@property (nonatomic, strong, readonly) UIPanGestureRecognizer            *interactivePopGestureRecognizer;

@end

NS_ASSUME_NONNULL_END
