//
//  VKSnifferProtocol.m
//  VKSnifferDemo
//
//  Created by Awhisper on 2017/3/6.
//  Copyright © 2017年 baidu. All rights reserved.
//

#import "VKSnifferProtocol.h"
#import "VKSniffer.h"


static NSString * const VKSnifferProtocolKey = @"VKSnifferProtocolKey";

@interface VKSnifferProtocol ()<NSURLSessionDataDelegate,NSURLSessionTaskDelegate>

@property (nonatomic,strong) NSURLSession *internalSession;
@property (nonatomic,strong) NSURLSessionDataTask *internalTask;
@property (nonatomic,strong) NSHTTPURLResponse *internalResponse;
@property (nonatomic,strong) NSMutableData *internalResponseData;

@end

@implementation VKSnifferProtocol

#pragma mark NSURLProtocol

+(BOOL)canInitWithRequest:(NSURLRequest *)request{
    if (![VKSniffer singleton].enableSniffer) {
        return NO;
    }
    
    //Post请求 body 会有问题因此抛弃
    if ([request.HTTPMethod isEqualToString:@"POST"]) {
        return NO;
    }
    
    //只处理http和https请求
    NSString *scheme = [[request URL] scheme];
    if ( ([scheme rangeOfString:@"http"].location != NSNotFound) ||
          ([scheme rangeOfString:@"https"].location != NSNotFound))
    {
        if ([VKSniffer singleton].hostFilter && [VKSniffer singleton].hostFilter.length > 0) {
            
            NSString *url = [[request URL] absoluteString];
            if ([url rangeOfString:[VKSniffer singleton].hostFilter].location != NSNotFound) {
                //看看是否已经处理过了，防止无限循环
                if ([NSURLProtocol propertyForKey:VKSnifferProtocolKey inRequest:request]) {
                    return NO;
                }
            }else{
                return NO;
            }
        }else{
            //看看是否已经处理过了，防止无限循环
            if ([NSURLProtocol propertyForKey:VKSnifferProtocolKey inRequest:request]) {
                return NO;
            }
        }
        return YES;
    }
    
    return NO;
}

-(instancetype)initWithRequest:(NSURLRequest *)request cachedResponse:(NSCachedURLResponse *)cachedResponse client:(id<NSURLProtocolClient>)client{
    self = [super initWithRequest:request cachedResponse:cachedResponse client:client];
    if (self) {
        self.internalSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
        self.internalTask = [self.internalSession dataTaskWithRequest:request];
    }
    return self;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

-(void)startLoading{
    [self hookRequest:self.request];
    [self.internalTask resume];
}

- (void)stopLoading{
    [VKSniffer singleton];
    //
    [self.internalSession invalidateAndCancel];
}

#pragma mark logic

-(NSMutableData *)internalResponseData{
    if (!_internalResponseData) {
        _internalResponseData = [[NSMutableData alloc]init];
    }
    return _internalResponseData;
}

-(NSInteger)requestIdentifier{
    if (self.internalTask && self.internalTask.originalRequest) {
        return self.internalTask.originalRequest.hash;
    }
    return 0;
}

-(void)hookRequest:(NSURLRequest *)request{
    NSTimeInterval startStamp = [[NSDate date] timeIntervalSince1970];
    VKSnifferRequestItem *reqItem = [[VKSnifferRequestItem alloc]init];
    reqItem.identifier = [self requestIdentifier];
    reqItem.timeStamp = startStamp;
    reqItem.request = request;
    //
    
}

-(void)hookResponse:(NSHTTPURLResponse *)response Data:(NSData *)data Session:(NSURLSession *)session{
    NSTimeInterval endStamp = [[NSDate date] timeIntervalSince1970];
    VKSnifferResponseItem * responseItem = [[VKSnifferResponseItem alloc]init];
    responseItem.identifier = [self requestIdentifier];
    responseItem.timeStamp = endStamp;
    responseItem.response = response;
    responseItem.session = session;
    //
}

-(void)hookError:(NSError *)error Response:(NSHTTPURLResponse *)response Data:(NSData *)data Session:(NSURLSession *)session{
    NSTimeInterval endStamp = [[NSDate date] timeIntervalSince1970];
    VKSnifferErrorItem * errorItem = [[VKSnifferErrorItem alloc]init];
    errorItem.identifier = [self requestIdentifier];
    errorItem.timeStamp = endStamp;
    errorItem.response = response;
    errorItem.session = session;
    errorItem.error = error;
    //
}

#pragma mark URLSessionTaskDelegate

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    if (error) {
        [self hookError:error Response:self.internalResponse Data:self.internalResponseData Session:session];
        [self.client URLProtocol:self didFailWithError:error];
    }else if(self.internalResponse){
        [self hookResponse:self.internalResponse Data:self.internalResponseData Session:session];
        [self.client URLProtocolDidFinishLoading:self];
    }
}

#pragma mark URLSessionDataDelegate

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(nonnull NSURLResponse *)response completionHandler:(nonnull void (^)(NSURLSessionResponseDisposition))completionHandler{
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        self.internalResponse = (NSHTTPURLResponse *)response;
        completionHandler(NSURLSessionResponseAllow);
        [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageAllowed];
    }
}

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    [self.internalResponseData appendData:data];
    [self.client URLProtocol:self didLoadData:data];
}


@end
