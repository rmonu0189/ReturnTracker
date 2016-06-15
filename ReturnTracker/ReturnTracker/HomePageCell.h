//
//  HomePageCell.h
//  Return Tracker
//
//  Created by Ranjeeta Rajput on 05/10/13.
//  Copyright (c) 2013 Ranjeeta Rajput. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIKeyboardViewController.h"
#import "RecordData.h"
@protocol HomePageCellDelegate;

@interface HomePageCell : UITableViewCell<UIKeyboardViewControllerDelegate,UIActionSheetDelegate>
{
    id <HomePageCellDelegate> delegate;
    UIView *mainView,*imageViw,*itemView;
    //********Main View Item*********
   
    //image view item
    UIImageView *backImage,*firstImageView,*secondImageView,*thirdImageView,*fourthImageView;
    UIButton *cameraBtn,*gallaryBtn;
    UILabel *imageViewHdr;
    
    
    //item View content
    UITextField *productNameTxt;
    UITextField *receiptNoTxt;
    UITextField *purchaseDateTxt;
    UILabel *returnDateLbl,*returnDurationLbl;
    UIButton *returnDateRadioBtn,*returnDurationRadioBtn,*calendarBtn,*calendarBtn2;
    UIImageView *returnDateImgView,*returnDurationImgView,*returnDateTxtImag,*returnDurationTxtImg;
    UITextField *returnDateTxt,*returnDurationTxt;
    //
    UILabel *addNoteLbl,*timeLeftLbl,*timeLeftDescLbl;

    UIButton *clearBtn,*submitBtn;
    UIImageView *addNoteImg;
    UIButton *addNoteBtn;
    UIButton *image1Btn,*image2Btn,*image3Btn,*image4Btn;
    int dateBtnTag;
    int radioBtnTag;
    id viewControllerDelegate;

    UILabel *lblTemp,*lblTemp2;
    
    UILabel *returnAlert;
    UITextField *returnAlertTextField;
    UIImageView *returnAlertTextFieldImageView;
    UIButton *returnAlertBtn;
    UIImageView *returnAlertBtnImage;
}
@property (nonatomic,retain) UILabel *lblTemp,*lblTemp2;
@property(nonatomic,assign)id viewControllerDelegate;

@property(nonatomic,assign)id <HomePageCellDelegate> delegate;
@property(nonatomic,retain)UITextField *productNameTxt,*receiptNoTxt,*purchaseDateTxt,*returnDateTxt,*returnDurationTxt;

@property(nonatomic,retain)UIView *mainView,*imageViw,*itemView;
@property(nonatomic,retain)UIImageView *backImage,*firstImageView,*secondImageView,*thirdImageView,*fourthImageView,*addNoteImg,*returnDateImgView,*returnDurationImgView,*returnDateTxtImag,*returnDurationTxtImg;
@property(nonatomic,retain)UIButton *cameraBtn,*gallaryBtn,*clearBtn,*submitBtn,*calendarBtn,*addNoteBtn,*returnDateRadioBtn,*returnDurationRadioBtn,*calendarBtn2,*image1Btn,*image2Btn,*image3Btn,*image4Btn;
@property(nonatomic,retain)UILabel *imageViewHdr,*returnDateLbl,*returnDurationLbl,*addNoteLbl,*timeLeftLbl,*timeLeftDescLbl;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withDelegate:(id)delgate;


//
@property(assign)int dateBtnTag;
@property(assign)int radioBtnTag;
@property(nonatomic,retain)NSString *returnDate;

@property(nonatomic,retain)UILabel *returnAlert;
@property(nonatomic,retain)UITextField *returnAlertTextField;
@property(nonatomic,retain)UIImageView *returnAlertTextFieldImageView;
@property(nonatomic,retain)UIButton *returnAlertBtn;
@property(nonatomic,retain)UIImageView *returnAlertBtnImage;

@end


@protocol HomePageCellDelegate <NSObject>


@optional
-(void)setCameraImage:(id)sender withSenderTag:(NSInteger)tag;
-(void)addNotesClick:(id)sender;
-(void)calendarOpen:(id)sender;
-(void)setGallary:(id)sender withSenderTag:(NSInteger)tag;
-(void)submitBtnClick:(id)sender;
-(void)clearCellField;
//-(void)keyboardHightChange;
@end


