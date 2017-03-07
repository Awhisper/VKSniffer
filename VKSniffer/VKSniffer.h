//
//  VKSniffer.h
//  VKSnifferDemo
//
//  Created by Awhisper on 2017/3/6.
//  Copyright © 2017年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface VKSnifferRequestItem : NSObject

@property (nonatomic,assign) NSInteger identifier;

@property (nonatomic,assign) NSTimeInterval timeStamp;

@property (nonatomic,strong) NSURLRequest *request;

@end

@interface VKSnifferResponseItem : NSObject

@property (nonatomic,assign) NSInteger identifier;

@property (nonatomic,assign) NSTimeInterval timeStamp;

@property (nonatomic,strong) NSHTTPURLResponse *response;

@property (nonatomic,strong) NSURLSession *session;

@end

@interface VKSnifferErrorItem : NSObject

@property (nonatomic,assign) NSInteger identifier;

@property (nonatomic,assign) NSTimeInterval timeStamp;

@property (nonatomic,strong) NSHTTPURLResponse *response;

@property (nonatomic,strong) NSURLSession *session;

@property (nonatomic,strong) NSError *error;

@end

@interface VKSnifferResult : NSObject

@property (nonatomic,strong) NSURLRequest *request;

@property (nonatomic,strong) NSHTTPURLResponse *response;

@property (nonatomic,strong) NSError *error;

@property (nonatomic,strong) NSURLSession *session;

@property (nonatomic,assign) CGFloat duration;

@end

typedef void(^VKSnifferHandler)(VKSnifferResult *result);

@interface VKSniffer : NSObject

@property (nonatomic,assign) BOOL enableSniffer;

@property(nonatomic,strong) NSString* hostFilter;

- (instancetype)sharedInstance;

+ (instancetype)singleton;

+ (void)startSniffer;

//Afnetworking 3.0 need
+ (void)setupConfiguration:(NSURLSessionConfiguration *)config;
//option
+ (void)setupSnifferHandler:(VKSnifferHandler)callback;
//option
+ (void)setupHostFilter:(NSString *)host;

@end
