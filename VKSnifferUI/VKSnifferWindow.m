//
//  VKSnifferWindow.m
//  VKSnifferDemo
//
//  Created by Awhisper on 2017/3/10.
//  Copyright © 2017年 baidu. All rights reserved.
//

#import "VKSnifferWindow.h"
#import "VKSnifferViewController.h"

#define VKSnifferViewAlpha 0.8f

@interface VKSnifferWindow ()

@property (nonatomic,strong) VKSnifferViewController * snifferVC;

@property (nonatomic,weak) UIWindow *preWindow;

@end

@implementation VKSnifferWindow

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup{
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = true;
    self.windowLevel = UIWindowLevelStatusBar + 1;
    [self setupRootViewController];
}

-(void)setupRootViewController{
    self.snifferVC = [[VKSnifferViewController alloc]init];
    self.rootViewController = self.snifferVC;
    self.rootViewController.view.alpha = 0;
}


+(VKSnifferWindow *)showSnifferView
{
    if (![[UIApplication sharedApplication].keyWindow isKindOfClass:[VKSnifferWindow class]]) {
        VKSnifferWindow *snifferWindow = [[VKSnifferWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [snifferWindow showSnifferView];
        return snifferWindow;
    }
    return nil;
}

-(void)showSnifferView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.rootViewController.view.frame = [UIScreen mainScreen].bounds;
        self.rootViewController.view.alpha = VKSnifferViewAlpha;
        self.frame = [UIScreen mainScreen].bounds;
    } completion:^(BOOL finished) {
        self.preWindow = [UIApplication sharedApplication].keyWindow;
        [self makeKeyAndVisible];
    }];
}

+(void)hideSnifferView{

}


-(void)hideSnifferView{
//    [UIView animateWithDuration:0.3 animations:^{
//        self.rootViewController.view.frame = [UIScreen mainScreen].bounds;
//        self.rootViewController.view.alpha = 0.0f;
//        self.frame = [UIScreen mainScreen].bounds;
//    } completion:^(BOOL finished) {
        [self.preWindow makeKeyAndVisible];
        self.rootViewController = nil;
        self.snifferVC = nil;
//    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
