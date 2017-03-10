//
//  VKSnifferViewController.m
//  VKSnifferDemo
//
//  Created by Awhisper on 2017/3/10.
//  Copyright © 2017年 baidu. All rights reserved.
//

#import "VKSnifferViewController.h"
#import "VKSniffer+UI.h"


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"


@interface VKSnifferViewController ()<UIActionSheetDelegate,UIAlertViewDelegate>

@property (nonatomic,strong) UIActionSheet *actionSheet;

@end

@implementation VKSnifferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"VKSniffer Panel";
    self.view.backgroundColor = [UIColor redColor];
    [self setupNavigationBar];
    [self setupTableView];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    self.view.backgroundColor = [UIColor greenColor];
}

#pragma mark tableview
-(void)setupTableView{
    
}

#pragma mark navigationbar
-(void)setupNavigationBar{
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 50, 40);
    [rightButton setTitle:@"Menu" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(clickMenu) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 50, 40);
    [leftButton setTitle:@"Exit" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(clicExit) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
}

-(void)clicExit{
    [VKSniffer hideSnifferView];
}

-(void)clickMenu{
    [self showMenu];
}

#pragma mark menu
-(void)showMenu
{
    UIActionSheet *actionSheet = [UIActionSheet new];
    self.actionSheet = actionSheet;
    actionSheet.title = @"VKSnifferMenu";
    actionSheet.delegate = self;
    if ([VKSniffer singleton].enableSniffer) {
        [actionSheet addButtonWithTitle:@"Disable Sniffer"];
    }else{
        [actionSheet addButtonWithTitle:@"Enable Sniffer"];
    }
    
    [actionSheet addButtonWithTitle:@"Change Filter"];
    [actionSheet addButtonWithTitle:@"Cancel"];
    actionSheet.cancelButtonIndex = actionSheet.numberOfButtons - 1;
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow.rootViewController.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (!_actionSheet) {
        return;
    }
    switch (buttonIndex) {
        case 0:
        {
            [VKSniffer singleton].enableSniffer = ![VKSniffer singleton].enableSniffer;
        }
            break;
        case 1:
        {
            UIAlertView *inputbox = [[UIAlertView alloc] initWithTitle:@"Change Filter" message:nil delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"ok", nil];
            [inputbox setAlertViewStyle:UIAlertViewStylePlainTextInput];
            UITextField *nameField = [inputbox textFieldAtIndex:0];
            nameField.placeholder = @"域名过滤器";
            [inputbox show];
        }
            break;
        default:
            break;
    }
    _actionSheet = nil;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex == alertView.firstOtherButtonIndex) {
        UITextField *nameField = [alertView textFieldAtIndex:0];
        if (nameField.text.length <= 0) {
            [VKSniffer singleton].hostFilter = nil;
        }else{
            [VKSniffer singleton].hostFilter = nameField.text;
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma clang diagnostic pop

@end
