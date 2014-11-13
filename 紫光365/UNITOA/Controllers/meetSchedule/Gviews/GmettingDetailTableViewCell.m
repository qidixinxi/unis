//
//  GmettingDetailTableViewCell.m
//  GUKE
//
//  Created by gaomeng on 14-10-5.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "GmettingDetailTableViewCell.h"
#import "UILabel+GautoMatchedText.h"
#import "GeventDetailViewController.h"
#import "GMAPI.h"

@implementation GmettingDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(CGFloat)loadCustomViewWithIndexPath:(NSIndexPath*)indexPath dataModel:(GeventModel*)theModel{
    
    
    
    CGFloat height = 0;
    
    if (indexPath.row == 0) {//会议名称
        
        //会议名称
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 20, 230, 20)];
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.textColor = RGB(72, 158, 181);
        titleLabel.text = theModel.eventTitle;
        [titleLabel setMatchedFrame4LabelWithOrigin:CGPointMake(15, 20) width:230];
        if (titleLabel.frame.size.height<20) {
            titleLabel.frame = CGRectMake(15, 20, 230, 20);
        }
        
        
        //是否报名
        
        UILabel *isLabel = [[UILabel alloc]initWithFrame:CGRectMake(260, 21, 60, 35)];
        isLabel.font = [UIFont systemFontOfSize:15];
        isLabel.numberOfLines = 2;
        isLabel.textColor = RGB(72, 158, 181);
        
        
        if ([theModel.userExists intValue] == 0) {
            
            isLabel.text = @"未报名";
            
        }else if ([theModel.userExists intValue] == 1){ 
            isLabel.text = @"已报名";
        }
        NSDate *date = [NSDate date];
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        NSInteger interval = [zone secondsFromGMTForDate: date];
        NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
        NSString *localeDateStr = [[[NSString stringWithFormat:@"%@",localeDate]substringToIndex:10]stringByReplacingOccurrencesOfString:@"-" withString:@""];
        NSString *eventTimeStr = [theModel.eventTime stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        
        if ([eventTimeStr intValue] <[localeDateStr intValue]) {
            isLabel.text = @"已结束";
            isLabel.textColor = RGB(168,168,168);
        }
        
        
        
        for (NSDictionary *dic in theModel.userlist) {
            if ([theModel.userId isEqualToString:[dic objectForKey:@"userId"]]) {
                NSString *payStateStr = [dic objectForKey:@"payState"];
                if ([payStateStr isEqualToString:@"1"]) {
                    isLabel.text = @"已报名已付款";
                }
            }
        }
        
        [isLabel setMatchedFrame4LabelWithOrigin:CGPointMake(260, 21) width:60];
        
        [self.contentView addSubview:isLabel];
        
        ////限定名额
        UILabel *numLimitLabel = [[UILabel alloc]init];
        
        if (CGRectGetMaxY(isLabel.frame)<CGRectGetMaxY(titleLabel.frame)) {
            [numLimitLabel setFrame:CGRectMake(15, CGRectGetMaxY(titleLabel.frame)+5, 65, 17)];
        }else{
            [numLimitLabel setFrame:CGRectMake(15, CGRectGetMaxY(isLabel.frame)+5, 65, 17)];
        }
        
        
        
        
        numLimitLabel.font = [UIFont systemFontOfSize:14];
        numLimitLabel.textColor = RGB(168,168,168);
        numLimitLabel.text = @"限定名额:";
        UILabel *cNumLimintLabel  = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(numLimitLabel.frame), numLimitLabel.frame.origin.y, 30, 17)];
        cNumLimintLabel.font = [UIFont systemFontOfSize:14];
        cNumLimintLabel.textColor = RGB(168,168,168);
        
        cNumLimintLabel.text = theModel.userLimit;
        
        
        [self.contentView addSubview:titleLabel];
        [self.contentView addSubview:numLimitLabel];
        [self.contentView addSubview:cNumLimintLabel];
        
        //已报名
        UILabel *baomingLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(cNumLimintLabel.frame), numLimitLabel.frame.origin.y, 50, 17)];
        baomingLabel.font = [UIFont systemFontOfSize:14];
        baomingLabel.textColor = RGB(168, 168, 168);
        baomingLabel.text = @"已报名:";
        UILabel *cbaomingLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(baomingLabel.frame), baomingLabel.frame.origin.y, 30, 17)];
        cbaomingLabel.textColor = RGB(168, 168, 168);
        cbaomingLabel.font = [UIFont systemFontOfSize:14];
        
        cbaomingLabel.text = [NSString stringWithFormat:@"%d",theModel.userlist.count] ;
        
        [self.contentView addSubview:baomingLabel];
        [self.contentView addSubview:cbaomingLabel];
        
        //剩余名额
        UILabel *lastNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(cbaomingLabel.frame), cbaomingLabel.frame.origin.y, 65, 17)];
        lastNumLabel.text = @"剩余名额:";
        lastNumLabel.font = [UIFont systemFontOfSize:14];
        lastNumLabel.textColor = RGB(168, 168, 168);
        UILabel *cLastNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lastNumLabel.frame), lastNumLabel.frame.origin.y, 30, 17)];
        cLastNumLabel.font = [UIFont systemFontOfSize:14];
        cLastNumLabel.textColor = RGB(168, 168, 168);
        int lastNumber = 0;
        if ([theModel.userLimit intValue]-theModel.userlist.count>0) {
            lastNumber = [theModel.userLimit intValue]-theModel.userlist.count;
        }else{
            lastNumber = 0;
        }
        
        cLastNumLabel.text = [NSString stringWithFormat:@"%d",lastNumber];
        
        [self.contentView addSubview:lastNumLabel];
        [self.contentView addSubview:cLastNumLabel];
        
        
        
        
        
        
        
        
        
        height = CGRectGetMaxY(numLimitLabel.frame)+20;
        
        
        
    }else if (indexPath.row == 1){//会议时间
        //会议时间
        UILabel *meettingTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 20, 80, 20)];
        meettingTimeLabel.font = [UIFont systemFontOfSize:15];
        meettingTimeLabel.text = @"会议时间：";
        meettingTimeLabel.textColor = RGB(98, 97, 97);
        
        UILabel *cMeettingTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(meettingTimeLabel.frame)+5, meettingTimeLabel.frame.origin.y, 150, 20)];
        cMeettingTimeLabel.textColor = RGB(168,168,168);
        cMeettingTimeLabel.font = [UIFont systemFontOfSize:15];
        cMeettingTimeLabel.text = theModel.eventTime;
        
        //报名截止
        UILabel *meetingEndTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 43, 80, 20)];
        meetingEndTimeLabel.text = @"报名截止：";
        meetingEndTimeLabel.font = [UIFont systemFontOfSize:15];
        meetingEndTimeLabel.textColor = RGB(98, 97, 97);
        
        UILabel *cMeetingEndTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(meetingEndTimeLabel.frame)+5, meetingEndTimeLabel.frame.origin.y, 100, 20)];
        cMeetingEndTimeLabel.font = [UIFont systemFontOfSize:15];
        cMeetingEndTimeLabel.textColor = RGB(168,168,168);
        cMeetingEndTimeLabel.text = theModel.endTime;
        [self.contentView addSubview:meettingTimeLabel];
        [self.contentView addSubview:cMeettingTimeLabel];
        [self.contentView addSubview:meetingEndTimeLabel];
        [self.contentView addSubview:cMeetingEndTimeLabel];
        
        height = CGRectGetMaxY(cMeetingEndTimeLabel.frame)+20;
        
        
        
        
    }else if (indexPath.row == 2){//活动地点
        //活动地点
        UILabel *addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 20, 75, 20)];
        addressLabel.textColor = RGB(98, 97, 97);
        addressLabel.font = [UIFont systemFontOfSize:15];
        addressLabel.text = @"活动地点：";
        
        UILabel *cAddressLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(addressLabel.frame)+5, addressLabel.frame.origin.y, 200, 20)];
        cAddressLabel.font = [UIFont systemFontOfSize:15];
        cAddressLabel.textColor = RGB(168,168,168);
        cAddressLabel.text = theModel.address;
        [cAddressLabel setMatchedFrame4LabelWithOrigin:CGPointMake(CGRectGetMaxX(addressLabel.frame)+5, addressLabel.frame.origin.y) width:200];
        [self.contentView addSubview:addressLabel];
        [self.contentView addSubview:cAddressLabel];
        
        //会议费用
        UILabel *feeLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(cAddressLabel.frame)+5, 80, 20)];
        feeLabel.textColor = RGB(98, 97, 97);
        feeLabel.font = [UIFont systemFontOfSize:15];
        feeLabel.text = @"会议费用：";
        
        UILabel *cFeeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(feeLabel.frame)+5, feeLabel.frame.origin.y, 200, 20)];
        cFeeLabel.textColor = RGB(168, 168, 168);
        cFeeLabel.text = [theModel.fee stringByAppendingString:@"元"];
        
        [self.contentView addSubview:feeLabel];
        [self.contentView addSubview:cFeeLabel];
        
        
        //联系电话
        UILabel *phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(feeLabel.frame)+5, 80, 20)];
        phoneLabel.font = [UIFont systemFontOfSize:15];
        phoneLabel.textColor = RGB(72, 158, 181);
        phoneLabel.text = @"联系电话：";
        
        UILabel *cPhoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(phoneLabel.frame)+5, phoneLabel.frame.origin.y, 200, 20)];
        cPhoneLabel.font = [UIFont systemFontOfSize:15];
        cPhoneLabel.textColor = RGB(72, 158, 181);
        cPhoneLabel.text = theModel.phone;
        
        [self.contentView addSubview:phoneLabel];
        [self.contentView addSubview:cPhoneLabel];
        
        
        height = CGRectGetMaxY(phoneLabel.frame)+15;
        
        
    }else if (indexPath.row == 3) {//会议议程以及报名
        
        //会议议程
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, 75, 20)];
        titleLabel.text = @"会议议程";
        titleLabel.textColor = RGB(72, 158, 181);
        titleLabel.font = [UIFont systemFontOfSize:15];
        
//        UILabel *contextLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(titleLabel.frame), 200, 20)];
//        contextLabel.font = [UIFont systemFontOfSize:15];
//        contextLabel.textColor = RGB(168, 168, 168);
//        contextLabel.text = [NSString _859ToUTF8:theModel.context];
//        [contextLabel setMatchedFrame4LabelWithOrigin:CGPointMake(15, CGRectGetMaxY(titleLabel.frame)) width:275];
        
        
        
        
        UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(titleLabel.frame), 290, self.delegate.webViewHeight)];
        
        NSLog(@"%@",NSStringFromCGRect(webView.frame));
        
        webView.scrollView.scrollEnabled = NO;
        
        
        [webView loadHTMLString:theModel.context baseURL:nil];
        
        [self.contentView addSubview:webView];
        
        
        [self.contentView addSubview:titleLabel];
//        [self.contentView addSubview:contextLabel];
        
        
        
        NSArray *titleArray = @[@"报名",@"取消报名",@"支付费用"];//tag 10 11 12
        
        
        NSDate *date = [NSDate date];
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        NSInteger interval = [zone secondsFromGMTForDate: date];
        NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
        NSString *localeDateStr = [[NSString stringWithFormat:@"%@",localeDate]substringToIndex:10];
        if ([theModel.userExists intValue] >[localeDateStr intValue]) {//活动已结束
            height = CGRectGetMaxY(webView.frame)+20;
        }else{//活动没有结束
            if ([theModel.userExists intValue] == 1) {//已报名
                for (int i = 0; i<1; i++) {
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    [btn setTitle:titleArray[i+1] forState:UIControlStateNormal];
                    btn.tag = 11+i;
                    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
                    
                    btn.layer.cornerRadius = 4;
                    
                    if (i == 0){
                        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                        [btn setBackgroundColor:RGB(237, 238, 237)];
                    }else if (i == 1){
                        [btn setTitleColor:RGB(35, 178, 95) forState:UIControlStateNormal];
                        btn.layer.borderWidth = 1;
                        btn.layer.borderColor = [RGB(35, 178, 95)CGColor];
                        [btn setBackgroundColor:[UIColor whiteColor]];
                    }
                    
                    [btn setFrame:CGRectMake(10, CGRectGetMaxY(webView.frame)+20 +i*(50+10), 300, 50)];
                    
                    [self.contentView addSubview:btn];
                    
                    height = CGRectGetMaxY(btn.frame)+20;
                }
            }else if ([theModel.userExists intValue] == 0){//未报名
                
                
                NSDate *date = [NSDate date];
                NSTimeZone *zone = [NSTimeZone systemTimeZone];
                NSInteger interval = [zone secondsFromGMTForDate: date];
                NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
                NSString *localeDateStr = [[[NSString stringWithFormat:@"%@",localeDate]substringToIndex:10]stringByReplacingOccurrencesOfString:@"-" withString:@""];
                NSString *endTimeStr = [theModel.endTime stringByReplacingOccurrencesOfString:@"-" withString:@""];
                
                if ([endTimeStr intValue]< [localeDateStr intValue]) {
                    
                    height = CGRectGetMaxY(webView.frame)+20;
                    
                }else{
                    
                    for (int i = 0; i<1; i++) {
                        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
                        btn.tag = 10+i;
                        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
                        btn.layer.cornerRadius = 4;
                        if (i ==0) {
                            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                            [btn setBackgroundColor:RGB(35, 178, 95)];
                        }
                        [btn setFrame:CGRectMake(10, CGRectGetMaxY(webView.frame)+20 +i*(50+10), 300, 50)];
                        [self.contentView addSubview:btn];
                        height = CGRectGetMaxY(btn.frame)+20;
                    }
                }
                
            }
        }
        
        
        
    }
    
    
        return height;
    
}



-(void)btnClicked:(UIButton *)sender{
    [self.delegate btnClicked:sender];
}





@end
