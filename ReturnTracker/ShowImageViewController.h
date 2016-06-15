//
//  ShowImageViewController.h
//  ReturnTracker
//
//  Created by monu on 14/11/13.
//  Copyright (c) 2013 Ranjeeta Rajput. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordData.h"
#import "myRecordTableViewCell.h"
#import "SettingMenuView.h"
#import "HomePageCell.h"

@protocol ShowImageViewDelegate <NSObject>

- (void)setImageFinished:(RecordData*)imgRecord;

@end

@interface ShowImageViewController : UIViewController<SettingMenuDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImageView *imgView1,*imgView2,*imgView3,*imgView4;
    SettingMenuView *menuView;
    int imgNumber;
    id cellDelegate;
    id<ShowImageViewDelegate> delegate;
}
@property (nonatomic, assign) id cellDelegate;
@property (nonatomic, assign) id<ShowImageViewDelegate> delegate;
@property (nonatomic, retain) SettingMenuView *menuView;
@property (nonatomic,retain) UIImageView *imgView1,*imgView2,*imgView3,*imgView4;
- (IBAction)clickedDone:(id)sender;
@property (retain, nonatomic) IBOutlet UIImageView *imgView;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollImage;
- (void)setImg:(UIImage*)img;
- (void)designViewForImageAndSelectImageTag:(int)tag andCellData:(myRecordTableViewCell*)data andCellDelegate:(id)cellDel;
- (void)designViewForImageAndSelectImageTag:(int)tag andHomeCellData:(HomePageCell *)data andCellDelegate:(id)cellDel;
@end
