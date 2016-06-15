//
//  MyRecordSectionView.h
//  ReturnTracker
//
//  Created by Ranjeeta Rajput on 10/10/13.
//  Copyright (c) 2013 Ranjeeta Rajput. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordData.h"
@interface MyRecordSectionView : UIView
{
    UIImageView *backImageView,*productImageView;
    
    //Static Label
    UILabel *staticProductLbl,*staticShopNameLbl,*staticPurchaseDateLbl,*staticreturnDateLbl;
    
    UIButton *addBtn;
    UIImageView *addBtnImageView;
    //Label according to data
    UILabel *productNameLbl,*shopNameLbl,*purchaseDateLbl,*returnDateLbl,*dayLeftLabel;
    NSInteger sectionTag;
    
    
}
@property(nonatomic, retain) UIImageView *backImageView;
@property(nonatomic,retain)UIImageView *productImageView,*addBtnImageView;
@property(nonatomic,retain)    UILabel *productNameLbl,*shopNameLbl,*purchaseDateLbl,*returnDateLbl,*dayLeftLabel;

@property(nonatomic,assign)NSInteger  sectionTag;
@property(nonatomic,retain)UIButton *addBtn;

- (id)initWithFrame:(CGRect)frame delegate:(id)delegate withTag:(NSInteger)tag withRecord:(RecordData*)record;
@end
