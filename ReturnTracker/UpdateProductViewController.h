//
//  UpdateProductViewController.h
//  ReturnTracker
//
//  Created by monu on 28/11/13.
//  Copyright (c) 2013 Ranjeeta Rajput. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordData.h"
#import "AddNotesViewController.h"
#import "SettingMenuView.h"
#import "DataBaseClass.h"
#import "NotificationClass.h"

@interface UpdateProductViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate,SettingMenuDelegate>
{
    RecordData *record;
    int imageNumber;
    SettingMenuView *menuView;
    
    UIDatePicker *pickerView;
    NSArray *pickerElement;
    NSInteger selectedPickerElement;
    
    NSDateFormatter *dateFormatter;
}
@property (nonatomic, retain) NSDateFormatter *dateFormatter;
@property (nonatomic, retain) UIDatePicker *pickerView;
@property (nonatomic, retain) NSArray *pickerElement;
@property (nonatomic, assign) NSInteger selectedPickerElement;
@property (nonatomic, retain) RecordData *record;
@property (nonatomic, retain) SettingMenuView *menuView;
@property (retain, nonatomic) IBOutlet UIView *viewAdvertisement;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andRecordData:(RecordData*)recordData;
@property (retain, nonatomic) IBOutlet UIImageView *imgView1;
@property (retain, nonatomic) IBOutlet UIImageView *imgView2;
@property (retain, nonatomic) IBOutlet UIImageView *imgView3;
@property (retain, nonatomic) IBOutlet UIImageView *imgView4;
@property (retain, nonatomic) IBOutlet UITextField *txtProductName;
@property (retain, nonatomic) IBOutlet UITextField *txtReceiptNumber;
@property (retain, nonatomic) IBOutlet UITextField *txtPurchaseDate;
@property (retain, nonatomic) IBOutlet UILabel *lblReturnDate;
@property (retain, nonatomic) IBOutlet UITextField *txtReturnDays;
- (IBAction)clickedReturnDate:(id)sender;
- (IBAction)clickedReturnDays:(id)sender;
@property (retain, nonatomic) IBOutlet UILabel *lblLeftDays;
- (IBAction)clickedViewNote:(id)sender;
- (IBAction)clickedUpdate:(id)sender;
- (IBAction)clickedCancel:(id)sender;
- (IBAction)clickedImageFirst:(id)sender;
- (IBAction)clickedImageSecond:(id)sender;
- (IBAction)clickedImageThired:(id)sender;
- (IBAction)clickedImageFourth:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *btnReturnDate;
@property (retain, nonatomic) IBOutlet UIButton *btnReturnDays;
@property (retain, nonatomic) IBOutlet UIButton *btnReturned;
- (IBAction)clickedReturned:(id)sender;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollViewContent;

@property (retain, nonatomic) IBOutlet UIView *viewScroll;
- (IBAction)clickedCalenderReturnDate:(id)sender;
@property (retain, nonatomic) IBOutlet UIImageView *imgViewSmallCalender;
@property (retain, nonatomic) IBOutlet UIButton *btnSmallCalender;
- (IBAction)clickedPickerDone:(id)sender;
@property (retain, nonatomic) IBOutlet UIView *viewPickerControll;
@property (retain, nonatomic) IBOutlet UITextField *txtRemindMe;
- (IBAction)clickedPurchaseDate:(id)sender;
- (IBAction)clickedRemindMe:(id)sender;

@end
