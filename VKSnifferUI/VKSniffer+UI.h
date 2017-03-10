//
//  VKSniffer+UI.h
//  VKSnifferDemo
//
//  Created by Awhisper on 2017/3/10.
//  Copyright © 2017年 baidu. All rights reserved.
//

#import "VKSniffer.h"

@class VKSnifferWindow;

@interface VKSniffer (UI)

@property(nonatomic,strong) VKSnifferWindow *snifferWindow;

+ (void)showSnifferView;

+ (void)hideSnifferView;

@end
