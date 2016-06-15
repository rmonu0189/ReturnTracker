//
//  SettingViewController.h
//  ReturnTracker
//
//  Created by Ranjeeta Rajput on 08/10/13.
//  Copyright (c) 2013 Ranjeeta Rajput. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSDateFormatter *dateFormatterNotification;
}
@property (nonatomic, retain) NSDateFormatter *dateFormatterNotification;

@property (retain, nonatomic) IBOutlet UISwitch *notificationBtn;

@property (retain, nonatomic) IBOutlet UIView *notificationItemView;
@property (retain, nonatomic) IBOutlet UIView *productAlertSettingView;
@property (retain, nonatomic) IBOutlet UIScrollView *mainScrollView;




//Notification Content which may we so or not
@property (retain, nonatomic) IBOutlet UILabel *soundLbl;
@property (retain, nonatomic) IBOutlet UILabel *vibrateLbl;
@property (retain, nonatomic) IBOutlet UILabel *alertTimeLbl;
@property (retain, nonatomic) IBOutlet UISwitch *soundBtn;
@property (retain, nonatomic) IBOutlet UISwitch *vibrateBtn;@property (retain, nonatomic) IBOutlet UITextField *alertTxt;
@property (retain, nonatomic) IBOutlet UILabel *alertPeriodLbl;
- (IBAction)alertTimeClickMethod:(id)sender;
@property (retain, nonatomic) IBOutlet UILabel *alertTimeLabel;
- (IBAction)alertPeriodMethod:(id)sender;

@property (retain, nonatomic) IBOutlet UIView *viewAdvertisement;

//Default Alert View Content
@property (retain, nonatomic) IBOutlet UISwitch *defualtAlertBtn;
@property (retain, nonatomic) IBOutlet UIView *cmpnyView;
@property (retain, nonatomic) IBOutlet UITableView *cmpnyTableView;
@property (retain, nonatomic) IBOutlet UILabel *startAlertLbl;
- (IBAction)switchSound:(id)sender;
- (IBAction)switchVibration:(id)sender;
- (IBAction)switchDefaultAlert:(id)sender;

@property (retain, nonatomic) IBOutlet UIView *viewPickerController;
- (IBAction)clickedCancelPicker:(id)sender;
- (IBAction)clickedDonePicker:(id)sender;


//Product Alert Setting
@property (retain, nonatomic) IBOutlet UISwitch *soundSwitch;
@property (retain, nonatomic) IBOutlet UISwitch *vibrationSwitch;


- (IBAction)notificationBtnMethod:(id)sender;
- (IBAction)defaultAlertMethod:(id)sender;
- (IBAction)startAlertFromMethod:(id)sender;
-(void)selectedElement:(NSString*)element sender:(NSString*)sender;;
@end
