//
//  NSObject+StackerPrivate.h
//  RANC
//
//  Created by retriable on 2019/4/19.
//  Copyright © 2019 retriable. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (StackerPrivate)

+ (BOOL)stacker_swizzleinstanceWithOrignalMethod:(SEL)orignalMethod alteredMethod:(SEL)altertedMethod;

@end

NS_ASSUME_NONNULL_END
