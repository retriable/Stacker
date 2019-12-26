//
//  StackerDefaultTransition.m
//  Stacker
//
//  Created by ouyanghua on 2019/10/16.
//  Copyright © 2019 ouyanghua. All rights reserved.
//

#import <objc/runtime.h>

#import "Stacker.h"
#import "NSObject+StackerPrivate.h"
#import "StackerDefaultTransition.h"

@interface UIView (StackerDefaultTransition)

@property (nonatomic, strong) NSValue  *stacker_shadowEffectOffset;
@property (nonatomic, strong) NSNumber *stacker_backgroundEffectAlpha;
@property (nonatomic, strong) UIView   *stacker_backgroundEffectView;

@end

@implementation  UIView (StackerDefaultTransition)

- (void)setStacker_shadowEffectOffset:(NSValue*)stacker_shadowEffectOffset{
    objc_setAssociatedObject(self, @selector(stacker_shadowEffectOffset), stacker_shadowEffectOffset, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self stacker_setNeedDisplay];
}

- (NSValue*)stacker_shadowEffectOffset{
    return objc_getAssociatedObject(self, @selector(stacker_shadowEffectOffset));
}

- (void)setStacker_backgroundEffectAlpha:(NSNumber*)stacker_backgroundEffectAlpha{
    objc_setAssociatedObject(self, @selector(stacker_backgroundEffectAlpha), stacker_backgroundEffectAlpha, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self stacker_setNeedDisplay];
}

- (NSNumber*)stacker_backgroundEffectAlpha{
    return objc_getAssociatedObject(self, @selector(stacker_backgroundEffectAlpha));
}

- (void)setStacker_backgroundEffectView:(UIView *)stacker_backgroundEffectView{
    objc_setAssociatedObject(self, @selector(stacker_backgroundEffectView), stacker_backgroundEffectView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView*)stacker_backgroundEffectView{
    return objc_getAssociatedObject(self, @selector(stacker_backgroundEffectView));
}

- (void)stacker_setNeedDisplay{
    UIView *superView = self.superview;
    NSValue *offset = self.stacker_shadowEffectOffset;
    if (offset && superView){
        self.layer.shadowPath =[UIBezierPath bezierPathWithRect:self.bounds].CGPath;
         self.layer.shadowColor=[UIColor blackColor].CGColor;
         self.layer.shadowOffset = [offset CGSizeValue];
         self.layer.shadowRadius=8;
         self.layer.shadowOpacity=0.5;
    }else{
        self.layer.shadowOpacity=0;
    }
    NSNumber *alpha = self.stacker_backgroundEffectAlpha;
    if (alpha && superView){
        if (!self.stacker_backgroundEffectView){
            self.stacker_backgroundEffectView =({
                UIView *v = [[UIView alloc]init];
                v.backgroundColor=[UIColor blackColor];
                [superView insertSubview:v belowSubview:self];
                v.translatesAutoresizingMaskIntoConstraints = NO;
                [superView addConstraints:@[
                    [NSLayoutConstraint constraintWithItem:v attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeTop multiplier:1 constant:0],
                    [NSLayoutConstraint constraintWithItem:v attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeLeading multiplier:1 constant:0],
                    [NSLayoutConstraint constraintWithItem:v attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeBottom multiplier:1 constant:0],
                    [NSLayoutConstraint constraintWithItem:v attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0],
                    
                ]];
                v;
            });
        }
        self.stacker_backgroundEffectView.alpha = alpha.doubleValue;
    }else{
        [self.stacker_backgroundEffectView removeFromSuperview];
        self.stacker_backgroundEffectView = nil;
    }
}

- (void)stacker_removeFromSuperview{
    [self stacker_removeFromSuperview];
    [self stacker_setNeedDisplay];
}

- (void)stacker_didMoveToSuperview{
    [self stacker_didMoveToSuperview];
    [self stacker_setNeedDisplay];
}

+ (void)load{
    [self stacker_swizzleinstanceWithOrignalMethod:@selector(removeFromSuperview) alteredMethod:@selector(stacker_removeFromSuperview)];
    [self stacker_swizzleinstanceWithOrignalMethod:@selector(didMoveToSuperview) alteredMethod:@selector(stacker_didMoveToSuperview)];
}
@end

@interface StackerDefaultTransition() <UIGestureRecognizerDelegate>

@property (nonatomic,strong) UIPanGestureRecognizer *interactivePopGestureRecognizer;
@property (nonatomic,assign) CGPoint                startPoint;
@property (nonatomic,assign) CATransform3D          fromTransform;
@property (nonatomic,assign) CATransform3D          toTransform;

@end

@implementation StackerDefaultTransition

- (instancetype)init{
    self = [super init];
    if (!self) return nil;
    return self;
}

- (void)startTransition:(CFTimeInterval)duration{
    BOOL push = self.viewController==self.toViewController;
    UIViewController *toViewController = self.toViewController;
    UIView *fromView=self.fromViewController.view;
    UIView *toView=self.toViewController.view;
    StackerDefaultTransitionDirection direction = self.direction;
    if (push){
        if (toView!=self.interactivePopGestureRecognizer.view){
            [self.interactivePopGestureRecognizer.view removeGestureRecognizer:self.interactivePopGestureRecognizer];
            [toView addGestureRecognizer:self.interactivePopGestureRecognizer];
        }
        [(UINavigationController*)toViewController interactivePopGestureRecognizer].enabled=NO;
        switch (direction) {
            case StackerDefaultTransitionDirectionRightToLeft:
                toView.stacker_shadowEffectOffset = @(CGSizeMake(-8, 0));
                break;
            case StackerDefaultTransitionDirectionBottomToTop:
                toView.stacker_shadowEffectOffset = @(CGSizeMake(0, -8));
                break;
            default:
                break;
        }
        toView.stacker_backgroundEffectAlpha = @(0);
        self.fromTransform = fromView.layer.transform;
        switch (direction) {
            case StackerDefaultTransitionDirectionRightToLeft:
                self.toTransform = CATransform3DMakeTranslation(CGRectGetWidth(self.toViewController.view.bounds), 0, 0);
                break;
            case StackerDefaultTransitionDirectionBottomToTop:
                self.toTransform = CATransform3DMakeTranslation(0,CGRectGetHeight(self.toViewController.view.bounds), 0);
                break;
            default:
                break;
        }
        toView.layer.transform=self.toTransform;
        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            toView.stacker_backgroundEffectAlpha = @(0.5);
            toView.layer.transform=CATransform3DIdentity;
        } completion:^(BOOL finished) {
            BOOL completed = !self.interactionCancelled && finished;
            if (!completed){
                toView.stacker_backgroundEffectAlpha = nil;
                toView.stacker_shadowEffectOffset = nil;
            }
            [self complete:completed];
        }];
    }else{
        switch (direction) {
            case StackerDefaultTransitionDirectionRightToLeft:
                fromView.stacker_shadowEffectOffset = @(CGSizeMake(-8, 0));
                break;
            case StackerDefaultTransitionDirectionBottomToTop:
                fromView.stacker_shadowEffectOffset = @(CGSizeMake(0, -8));
                break;
            default:
                break;
        }
        fromView.stacker_backgroundEffectAlpha = @(0.5);
        self.fromTransform = fromView.layer.transform;
        self.toTransform = toView.layer.transform;
        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            fromView.stacker_backgroundEffectAlpha = @(0);
            switch (direction) {
                case StackerDefaultTransitionDirectionRightToLeft:
                    fromView.layer.transform=CATransform3DTranslate(fromView.layer.transform, CGRectGetWidth(toView.bounds), 0, 0);
                    break;
                case StackerDefaultTransitionDirectionBottomToTop:
                    fromView.layer.transform=CATransform3DTranslate(fromView.layer.transform, 0, CGRectGetHeight(fromView.bounds), 0);
                    break;
                default:
                    break;
            }
            toView.layer.transform=CATransform3DIdentity;
        } completion:^(BOOL finished) {
            BOOL completed = !self.interactionCancelled && finished;
            if (completed){
                fromView.stacker_backgroundEffectAlpha = nil;
                fromView.stacker_shadowEffectOffset = nil;
            }else{
                fromView.stacker_backgroundEffectAlpha = @(0.5);
                UINavigationController *navigationController = (UINavigationController*)self.fromViewController;
                navigationController.navigationBarHidden = !navigationController.navigationBarHidden;
                navigationController.navigationBarHidden = !navigationController.navigationBarHidden;
            }
            [self complete:completed];
        }];
    }
}

- (void)restoreTransition{
    self.fromViewController.view.layer.transform=self.fromTransform;
    self.toViewController.view.layer.transform=self.toTransform;
}

- (void)layoutView:(UIView*)view{
    NSParameterAssert(self.percentParallax>=0 && self.percentParallax<1);
    view.translatesAutoresizingMaskIntoConstraints = NO;
    switch (self.direction) {
        case StackerDefaultTransitionDirectionRightToLeft:
            [view.superview addConstraints:@[
                [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view.superview attribute:NSLayoutAttributeTop multiplier:1 constant:0],
                [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view.superview attribute:NSLayoutAttributeBottom multiplier:1 constant:0],
                [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:view.superview attribute:NSLayoutAttributeTrailing multiplier:1 constant:0],
                [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view.superview attribute:NSLayoutAttributeWidth multiplier:1-self.percentParallax constant:0],
            ]];
            break;
        case StackerDefaultTransitionDirectionBottomToTop:
            [view.superview addConstraints:@[
                [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:view.superview attribute:NSLayoutAttributeLeading multiplier:1 constant:0],
                [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view.superview attribute:NSLayoutAttributeBottom multiplier:1 constant:0],
                [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:view.superview attribute:NSLayoutAttributeTrailing multiplier:1 constant:0],
                [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:view.superview attribute:NSLayoutAttributeHeight multiplier:1-self.percentParallax constant:0],
            ]];
            break;
        default:
            break;
    }
}

- (void)pan:(UIPanGestureRecognizer*)gestureRecognizer{
    UIView *view = gestureRecognizer.view;
    UIView *superview=view.superview;
    CGPoint point=[gestureRecognizer locationInView:superview];
    CGPoint velocity=[gestureRecognizer velocityInView:superview];
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            self.startPoint=point;
            [self.stacker popViewController];
            [self startInteraction];
            break;
        case UIGestureRecognizerStateChanged:
            switch (self.direction) {
                case StackerDefaultTransitionDirectionRightToLeft:
                    [self updateInteraction:(point.x-self.startPoint.x)/CGRectGetWidth(view.bounds)];
                    break;
                case StackerDefaultTransitionDirectionBottomToTop:
                    [self updateInteraction:(point.y-self.startPoint.y)/CGRectGetHeight(view.bounds)];
                    break;
                default:
                    break;
            }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            switch (self.direction) {
                case StackerDefaultTransitionDirectionRightToLeft:
                    if (velocity.x>1000){
                        [self finishInteraction:velocity.x/CGRectGetWidth(view.bounds)/3.0];
                    }else if (point.x-self.startPoint.x>CGRectGetWidth(view.bounds)/5.0){
                        [self finishInteraction:0.75];
                    } else [self cancelInteraction:0.25];
                    break;
                case StackerDefaultTransitionDirectionBottomToTop:
                    if (velocity.y>1000){
                        [self finishInteraction:velocity.y/CGRectGetHeight(view.bounds)/3.0];
                    }else if (point.y-self.startPoint.y>CGRectGetHeight(view.bounds)/5.0){
                        [self finishInteraction:0.75];
                    } else [self cancelInteraction:0.25];
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    UIView *superview=gestureRecognizer.view.superview;
    CGPoint point=[gestureRecognizer locationInView:superview];
    switch (self.direction) {
        case StackerDefaultTransitionDirectionRightToLeft:
            if (point.x>self.viewController.view.frame.origin.x+self.viewController.view.frame.size.width/2.0){
                return NO;
            }
            break;
        case StackerDefaultTransitionDirectionBottomToTop:
            if (point.y>self.viewController.view.frame.origin.y+self.viewController.view.frame.size.height/2.0){
                return NO;
            }
            return NO;
            break;
        default:
            break;
    }
    
    return YES;
}

- (UIPanGestureRecognizer*)interactivePopGestureRecognizer{
    if (_interactivePopGestureRecognizer) return _interactivePopGestureRecognizer;
    _interactivePopGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    _interactivePopGestureRecognizer.delegate = self;
    return _interactivePopGestureRecognizer;
}

@end
