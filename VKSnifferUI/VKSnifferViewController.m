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


@interface VKSnifferViewController ()<UIActionSheetDelegate,UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UIActionSheet *actionSheet;

@property (nonatomic,strong) UITableView *requestTable;

@property (nonatomic,strong) NSString *pasteboardString;

@end

@implementation VKSnifferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"VKSniffer Panel";
    self.view.backgroundColor = [UIColor blackColor];
    [self setupNavigationBar];
    [self setupTableView];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    
}

#pragma mark tableview
-(void)setupTableView{
    _requestTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - 20)];
    _requestTable.delegate = self;
    _requestTable.dataSource = self;
    _requestTable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_requestTable];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [VKSniffer singleton].netResultArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *resultArr = [VKSniffer singleton].netResultArray;
    NSString *requestID = @"VKSnifferCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:requestID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:requestID];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
    }
    if (indexPath.row < resultArr.count) {
        VKSnifferResult *result = resultArr[indexPath.row];
        cell.textLabel.text = result.request.URL.absoluteString;
    }
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *resultArr = [VKSniffer singleton].netResultArray;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    VKSnifferResult *result = resultArr[indexPath.row];
    NSString *strurl = result.request.URL.absoluteString;
    NSData *reqData = result.data;
    NSString *strdata = [[NSJSONSerialization JSONObjectWithData:reqData options:kNilOptions error:nil] description];
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"返回数据" message:strdata delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"复制", nil];
    [alert show];
    
    NSString *pasteboardstr = [NSString stringWithFormat:@"URL: %@ \n\n Data: %@",strurl,strdata];
    self.pasteboardString = pasteboardstr;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.pasteboardString) {
        if (buttonIndex == 1) {//复制
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = self.pasteboardString;
        }
    }else{
        [self alertView:alertView clickedMenuButtonAtIndex:buttonIndex];
    }
    self.pasteboardString = nil;
}


#pragma mark navigationbar
-(void)setupNavigationBar{
    
    UILabel *titlelb = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 44)];
    titlelb.textColor = [UIColor whiteColor];
    titlelb.text = @"VKSniffer";
    [self.view addSubview:titlelb];
    titlelb.textAlignment = NSTextAlignmentCenter;
    titlelb.font = [UIFont boldSystemFontOfSize:titlelb.font.pointSize];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat x = [UIScreen mainScreen].bounds.size.width - 50 - 20;
    rightButton.frame = CGRectMake(x, 20, 50, 44);
    [rightButton setTitle:@"Menu" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(clickMenu) forControlEvents:UIControlEventTouchUpInside];
   
    [self.view addSubview:rightButton];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(10, 20, 50, 44);
    [leftButton setTitle:@"Exit" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(clicExit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 64,  [UIScreen mainScreen].bounds.size.width, 0.5f)];
    line.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:line];
    
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
    [actionSheet addButtonWithTitle:@"Remove All"];
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
        case 2:
        {
            [VKSniffer removeSnifferResult];
            [self.requestTable reloadData];
        }
            break;
        default:
            break;
    }
    _actionSheet = nil;
}

-(void)alertView:(UIAlertView *)alertView clickedMenuButtonAtIndex:(NSInteger)buttonIndex{

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
