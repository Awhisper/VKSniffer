//
//  VKSnifferProtocol.h
//  VKSnifferDemo
//
//  Created by Awhisper on 2017/3/6.
//  Copyright © 2017年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VKSniffer.h"
@interface VKSniffer (NSURLProtocol)

-(void)sniffRequestEnqueue:(VKSnifferRequestItem *)request;

-(void)sniffRequestResponse:(VKSnifferResponseItem *)response;

-(void)sniffRequestError:(VKSnifferErrorItem *)error;

-(VKSnifferRequestItem *)sniffRequestDequeue:(NSInteger)requestId;

@end

@interface VKSnifferProtocol : NSURLProtocol

@end
