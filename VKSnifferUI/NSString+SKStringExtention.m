//
//  NSString+SKStringExtention.m
//  AFNetworking
//
//  Created by kang lin on 2018/11/21.
//

#import "NSString+SKStringExtention.h"

@implementation NSString (SKStringExtention)

+(NSString *)logChinese:(NSString *)content {
    
    NSString *tempStr1 =
    [content stringByReplacingOccurrencesOfString:@"\\u"
                                       withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListWithData:tempData
                                              options:NSPropertyListImmutable
                                               format:NULL
                                                error:NULL];
    return str;
}
@end
