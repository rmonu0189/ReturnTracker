//
//  CalenderRecordCell.h
//  ReturnTracker
//
//  Created by monu on 11/11/13.
//  Copyright (c) 2013 Ranjeeta Rajput. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CalendarRecordCellDelegate <NSObject>
-(void)clickDelete:(int)tag;
@end
@interface CalenderRecordCell : UITableViewCell
{
    UIImageView *imgProduct;
    UILabel *lblProductName,*lblShopName,*lblPurchaseDate,*lblReturnDate,*lblRemainDay;
    UIButton *btnDelete;
    id<CalendarRecordCellDelegate> delegate;
}
@property(assign)id<CalendarRecordCellDelegate> delegate;
@property (nonatomic, retain) UIImageView *imgProduct;
@property (nonatomic, retain) UILabel *lblProductName,*lblShopName,*lblPurchaseDate,*lblReturnDate,*lblRemainDay;
@property (nonatomic, retain) UIButton *btnDelete;
@end
