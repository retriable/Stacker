//
//  StackerPushTransition.m
//  Stacker
//
//  Created by ouyanghua on 2019/10/16.
//  Copyright © 2019 ouyanghua. All rights reserved.
//

#import "Stacker.h"
#import "StackerPresentTransition.h"

@interface StackerPresentTransition()

@property (nonatomic,strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic,assign) CGPoint                startPoint;
@property (nonatomic,assign) CATransform3D          fromTransform;
@property (nonatomic,assign) CATransform3D          toTransform;

@end

@implementation StackerPresentTransition

- (void)startTransition:(CFTimeInterval)duration{
    void(^enableShadow)(UIView *v)=^(UIView *v){
        v.layer.shadowPath =[UIBezierPath bezierPathWithRect:v.bounds].CGPath;
        v.layer.shadowColor=[UIColor blackColor].CGColor;
        v.layer.shadowOffset=CGSizeMake(0, -8);
        v.layer.shadowRadius=8;
        v.layer.shadowOpacity=0.5;
    };
    void(^disableShadow)(UIView *v)=^(UIView *v){
        v.layer.shadowOpacity=0;
    };
    __block UIView *view = nil;
     void(^cover)(UIView *v)=^(UIView *v){
         view = [[UIView alloc]init];
         view.backgroundColor=[UIColor blackColor];
         view.frame=v.bounds;
         [v addSubview:view];
     };
     void(^uncover)(UIView *v)=^(UIView *v){
         [view removeFromSuperview];
     };
    BOOL push = self.viewController==self.toViewController;
    UIView *fromView=self.fromViewController.view;
    UIView *toView=self.toViewController.view;
    if (push){
        if (self.toViewController.view!=self.panGestureRecognizer.view){
            [self.panGestureRecognizer.view removeGestureRecognizer:self.panGestureRecognizer];
            [self.toViewController.view addGestureRecognizer:self.panGestureRecognizer];
        }
        enableShadow(toView);
        cover(fromView);
        view.alpha=0;
        self.fromTransform = fromView.layer.transform;
        self.toTransform = CATransform3DTranslate(fromView.layer.transform,0, CGRectGetHeight(self.stacker.view.bounds), 0);
        toView.layer.transform=self.toTransform;
        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            view.alpha=0.5;
            toView.layer.transform=CATransform3DIdentity;
            fromView.layer.transform=CATransform3DScale(fromView.layer.transform, 0.985, 0.985, 1);
        } completion:^(BOOL finished) {
            uncover(fromView);
            disableShadow(toView);
            [self complete:!self.interactionCancelled && finished];
        }];
    }else{
        enableShadow(fromView);
        cover(toView);
        view.alpha=0.5;
        self.fromTransform = fromView.layer.transform;
        self.toTransform = toView.layer.transform;
        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            view.alpha=0;
            fromView.layer.transform=CATransform3DTranslate(fromView.layer.transform, 0, CGRectGetHeight(self.stacker.view.bounds), 0);
            toView.layer.transform=CATransform3DIdentity;
        } completion:^(BOOL finished) {
            uncover(toView);
            disableShadow(fromView);
            [self complete:!self.interactionCancelled && finished];
        }];
    }
}

- (void)restoreTransition{
    self.fromViewController.view.layer.transform=self.fromTransform;
    self.toViewController.view.layer.transform=self.toTransform;
}

- (void)pan:(UIPanGestureRecognizer*)gestureRecognizer{
    UIView *superview=gestureRecognizer.view.superview;
    CGPoint point=[gestureRecognizer locationInView:superview];
    CGPoint velocity=[gestureRecognizer velocityInView:superview];
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            if (point.y<CGRectGetHeight(superview.bounds)/2.0){
                self.startPoint=point;
                [self.stacker popViewController];
                [self startInteraction:self.duration];
            }
            break;
        case UIGestureRecognizerStateChanged:
            [self updateInteraction:(point.y-self.startPoint.y)/CGRectGetHeight(superview.bounds)];
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            if (velocity.y>1000){
                [self finishInteraction:velocity.y/CGRectGetHeight(superview.bounds)/3.0];
            }else if (point.y-self.startPoint.y>CGRectGetHeight(superview.bounds)/5.0){
                 [self finishInteraction:0.75];
            } else [self cancelInteraction:0.25];
            break;
        default:
            break;
    }
}

- (UIPanGestureRecognizer*)panGestureRecognizer{
    if (_panGestureRecognizer) return _panGestureRecognizer;
    _panGestureRecognizer=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    return _panGestureRecognizer;
}

@end
