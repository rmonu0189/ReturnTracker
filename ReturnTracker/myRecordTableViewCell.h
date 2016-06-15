//
//  myRecordTableViewCell.h
//  ReturnTracker
//
//  Created by Ranjeeta Rajput on 10/10/13.
//  Copyright (c) 2013 Ranjeeta Rajput. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIKeyboardViewController.h"
#import "NotificationClass.h"


@protocol myRecordTableViewCellDelegate;
@interface myRecordTableViewCell : UITableViewCell<UITextFieldDelegate>
{
    id <myRecordTableViewCellDelegate> delegate;

    UIView *mainView,*imageViw,*itemView;
    //********Main View Item*********
    
    //image view item
    UIButton *image1Btn,*image2Btn,*image3Btn,*image4Btn;

    UIImageView *backImage,*firstImageView,*secondImageView,*thirdImageView,*fourthImageView,*productReturnedImageView;
    UIButton *cameraBtn,*gallaryBtn;
    UILabel *imageViewHdr;
    
    
    //item View content
    UITextField *productNameTxt;
    UITextField *receiptNoTxt;
    UITextField *purchaseDateTxt;
    

    UILabel *returnDateLbl,*returnDurationLbl,*productReturnLbl;
    UIImageView *returnDateImgView,*returnDurationImgView;
    UIButton *returnDateRadioBtn,*returnDurationRadioBtn,*calendarBtn,*calendarBtn2, *productReturntBtn;
    UITextField *returnDateTxt,*returnDurationTxt;
    UIImageView *returnDateTxtImage,*returnDurationTxtImage;
    
    //
    UILabel *addNoteLbl,*timeLeftLbl,*timeLeftDescLbl;
    
    UIButton *deleteBtn,*updateBtn;
    UIImageView *addNoteImg;
    UIButton *addNoteBtn;
    
    //calImage
    UIImageView *cal2ImageView;
    
    
    //TextField Position
    UIKeyboardViewController *keyBoardController;
    
    int productReturnValue;
    
    //
    UILabel *returnAlert;
    UITextField *returnAlertTextField;
    UIImageView *returnAlertTextFieldImageView;
    UIButton *returnAlertBtn;
    UIImageView *returnAlertBtnImage;
    UILabel *lblTemp2;

    
}

@property(nonatomic,assign)id <myRecordTableViewCellDelegate> delegate;

@property(nonatomic,retain)UITextField *productNameTxt,*receiptNoTxt,*purchaseDateTxt;


@property(nonatomic,retain) UIButton *image1Btn,*image2Btn,*image3Btn,*image4Btn;

@property(nonatomic,retain)UIView *mainView,*imageViw,*itemView;
@property(nonatomic,retain)UIImageView *backImage,*firstImageView,*secondImageView,*thirdImageView,*fourthImageView,*addNoteImg,*productReturnedImageView,*cal2ImageView, *returnDateImgView,*returnDurationImgView,*returnDateTxtImage,*returnDurationTxtImage;
@property(nonatomic,retain)UIButton *cameraBtn,*gallaryBtn,*deleteBtn,*updateBtn,*calendarBtn,*addNoteBtn,*returnDateRadioBtn,*returnDurationRadioBtn,*productReturntBtn,*calendarBtn2;
@property(nonatomic,retain)UILabel *imageViewHdr,*returnDateLbl,*returnDurationLbl,*addNoteLbl,*timeLeftLbl,*timeLeftDescLbl,*productReturnLbl;
@property(nonatomic,retain)UITextField *returnDateTxt,*returnDurationTxt;

@property(assign)int productReturnValue;


@property(assign)int dateBtnTag;
@property(assign)int radioBtnTag;
@property(nonatomic,retain)NSString *returnDate;


@property (nonatomic, retain) UIKeyboardViewController *keyBoardController;
@property(nonatomic,retain)UILabel *returnAlert,*lblTemp2;
@property(nonatomic,retain)UITextField *returnAlertTextField;
@property(nonatomic,retain)UIImageView *returnAlertTextFieldImageView;
@property(nonatomic,retain)UIButton *returnAlertBtn;
@property(nonatomic,retain)UIImageView *returnAlertBtnImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
-(void)setImagePicker:(NSString*)imageName;
@end
@protocol myRecordTableViewCellDelegate <NSObject>
-(void)calendarOpen:(id)sender;
-(void)updateBtnMethod:(id)sender;
-(void)deleteBtnMethod:(id)sender;
-(void)setGallary:(id)sender withSenderTag:(NSInteger)tag;
-(void)setCameraImage:(id)sender withSenderTag:(NSInteger)tag;
@end
