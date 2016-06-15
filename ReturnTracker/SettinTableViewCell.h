//
//  SettinTableViewCell.h
//  ReturnTracker
//
//  Created by Ranjeeta Rajput on 18/10/13.
//  Copyright (c) 2013 Ranjeeta Rajput. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettinTableViewCell : UITableViewCell
{
    UIImageView *iconImageView;
    UILabel *titleLbl,*alertPeriodLbl,*alertPeriod;
    UIButton *alertPeriodBtn;
    
}
@property(nonatomic,retain)UIImageView *iconImageView;
@property(nonatomic,retain)UILabel *titleLbl,*alertPeriodLbl,*alertPeriod;
@property(nonatomic,retain)UIButton *alertPeriodBtn;

@end
