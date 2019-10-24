//
//  UINavigationController+StackerPublic.m
//  Stacker
//
//  Created by ouyanghua on 2019/10/16.
//  Copyright © 2019 ouyanghua. All rights reserved.
//

#import <objc/runtime.h>

#import "NSObject+StackerPrivate.h"
#import "Stacker.h"
#import "UINavigationController+StackerPublic.h"
#import "UIViewController+StackerPrivate.h"

@implementation UINavigationController (StackerPublic)

- (void)setStacker_pop:(void (^)(__kindof UINavigationController *))stacker_pop{
    objc_setAssociatedObject(self, @selector(stacker_pop), stacker_pop, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void(^)(__kindof UINavigationController *))stacker_pop{
    return objc_getAssociatedObject(self, @selector(stacker_pop));
}

- (BOOL)stacker_original_navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item{
    if (self.stacker_pop){
        self.stacker_pop(self);
        return NO;
    }
    if (!self.stacker_stacker){
        [self.stacker_stacker popViewControllerAnimated:YES];
        return NO;
    }
    return [self stacker_original_navigationBar:navigationBar shouldPopItem:item];
}

- (void)stacker_original_setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers{
    [self setViewControllers:viewControllers animated:NO];
}

- (void)stacker_original_setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated{
    [self setViewControllers:viewControllers animated:animated completion:nil];
}

- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers animated:(BOOL)animated completion:(void (^)(BOOL finished))completion{
    if (self.stacker_stacker){
        [self.stacker_stacker setViewControllers:viewControllers animated:animated completion:completion];
        return;
    }
    [self stacker_original_setViewControllers:viewControllers animated:animated];
     if (completion) completion(YES);
}

- (void)pushViewController:(__kindof UIViewController *)viewController{
    [self pushViewController:viewController animated:NO];
}

- (void)stacker_original_pushViewController:(__kindof UIViewController *)viewController animated:(BOOL)animated{
    [self pushViewController:viewController animated:animated completion:nil];
}

- (void)pushViewController:(__kindof UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(BOOL finished))completion{
    if (self.stacker_stacker){
        [self.stacker_stacker pushViewController:viewController animated:animated completion:completion];
        return;
    }
    [self stacker_original_pushViewController:viewController animated:animated];
    if (completion) completion(YES);
}

- (void)pushViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers{
    [self pushViewControllers:viewControllers animated:NO];
}

- (void)pushViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers animated:(BOOL)animated{
    [self pushViewControllers:viewControllers animated:animated completion:nil];
}

- (void)pushViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers animated:(BOOL)animated completion:(void (^)(BOOL finished))completion{
    if (self.stacker_stacker){
        [self.stacker_stacker pushViewControllers:viewControllers animated:animated completion:completion];
        return;
    }
    if (viewControllers.count==0){
        if (completion) completion(YES);
        return;
    }
    for (NSInteger i=0;i<viewControllers.count-1;i++){
        [self stacker_original_pushViewController:viewControllers[i] animated:NO];
    }
    [self stacker_original_pushViewController:viewControllers.lastObject animated:animated];
    if (completion) completion(YES);
}

- (nullable __kindof UIViewController *)popViewController{
    return [self popViewControllerAnimated:NO];
}

- (nullable __kindof UIViewController *)stacker_original_popViewControllerAnimated:(BOOL)animated{
    return [self popViewControllerAnimated:animated completion:nil];
}

- (nullable __kindof UIViewController *)popViewControllerAnimated:(BOOL)animated completion:(void(^_Nullable)(BOOL finished))completion{
    if (self.stacker_stacker){
        return [self.stacker_stacker popViewControllerAnimated:animated completion:completion];
    }
    UIViewController *v = [self stacker_original_popViewControllerAnimated:animated];
    if (completion) completion(YES);
    return v;
}

- (nullable NSArray<__kindof UIViewController *> *)popToRootViewController{
    return [self popToRootViewControllerAnimated:NO];
}

- (nullable NSArray<__kindof UIViewController *> *)stacker_original_popToRootViewControllerAnimated:(BOOL)animated{
    return [self popToRootViewControllerAnimated:animated completion:nil];
}

- (nullable NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated completion:(void(^_Nullable)(BOOL finished))completion{
    if (self.stacker_stacker){
        return [self.stacker_stacker popToRootViewControllerAnimated:animated completion:completion];
    }
    NSArray * v= [self stacker_original_popToRootViewControllerAnimated:animated];
    if (completion) completion(YES);
    return v;
}

- (nullable NSArray<__kindof UIViewController *> *)popToViewController:(UIViewController *)viewController{
    return [self popToViewController:viewController animated:NO];
}

- (nullable NSArray<__kindof UIViewController *> *)stacker_original_popToViewController:(UIViewController *)viewController animated:(BOOL)animated{
    return [self popToViewController:viewController animated:animated completion:nil];
}

- (nullable NSArray<__kindof UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^ _Nullable)(BOOL finished))completion{
    if (self.stacker_stacker){
        return [self.stacker_stacker popToViewController:viewController animated:animated completion:completion];
    }
    NSArray *v = [self stacker_original_popToViewController:viewController animated:animated];
    if (completion) completion(YES);
    return v;
}

- (BOOL)stacker_original_prefersStatusBarHidden{
    if (!self.stacker_stacker){
        return [self stacker_original_prefersStatusBarHidden];
    }
    if (!self.topViewController){
        return [self stacker_original_prefersStatusBarHidden];
    }
    return [self.topViewController prefersStatusBarHidden];
}

- (UIStatusBarStyle)stacker_original_preferredStatusBarStyle{
    if (!self.stacker_stacker){
        return [self stacker_original_preferredStatusBarStyle];
    }
    if (!self.topViewController){
        return [self stacker_original_preferredStatusBarStyle];
    }
    return [self.topViewController preferredStatusBarStyle];
}

- (UIStatusBarAnimation)stacker_original_preferredStatusBarUpdateAnimation{
    if (!self.stacker_stacker){
        return [self stacker_original_preferredStatusBarUpdateAnimation];
    }
    if (!self.topViewController){
        return [self stacker_original_preferredStatusBarUpdateAnimation];
    }
    return [self.topViewController preferredStatusBarUpdateAnimation];
}

- (BOOL)stacker_original_shouldAutorotate{
    if (!self.stacker_stacker){
        return [self stacker_original_shouldAutorotate];
    }
    if (!self.topViewController){
        return [self stacker_original_shouldAutorotate];
    }
    return [self.topViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)stacker_original_supportedInterfaceOrientations{
    if (!self.stacker_stacker){
        return [self stacker_original_supportedInterfaceOrientations];
    }
    if (!self.topViewController){
        return [self stacker_original_supportedInterfaceOrientations];
    }
    return [self.topViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)stacker_original_preferredInterfaceOrientationForPresentation{
    if (!self.stacker_stacker){
        return [self stacker_original_preferredInterfaceOrientationForPresentation];
    }
    if (!self.topViewController){
        return [self stacker_original_preferredInterfaceOrientationForPresentation];
    }
    return [self.topViewController preferredInterfaceOrientationForPresentation];
}

+ (void)load{
    [self stacker_swizzleinstanceWithOrignalMethod:@selector(navigationBar:shouldPopItem:) alteredMethod:@selector(stacker_original_navigationBar:shouldPopItem:)];
    [self stacker_swizzleinstanceWithOrignalMethod:@selector(setViewControllers:) alteredMethod:@selector(stacker_original_setViewControllers:)];
    [self stacker_swizzleinstanceWithOrignalMethod:@selector(setViewControllers:animated:) alteredMethod:@selector(stacker_original_setViewControllers:animated:)];
    [self stacker_swizzleinstanceWithOrignalMethod:@selector(pushViewController:animated:) alteredMethod:@selector(stacker_original_pushViewController:animated:)];
    [self stacker_swizzleinstanceWithOrignalMethod:@selector(popViewControllerAnimated:) alteredMethod:@selector(stacker_original_popViewControllerAnimated:)];
    [self stacker_swizzleinstanceWithOrignalMethod:@selector(popToRootViewControllerAnimated:) alteredMethod:@selector(stacker_original_popToRootViewControllerAnimated:)];
    [self stacker_swizzleinstanceWithOrignalMethod:@selector(popToViewController:animated:) alteredMethod:@selector(stacker_original_popToViewController:animated:)];
    [self stacker_swizzleinstanceWithOrignalMethod:@selector(prefersStatusBarHidden) alteredMethod:@selector(stacker_original_prefersStatusBarHidden)];
    [self stacker_swizzleinstanceWithOrignalMethod:@selector(preferredStatusBarStyle) alteredMethod:@selector(stacker_original_preferredStatusBarStyle)];
    [self stacker_swizzleinstanceWithOrignalMethod:@selector(preferredStatusBarUpdateAnimation) alteredMethod:@selector(stacker_original_preferredStatusBarUpdateAnimation)];
    [self stacker_swizzleinstanceWithOrignalMethod:@selector(shouldAutorotate) alteredMethod:@selector(stacker_original_shouldAutorotate)];
    [self stacker_swizzleinstanceWithOrignalMethod:@selector(supportedInterfaceOrientations) alteredMethod:@selector(stacker_original_supportedInterfaceOrientations)];
    [self stacker_swizzleinstanceWithOrignalMethod:@selector(preferredInterfaceOrientationForPresentation) alteredMethod:@selector(stacker_original_preferredInterfaceOrientationForPresentation)];
}
@end
