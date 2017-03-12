//
//  ViewController.m
//  VKSnifferDemo
//
//  Created by Awhisper on 2017/3/6.
//  Copyright © 2017年 baidu. All rights reserved.
//

#import "ViewController.h"
#import "VKSniffer+UI.h"
#import <AFNetworking/AFNetworking.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"


#define VKSnifferAppWidth ([[UIScreen mainScreen] bounds].size.width)
#define VKSnifferAppHeight ([[UIScreen mainScreen] bounds].size.height)

@interface ViewController ()

@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,strong) AFURLSessionManager *manager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //Start Sniffer
    [VKSniffer setupSnifferHandler:^(VKSnifferResult *result) {
        NSLog(@"%@",result);
    }];
    [VKSniffer startSniffer];
    
    [self commenSessionTaskTest];
    [self commenConnectionTest];
    [self afnetworkingTest];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake((VKSnifferAppWidth - 200)/2, (VKSnifferAppHeight - 40)/2, 200, 40)];
    [button setTitle:@"Open VKSniffer" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickBt) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timertimer) userInfo:nil repeats:YES];
    self.timer = timer;
}

-(void)clickBt{
    [VKSniffer showSnifferView];
}

-(NSArray *)networkApiArray
{
    return @[@"https://api.github.com/users/xmartlabs",
             @"https://api.github.com/users/xmartlabs/broke",
             @"https://api.github.com/users/xmartlabs/repos",
             @"https://api.github.com/users/xmartlabs/followers",
             @"https://appwk.baidu.com/naapi/iap/userbankinfo?uid=bd_0&from=ios_appstore",
             @"https://appwk.baidu.com/naapi/iap/userbankinfo?uid=bd_0&from=ios_appstore&app_ua=Simulator&ua=bd_1334_750_Simulator_3.4.9_9.2&Bdi_bear=wifi&app_ver=0.0.0&sys_ver=9.2&screen=750_1334&opid=wk_na"];
}

-(void)afnetworkingTest{
    //init Afnetworking manager
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    //setupConfiguration before init manager
    [VKSniffer setupConfiguration:configuration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    self.manager = manager;
    
    for (NSString *urlstr in [self networkApiArray]) {
        NSURL *URL = [NSURL URLWithString:urlstr];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        NSURLSessionDataTask *dataTask = [self.manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {

        }];
        [dataTask resume];
    }
}

-(void)commenConnectionTest{
    for (NSString *urlstr in [self networkApiArray]) {
        NSURL *url = [NSURL URLWithString:urlstr];
        NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url];
        NSOperationQueue *queue=[NSOperationQueue mainQueue];
        [NSURLConnection sendAsynchronousRequest:req queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
         {
             
         }];

    }
}

-(void)commenSessionTaskTest
{
    for (NSString *urlstr in [self networkApiArray]) {
        NSURLSession *session = [NSURLSession sharedSession];
        NSURL *url = [NSURL URLWithString:urlstr];
        NSURLSessionTask *task = [session dataTaskWithURL:url
                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                        
                                        }];
        [task resume];
    }
}

-(void)timertimer{
    [self commenConnectionTest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma clang diagnostic pop
@end
