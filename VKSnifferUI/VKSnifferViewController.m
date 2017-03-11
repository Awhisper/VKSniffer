//
//  VKSnifferViewController.m
//  VKSnifferDemo
//
//  Created by Awhisper on 2017/3/10.
//  Copyright © 2017年 baidu. All rights reserved.
//

#import "VKSnifferViewController.h"
#import "VKSniffer+UI.h"
#import "VKSnifferCell.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#define VKSnifferViewControllerUIWidth ([[UIScreen mainScreen] bounds].size.width)
#define VKSnifferViewControllerUIHeight ([[UIScreen mainScreen] bounds].size.height)


@interface VKSnifferViewController ()<UIActionSheetDelegate,UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UIActionSheet *actionSheet;

@property (nonatomic,strong) UITableView *requestTable;

@property (nonatomic,strong) NSString *pasteboardString;

@property (nonatomic,assign) BOOL isReverse;

@property (nonatomic,strong) NSMutableArray<VKSnifferResult *>* dataArr;

@end

@implementation VKSnifferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"VKSniffer Panel";
    self.view.backgroundColor = [UIColor blackColor];
    [self setupNavigationBar];
    [self setupTableView];
    [self addLogNotificationObserver];
    self.dataArr = [[VKSniffer singleton].netResultArray mutableCopy];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    [self.requestTable reloadData];
}

-(void)setIsReverse:(BOOL)isReverse{
    [VKSniffer singleton].isReverse = @(isReverse);
}

-(BOOL)isReverse
{
    if ([VKSniffer singleton].isReverse) {
        return [[VKSniffer singleton].isReverse boolValue];
    }else{
        return YES; //default
    }
}

-(void)dealloc
{
    [self removeLogNotificationObserver];
}
#pragma mark notification
-(void)addLogNotificationObserver
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(logNotificationGet:) name:VKNetSnifferReqLogNotification object:nil];
}

-(void)removeLogNotificationObserver
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)logNotificationGet:(NSNotification *)noti{
    VKSnifferResult *result = noti.object;
    if (result) {
        [self.dataArr addObject:result];
        [self.requestTable reloadData];
    }
}

#pragma mark tableview
-(void)setupTableView{
    _requestTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 64,VKSnifferViewControllerUIWidth, VKSnifferViewControllerUIHeight - 20)];
    _requestTable.delegate = self;
    _requestTable.dataSource = self;
    _requestTable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_requestTable];
}

-(NSInteger)tableViewConvertIndexPath:(NSIndexPath *)indexPath{
    if (self.isReverse) {
        NSInteger index = self.dataArr.count - indexPath.row - 1;
        return index>=0?index:0;
    }else{
        return indexPath.row;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger trueIndex = [self tableViewConvertIndexPath:indexPath];
    NSArray *resultArr = self.dataArr;
    VKSnifferResult *result = resultArr[trueIndex];
    if (result.cellHeightCache) {
        return [result.cellHeightCache floatValue];
    }else{
        CGFloat cellheight = [VKSnifferCell caculateSnifferResultHeight:result];
        result.cellHeightCache = [NSNumber numberWithFloat:cellheight];
        return cellheight;
    }
    return VKSnifferCellHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *resultArr = self.dataArr;
    NSString *requestID = @"VKSnifferCellID";
    VKSnifferCell *cell = [tableView dequeueReusableCellWithIdentifier:requestID];
    if (!cell) {
        cell = [[VKSnifferCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:requestID];
    }
    NSInteger trueIndex = [self tableViewConvertIndexPath:indexPath];
    VKSnifferResult *result = resultArr[trueIndex];
    [cell setSnifferResult:result];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger trueIndex = [self tableViewConvertIndexPath:indexPath];
    NSArray *resultArr = self.dataArr;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    VKSnifferResult *result = resultArr[trueIndex];
    NSData *reqData = result.data;
    NSString *strdata = [[NSJSONSerialization JSONObjectWithData:reqData options:kNilOptions error:nil] description];
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Response Detail" message:strdata delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Copy", nil];
    [alert show];
    NSString *pasteboardstr = [result description];
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
    
    UILabel *titlelb = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, VKSnifferViewControllerUIWidth, 44)];
    titlelb.textColor = [UIColor whiteColor];
    titlelb.text = @"VKSniffer";
    [self.view addSubview:titlelb];
    titlelb.textAlignment = NSTextAlignmentCenter;
    titlelb.font = [UIFont boldSystemFontOfSize:titlelb.font.pointSize];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat x = VKSnifferViewControllerUIWidth - 50 - 20;
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
    
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 64,  VKSnifferViewControllerUIWidth, 0.5f)];
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
    if (self.isReverse) {
        [actionSheet addButtonWithTitle:@"Forward Sequence"];
    }else{
        [actionSheet addButtonWithTitle:@"Reverse Sequence"];
    }
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
        case 3:
        {
            self.isReverse = !self.isReverse;
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
