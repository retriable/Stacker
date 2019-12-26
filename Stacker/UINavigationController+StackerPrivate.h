//
//  UINavigationController+StackerPrivate.h
//  Stacker
//
//  Created by ouyanghua on 2019/10/16.
//  Copyright © 2019 ouyanghua. All rights reserved.
//

@import UIKit;

#import "UINavigationController+StackerPublic.h"

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (StackerPrivate)

- (void)stacker_original_setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
