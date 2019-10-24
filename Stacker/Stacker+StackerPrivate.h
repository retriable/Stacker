//
//  Stacker+StackerPrivate.h
//  Stacker
//
//  Created by ouyanghua on 2019/10/18.
//  Copyright © 2019 ouyanghua. All rights reserved.
//

#import "Stacker.h"

NS_ASSUME_NONNULL_BEGIN

@interface Stacker (StackerPrivate)

@property (readonly,assign) BOOL interactionCancelled;

- (void)startInteractionWithDuration:(CFTimeInterval)duration;

- (void)updateInteractionProgress:(CGFloat)progress;

- (void)finishInteractionWithSpeed:(CGFloat)speed;

- (void)cancelInteractionWithSpeed:(CGFloat)speed;

@end

NS_ASSUME_NONNULL_END
