//
//  UIViewController+StackerPrivate.h
//  Stacker
//
//  Created by ouyanghua on 2019/10/16.
//  Copyright © 2019 ouyanghua. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Stacker;

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (StackerPrivate)

@property (nonatomic,weak)Stacker *stacker_stacker;

@end

NS_ASSUME_NONNULL_END