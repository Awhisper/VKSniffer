//
//  VKSnifferResult+UI.m
//  VKSnifferDemo
//
//  Created by Awhisper on 2017/3/11.
//  Copyright © 2017年 baidu. All rights reserved.
//

#import "VKSnifferResult+UI.h"
#import <objc/runtime.h>
@implementation VKSnifferResult (UI)

-(NSNumber *)isShowDetail
{
    return objc_getAssociatedObject(self, @selector(isShowDetail));
}

-(void)setIsShowDetail:(NSNumber *)isShowDetail{
    objc_setAssociatedObject(self, @selector(isShowDetail), isShowDetail, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
