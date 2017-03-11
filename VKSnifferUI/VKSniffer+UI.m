//
//  VKSniffer+UI.m
//  VKSnifferDemo
//
//  Created by Awhisper on 2017/3/10.
//  Copyright © 2017年 baidu. All rights reserved.
//

#import "VKSniffer+UI.h"
#import "VKSnifferWindow.h"
#import <objc/runtime.h>

@implementation VKSniffer (UI)

-(VKSnifferWindow *)snifferWindow{
    return objc_getAssociatedObject(self, @selector(snifferWindow));
}

-(void)setSnifferWindow:(VKSnifferWindow *)snifferWindow{
    objc_setAssociatedObject(self, @selector(snifferWindow), snifferWindow, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSNumber *)isReverse{
    return objc_getAssociatedObject(self, @selector(isReverse));
}

-(void)setIsReverse:(NSNumber *)isReverse{
    objc_setAssociatedObject(self, @selector(isReverse), isReverse, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


+(void)showSnifferView{
    [VKSniffer singleton].snifferWindow = [VKSnifferWindow showSnifferView];
}

+(void)hideSnifferView
{
    [VKSnifferWindow hideSnifferView];
    [VKSniffer singleton].snifferWindow = nil;
}

@end
