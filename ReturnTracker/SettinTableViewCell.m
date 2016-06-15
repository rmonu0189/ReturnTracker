//
//  SettinTableViewCell.m
//  ReturnTracker
//
//  Created by Ranjeeta Rajput on 18/10/13.
//  Copyright (c) 2013 Ranjeeta Rajput. All rights reserved.
//

#import "SettinTableViewCell.h"

@implementation SettinTableViewCell
@synthesize iconImageView,titleLbl,alertPeriodLbl,alertPeriodBtn,alertPeriod;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImageView *borderImg=[[UIImageView alloc]initWithFrame:CGRectMake(0,3, 320, 2)];
        [borderImg setImage:[UIImage imageNamed:@"Line"]];
        
        iconImageView=[[UIImageView alloc]initWithFrame:CGRectMake(3, 5, 44, 38)];
        
        titleLbl=[[UILabel alloc]initWithFrame:CGRectMake(50, 5, 80, 25)];
        [titleLbl setFont:[UIFont systemFontOfSize:13]];
        [titleLbl setBackgroundColor:[UIColor clearColor]];
        
        alertPeriodLbl=[[UILabel alloc]initWithFrame:CGRectMake(130, 32,80, 20)];
        [alertPeriodLbl setBackgroundColor:[UIColor clearColor]];
        [alertPeriodLbl setFont:[UIFont systemFontOfSize:11.0f]];
        
        
        alertPeriodBtn=[[UIButton alloc]initWithFrame:CGRectMake(212, 32, 90, 20)];
        [alertPeriodBtn setImage:[UIImage imageNamed:@"White box"] forState:UIControlStateNormal];
        alertPeriod=[[UILabel alloc]initWithFrame:CGRectMake(222,34, 20, 15)];
        [alertPeriod setFont:[UIFont systemFontOfSize:13]];
        [alertPeriod setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:iconImageView];
        [self.contentView addSubview:titleLbl];
        [self.contentView addSubview:alertPeriodLbl];
        [self.contentView addSubview:alertPeriodBtn];
        [self.contentView addSubview:alertPeriod];
        
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
