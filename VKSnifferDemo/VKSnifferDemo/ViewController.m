//
//  ViewController.m
//  VKSnifferDemo
//
//  Created by Awhisper on 2017/3/6.
//  Copyright © 2017年 baidu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:@"http://appwk.baidu.com/naapi/iap/userbankinfo?uid=bd_0&from=ios_appstore&app_ua=Simulator&ua=bd_1334_750_Simulator_3.4.9_9.2&fr=2&pid=1&bid=2&Bdi_bear=wifi&app_ver=3.4.9&sys_ver=9.2&cuid=50c78ca9f3c39a34c963de578bef1d8c7aecc087&sessid=1471498926&screen=750_1334&opid=wk_na&ydvendor=84942C9A-E479-4856-945A-D55FBCDF4D57"];
    // 通过URL初始化task,在block内部可以直接对返回的数据进行处理
    NSURLSessionTask *task = [session dataTaskWithURL:url
                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                        if (data) {
                                            NSLog(@"%@", [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]);
                                        }
                                        
                                    }];
    
    NSURLSessionTask *task1 = [session dataTaskWithURL:url
                                     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                         if (data) {
                                             NSLog(@"%@", [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]);
                                         }
                                     }];
    //
    NSURLSessionTask *task2 = [session dataTaskWithURL:url
                                     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                         if (data) {
                                             NSLog(@"%@", [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]);
                                         }
                                     }];
    // 启动任务
    [task resume];
    [task2 resume];
    [task1 resume];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
