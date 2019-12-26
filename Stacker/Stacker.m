//
//  Stacker.m
//  Stacker
//
//  Created by ouyanghua on 2019/10/16.
//  Copyright © 2019 ouyanghua. All rights reserved.
//

#import "NSObject+StackerPrivate.h"
#import "Stacker.h"
#import "StackerTransition+StackerPrivate.h"
#import "UINavigationController+StackerPrivate.h"
#import "UIViewController+StackerPrivate.h"

@interface Stacker ()
{
    NSArray<__kindof UIViewController*> *_viewControllers;
}
@property (nonatomic,assign) BOOL             busy;

@property (nonatomic,assign) Class            navigationControllerClass;
@property (nonatomic,weak  ) UIViewController *masterViewController;

@property (nonatomic,strong) NSMutableArray<__kindof UINavigationController*> *navigationControllers;

//percent driven interactive transition
@property (nonatomic,assign) CFTimeInterval animationDuration;
@property (nonatomic,assign) CFTimeInterval animationPausedTimeOffset;
@property (nonatomic,assign) CGFloat        animationCompletionSpeed;
@property (nonatomic,strong) CADisplayLink  *displayLink;
@property (nonatomic,assign) BOOL           interactionCancelled;
@property (nonatomic,copy  ) void(^interactionDidCancel)(void);

@end

@implementation Stacker

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (instancetype)initWithNavigationControllerClass:(nullable Class)navigationControllerClass{
    self=[self init];
    if (!self) return nil;
    self.navigationControllerClass=navigationControllerClass;
    return self;
}

- (instancetype)initWithRootViewController:(__kindof UIViewController *)rootViewController{
    self=[self init];
    if (!self) return nil;
    [self pushViewController:rootViewController animated:NO];
    return self;
}

- (instancetype)initWithViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers{
    self=[self init];
    if (!self) return nil;
    [self pushViewControllers:viewControllers animated:NO];
    return self;
}

- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers{
    [self setViewControllers:viewControllers animated:NO];
}

- (void)pushViewController:(__kindof UIViewController *)viewController{
    [self pushViewController:viewController animated:YES];
}

- (void)pushViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers{
    [self pushViewControllers:viewControllers animated:YES];
}

- (nullable __kindof UIViewController *)popViewController{
    return [self popViewControllerAnimated:YES];
}

- (nullable NSArray<__kindof UIViewController *> *)popToRootViewController{
    return [self popToRootViewControllerAnimated:YES];
}

- (nullable NSArray<__kindof UIViewController *> *)popToViewController:(UIViewController *)viewController{
    return [self popToViewController:viewController animated:YES];
}

- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers animated:(BOOL)animated{
    [self setViewControllers:viewControllers animated:animated completion:nil];
}

- (void)pushViewController:(__kindof UIViewController *)viewController animated:(BOOL)animated{
    [self pushViewController:viewController animated:animated completion:nil];
}

- (void)pushViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers animated:(BOOL)animated{
    [self pushViewControllers:viewControllers animated:animated completion:nil];
}

- (nullable __kindof UIViewController *)popViewControllerAnimated:(BOOL)animated{
    return [self popViewControllerAnimated:animated completion:nil];
}

- (nullable NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated{
    return [self popToRootViewControllerAnimated:animated completion:nil];
}

- (nullable NSArray<__kindof UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated{
    return [self popToViewController:viewController animated:animated completion:nil];
}

- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers animated:(BOOL)animated completion:(void(^_Nullable)(BOOL finished))completion{
    if (self.busy) {
        if (completion) completion(NO);
        return;
    }
    self.busy=YES;
    if (viewControllers.count==0){
        self.busy=NO;
        if (completion) completion(NO);
        return;
    }
    __weak typeof(self) weakSelf=self;
    [self _pushViewControllers:viewControllers increasing:NO animated:animated completion:^(BOOL finished){
        weakSelf.busy=NO;
        if (completion) completion(finished);
    }];
}

- (void)pushViewController:(__kindof UIViewController *)viewController animated:(BOOL)animated completion:(void(^_Nullable)(BOOL finished))completion{
    if (self.busy) {
        if (completion) completion(NO);
        return;
    }
    self.busy=YES;
    __weak typeof(self) weakSelf=self;
    [self _pushViewControllers:@[viewController] increasing:YES animated:animated completion:^(BOOL finished){
        weakSelf.busy=NO;
        if (completion) completion(finished);
    }];
}

- (void)pushViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers animated:(BOOL)animated completion:(void(^_Nullable)(BOOL finished))completion{
    if (self.busy) {
        if (completion) completion(NO);
        return;
    }
    self.busy=YES;
    if (viewControllers.count==0){
        self.busy=NO;
        if (completion) completion(NO);
        return;
    }
    __weak typeof(self) weakSelf=self;
    [self _pushViewControllers:viewControllers increasing:YES animated:animated completion:^(BOOL finished){
        weakSelf.busy=NO;
        if (completion) completion(finished);
    }];
}

- (nullable __kindof UIViewController *)popViewControllerAnimated:(BOOL)animated completion:(void(^_Nullable)(BOOL finished))completion{
    if (self.busy) {
        if (completion) completion(NO);
        return nil;
    }
    self.busy=YES;
    if (self.viewControllers.count<2){
        self.busy=NO;
        if (completion) completion(NO);
        return nil;
    }
    __weak typeof(self) weakSelf=self;
    return [self _popToViewController:self.viewControllers[self.viewControllers.count-2] animated:animated completion:^(BOOL finished){
        weakSelf.busy=NO;
        if (completion) completion(finished);
    }].lastObject;
}

- (nullable NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated completion:(void(^_Nullable)(BOOL finished))completion{
    if (self.busy) {
        if (completion) completion(NO);
        return nil;
    }
    self.busy=YES;
    if (self.viewControllers.count<2){
        self.busy=NO;
        if (completion) completion(NO);
        return nil;
    }
    __weak typeof(self) weakSelf=self;
    return [self _popToViewController:self.viewControllers.firstObject animated:animated completion:^(BOOL finished){
        weakSelf.busy=NO;
        if (completion) completion(finished);
    }];
}

- (nullable NSArray<__kindof UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void(^_Nullable)(BOOL finished))completion{
    if (self.busy) {
        if (completion) completion(NO);
        return nil;
    }
    self.busy=YES;
    NSInteger index=[self.viewControllers indexOfObject:viewController];
    if (index==NSNotFound){
        self.busy=NO;
        if (completion) completion(NO);
        return nil;
    }
    if (index==self.viewControllers.count-1){
        self.busy=NO;
        if (completion) completion(NO);
        return nil;
    }
    __weak typeof(self) weakSelf=self;
    return [self _popToViewController:viewController animated:animated completion:^(BOOL finished){
        weakSelf.busy=NO;
        if (completion) completion(finished);
    }];
}

- (void)_pushViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers increasing:(BOOL)increasing animated:(BOOL)animated completion:(void(^_Nullable)(BOOL finished))completion{
    self.interactionCancelled=NO;
    __weak typeof(self) weakSelf=self;
    dispatch_group_t group = animated?dispatch_group_create():NULL;
    NSMutableArray <void(^)(void)> *willCancelBlocks=[NSMutableArray array];
    NSMutableArray <void(^)(void)> *didCancelBlocks=[NSMutableArray array];
    NSMutableArray <void(^)(void)> *didFinishBlocks=[NSMutableArray array];
    NSMutableArray<__kindof UIViewController*> *navigationControllers=({
        NSMutableArray *v=[NSMutableArray arrayWithCapacity:self.navigationControllers.count+viewControllers.count];
        [v addObjectsFromArray:self.navigationControllers];
        v;
    });
    NSArray *pushingNavigationControllers=({
        NSMutableArray *v=[NSMutableArray arrayWithCapacity:viewControllers.count];
        for (NSInteger i=0,count=viewControllers.count;i<count;i++){
            BOOL backItemVisable = !increasing?(i!=0):i+navigationControllers.count>0;
            [v addObject:[self createNavigationControllerForViewController:viewControllers[i] backItemVisable:backItemVisable]];
        }
        v;
    });
    [navigationControllers addObjectsFromArray:pushingNavigationControllers];
    NSInteger location=self.navigationControllers.count;
    BOOL visableFlags[navigationControllers.count];
    UIViewController *newMasterViewController=nil;
    BOOL didGetMaster=NO;
    for (NSInteger newCount = navigationControllers.count-1,i=newCount;i>=0;i--){
        if (i==newCount) {
            visableFlags[i]=YES;
        }else{
            UIViewController *nextViewController=navigationControllers[i+1];
            if (i>=location) {
                visableFlags[i]=visableFlags[i+1]?nextViewController.stacker_style==StackerTransitionStyleOverCurrentContext:NO;
            }else {
                visableFlags[i]=increasing?(visableFlags[i+1]?nextViewController.stacker_style==StackerTransitionStyleOverCurrentContext:NO):NO;
            }
        }
        if (!visableFlags[i]||didGetMaster) continue;
        newMasterViewController = [navigationControllers[i] topViewController];
        if (newMasterViewController.stacker_master) didGetMaster=YES;
    }
    {
        __weak UIViewController *oldMasterViewController=self.masterViewController;
        self.masterViewController=newMasterViewController;
        [willCancelBlocks addObject:^{
            weakSelf.masterViewController=oldMasterViewController;
        }];
    }
    void (^willCancelBlock)(void)=^{
        for (NSInteger i=willCancelBlocks.count-1;i>=0;i--){
            willCancelBlocks[i]();
        }
    };
    NSArray *oldViewControllers = [self.viewControllers copy];
    NSArray *oldNavigationControllers = [self.navigationControllers copy];
    void (^didCancelBlock)(void)=^{
        weakSelf.interactionDidCancel = nil;
        for (NSInteger i=0,count=didCancelBlocks.count;i<count;i++){
            didCancelBlocks[i]();
        }
        if (!increasing){
            [(NSMutableArray*)weakSelf.viewControllers removeAllObjects];
            [weakSelf.navigationControllers removeAllObjects];
            [(NSMutableArray*)weakSelf.viewControllers addObjectsFromArray:oldViewControllers];
            [weakSelf.navigationControllers addObjectsFromArray:oldNavigationControllers];
            return;
        }
        NSRange range = NSMakeRange(weakSelf.viewControllers.count-1-viewControllers.count, viewControllers.count);
        [(NSMutableArray*)weakSelf.viewControllers removeObjectsInRange:range];
        [weakSelf.navigationControllers removeObjectsInRange:range];
        if (completion) completion(NO);
    };
    self.interactionDidCancel = didCancelBlock;
    void (^didFinishBlock)(void)=^{
        weakSelf.interactionDidCancel = nil;
        for (NSInteger i=didFinishBlocks.count-1;i>=0;i--){
            didFinishBlocks[i]();
        }
        if (completion) completion(YES);
    };
    BOOL appeared=self.view.superview?YES:NO;
    for (NSInteger i=0,count=navigationControllers.count;i<count;i++){
        __weak UINavigationController *navigationController=navigationControllers[i];
        if (visableFlags[i]) {
            if (!navigationController.parentViewController){
                navigationController.view.translatesAutoresizingMaskIntoConstraints=NO;
                if(appeared) [navigationController beginAppearanceTransition:YES animated:animated];
                [self stacker_addChildViewController:navigationController];
                [self.view addSubview:navigationController.view];
                [self.view addConstraints:@[
                    [NSLayoutConstraint constraintWithItem:navigationController.view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0],
                    [NSLayoutConstraint constraintWithItem:navigationController.view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0],
                    [NSLayoutConstraint constraintWithItem:navigationController.view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1 constant:0],
                    [NSLayoutConstraint constraintWithItem:navigationController.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:1 constant:0]]
                 ];
                [willCancelBlocks addObject:^{
                    if(appeared) [navigationController beginAppearanceTransition:NO animated:animated];
                }];
                [didCancelBlocks addObject:^{
                    [navigationController didMoveToParentViewController:weakSelf];
                    [navigationController willMoveToParentViewController:nil];
                    [navigationController.view removeFromSuperview];
                    [navigationController removeFromParentViewController];
                    if(appeared) [navigationController endAppearanceTransition];
                }];
                [didFinishBlocks addObject:^{
                    [navigationController didMoveToParentViewController:weakSelf];
                    if(appeared) [navigationController endAppearanceTransition];
                }];
            }
        }else{
            if (navigationController.parentViewController){
                if(appeared) [navigationController beginAppearanceTransition:NO animated:animated];
                [navigationController willMoveToParentViewController:nil];
                [willCancelBlocks addObject:^{
                    if(appeared) [navigationController beginAppearanceTransition:YES animated:animated];
                }];
                [didCancelBlocks addObject:^{
                    if(appeared) [navigationController endAppearanceTransition];
                    [navigationController removeFromParentViewController];
                    [weakSelf stacker_addChildViewController:navigationController];
                    [navigationController didMoveToParentViewController:weakSelf];
                }];
                [didFinishBlocks addObject:^{
                    if(appeared) [navigationController endAppearanceTransition];
                    [navigationController.view removeFromSuperview];
                    [navigationController removeFromParentViewController];
                }];
            }
        }
        if (animated){
            if (i>=location){
                StackerTransition *transition=navigationController.stacker_transition;
                transition.stacker=self;
                transition.fromViewController=i>0?navigationControllers[i-1]:nil;
                transition.toViewController=navigationController;
                transition.viewController=navigationController;
                transition.interactionCancelledBlock = ^{
                    return self.interactionCancelled;
                };
                transition.startInteractionBlock = ^(CFTimeInterval duration) {
                    [weakSelf startInteractionWithDuration:duration];
                };
                transition.updateInteractionBlock = ^(CGFloat progress) {
                    [weakSelf updateInteractionProgress:progress];
                };
                transition.cancelInteractionBlock = ^(CGFloat speed) {
                    if (self.interactionCancelled) return;
                    self.interactionCancelled=YES;
                    willCancelBlock();
                    [weakSelf cancelInteractionWithSpeed:speed];
                };
                transition.finishInteractionBlock = ^(CGFloat speed) {
                    [weakSelf finishInteractionWithSpeed:speed];
                };
                transition.completeBlock = ^(BOOL finished) {
                    dispatch_group_leave(group);
                };
                dispatch_group_enter(group);
                [transition startTransition:navigationControllers.lastObject.stacker_transition.duration];
            }
        }
    }
    if (!increasing){
        [(NSMutableArray*)self.viewControllers removeAllObjects];
        [self.navigationControllers removeAllObjects];
    }
    [(NSMutableArray*)self.viewControllers addObjectsFromArray:viewControllers];
    [self.navigationControllers addObjectsFromArray:pushingNavigationControllers];
    if (animated){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
            dispatch_sync(dispatch_get_main_queue(), ^{
                if (weakSelf.interactionCancelled) return;
                didFinishBlock();
            });
        });
    }else{
        didFinishBlock();
    }
}

- (nullable NSArray<__kindof UIViewController *> *)_popToViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void(^_Nullable)(BOOL finished))completion{
    self.interactionCancelled=NO;
    __weak typeof(self) weakSelf=self;
    dispatch_group_t group = animated?dispatch_group_create():NULL;
    NSMutableArray <void(^)(void)> *willCancelBlocks=[NSMutableArray array];
    NSMutableArray <void(^)(void)> *didCancelBlocks=[NSMutableArray array];
    NSMutableArray <void(^)(void)> *didFinishBlocks=[NSMutableArray array];
    NSArray<UINavigationController*> *navigationControllers=[self.navigationControllers copy];
    BOOL visableFlags[navigationControllers.count];
    BOOL appeared=self.view.superview?YES:NO;
    NSInteger location=[self.viewControllers indexOfObject:viewController];
    NSRange range = NSMakeRange(location+1, self.viewControllers.count-location-1);
    NSArray *popedViewControllers=[self.viewControllers subarrayWithRange:range];
    NSArray *popedNavigationControllers=[self.navigationControllers subarrayWithRange:range];
    void(^willCancelBlock)(void)=^{
        for (NSInteger i = willCancelBlocks.count-1;i>=0;i--){
            willCancelBlocks[i]();
        }
    };
    void(^didCancelBlock)(void)=^{
        weakSelf.interactionDidCancel = nil;
        [(NSMutableArray*)weakSelf.viewControllers addObjectsFromArray:popedViewControllers];
        [weakSelf.navigationControllers addObjectsFromArray:popedNavigationControllers];
        for (NSInteger i = 0,count = didCancelBlocks.count;i<count;i++){
            didCancelBlocks[i]();
        }
        if (completion) completion(NO);
    };
    self.interactionDidCancel = didCancelBlock;
    void(^didFinishBlock)(void)=^{
        weakSelf.interactionDidCancel = nil;
        for (NSInteger i = didFinishBlocks.count-1;i>=0;i--){
            didFinishBlocks[i]();
        }
        if (completion) completion(YES);
    };
    UIViewController *newMasterViewController=nil;
    BOOL didGetMaster=NO;
    for (NSInteger i=navigationControllers.count-1;i>=0;i--){
        visableFlags[i]=NO;
        if (i==location) visableFlags[i]=YES;
        else if (i>location) visableFlags[i]=NO;
        else{
            UIViewController *nextViewController=self.navigationControllers[i+1];
            visableFlags[i]=visableFlags[i+1]?nextViewController.stacker_style==StackerTransitionStyleOverCurrentContext:NO;
        }
        if (!visableFlags[i]||didGetMaster) continue;
        newMasterViewController=[navigationControllers[i] topViewController];
        if (newMasterViewController.stacker_master) didGetMaster=YES;
    }
    {
        __weak UIViewController *oldMasterViewController=self.masterViewController;
        self.masterViewController=newMasterViewController;
        [willCancelBlocks addObject:^{
            weakSelf.masterViewController=oldMasterViewController;
        }];
    }
    for (NSInteger i=navigationControllers.count-1;i>=0;i--){
        __weak UINavigationController *navigationController=navigationControllers[i];
        if (visableFlags[i]) {
            if (!navigationController.parentViewController){
                navigationController.view.translatesAutoresizingMaskIntoConstraints=NO;
                [self stacker_addChildViewController:navigationController];
                if(appeared) [navigationController beginAppearanceTransition:YES animated:animated];
                [self.view insertSubview:navigationController.view atIndex:0];
                [self.view addConstraints:@[
                    [NSLayoutConstraint constraintWithItem:navigationController.view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0],
                    [NSLayoutConstraint constraintWithItem:navigationController.view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0],
                    [NSLayoutConstraint constraintWithItem:navigationController.view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1 constant:0],
                    [NSLayoutConstraint constraintWithItem:navigationController.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:1 constant:0]]
                 ];
                [willCancelBlocks addObject:^{
                    if(appeared) [navigationController beginAppearanceTransition:NO animated:animated];
                }];
                [didCancelBlocks addObject:^{
                    [navigationController didMoveToParentViewController:weakSelf];
                    [navigationController willMoveToParentViewController:nil];
                    [navigationController.view removeFromSuperview];
                    [navigationController removeFromParentViewController];
                    if(appeared) [navigationController endAppearanceTransition];
                }];
                [didFinishBlocks addObject:^{
                    [navigationController didMoveToParentViewController:weakSelf];
                    if(appeared) [navigationController endAppearanceTransition];
                }];
            }
        }else{
            if (navigationController.parentViewController){
                [navigationController beginAppearanceTransition:NO animated:animated];
                [navigationController willMoveToParentViewController:nil];
                [willCancelBlocks addObject:^{
                    if(appeared) [navigationController beginAppearanceTransition:YES animated:animated];
                }];
                [didCancelBlocks addObject:^{
                    [navigationController removeFromParentViewController];
                    [weakSelf stacker_addChildViewController:navigationController];
                    [navigationController didMoveToParentViewController:weakSelf];
                    if(appeared) [navigationController endAppearanceTransition];
                }];
                [didFinishBlocks addObject:^{
                    [navigationController.view removeFromSuperview];
                    [navigationController removeFromParentViewController];
                    if(appeared) [navigationController endAppearanceTransition];
                }];
            }
        }
        if (animated){
            if (i>location){
                __weak StackerTransition *transition=navigationController.stacker_transition;
                transition.stacker=self;
                transition.fromViewController=navigationController;
                transition.toViewController=i>0?navigationControllers[i-1]:nil;
                transition.viewController=navigationController;
                transition.interactionCancelledBlock = ^{
                    return weakSelf.interactionCancelled;
                };
                transition.startInteractionBlock = ^(CFTimeInterval duration) {
                    [weakSelf startInteractionWithDuration:duration];
                };
                transition.updateInteractionBlock = ^(CGFloat progress) {
                    [weakSelf updateInteractionProgress:progress];
                };
                transition.cancelInteractionBlock = ^(CGFloat speed) {
                    if (weakSelf.interactionCancelled) return;
                    weakSelf.interactionCancelled=YES;
                    willCancelBlock();
                    [weakSelf cancelInteractionWithSpeed:speed];
                };
                transition.finishInteractionBlock = ^(CGFloat speed) {
                    [weakSelf finishInteractionWithSpeed:speed];
                };
                transition.completeBlock = ^(BOOL finished) {
                    dispatch_group_leave(group);
                };
                [didCancelBlocks addObject:^{
                    [transition restoreTransition];
                }];
                dispatch_group_enter(group);
                [transition startTransition:navigationControllers.lastObject.stacker_transition.duration];
            }
        }
    }
    NSIndexSet *set=[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(location+1, self.viewControllers.count-location-1)];
    [(NSMutableArray*)self.viewControllers removeObjectsAtIndexes:set];
    [self.navigationControllers removeObjectsAtIndexes:set];
    if (animated){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
            dispatch_sync(dispatch_get_main_queue(), ^{
                if (self.interactionCancelled) return;
                didFinishBlock();
            });
        });
    }else{
        didFinishBlock();
    }
    return popedViewControllers;
}

- (void)startInteractionWithDuration:(CFTimeInterval)duration{
    if (self.displayLink) return;
    self.animationDuration=duration;
    CALayer *layer = self.view.layer;
    layer.speed = 0.0;
    layer.timeOffset = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    self.animationPausedTimeOffset = layer.timeOffset;
}

- (void)updateInteractionProgress:(CGFloat)progress{
    progress=fmax(fmin(progress, 1), 0);
    CALayer *layer = self.view.layer;
    layer.timeOffset = self.animationPausedTimeOffset + self.animationDuration * progress;
}


- (void)finishInteractionWithSpeed:(CGFloat)speed{
    if (self.displayLink) return;
    self.animationCompletionSpeed=speed;
    self.displayLink=[CADisplayLink displayLinkWithTarget:self selector:@selector(finishingRender)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)cancelInteractionWithSpeed:(CGFloat)speed{
    if (self.displayLink) return;
    NSParameterAssert(!self.displayLink);
    self.animationCompletionSpeed=speed;
    self.displayLink=[CADisplayLink displayLinkWithTarget:self selector:@selector(cancellingRender)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)recoverLayer{
    if (!self.displayLink) return;
    [self.displayLink invalidate];
    self.displayLink=nil;
    CALayer *layer = self.view.layer;
    layer.beginTime = 0;
    layer.speed = 1.0;
    layer.beginTime = CACurrentMediaTime()-self.animationDuration;
    layer.timeOffset = CACurrentMediaTime();
    if (self.interactionCancelled) {
        if (self.interactionDidCancel){
            self.interactionDidCancel();
        }
    }
    layer.beginTime=0;
    layer.timeOffset=0;
}

- (void)finishingRender{
    CALayer *layer = self.view.layer;
    CFTimeInterval duration  = self.displayLink.duration;
    CFTimeInterval timeOffset = layer.timeOffset+duration*self.animationCompletionSpeed;
    CFTimeInterval targetTimeOffset = self.animationPausedTimeOffset+self.animationDuration;
    if (timeOffset < targetTimeOffset){
        layer.timeOffset=timeOffset;
        return;
    }
    layer.timeOffset=targetTimeOffset;
    [self recoverLayer];
}

- (void)cancellingRender{
    CALayer *layer = self.view.layer;
    CFTimeInterval duration  = self.displayLink.duration;
    CFTimeInterval timeOffset=layer.timeOffset-duration*self.animationCompletionSpeed;
    if (timeOffset > self.animationPausedTimeOffset){
        layer.timeOffset=timeOffset;
        return;
    }
    layer.timeOffset=self.animationPausedTimeOffset;
    [self recoverLayer];
}


#pragma mark --
#pragma mark -- create new navigationController from navigationController class

- (__kindof UINavigationController*)createNavigationControllerForViewController:(UIViewController*)viewController backItemVisable:(BOOL)backItemVisable{
    UINavigationController *navigationController = [[self.navigationControllerClass alloc]init];
    [navigationController stacker_original_setViewControllers:backItemVisable?@[[[UIViewController alloc]init],viewController]:@[viewController] animated:NO];
    navigationController.stacker_stacker=self;
    return navigationController;
}

#pragma mark --
#pragma mark -- getter

- (Class)navigationControllerClass{
    if (_navigationControllerClass) return _navigationControllerClass;
    return UINavigationController.class;
}

- (NSArray<__kindof UIViewController*>*)viewControllers{
    if(_viewControllers) return _viewControllers;
    _viewControllers=[NSMutableArray array];
    return _viewControllers;
}

#pragma mark --
#pragma mark -- override

- (BOOL)shouldAutomaticallyForwardAppearanceMethods{
    return NO;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    for (UIViewController *viewController in self.childViewControllers){
        [viewController beginAppearanceTransition:YES animated:animated];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    for (UIViewController *viewController in self.childViewControllers){
        [viewController endAppearanceTransition];
    }
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    for (UIViewController *viewController in self.childViewControllers){
        [viewController beginAppearanceTransition:NO animated:animated];
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    for (UIViewController *viewController in self.childViewControllers){
        [viewController endAppearanceTransition];
    }
    [super viewDidDisappear:animated];
}


- (void)stacker_addChildViewController:(UIViewController *)childController{
    NSAssert(0, @"Do not call this method directly");
    return;
}

- (void)setMasterViewController:(UIViewController *)masterViewController{
    if (_masterViewController==masterViewController) return;
    _masterViewController=masterViewController;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (BOOL)shouldAutorotate{
    if (!self.masterViewController) return [super shouldAutorotate];
    return [self.masterViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    if (!self.masterViewController) return [super supportedInterfaceOrientations];
    return [self.masterViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    if (!self.masterViewController) return [super preferredInterfaceOrientationForPresentation];
    return [self.masterViewController preferredInterfaceOrientationForPresentation];
}

- (BOOL)prefersStatusBarHidden{
    if (!self.masterViewController) return [super prefersStatusBarHidden];
    return [self.masterViewController prefersStatusBarHidden];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    if (!self.masterViewController) return [super preferredStatusBarStyle];
    return [self.masterViewController preferredStatusBarStyle];
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation{
    if (!self.masterViewController) return [super preferredStatusBarUpdateAnimation];
    return [self.masterViewController preferredStatusBarUpdateAnimation];
}

- (UIViewController*)topViewController{
    return self.viewControllers.lastObject;
}

- (NSMutableArray*)navigationControllers{
    if (_navigationControllers) return _navigationControllers;
    _navigationControllers=[NSMutableArray array];
    return _navigationControllers;
}

+ (void)load{
    [self stacker_swizzleinstanceWithOrignalMethod:@selector(addChildViewController:) alteredMethod:@selector(stacker_addChildViewController:)];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

