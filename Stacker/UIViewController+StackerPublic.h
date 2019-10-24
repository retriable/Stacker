//
//  UIViewController+StackerPublic.h
//  Stacker
//
//  Created by ouyanghua on 2019/10/16.
//  Copyright © 2019 ouyanghua. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "StackerTransition.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (StackerPublic)

@property (nonatomic,strong,nullable) StackerTransition *stacker_transition;

@end

NS_ASSUME_NONNULL_END
