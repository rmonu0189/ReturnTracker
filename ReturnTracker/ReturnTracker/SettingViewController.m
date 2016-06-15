//
//  SettingViewController.m
//  ReturnTracker
//
//  Created by Ranjeeta Rajput on 08/10/13.
//  Copyright (c) 2013 Ranjeeta Rajput. All rights reserved.
//

#import "SettingViewController.h"
#import "SettinTableViewCell.h"
#import "StoreData.h"
#import "NotificationClass.h"
#import "DataBaseClass.h"

@interface SettingViewController ()
{
    UIActionSheet *actionSheet;
    UIDatePicker *datePickerView;
    
    //Picker Controller
    NSInteger pressBtnTag;
    UIActionSheet *pickerActionSheet;
    UIPickerView *durationPicker;
    NSArray *dayCountArray;

    BOOL alertTimeFlag;
}
@end

@implementation SettingViewController
@synthesize notificationBtn,notificationItemView,productAlertSettingView,mainScrollView,defualtAlertBtn,soundBtn,vibrateBtn,cmpnyTableView,cmpnyView,alertTimeLabel,alertPeriodLbl,startAlertLbl;
@synthesize dateFormatterNotification;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Setting", @"Setting");
        self.tabBarItem.image = [UIImage imageNamed:@"setting-icon.png"];
         self.view.transform = CGAffineTransformMakeScale([UIScreen mainScreen].applicationFrame.size.width / 320.0f, [UIScreen mainScreen].applicationFrame.size.height / 480.0f);

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dateFormatterNotification = [[NSDateFormatter alloc] init];
    [self.dateFormatterNotification setDateFormat:@"dd-MMM-yy HH:mm:ss"];
    dayCountArray=[[NSArray alloc]initWithObjects:@"1",@"2", @"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",nil];

    
    if (notificationBtn.isOn) {
        [AppDelegate sharedAppDelegate].notificationIsOn=YES;
               
    }
    else
    {
        [AppDelegate sharedAppDelegate].notificationIsOn=NO;
        
    }
    [self.view addSubview:self.viewPickerController];
    self.viewPickerController.center = CGPointMake(160, 240);
    self.viewPickerController.hidden=YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if([[AppDelegate sharedAppDelegate] getOsVersion] == 7){
        [self.viewAdvertisement setFrame:CGRectMake(0, 398, 320, 50)];
    }
    [[AppDelegate sharedAppDelegate] showAdvertisement:self.viewAdvertisement];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    [[AppDelegate sharedAppDelegate] hideAdvertisement];
}

-(void)selectedElement:(NSString*)element sender:(NSString*)sender;
{
    if ([sender isEqualToString:@"alertTimeLabel"]) {
        [alertTimeLabel setText:element];
    }
    if ([sender isEqualToString:@"alertPeriodLabel"]) {
        [alertPeriodLbl setText:element];
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [self.dateFormatterNotification release];
    [dayCountArray release];
    [notificationBtn release];
    [notificationItemView release];
    [productAlertSettingView release];
    [mainScrollView release];
    [_soundLbl release];
    [_vibrateLbl release];
    [_alertTimeLbl release];
    [soundBtn release];
    [vibrateBtn release];
    [defualtAlertBtn release];
    [cmpnyView release];
    [cmpnyTableView release];
    [alertTimeLabel release];
    [alertPeriodLbl release];
    [startAlertLbl release];
    [_viewAdvertisement release];
    [_viewPickerController release];
    [_soundSwitch release];
    [_vibrationSwitch release];
    [super dealloc];
}

- (IBAction)notificationBtnMethod:(id)sender {
    if (notificationBtn.isOn) {
        [AppDelegate sharedAppDelegate].notificationIsOn=YES;
        [[AppDelegate sharedAppDelegate] startActivityIndicatorAnimationWithMsg:@"Wait"];
        [self performSelectorInBackground:@selector(addAllNotificationFromRecord) withObject:nil];
    }
    else
    {
        [AppDelegate sharedAppDelegate].notificationIsOn=NO;
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }

}

-(void)changeNoOfDays
{
    [[AppDelegate sharedAppDelegate] startActivityIndicatorAnimationWithMsg:@"Wait"];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [self performSelectorInBackground:@selector(addAllNotificationFromRecord) withObject:nil];
}

- (void)addAllNotificationFromRecord{
    for (int i=0; i<[[DataBaseClass getSharedInstance].arrRecord count]; i++) {
        RecordData *recordData = [[[RecordData alloc] init] autorelease];
        recordData = [[DataBaseClass getSharedInstance].arrRecord objectAtIndex:i];
        NotificationClass *noti = [[NotificationClass alloc] init];
        noti.isSettingClass=YES;
        NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
        [dict setValue:recordData.receiptNumberStr forKey:@"receiptNumber"];
        [dict setValue:recordData.productNameStr forKey:@"productName"];
        [dict setValue:[NSString stringWithFormat:@"%i",recordData.productID] forKey:@"productId"];
        [dict setValue:[[AppDelegate sharedAppDelegate] getShopNameWithID:recordData.shopID] forKey:@"companyName"];
        [noti setNotificationWithPurchaseDate:[noti getDateWithDefaultTime:[self.dateFormatterNotification dateFromString:recordData.purchaseDateStr]] ReturnDate:[noti getDateWithDefaultTime:[self.dateFormatterNotification dateFromString:recordData.returnDate]] msgDictionary:dict];
        if([recordData.returnAlertDate length]>0){
            [noti addNotificationWithDate:[self.dateFormatterNotification dateFromString:recordData.returnAlertDate] ReturnDate:[self.dateFormatterNotification dateFromString:recordData.returnDate] andDictionar:dict];
        }
        [noti release];
    }
    [[AppDelegate sharedAppDelegate] endActivityIndicatorAnimation];
}

//Start Alert Method
- (IBAction)startAlertFromMethod:(id)sender {
    UIButton *btn=(UIButton*)sender;
    [self pickerOpenWithTag:btn.tag];

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[AppDelegate sharedAppDelegate].cellItemArr count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
       static NSString *cellIdentifier=@"cell";
    SettinTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell=[[SettinTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    StoreData *cellData=(StoreData*)[[AppDelegate sharedAppDelegate].cellItemArr objectAtIndex:indexPath.row];
    [cell.iconImageView setImage:[UIImage imageNamed:cellData.imagePath]];
    [cell setSelected:NO];
    [cell.titleLbl setText:cellData.shopName];
    cell.selectionStyle= UITableViewCellSelectionStyleNone;
    [cell.alertPeriodLbl setText:@"Alert Period"];
    [cell.alertPeriodBtn setTag:indexPath.row+3];
    [cell.alertPeriodBtn addTarget:self action:@selector(alertPeriodBtnClick:) forControlEvents:UIControlEventTouchUpInside];
   
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58;
}

//Table View Btn
-(void)alertPeriodBtnClick:(id)sender
{
    UIButton *btn=(UIButton*)sender;
     [self pickerOpenWithTag:btn.tag];
}
- (IBAction)alertTimeClickMethod:(id)sender {
    //UIButton *btn=(UIButton*)sender;
    actionSheet = [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n\n" delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    [actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    
    CGRect pickerFrame = CGRectMake(0, 40, 0, 0);
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter1 setDateFormat:@"HH:mm:ss"];
    if(!datePickerView){
        datePickerView = [[UIDatePicker alloc] initWithFrame:pickerFrame];
        [datePickerView addTarget:self action:@selector(changeDate:) forControlEvents:UIControlEventValueChanged];
        [self.viewPickerController addSubview:datePickerView];
    }
    datePickerView.tag = 10;
    [datePickerView setDatePickerMode:UIDatePickerModeTime];
    [datePickerView setTimeZone:[NSTimeZone localTimeZone]];
    [datePickerView setDate:[dateFormatter1 dateFromString:alertTimeLabel.text]];
    //[actionSheet addSubview:datePickerView];
    
    durationPicker.hidden=YES;
    datePickerView.hidden=NO;
    self.viewPickerController.hidden=NO;
    
    
//    UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Done"]];
//    closeButton.momentary = YES;
//    closeButton.frame = CGRectMake(15, 7.0f, 50.0f, 30.0f);
//    closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
//    closeButton.tintColor = [UIColor blackColor];
//    [closeButton addTarget:self action:@selector(dismissActionSheet:) forControlEvents:UIControlEventValueChanged];
//    [actionSheet addSubview:closeButton];
//    [closeButton release];
    
    
    
    UISegmentedControl *doneBtn = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Done"]];
    doneBtn.momentary = YES;
    doneBtn.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
    doneBtn.segmentedControlStyle = UISegmentedControlStyleBar;
    doneBtn.tintColor = [UIColor blackColor];
    [doneBtn addTarget:self action:@selector(dismissActionSheet:) forControlEvents:UIControlEventValueChanged];
    [actionSheet addSubview:doneBtn];
    [doneBtn release];
    //CGRect myImageRect = CGRectMake(0.0f, 300.0f, 320.0f, 175.0f);
//    [actionSheet showFromTabBar:self.tabBarController.tabBar];
//    
//    [UIView beginAnimations:nil context:nil];
//    
    
//    if ([[[UIDevice currentDevice] model] hasPrefix:@"iPad"]) {
//        // This app is an iPhone app running on an iPad
//        
//        [actionSheet showFromRect:CGRectMake(0, 300, 320, 600) inView:self.view animated:YES];
//        [datePickerView setFrame:CGRectMake(-30, 40, 0, 90)];
//        doneBtn.frame = CGRectMake(220, 7.0f, 50.0f, 30.0f);
//    }
    //ActionSheet Custom scaling
    
   
//    if([self interfaceOrientation] == UIInterfaceOrientationPortraitUpsideDown || [self interfaceOrientation] == UIInterfaceOrientationPortrait)
//        [actionSheet showFromRect:CGRectMake(0, 300, 320, 600) inView:self.view animated:YES];
//    else
//        [actionSheet setBounds:CGRectMake(0,0,480, 400)];
//    
//    [UIView commitAnimations];
    



   
}
- (void)changeDate:(UIDatePicker *)sender {
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"HH:mm:ss"];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *timeComponents = [calendar components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:datePickerView.date];
    [timeComponents setSecond:0.0];
    
    NSDate *newDate = [calendar dateFromComponents:timeComponents];
    
    [alertTimeLabel setText:[outputFormatter stringFromDate:newDate]];
    [AppDelegate sharedAppDelegate].defualtTimeStr=[NSString stringWithFormat:@"%@",[outputFormatter stringFromDate:newDate]];
    [outputFormatter release];
}

-(void)dismissActionSheet:(id)sender
{
    [self changeNoOfDays];
    //[datePickerView removeFromSuperview];
    //[actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}
 
- (IBAction)alertPeriodMethod:(id)sender {
    UIButton *btn=(UIButton*)sender;
    [self pickerOpenWithTag:btn.tag];
}

-(void)pickerOpenWithTag:(NSInteger)tag
{
    //Assing which btn tag is click
    pressBtnTag=tag;
    
    //ran change
    if (!pickerActionSheet) {
        pickerActionSheet = [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n\n" delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        
        [pickerActionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    }
    
    
    if (!durationPicker) {
        CGRect pickerFrame = CGRectMake(0, 40, 0, 0);
        
        durationPicker = [[UIPickerView alloc] initWithFrame:pickerFrame];
        durationPicker.showsSelectionIndicator=YES;
        [durationPicker selectRow:1 inComponent:0 animated:NO];
        [self.viewPickerController addSubview:durationPicker];
        //durationPicker.backgroundColor = [UIColor whiteColor];
        durationPicker.center = CGPointMake(self.viewPickerController.center.x, 147);
    }
    durationPicker.hidden=NO;
    datePickerView.hidden=YES;
    self.viewPickerController.hidden=NO;
    [durationPicker setDataSource:self];
    [durationPicker setDelegate:self];
    //[pickerActionSheet addSubview:durationPicker];
    if (tag==1) {
        [durationPicker selectRow:[[AppDelegate sharedAppDelegate].defaultDaysStr integerValue]-1 inComponent:0 animated:NO];
        //[durationPicker sel]
    }
    else if (tag==2) {
        [durationPicker selectRow:[[AppDelegate sharedAppDelegate].startAlertFromStr integerValue]-1 inComponent:0 animated:NO];
    }
    UISegmentedControl *doneBtn = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Done"]];
    doneBtn.momentary = YES;
    doneBtn.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
    doneBtn.segmentedControlStyle = UISegmentedControlStyleBar;
    doneBtn.tintColor = [UIColor blackColor];
    [doneBtn addTarget:self action:@selector(dismissDurationPickerActionSheet:) forControlEvents:UIControlEventValueChanged];
    [pickerActionSheet addSubview:doneBtn];
    [doneBtn release];
    
    
    //ran change
    //[pickerActionSheet showFromTabBar:self.tabBarController.tabBar];
    //[UIView beginAnimations:nil context:nil];
    
    
//    if ([[[UIDevice currentDevice] model] hasPrefix:@"iPad"]) {
//        // This app is an iPhone app running on an iPad
//        [pickerActionSheet showFromRect:CGRectMake(30, 300, 320, 600) inView:self.view animated:YES];
//        [durationPicker setFrame:CGRectMake(0, 40, 0,0)];
//        doneBtn.frame = CGRectMake(220, 7.0f, 50.0f, 30.0f);
//        
//        
//        //        [durationPicker setFrame:CGRectMake(-30, 40, 0, 0)];
//        //        closeButton.frame = CGRectMake(220, 7.0f, 50.0f, 30.0f);
//    }
    
}

-(void)dismissDurationPickerActionSheet:(id)sender
{
    [self changeNoOfDays];
    //[durationPicker removeFromSuperview];
    //[pickerActionSheet dismissWithClickedButtonIndex:0 animated:YES];
    
    
}


//Picker View Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
	return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if (pressBtnTag==1) {
        [alertPeriodLbl setText:[NSString stringWithFormat:@"%@ days before return",[dayCountArray  objectAtIndex:row]]];
        [AppDelegate sharedAppDelegate].defaultDaysStr=[dayCountArray  objectAtIndex:row];
    }
    else if (pressBtnTag==2)
    {
         [startAlertLbl setText:[NSString stringWithFormat:@"%@ days before return",[dayCountArray  objectAtIndex:row]]];
        [AppDelegate sharedAppDelegate].startAlertFromStr=[dayCountArray objectAtIndex:row];
    }


}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
	return [dayCountArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    //ran change
    if ([[dayCountArray objectAtIndex:row] integerValue]==1) {
        return [NSString stringWithFormat:@"%@ day before return",[dayCountArray objectAtIndex:row]];
    }
    
	return [NSString stringWithFormat:@"%@ days before return",[dayCountArray objectAtIndex:row]];
}

- (void)viewDidUnload {

    [self setViewAdvertisement:nil];
    [self setViewPickerController:nil];
    [self setSoundSwitch:nil];
    [self setVibrationSwitch:nil];
    [super viewDidUnload];
}

-(BOOL)prefersStatusBarHidden {
    if ([[AppDelegate sharedAppDelegate]getOsVersion]==7) {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark - Switch IBAction method
- (IBAction)switchSound:(id)sender {
    if ([sender isOn]) {
        [AppDelegate sharedAppDelegate].isSoundButtonOn=YES;
    }
    else {
        [AppDelegate sharedAppDelegate].isSoundButtonOn=NO;
    }
    [self changeNoOfDays];
}

- (IBAction)switchVibration:(id)sender {
    if ([sender isOn]) {
        [AppDelegate sharedAppDelegate].isVibrationButtonOn=YES;
    }
    else {
        [AppDelegate sharedAppDelegate].isVibrationButtonOn=NO;
    }
    [self changeNoOfDays];
}

- (IBAction)switchDefaultAlert:(id)sender {
    if ([sender isOn]) {
        [AppDelegate sharedAppDelegate].isDefaultAlert=YES;
        self.soundSwitch.enabled = NO;
        self.vibrationSwitch.enabled = NO;
    }
    else {
        [AppDelegate sharedAppDelegate].isDefaultAlert=NO;
        self.soundSwitch.enabled = YES;
        self.vibrationSwitch.enabled = YES;
    }
    [self changeNoOfDays];
}
- (IBAction)clickedCancelPicker:(id)sender {
    self.viewPickerController.hidden=YES;
}

- (IBAction)clickedDonePicker:(id)sender {
    self.viewPickerController.hidden=YES;
    [self changeNoOfDays];
    
}
@end
