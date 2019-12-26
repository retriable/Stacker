//
//  UIViewController+StackerPublic.h
//  Stacker
//
//  Created by ouyanghua on 2019/10/16.
//  Copyright © 2019 ouyanghua. All rights reserved.
//

@import UIKit;

@class Stacker;
@class StackerTransition;

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (StackerPublic)

@property (readonly,  weak,   nullable) Stacker                *stacker_stacker;
@property (nonatomic, strong          ) StackerTransition      *stacker_transition;
@property (nonatomic, assign          ) BOOL                   stacker_master;

@end

NS_ASSUME_NONNULL_END
