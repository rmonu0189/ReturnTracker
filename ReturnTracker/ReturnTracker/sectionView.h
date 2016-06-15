//
//  sectionView.h
//  MyTableCollapseView
//
//  Created by Ranjeeta Rajput on 07/10/13.
//  Copyright (c) 2013 Ranjeeta Rajput. All rights reserved.
//


//Class contain UIView Element containt by class
#import <UIKit/UIKit.h>

@protocol SectionViewDelegate<NSObject>
@optional
-(void)longPressClickTag:(int)tag;
- (void)clickedStar:(id)sender;
@end

@interface sectionView : UIView
{
    UILabel *lblTitle;//,*lblSubTitle;
    UIImageView *iconImageView,*backImageView,*addBtnImageView,*favouriteImageView;
    UIButton *addBtn;
    NSInteger sectionTag;
    id<SectionViewDelegate> sectionDelegate;
}
@property(nonatomic,assign)id<SectionViewDelegate> sectionDelegate;
@property(nonatomic,retain)UILabel *lblTitle;//,*lblSubTitle;
@property(nonatomic,retain)UIImageView *iconImageView,*backImageView,*addBtnImageView,*favouriteImageView;
@property(nonatomic,retain)UIButton *addBtn;
@property(nonatomic,assign)NSInteger  sectionTag;

- (id)initWithFrame:(CGRect)frame delegate:(id)delegate withTag:(NSInteger)tag;
@end
