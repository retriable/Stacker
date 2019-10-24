//
//  StackerPushTransition.h
//  Stacker
//
//  Created by ouyanghua on 2019/10/16.
//  Copyright © 2019 ouyanghua. All rights reserved.
//

#import "StackerTransition.h"

NS_ASSUME_NONNULL_BEGIN

@interface StackerPresentTransition : StackerTransition

@property (readonly) UIPanGestureRecognizer  *panGestureRecognizer;

@end

NS_ASSUME_NONNULL_END
