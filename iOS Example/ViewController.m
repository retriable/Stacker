//
//  ViewController.m
//  iOS Example
//
//  Created by retriable on 2019/4/19.
//  Copyright © 2019 retriable. All rights reserved.
//

@import Stacker;

#import <objc/message.h>

#import "ViewController.h"

@interface Model : NSObject

@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)void(^block)(void);

@end

@implementation Model : NSObject

@end

@interface Cell : UICollectionViewCell

@property (nonatomic,strong)UILabel *label;

@end

@implementation Cell

- (instancetype)initWithFrame:(CGRect)frame {
    self=[super initWithFrame:frame];
    if (!self) return nil;
    [self.contentView addSubview:self.label];
    self.label.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addConstraints:@[
        [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.label attribute:NSLayoutAttributeCenterX multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.label attribute:NSLayoutAttributeCenterY multiplier:1 constant:0],
    ]];
    return self;
}

- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes{
    UICollectionViewLayoutAttributes *attributes = [super preferredLayoutAttributesFittingAttributes:layoutAttributes];
    CGRect frame = [self.label.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 30) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.label.font,NSFontAttributeName, nil] context:nil];
    frame.size.width += 28;
    frame.size.height += 16;
    attributes.frame = frame;
    return attributes;
}

- (UILabel*)label{
    if (_label) return _label;
    _label=[[UILabel alloc]init];
    return _label;
}

@end

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,assign)UIInterfaceOrientation orientation;
@property (nonatomic,strong)NSArray *Models;
@property (nonatomic,strong)UICollectionView *collectionView;

@end

@implementation ViewController

- (void)dealloc{
    NSLog(@"%@，dealloc",self.title);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"%@，viewWillAppear：%@",self.title,@(animated));
    ((void (*)(id, SEL, UIInterfaceOrientation))(void *) objc_msgSend)([UIDevice currentDevice], NSSelectorFromString(@"setOrientation:"), UIInterfaceOrientationLandscapeRight);
    [UIViewController attemptRotationToDeviceOrientation];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"%@，viewDidAppear：%@",self.title,@(animated));
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"%@，viewWillDisappear：%@",self.title,@(animated));
    ((void (*)(id, SEL, UIInterfaceOrientation))(void *) objc_msgSend)([UIDevice currentDevice], NSSelectorFromString(@"setOrientation:"), UIInterfaceOrientationPortrait);
    [UIViewController attemptRotationToDeviceOrientation];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    NSLog(@"%@，viewDidDisappear：%@",self.title,@(animated));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.title){
        self.title=@"0";
    }
    self.navigationController.view.backgroundColor=!self.stacker_master?[UIColor colorWithWhite:0 alpha:0.5]:[UIColor whiteColor];
    __weak typeof(self) weakSelf=self;
    self.Models=@[
        ({
            Model *v=[[Model alloc]init];
            v.title=@"pop";
            v.block = ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            };
            v;
        }),
        ({
            Model *v=[[Model alloc]init];
            v.title=@"push 1";
            v.block=^{
                [weakSelf.navigationController pushViewController:({
                    ViewController *v= [[ViewController alloc]init];
                    v.title=[@(weakSelf.title.integerValue+1) description];
                    if (weakSelf.title.integerValue%2!=0){
                        StackerDefaultTransition * transition = (StackerDefaultTransition*)v.stacker_transition;
                        transition.percentParallax = 0.25;
                        transition.style = StackerTransitionStyleOverCurrentContext;
                    }
                    v;
                }) animated:YES];
            };
            v;
        }),
        ({
            Model *v=[[Model alloc]init];
            v.title=@"push 2";
            v.block=^{
                [weakSelf.navigationController pushViewControllers:@[({
                    ViewController *v= [[ViewController alloc]init];
                    v.title=[@(weakSelf.title.integerValue+1) description];
                    StackerDefaultTransition * transition = (StackerDefaultTransition*)v.stacker_transition;
                    if (weakSelf.title.integerValue%2!=0){
                        transition.percentParallax = 0.25;
                        transition.style = StackerTransitionStyleOverCurrentContext;
                    }
                    v;
                }),({
                    ViewController *v= [[ViewController alloc]init];
                    v.title=[@(weakSelf.title.integerValue+2) description];
                    StackerDefaultTransition * transition = (StackerDefaultTransition*)v.stacker_transition;
                    if (weakSelf.title.integerValue%2!=0){
                        transition.percentParallax = 0.25;
                        transition.style = StackerTransitionStyleOverCurrentContext;
                    }
                    v;
                })] animated:YES];
            };
            v;
        }),
        ({
            Model *v=[[Model alloc]init];
            v.title=@"present 1";
            v.block=^{
                [weakSelf.navigationController pushViewController:({
                    ViewController *v= [[ViewController alloc]init];
                    v.title=[@(weakSelf.title.integerValue+1) description];
                    StackerDefaultTransition * transition = (StackerDefaultTransition*)v.stacker_transition;
                    transition.direction = StackerDefaultTransitionDirectionBottomToTop;
                    if (weakSelf.title.integerValue%2!=0){
                        transition.percentParallax = 0.25;
                        transition.style = StackerTransitionStyleOverCurrentContext;
                    }
                    v;
                }) animated:YES];
            };
            v;
        }),
        ({
            Model *v=[[Model alloc]init];
            v.title=@"present 2";
            v.block=^{
                [weakSelf.navigationController pushViewControllers:@[({
                    ViewController *v= [[ViewController alloc]init];
                    v.title=[@(weakSelf.title.integerValue+1) description];
                    StackerDefaultTransition * transition = (StackerDefaultTransition*)v.stacker_transition;
                    transition.direction = StackerDefaultTransitionDirectionBottomToTop;
                    if (weakSelf.title.integerValue%2!=0){
                        transition.percentParallax = 0.25;
                        transition.style = StackerTransitionStyleOverCurrentContext;
                    }
                    v;
                }),({
                    ViewController *v= [[ViewController alloc]init];
                    v.title=[@(weakSelf.title.integerValue+2) description];
                    StackerDefaultTransition * transition = (StackerDefaultTransition*)v.stacker_transition;
                    transition.direction = StackerDefaultTransitionDirectionBottomToTop;
                    if (weakSelf.title.integerValue%2!=0){
                        transition.percentParallax = 0.25;
                        transition.style = StackerTransitionStyleOverCurrentContext;
                    }
                    v;
                })] animated:YES];
            };
            v;
        })
    ];
    UICollectionView  *collectionView=({
        UICollectionViewFlowLayout *layout=({
            UICollectionViewFlowLayout *v=[[UICollectionViewFlowLayout alloc]init];
            v.estimatedItemSize=CGSizeMake(200, 200);
            v.minimumLineSpacing = 20;
            v.minimumInteritemSpacing = 20;
            v;
        });
        UICollectionView *v=[[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        [v registerClass:Cell.class forCellWithReuseIdentifier:@"cell"];
        v.dataSource=self;
        v.delegate=self;
        v.backgroundColor=[UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];
        v;
    });
    [self.view addSubview:collectionView];
    collectionView.translatesAutoresizingMaskIntoConstraints=NO;
    [self.view addConstraints:@[
        !self.stacker_transition?[NSLayoutConstraint constraintWithItem:collectionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:88+44]:[NSLayoutConstraint constraintWithItem:collectionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:44],
         [NSLayoutConstraint constraintWithItem:collectionView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0],
         [NSLayoutConstraint constraintWithItem:collectionView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0],
         [NSLayoutConstraint constraintWithItem:collectionView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]
    ]];
    self.collectionView=collectionView;
    UIView *indicatorView=({
        UILabel *v=[[UILabel alloc]initWithFrame:CGRectMake( CGRectGetWidth(self.view.bounds)/2.0-22, 88, 44, 44)];
        v.textAlignment=NSTextAlignmentCenter;
        v.text= @"口";
        CABasicAnimation *basicAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        basicAnimation.byValue = [NSNumber numberWithFloat:M_PI*2];
        basicAnimation.speed=3;
        basicAnimation.duration = 2;
        basicAnimation.repeatCount=HUGE_VALF;
        basicAnimation.removedOnCompletion = NO;
        [v.layer addAnimation:basicAnimation forKey:@"KCBasicAnimation_Rotation"];
        v;
    });
    [self.view addSubview:indicatorView];
    // Do any additional setup after loading the view.
}

#pragma mark <UICollectionViewDataSource>


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.Models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    Cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor=[UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];
    cell.label.text=[self.Models[indexPath.item] title];
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    Model *model=self.Models[indexPath.item];
    model.block();
}

- (BOOL)prefersStatusBarHidden{
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return self.orientation;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return 1<<self.orientation;
    //    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (UIInterfaceOrientation)orientation{
    if (_orientation==UIInterfaceOrientationUnknown) _orientation=UIInterfaceOrientationPortrait;
    return _orientation;
}
@end
