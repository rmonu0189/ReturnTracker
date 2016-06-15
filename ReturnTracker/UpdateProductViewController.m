//
//  UpdateProductViewController.m
//  ReturnTracker
//
//  Created by monu on 28/11/13.
//  Copyright (c) 2013 Ranjeeta Rajput. All rights reserved.
//

#import "UpdateProductViewController.h"

#define TABLE_MAX_SIZE 480
#define TABLE_MIN_SIZE 380

@interface UpdateProductViewController ()
{
    UIPopoverController *popover;
}
@end

@implementation UpdateProductViewController
@synthesize record;
@synthesize menuView;
@synthesize pickerElement,pickerView,selectedPickerElement;
@synthesize dateFormatter;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.transform = CGAffineTransformMakeScale([UIScreen mainScreen].applicationFrame.size.width / 320.0f, [UIScreen mainScreen].applicationFrame.size.height / 480.0f);
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andRecordData:(RecordData*)recordData
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
    }
    self.record = recordData;
    return self;
}

- (void)fillData:(RecordData*)recordData{
    self.txtProductName.text = recordData.productNameStr;
    self.txtReceiptNumber.text = recordData.receiptNumberStr;
    self.txtPurchaseDate.text = [[recordData.purchaseDateStr componentsSeparatedByString:@" "] objectAtIndex:0];
    self.lblReturnDate.text = recordData.returnDate;
    self.txtRemindMe.text=[[recordData.returnAlertDate componentsSeparatedByString:@" "] objectAtIndex:0];
    [self showReturnDateRadio];
    [self hideReturnDaysRadio];
    self.imgView1.image = [[AppDelegate sharedAppDelegate] getProductImageFromName:[NSString stringWithFormat:@"%d",recordData.productID] andImageName:@"1.png"];
    self.imgView2.image = [[AppDelegate sharedAppDelegate] getProductImageFromName:[NSString stringWithFormat:@"%d",recordData.productID] andImageName:@"2.png"];
    self.imgView3.image = [[AppDelegate sharedAppDelegate] getProductImageFromName:[NSString stringWithFormat:@"%d",recordData.productID] andImageName:@"3.png"];
    self.imgView4.image = [[AppDelegate sharedAppDelegate] getProductImageFromName:[NSString stringWithFormat:@"%d",recordData.productID] andImageName:@"4.png"];
    
    if(recordData.productReturnedStatus==1){
        self.btnReturned.selected=YES;
        self.lblLeftDays.text = @"Product returned";
    }
    else{
        self.btnReturned.selected=NO;
        self.lblLeftDays.text = [[AppDelegate sharedAppDelegate] getInterBetweenTwoDate:getCurrentDate() ReturnDate:[self.dateFormatter dateFromString:record.returnDate]];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"dd-MMM-yy HH:mm:ss"];
    
    self.scrollViewContent.frame = CGRectMake(0, 0, 320, self.viewScroll.frame.size.height);
    [self.viewScroll addSubview:self.scrollViewContent];
    [self fillData:self.record];
    
    NSArray *arrMenu = [[NSArray alloc] initWithObjects:@"Camera",@"Gallery",@"Default", nil];
    self.menuView = [[SettingMenuView alloc] initWithFrame:CGRectMake(self.imgView1.frame.origin.x, 80, 100, 132) andMenuArray:arrMenu];
    self.menuView.delegate = self;
    self.menuView.hidden=YES;
    [self.view addSubview:self.menuView];
    
    [self.view addSubview:self.viewPickerControll];
    self.viewPickerControll.center = CGPointMake(160, 240);
    self.viewPickerControll.hidden=YES;
    
    self.pickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 44.0, 0.0, 0.0)];
    self.pickerView.datePickerMode=UIDatePickerModeDate;
    [self.viewPickerControll addSubview:self.pickerView];
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    self.txtReturnDays.inputAccessoryView = numberToolbar;
}
- (void)viewWillAppear:(BOOL)animated{
    self.view.transform = CGAffineTransformMakeScale([UIScreen mainScreen].applicationFrame.size.width / 320.0f, [UIScreen mainScreen].applicationFrame.size.height / 480.0f);
}


-(void)doneWithNumberPad{
    if([self.txtReturnDays.text length]<=0){
        self.txtReturnDays.text = @"0";
    }
    NSDate *nextDate = [[dateFormatter dateFromString:self.record.purchaseDateStr] dateByAddingTimeInterval:24*60*60*[self.txtReturnDays.text integerValue]];
    self.lblReturnDate.text = [dateFormatter stringFromDate:nextDate];
    self.record.returnDate = [dateFormatter stringFromDate:nextDate];
    if(self.record.productReturnedStatus==1){
        self.lblLeftDays.text = @"Returned";
    }
    else{
        self.lblLeftDays.text = [[AppDelegate sharedAppDelegate] getInterBetweenTwoDate:getCurrentDate() ReturnDate:[self.dateFormatter dateFromString:record.returnDate]];
    }
    [self resignKeyboard];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_viewAdvertisement release];
    [_imgView1 release];
    [_imgView2 release];
    [_imgView3 release];
    [_imgView4 release];
    [_txtProductName release];
    [_txtReceiptNumber release];
    [_txtPurchaseDate release];
    [_lblReturnDate release];
    [_txtReturnDays release];
    [_lblLeftDays release];
    [_btnReturnDate release];
    [_btnReturnDays release];
    [_btnReturned release];
    [_viewScroll release];
    [_scrollViewContent release];
    [_imgViewSmallCalender release];
    [_btnSmallCalender release];
    [_viewPickerControll release];
    [_txtRemindMe release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setViewAdvertisement:nil];
    [self setImgView1:nil];
    [self setImgView2:nil];
    [self setImgView3:nil];
    [self setImgView4:nil];
    [self setTxtProductName:nil];
    [self setTxtReceiptNumber:nil];
    [self setTxtPurchaseDate:nil];
    [self setLblReturnDate:nil];
    [self setTxtReturnDays:nil];
    [self setLblLeftDays:nil];
    [self setBtnReturnDate:nil];
    [self setBtnReturnDays:nil];
    [self setBtnReturned:nil];
    [self setViewScroll:nil];
    [self setScrollViewContent:nil];
    [self setImgViewSmallCalender:nil];
    [self setBtnSmallCalender:nil];
    [self setViewPickerControll:nil];
    [self setTxtRemindMe:nil];
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

- (void)resignKeyboard{
    [self.txtProductName resignFirstResponder];
    [self.txtReceiptNumber resignFirstResponder];
    [self.txtReturnDays resignFirstResponder];
    [self.scrollViewContent setContentSize:CGSizeMake(320, TABLE_MIN_SIZE)];
    [self.scrollViewContent setContentOffset:CGPointMake(0, 0)];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self resignKeyboard];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if([textField isEqual:self.txtReturnDays]){
        [self.scrollViewContent setContentSize:CGSizeMake(320, TABLE_MAX_SIZE)];
        [self.scrollViewContent setContentOffset:CGPointMake(0, 50)];
    }
}

- (void)hideReturnDateRadio{
    self.btnReturnDate.selected = NO;
    self.lblReturnDate.hidden=YES;
    self.imgViewSmallCalender.hidden=YES;
    self.btnSmallCalender.hidden=YES;
}

- (void)showReturnDateRadio{
    self.btnReturnDate.selected = YES;
    self.lblReturnDate.hidden=NO;
    self.imgViewSmallCalender.hidden=NO;
    self.btnSmallCalender.hidden=NO;
}

- (void)hideReturnDaysRadio{
    self.btnReturnDays.selected=NO;
    self.txtReturnDays.hidden=YES;
}

- (void)showReturnDaysRadio{
    self.btnReturnDays.selected=YES;
    self.txtReturnDays.hidden=NO;
}

- (IBAction)clickedReturnDate:(id)sender {
    [self showReturnDateRadio];
    [self hideReturnDaysRadio];
}

- (IBAction)clickedReturnDays:(id)sender {
    [self hideReturnDateRadio];
    [self showReturnDaysRadio];
    self.txtReturnDays.text = [NSString stringWithFormat:@"%d",getIntervalBetween([dateFormatter dateFromString:self.record.purchaseDateStr], [dateFormatter dateFromString:self.record.returnDate])];
}

- (IBAction)clickedViewNote:(id)sender {
    NSString *shopName = @"";
    AddNotesViewController *addNotesView=[[AddNotesViewController alloc]initWithNibName:@"AddNotesViewController" bundle:nil currentDate:[NSString stringWithFormat:@"%@",getCurrentDate()] productName:record.productNameStr shopName:shopName purchaseDate:record.purchaseDateStr returnDate:record.returnDate image:record.img1  withAddNotesStr:record.notes] ;
    addNotesView.delegate=self;
    [self presentModalViewController:addNotesView animated:YES];
}

- (BOOL)validate{
    BOOL isValidate = YES;
    if([self.txtProductName.text length]<=0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please enter product name." delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return NO;
    }
    else if([self.txtReceiptNumber.text length]<=0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please enter receipt number." delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return NO;
    }
    else if([self.txtPurchaseDate.text length]<=0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please select purchase date." delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return NO;
    }
    else if([self.lblReturnDate.text length]<=0 && [self.txtReturnDays.text length]<=0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please select return date or duration." delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return NO;
    }
    return isValidate;
}

- (IBAction)clickedUpdate:(id)sender {
    if(![self validate]){
        return;
    }
    if(![self.record.receiptNumberStr isEqualToString:self.txtReceiptNumber.text]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"You can not change receipt number." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        self.txtReceiptNumber.text = self.record.receiptNumberStr;
        return;
    }
    self.record.productNameStr = self.txtProductName.text;
//    self.record.img1 = self.imgView1.image;
//    self.record.img2 = self.imgView2.image;
//    self.record.img3 = self.imgView3.image;
//    self.record.img4 = self.imgView4.image;
    //self.record.returnAlertDate=self.txtRemindMe.text;
    [[AppDelegate sharedAppDelegate] startActivityIndicatorAnimationWithMsg:@"Wait"];
    //******It Will Replace by submitSelector Method*********/
    [self performSelector:@selector(submitSelector) withObject:nil afterDelay:2.0f];
}


-(void)submitSelector
{
    BOOL success=[[DataBaseClass getSharedInstance]updateData:self.record];
    NSString *alrtMsg;
    if (success) {
        if(self.imgView1.image){
            [[AppDelegate sharedAppDelegate] saveProductImageWithName:@"1.png" andImage:self.imgView1.image andProductID:[NSString stringWithFormat:@"%d",self.record.productID]];
        }
        if(self.imgView2.image){
            [[AppDelegate sharedAppDelegate] saveProductImageWithName:@"2.png" andImage:self.imgView1.image andProductID:[NSString stringWithFormat:@"%d",self.record.productID]];
        }
        if(self.imgView3.image){
            [[AppDelegate sharedAppDelegate] saveProductImageWithName:@"3.png" andImage:self.imgView1.image andProductID:[NSString stringWithFormat:@"%d",self.record.productID]];
        }
        if(self.imgView4.image){
            [[AppDelegate sharedAppDelegate] saveProductImageWithName:@"4.png" andImage:self.imgView1.image andProductID:[NSString stringWithFormat:@"%d",self.record.productID]];
        }
        alrtMsg=@"Details has been updated successfully.";
        NotificationClass *noti = [[NotificationClass alloc] init];
        [noti cancelNotificationWithReceiptNumber:[NSString stringWithFormat:@"%i",self.record.productID]];
        if ([AppDelegate sharedAppDelegate].notificationIsOn) {
            //[self notification:records.returnDate purchaseDate:records.purchaseDateStr];
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:record.receiptNumberStr forKey:@"receiptNumber"];
            [dict setValue:record.productNameStr forKey:@"productName"];
            [dict setValue:[NSString stringWithFormat:@"%i",self.record.productID] forKey:@"productId"];
            [dict setValue:[[AppDelegate sharedAppDelegate] getShopNameWithID:record.shopID] forKey:@"companyName"];
            NotificationClass *notificationObj = [[NotificationClass alloc] init];
            [notificationObj setNotificationWithPurchaseDate:[dateFormatter dateFromString:record.purchaseDateStr] ReturnDate:[dateFormatter dateFromString:record.returnDate] msgDictionary:dict];
            if([record.returnAlertDate length]>0){
                [notificationObj addNotificationWithDate:[dateFormatter dateFromString:record.returnAlertDate] ReturnDate:[dateFormatter dateFromString:record.returnDate] andDictionar:dict];
            }
            [notificationObj release];
        }
        [self dismissModalViewControllerAnimated:YES];
    }
    else
    {
        alrtMsg=@"ther should we some error";
    }
    [[AppDelegate sharedAppDelegate] endActivityIndicatorAnimation];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:alrtMsg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
    [alert release];
    
}

- (IBAction)clickedCancel:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)clickedImageFirst:(id)sender {
    imageNumber=1;
    self.menuView.hidden=NO;
}

- (IBAction)clickedImageSecond:(id)sender {
    imageNumber=2;
    self.menuView.hidden=NO;
}

- (IBAction)clickedImageThired:(id)sender {
    imageNumber=3;
    self.menuView.hidden=NO;
}

- (IBAction)clickedImageFourth:(id)sender {
    imageNumber=4;
    self.menuView.hidden=NO;
}

- (void)selectMenuAtIndex:(int)index{
    self.menuView.hidden=YES;
    if(index==0){
        [self showImagePickerView:@"Camera"];
    }
    else if(index==1){
        [self showImagePickerView:@"Gallery"];
    }
    else if(index==2){
        [self setImageAtIndex:[UIImage imageNamed:@"defaultLogo.png"]];
    }
}

- (void)clickeOutSideFromMenu{
    self.menuView.hidden=YES;
}

- (void)setImageAtIndex:(UIImage*)img{
    self.menuView.hidden=YES;
    if(imageNumber==1){
        self.imgView1.image=img;
    }
    else if(imageNumber==2){
        self.imgView2.image=img;
    }
    else if(imageNumber==3){
        self.imgView3.image=img;
    }
    else if(imageNumber==4){
        self.imgView4.image=img;
    }
}

#pragma mark - ImagePicker Delegate Method

// This method createImage Picker Controller delegate methods
-(void)imagePickerController:(UIImagePickerController *)picker  didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissModalViewControllerAnimated:YES];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        [popover dismissPopoverAnimated:YES];
    }
    [self setImageAtIndex:scaleImage([info objectForKey:@"UIImagePickerControllerOriginalImage"], 500)];
}

// This method cancel the imagepicker object
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        [popover dismissPopoverAnimated:YES];
    }
}

- (void)showImagePickerView:(NSString*)pickerType{
    UIImagePickerController *picker=[[UIImagePickerController alloc]init];
    picker.delegate=self;
    picker.allowsEditing=YES;
    if([pickerType isEqualToString:@"Camera"]){
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        else{
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
    }
    else{
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        popover = [[UIPopoverController alloc] initWithContentViewController:picker];
        popover.delegate=self;
        [popover presentPopoverFromRect:CGRectMake(10, 40, 100, 400.0)
                                 inView:self.view
               permittedArrowDirections:UIPopoverArrowDirectionAny
                               animated:YES];
    } else {
        [self presentViewController:picker animated:YES completion:NULL ];
    }

   // [self presentModalViewController:picker animated:YES];
    [picker release];
}

- (IBAction)clickedReturned:(id)sender {
    UIButton *tmp = (UIButton*)sender;
    if(tmp.selected){
        tmp.selected=NO;
        self.lblLeftDays.text = [[AppDelegate sharedAppDelegate] getInterBetweenTwoDate:getCurrentDate() ReturnDate:[dateFormatter dateFromString:self.record.returnDate]];
        self.record.productReturnedStatus=0;
    }
    else{
        tmp.selected=YES;
        self.lblLeftDays.text = @"Product returned";
        self.record.productReturnedStatus=1;
    }
}
- (IBAction)clickedCalenderReturnDate:(id)sender {
    [self resignKeyboard];
    self.viewPickerControll.hidden=NO;
    self.selectedPickerElement=2;
    self.pickerView.maximumDate=nil;
    if([self.record.purchaseDateStr length]>0){
        self.pickerView.minimumDate = [self.dateFormatter dateFromString:self.record.purchaseDateStr];
    }
    else{
        self.pickerView.minimumDate = getCurrentDate();
    }
    self.pickerView.date = [self.dateFormatter dateFromString:self.record.returnDate];
}

- (IBAction)clickedPickerDone:(id)sender {
    self.viewPickerControll.hidden=YES;
    if(self.selectedPickerElement==2){
        self.record.returnDate = [self.dateFormatter stringFromDate:self.pickerView.date];
        self.lblReturnDate.text = [self.dateFormatter stringFromDate:self.pickerView.date];
        self.lblLeftDays.text = [[AppDelegate sharedAppDelegate] getInterBetweenTwoDate:getCurrentDate() ReturnDate:[dateFormatter dateFromString:self.record.returnDate]];
        
    }
    else if(self.selectedPickerElement==1){
        self.record.purchaseDateStr = [self.dateFormatter stringFromDate:self.pickerView.date];
        self.txtPurchaseDate.text = [[[self.dateFormatter stringFromDate:self.pickerView.date] componentsSeparatedByString:@" "] objectAtIndex:0];
    }
    else if(self.selectedPickerElement==3){
        self.record.returnAlertDate=[self.dateFormatter stringFromDate:self.pickerView.date];
        self.txtRemindMe.text = [[[self.dateFormatter stringFromDate:self.pickerView.date] componentsSeparatedByString:@" "] objectAtIndex:0];
    }
}
- (IBAction)clickedPurchaseDate:(id)sender {
    [self resignKeyboard];
    self.viewPickerControll.hidden=NO;
    self.selectedPickerElement=1;
    self.pickerView.minimumDate=nil;
    self.pickerView.maximumDate = getCurrentDate();
    self.pickerView.date = [self.dateFormatter dateFromString:self.record.purchaseDateStr];
}

- (IBAction)clickedRemindMe:(id)sender {
    [self resignKeyboard];
    self.viewPickerControll.hidden=NO;
    self.selectedPickerElement=3;
    self.pickerView.minimumDate = [self.dateFormatter dateFromString:self.record.purchaseDateStr];
    self.pickerView.maximumDate = [self.dateFormatter dateFromString:self.record.returnDate];
    self.pickerView.date = getCurrentDate();
}

//Method call by AddNotesViewController
-(void)assingAddNote:(NSString*)note
{
    
    self.record.notes =[[NSString alloc]initWithString:note];
}
@end
