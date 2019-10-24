//
//  UIViewController+StackerPrivate.m
//  Stacker
//
//  Created by ouyanghua on 2019/10/16.
//  Copyright © 2019 ouyanghua. All rights reserved.
//

#import <objc/runtime.h>

#import "NSObject+StackerPrivate.h"
#import "Stacker.h"
#import "StackerPushTransition.h"
#import "UIViewController+StackerPrivate.h"

@implementation UIViewController (StackerPrivate)

- (Stacker *)stacker_stacker {
    if ([self isKindOfClass:UINavigationController.class]) {
        return [objc_getAssociatedObject(self, @selector(stacker_stacker)) anyObject];
    }
    return [self.navigationController stacker_stacker];
}

- (void)setStacker_stacker:(Stacker *)stacker_stacker{
    objc_setAssociatedObject(self, @selector(stacker_stacker), stacker_stacker ? ({
        NSHashTable *v = [NSHashTable weakObjectsHashTable];
        [v addObject:stacker_stacker];
        v;
    }): nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setStacker_transition:(StackerTransition*)stacker_transition{
    objc_setAssociatedObject(self, @selector(stacker_transition), stacker_transition, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (StackerTransition*)stacker_transition{
    StackerTransition* transition = objc_getAssociatedObject(self, @selector(stacker_transition));
    if (transition) return transition;
    if ([self isKindOfClass:UINavigationController.class]){
        transition=[(UINavigationController*)self topViewController].stacker_transition;
        if (transition) return transition;
    }
    transition=[[StackerPushTransition alloc]init];
    self.stacker_transition=transition;
    return transition;
}

@end
