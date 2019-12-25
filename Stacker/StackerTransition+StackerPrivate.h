//
//  StackerTransition+StackerPrivate.h
//  Stacker
//
//  Created by ouyanghua on 2019/10/16.
//  Copyright © 2019 ouyanghua. All rights reserved.
//

@class Stacker;

#import "StackerTransition.h"

NS_ASSUME_NONNULL_BEGIN

@interface StackerTransition (StackerPrivate)

@property (nonatomic,weak) Stacker          *stacker;

@property (nonatomic,copy) void(^completeBlock)(BOOL finished);
@property (nonatomic,copy) BOOL(^interactionCancelledBlock)(void);
@property (nonatomic,copy) void(^startInteractionBlock)(void);
@property (nonatomic,copy) void(^updateInteractionBlock)(CGFloat progress);
@property (nonatomic,copy) void(^cancelInteractionBlock)(CGFloat speed);
@property (nonatomic,copy) void(^finishInteractionBlock)(CGFloat speed);

@end

NS_ASSUME_NONNULL_END
