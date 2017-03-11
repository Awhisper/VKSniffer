//
//  VKSnifferCell.m
//  VKSnifferDemo
//
//  Created by Awhisper on 2017/3/11.
//  Copyright © 2017年 baidu. All rights reserved.
//

#import "VKSnifferCell.h"


#define VKSnifferCellAppWidth ([[UIScreen mainScreen] bounds].size.width)
#define VKSnifferCellAppHeight ([[UIScreen mainScreen] bounds].size.height)

@interface VKSnifferCell ()

@property (nonatomic,strong) UILabel *urlLabel;

@property (nonatomic,strong) UILabel *statusLabel;

@property (nonatomic,strong) UILabel *timeLabel;

@property (nonatomic,strong) UILabel *detailLabel;


@end

@implementation VKSnifferCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    UILabel *urllb = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, VKSnifferCellAppWidth - 20, 15)];
    urllb.textColor = [UIColor whiteColor];
    urllb.numberOfLines = 1;
    self.urlLabel = urllb;
    [self.contentView addSubview:urllb];
    
//    UILabel *detail = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, VKSnifferCellAppWidth - 20, 0)];
//    urllb.textColor = [UIColor whiteColor];
//    urllb.numberOfLines = 1;
//    self.urlLabel = urllb;
//    [self.contentView addSubview:urllb];
    
    UILabel *statusLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, VKSnifferCellAppWidth - 20, 15)];
    statusLb.textColor = [UIColor whiteColor];
    statusLb.numberOfLines = 1;
    statusLb.textAlignment = NSTextAlignmentLeft;
    self.statusLabel = statusLb;
    [self.contentView addSubview:statusLb];
    
    UILabel *timelb = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, VKSnifferCellAppWidth - 20, 15)];
    timelb.textColor = [UIColor whiteColor];
    timelb.numberOfLines = 1;
    timelb.textAlignment = NSTextAlignmentRight;
    self.timeLabel = timelb;
    [self.contentView addSubview:timelb];
}

- (void)setSnifferResult:(VKSnifferResult *)result
{
    self.urlLabel.text = result.request.URL.absoluteString;
    NSTimeInterval ms = result.duration * 1000.0f;
    self.timeLabel.text = [NSString stringWithFormat:@"%.2f ms",ms];
    if (ms < 500.0f) {
        self.timeLabel.textColor = [UIColor whiteColor];
    }else if(ms > 500.0f && ms < 1000.0f){
        self.timeLabel.textColor = [UIColor yellowColor];
    }else{
        self.timeLabel.textColor = [UIColor redColor];
    }
    
    NSString * statusStr = (result.response.statusCode >= 200 && result.response.statusCode < 300) ? @"SUCCESS" : @"ERROR";
    self.statusLabel.text = [NSString stringWithFormat:@"%@: - %@",statusStr,@(result.response.statusCode)];
    
    if ([statusStr isEqualToString:@"SUCCESS"]) {
        self.statusLabel.textColor = [UIColor whiteColor];
    }else{
        self.statusLabel.textColor = [UIColor redColor];
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
