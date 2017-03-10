//
//  VKSniffer.m
//  VKSnifferDemo
//
//  Created by Awhisper on 2017/3/6.
//  Copyright © 2017年 baidu. All rights reserved.
//

#import "VKSniffer.h"
#import "VKSnifferProtocol.h"
#import "VKSnifferWindow.h"

#define VKMAXSNIFFERPRECORD 100

@implementation VKSnifferRequestItem


@end

@implementation VKSnifferResponseItem


@end

@implementation VKSnifferErrorItem


@end

@implementation VKSnifferResult


@end


@interface VKSniffer ()

@property (nonatomic,strong) VKSnifferHandler Snifferhandler;

@property(atomic,strong) NSMutableArray<VKSnifferRequestItem *> * netRequestArray;

@end

@implementation VKSniffer

#pragma mark singleton

- (instancetype)sharedInstance
{
    return [[self class] singleton];
}

static id __singleton__;

+ (instancetype)singleton
{
    static dispatch_once_t once;
    dispatch_once( &once, ^{ __singleton__ = [[self alloc] init]; } );
    return __singleton__;
}

#pragma mark init
-(instancetype)init{
    self = [super init];
    if (self) {
        self.enableSniffer = NO;
        self.netResultArray = [[NSMutableArray alloc]init];
        self.netRequestArray = [[NSMutableArray alloc]init];
    }
    return self;
}

+(void)setupConfiguration:(NSURLSessionConfiguration *)config
{
    if (config) {
        NSMutableArray *mProtocolClasses = [[NSMutableArray alloc]initWithArray:config.protocolClasses];
        [mProtocolClasses addObject:[VKSnifferProtocol class]];
        config.protocolClasses = [mProtocolClasses copy];
    }
    
}

+(void)setupSnifferHandler:(VKSnifferHandler)callback{
    if (callback) {
        [VKSniffer singleton].Snifferhandler = callback;
    }
}

+(void)setupHostFilter:(NSString *)host{
    if (host) {
        [VKSniffer singleton].hostFilter = host;
    }
}

+(void)startSniffer{
    [VKSniffer singleton].enableSniffer = YES;
    [NSURLProtocol registerClass:[VKSnifferProtocol class]];
}


#pragma mark logic

-(void)sniffRequestEnqueue:(VKSnifferRequestItem *)request
{
    if (request) {
        [self.netRequestArray addObject:request];
    }
}

-(VKSnifferRequestItem *)sniffRequestDequeue:(NSInteger)requestId
{
    VKSnifferRequestItem *request;
    for (VKSnifferRequestItem* item in self.netRequestArray) {
        if (item.identifier == requestId) {
            request = item;
            break;
        }
    }
    return request;
}

-(void)sniffRequestResponse:(VKSnifferResponseItem *)response{
    VKSnifferRequestItem *request = [self sniffRequestDequeue:response.identifier];
    NSTimeInterval timeInterval = response.timeStamp - request.timeStamp;
    VKSnifferResult *result = [[VKSnifferResult alloc]init];
    result.request = request.request;
    result.response = response.response;
    result.error = nil;
    result.data = response.data;
    result.session = response.session;
    result.duration = timeInterval;
    [self postSnifferResult:result];
}

-(void)sniffRequestError:(VKSnifferErrorItem *)error{
    VKSnifferRequestItem *request = [self sniffRequestDequeue:error.identifier];
    NSTimeInterval timeInterval = error.timeStamp - request.timeStamp;
    VKSnifferResult *result = [[VKSnifferResult alloc]init];
    result.request = request.request;
    result.response = error.response;
    result.error = error.error;
    result.session = error.session;
    result.duration = timeInterval;
    [self postSnifferResult:result];
}

-(void)postSnifferResult:(VKSnifferResult *)result{
    
    
    @synchronized([VKSniffer singleton]) {
        if (result) {
            
            [[VKSniffer singleton].netResultArray addObject:result];
            
            if ([[VKSniffer singleton].netResultArray count] > VKMAXSNIFFERPRECORD) {
                NSInteger nowCount = [VKSniffer singleton].netResultArray.count;
                [[VKSniffer singleton].netResultArray removeObjectsInRange:NSMakeRange(0, nowCount - VKMAXSNIFFERPRECORD)];
            }
            if ([NSThread isMainThread]) {
                [[NSNotificationCenter defaultCenter]postNotificationName:VKNetSnifferReqLogNotification object:result];
                if (self.Snifferhandler) {
                    self.Snifferhandler(result);
                }
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter]postNotificationName:VKNetSnifferReqLogNotification object:result];
                    if (self.Snifferhandler) {
                        self.Snifferhandler(result);
                    }
                });
            }
        }
        
    }

    
}

@end
