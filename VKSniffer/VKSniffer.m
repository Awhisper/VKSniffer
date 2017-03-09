//
//  VKSniffer.m
//  VKSnifferDemo
//
//  Created by Awhisper on 2017/3/6.
//  Copyright © 2017年 baidu. All rights reserved.
//

#import "VKSniffer.h"
#import "VKSnifferProtocol.h"
@interface VKSniffer ()

@property (nonatomic,strong) VKSnifferHandler Snifferhandler;

@property(atomic,strong) NSMutableArray<VKSnifferRequestItem *> * netRequestArray;

@property(atomic,strong) NSMutableArray<VKSnifferResult *>* netResultArray;

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

-(void)sniffRequestResponse:(VKSnifferResponseItem *)response{
    
}

-(void)sniffRequestError:(VKSnifferErrorItem *)error{
    
}

-(VKSnifferRequestItem *)sniffRequestDequeue:(NSInteger)requestId{
    NSInteger reqId;
    VKSnifferRequestItem *reqItem;
    for (VKSnifferRequestItem* req in self.netRequestArray) {
        if (req.identifier == requestId) {
            reqId = req.identifier;
            reqItem = req;
            break;
        }
    }
    if (reqItem) {
        [self.netRequestArray removeObject:reqItem];
        return reqItem;
    }
    return nil;
}


@end
