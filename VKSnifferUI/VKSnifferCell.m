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
#define VKSnifferCellUrlWidth VKSnifferCellAppWidth - 20

static NSInteger VKSnifferMaxUrlLine = 4;
static CGFloat VKSnifferMaxUrlFontSize = 12.0f;
static CGFloat VKSnifferMaxLabelLineHeight = 15;


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
    CGFloat secondLineTop = 45;
    UILabel *urllb = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, VKSnifferCellUrlWidth, 45)];
    urllb.textColor = [UIColor whiteColor];
    urllb.numberOfLines = VKSnifferMaxUrlLine;
    urllb.font = [UIFont systemFontOfSize:VKSnifferMaxUrlFontSize];
    self.urlLabel = urllb;
    [self.contentView addSubview:urllb];
    
//    UILabel *detail = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, VKSnifferCellAppWidth - 20, 0)];
//    urllb.textColor = [UIColor whiteColor];
//    urllb.numberOfLines = 1;
//    self.urlLabel = urllb;
//    [self.contentView addSubview:urllb];
    
    UILabel *statusLb = [[UILabel alloc]initWithFrame:CGRectMake(10, secondLineTop, VKSnifferCellUrlWidth, VKSnifferMaxLabelLineHeight)];
    statusLb.textColor = [UIColor whiteColor];
    statusLb.numberOfLines = 1;
    statusLb.textAlignment = NSTextAlignmentLeft;
    statusLb.font = [UIFont systemFontOfSize:VKSnifferMaxUrlFontSize];
    self.statusLabel = statusLb;
    [self.contentView addSubview:statusLb];
    
    UILabel *timelb = [[UILabel alloc]initWithFrame:CGRectMake(10, secondLineTop, VKSnifferCellUrlWidth, VKSnifferMaxLabelLineHeight)];
    timelb.textColor = [UIColor whiteColor];
    timelb.numberOfLines = 1;
    timelb.textAlignment = NSTextAlignmentRight;
    timelb.font = [UIFont systemFontOfSize:VKSnifferMaxUrlFontSize];
    self.timeLabel = timelb;
    [self.contentView addSubview:timelb];
}

- (void)setSnifferResult:(VKSnifferResult *)result
{
    NSString *url = result.request.URL.absoluteString;
    url = [NSString stringWithFormat:@"URL: - %@",url];
    self.urlLabel.text = url;
    NSTimeInterval ms = result.duration * 1000.0f;
    self.urlLabel.frame = CGRectMake(self.urlLabel.frame.origin.x, self.urlLabel.frame.origin.y, VKSnifferCellUrlWidth, [result.cellHeightCache floatValue] - VKSnifferMaxLabelLineHeight - 2);
    
    CGFloat secondLineTop = [result.cellHeightCache floatValue] - VKSnifferMaxLabelLineHeight - 2;
    self.timeLabel.text = [NSString stringWithFormat:@"%.2f ms",ms];
    if (ms < 500.0f) {
        self.timeLabel.textColor = [UIColor whiteColor];
    }else if(ms > 500.0f && ms < 1000.0f){
        self.timeLabel.textColor = [UIColor yellowColor];
    }else{
        self.timeLabel.textColor = [UIColor redColor];
    }
    self.timeLabel.frame = CGRectMake(self.timeLabel.frame.origin.x, secondLineTop, VKSnifferCellUrlWidth, VKSnifferMaxLabelLineHeight);
    
    NSString * statusStr = (result.response.statusCode >= 200 && result.response.statusCode < 300) ? @"SUCCESS" : @"ERROR";
    self.statusLabel.text = [NSString stringWithFormat:@"%@: - %@",statusStr,@(result.response.statusCode)];
    
    if ([statusStr isEqualToString:@"SUCCESS"]) {
        self.statusLabel.textColor = [UIColor whiteColor];
    }else{
        self.statusLabel.textColor = [UIColor redColor];
    }
    self.statusLabel.frame = CGRectMake(self.statusLabel.frame.origin.x, secondLineTop, VKSnifferCellUrlWidth, VKSnifferMaxLabelLineHeight);
}

+(CGFloat)caculateSnifferResultHeight:(VKSnifferResult *)result{
    NSString *url = result.request.URL.absoluteString;
    url = [NSString stringWithFormat:@"URL: - %@",url];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:VKSnifferMaxUrlFontSize], NSParagraphStyleAttributeName:paragraphStyle.copy};

    CGRect rect = [url boundingRectWithSize:CGSizeMake(VKSnifferCellUrlWidth, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    
    if (rect.size.height > VKSnifferMaxUrlFontSize * VKSnifferMaxUrlLine) {
        rect.size.height = (VKSnifferMaxUrlFontSize + 2) * VKSnifferMaxUrlLine;
    }
    
    return rect.size.height + VKSnifferMaxLabelLineHeight + 4;
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
