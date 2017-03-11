//
//  ViewController.m
//  VKSnifferDemo
//
//  Created by Awhisper on 2017/3/6.
//  Copyright © 2017年 baidu. All rights reserved.
//

#import "ViewController.h"
#import "VKSniffer+UI.h"


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"


#define VKSnifferAppWidth ([[UIScreen mainScreen] bounds].size.width)
#define VKSnifferAppHeight ([[UIScreen mainScreen] bounds].size.height)

@interface ViewController ()

@property (nonatomic,strong) NSTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self commenSessionTaskTest];
    [self commenConnectionTest];
    [self afnetworkingTest];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake((VKSnifferAppWidth - 200)/2, (VKSnifferAppHeight - 40)/2, 200, 40)];
    [button setTitle:@"Open VKSniffer" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickBt) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timertimer) userInfo:nil repeats:YES];
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
    
}

-(void)commenConnectionTest{
    
    for (NSString *urlstr in [self networkApiArray]) {
        NSURL *url = [NSURL URLWithString:urlstr];
        
        
        NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url];
        
        //创建一个队列（默认添加到该队列中的任务异步执行）
        //NSOperationQueue *queue=[[NSOperationQueue alloc]init];
        
        //获取一个主队列
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
    return;
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:@"http://appwk.baidu.com/naapi/iap/userbankinfo?uid=bd_0&from=ios_appstore&app_ua=Simulator&ua=bd_1334_750_Simulator_3.4.9_9.2&fr=2&pid=1&bid=2&Bdi_bear=wifi&app_ver=3.4.9&sys_ver=9.2&cuid=50c78ca9f3c39a34c963de578bef1d8c7aecc087&sessid=1471498926&screen=750_1334&opid=wk_na&ydvendor=84942C9A-E479-4856-945A-D55FBCDF4D57"];
    // 通过URL初始化task,在block内部可以直接对返回的数据进行处理
    NSURLSessionTask *task = [session dataTaskWithURL:url
                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                        
                                    }];
    [task resume];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma clang diagnostic pop
@end
