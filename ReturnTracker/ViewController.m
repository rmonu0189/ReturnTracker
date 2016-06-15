         //
//  ViewController.m
//  Return Tracker
//
//  Created by Ranjeeta Rajput on 05/10/13.
//  Copyright (c) 2013 Ranjeeta Rajput. All rights reserved.
//

#import "ViewController.h"
//#import "DataBaseClass.h"

@interface ViewController ()
{
    //When we press Section Btn this method controlling which row showing and hiding
    int didSelected;
    HomePageCell *obj;
    NSMutableArray *mainSectionElementArray;
    NSInteger selectedIndex;
    UIActionSheet *aac;
    UIDatePicker *theDatePicker;
    NSString *dateString1;
    //For Stroing Images
    UIPopoverController *popover;
    NSMutableArray *imageArray;
    NSInteger btnTag;
    BOOL isSelect;
    CGPoint currentOffset;
    SettingMenuView *settingView ;//for set frame when click on section btn
    //UIView *longPressMenuView;
    SettingMenuView *menuView;
}
@end

@implementation ViewController
@synthesize addNotesStr;
@synthesize viewControllerDelegate;
@synthesize homePageTableView;
@synthesize tableScrollView;
@synthesize pickerNumber;
@synthesize pickDateFormatter,pickerView;
HomePageCell *cell;

#pragma mark - UIViewController delegate method
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Home", @"Home");
        self.tabBarItem.image = [UIImage imageNamed:@"Home"];
        
        self.view.transform = CGAffineTransformMakeScale([UIScreen mainScreen].applicationFrame.size.width / 320.0f, [UIScreen mainScreen].applicationFrame.size.height / 480.0f);
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([mainSectionElementArray count]>0) {
        [mainSectionElementArray removeAllObjects];
    }
    for (StoreData *data in [AppDelegate sharedAppDelegate].cellItemArr) {
        [mainSectionElementArray addObject:data];
    }
    [self shortAsPerFavourite];
    [self showAllNotification];
}

- (void)showAllNotification{
    for(UILocalNotification *local in [[UIApplication sharedApplication] scheduledLocalNotifications]){
        NSLog(@"*******************************************");
        NSLog(@"%@",local.userInfo);
        NSLog(@"Fire date: %@",local.fireDate);
        NSLog(@"*******************************************\n\n");
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if([[AppDelegate sharedAppDelegate] getOsVersion] == 7){
        [self.viewAdvertisement setFrame:CGRectMake(0, 398, 320, 50)];
    }
    [[AppDelegate sharedAppDelegate] showAdvertisement:self.viewAdvertisement];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear: animated];
    [[AppDelegate sharedAppDelegate] hideAdvertisement];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.pickDateFormatter = [[NSDateFormatter alloc] init];
    [self.pickDateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [self.pickDateFormatter setDateFormat:@"dd-MMM-yy HH:mm:ss"];
    
    [self.view addSubview:self.viewPickDate];
    self.viewPickDate.center = CGPointMake(160, 240);
    self.viewPickDate.hidden=YES;
    
    self.pickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 44.0, 0.0, 0.0)];
    self.pickerView.datePickerMode=UIDatePickerModeDate;
    [self.viewPickDate addSubview:self.pickerView];
    
    
    
    didSelected=8999;
    [DataBaseClass getSharedInstance].delegate=self;
    [tableScrollView setScrollEnabled:NO];
    //[AppDelegate sharedAppDelegate].cellItemArr=[[NSMutableArray alloc]init];
    
    //AddNotes defualt value
    addNotesStr=@"";
    //This array contains section data
//    NSArray *icon,*title,*subTitle;
//    icon=[[NSArray alloc]initWithObjects:@"amazon-logo",@"bestbuy_logo",@"kohls-logo",@"costco_logo",@"macys_logo",@"marshalls_logo",@"overstock_logo", nil];
//    title=[[NSArray alloc]initWithObjects:@"Amazon.com",@"Best Buy",@"Kohl's",@"Costco",@"Macys",@"Marshalls",@"OverStock", nil];
//    subTitle=[[NSArray alloc]initWithObjects:@"Amazon's customer service with  24X7 support...... ",@"Best Buy  customer service with  24X7 support...... ",@"Kohl's  customer service with  24X7 support...... ",@"Costco  customer service with  24X7 support...... ",@"Macys's customer service with  24X7 support...... ",@"Marshalls  customer service with  24X7 support...... ",@"OverStock's  customer service with  24X7 support...... ", nil];
    imageArray=[[NSMutableArray alloc]init];
    mainSectionElementArray=[[NSMutableArray alloc]init];
      for (StoreData *record in [AppDelegate sharedAppDelegate].cellItemArr) {
        [mainSectionElementArray addObject:record];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(keyBoardHide)];
    [self.bannerImageView setUserInteractionEnabled:YES];
    [self.bannerImageView addGestureRecognizer:tap];
    
    if ([[AppDelegate sharedAppDelegate]getOsVersion]==7) {
        self.searchBar.placeholder = @"Search stores....                                       ";
    }
    else
    {
        self.searchBar.placeholder = @"Search stores....";
    }

}

-(void)keyBoardHide
{
    [self.view endEditing:YES];
//    if (menuView) {
//        [menuView removeFromSuperview];
//        [menuView release];
//        menuView=nil;
//    }
//    
    

    
}
#pragma mark - SearchBar Delegate Method

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [homePageTableView setContentOffset:CGPointMake(0, 0)];
    isSearchActive=true;
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    isSearchActive=false;
    [searchBar resignFirstResponder];
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;
{
    
    [searchBar resignFirstResponder];
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    isSearchActive=FALSE;
    [searchBar resignFirstResponder];
    [[AppDelegate sharedAppDelegate].cellItemArr removeAllObjects];
    for (StoreData *element in mainSectionElementArray) {
        [[AppDelegate sharedAppDelegate].cellItemArr addObject:element];
    }
    
    [self shortAsPerFavourite];
    //[homePageTableView reloadData];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    if(searchText.length==0)
    {
        
        isSearchActive=false;
        [[AppDelegate sharedAppDelegate].cellItemArr removeAllObjects];
        [AppDelegate sharedAppDelegate].cellItemArr=[[NSMutableArray alloc]init];
        for (StoreData *element in mainSectionElementArray) {
            [[AppDelegate sharedAppDelegate].cellItemArr addObject:element];
        }
        [self shortAsPerFavourite];
        //[homePageTableView reloadData];
        [homePageTableView resignFirstResponder];
        [searchBar performSelector: @selector(resignFirstResponder)
                        withObject: nil
                        afterDelay: 0.1];
        
        
    }else
    {
        //    isFiltered=true;
        isSearchActive=TRUE;
        [[AppDelegate sharedAppDelegate].cellItemArr removeAllObjects];
        [AppDelegate sharedAppDelegate].cellItemArr=[[NSMutableArray alloc]init];
        
        for (StoreData *rec in mainSectionElementArray)
        {
            NSString *strSearch = searchBar.text;
            
            strSearch = [strSearch lowercaseString];
            strSearch = [strSearch stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[strSearch substringToIndex:1] uppercaseString]];
            
            NSString *matchString = rec.shopName;
            matchString = [matchString lowercaseString];
            matchString = [matchString stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[matchString substringToIndex:1] uppercaseString]];
            
            NSRange strtitlerange=[matchString rangeOfString:strSearch options:(NSLiteralSearch)];
            if(strtitlerange.location != NSNotFound)
            {
                [[AppDelegate sharedAppDelegate].cellItemArr addObject:rec];
            }
            
        }
        //[self shortAsPerFavourite];
       [homePageTableView reloadData];
    }
}


//-------------------------------------------------------------




#pragma mark - TableView Delegate Method
//This return no of Section in table view
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[AppDelegate sharedAppDelegate].cellItemArr count];
}

//this returnno of row in section here we want only one section row is display, this this control by 'didselected' variable 
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (didSelected==section)
    {
        return 1;
    }
    return 0;
}

//Define hight for section in table view
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return sectionSize;
}

//it Define the Containt of 'Section'
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    selectedIndex=section;
    sectionView *view=[[[sectionView alloc]initWithFrame:CGRectMake(0, 0, 320, 110) delegate:self withTag:section] autorelease];

    
    StoreData *element=(StoreData*)[   [AppDelegate sharedAppDelegate].cellItemArr objectAtIndex:section];
    
    if(element.imagePath){
        //[view.iconImageView setImage:[UIImage imageNamed:element.imagePath]];
        view.iconImageView.image=[[AppDelegate sharedAppDelegate]getStoreImageFromName:element.imagePath];
    }
    else{
        //[view.iconImageView setImage:element.imgIcon];
    }
    
    [view.lblTitle setText:element.shopName];
    //[view.lblSubTitle setText:element.subTitle];
    if (section==didSelected)
    {
        view.addBtn.selected=YES;
        [view.addBtnImageView setImage:[UIImage imageNamed:@"minus-icon"]];
           [homePageTableView setContentOffset:CGPointMake(0, section*sectionSize)];
        
        
          

    }else 
    {
        [view.addBtnImageView setImage:[UIImage imageNamed:@"plush-icon"]];
        view.addBtn.selected=NO;

    }
    if (element.favourite==0) {
        [view.favouriteImageView setImage:[UIImage imageNamed:@"star"]];
    }
    else
    {
        [view.favouriteImageView setImage:[UIImage imageNamed:@"star_glo"]];

    }

    return view;
    


}

//Define the row containt
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //For Assinging which shop we click
    
    shopNo=indexPath.section;
    
    static NSString *cellIdentifier=@"cell";
    cell=(HomePageCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell==nil)
    {
        cell=[[[HomePageCell alloc]initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:cellIdentifier withDelegate:self] autorelease];
        
    }
    cell.cameraBtn.enabled=YES;
    cell.gallaryBtn.enabled=YES;
    cell.delegate=self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return rowSize;
}

#pragma mark - Add note view method
//Add Notes Click Btn Method
-(void)addNotesClick:(id)sender
{
//    Gitting shop name
    StoreData *shopName=(StoreData*)[ [AppDelegate sharedAppDelegate].cellItemArr objectAtIndex:shopNo];
    
    
    obj=(HomePageCell*)sender;
    NSString *productName=obj.productNameTxt.text;
   
    NSString *purchaseDate=obj.purchaseDateTxt.text;
    NSString *returnDate=obj.returnDateTxt.text;
    
    
    AddNotesViewController *addNotesView=[[AddNotesViewController alloc]initWithNibName:@"AddNotesViewController" bundle:nil currentDate:getCurrentDate() productName:productName shopName:shopName.shopName purchaseDate:purchaseDate returnDate:returnDate image:([imageArray count]>0)?[imageArray objectAtIndex:0]:nil  withAddNotesStr:addNotesStr] ;
    addNotesView.delegate=self;
    [self presentModalViewController:addNotesView animated:YES];
    
    
    //[self.view addSubview:addNotesView.view];
}

//Method call by AddNotesViewController
-(void)assingAddNote:(NSString*)note
{
    addNotesStr=[[NSString alloc]initWithString:note];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y<=sectionSize&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionSize) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionSize, 0, 0, 0);
    }
}

//When user press Add Or Minus button on section
#pragma mark - section Btn Code
-(void)clickOnSectionBtn:(id)sender
{
    UIButton *tmp=(UIButton *)sender;
    [self keyBoardHide];
    tmp.selected=!tmp.selected;
    sectionNumber=tmp.tag;
    if (tmp.selected)
    {
        isSelect=YES;
        currentOffset=homePageTableView.contentOffset;

        [self clearCellField];
        didSelected=tmp.tag;
//        CGRect frame=homePageTableView.frame;
//        frame.size.height=300;
//        homePageTableView.frame=frame;
//        [tableScrollView setContentSize:CGSizeMake(0, CGRectGetMaxY(frame))];
//         tableScrollView.contentOffset=CGPointMake(0, homePageTableView.frame.origin.y-3);
        [homePageTableView setContentOffset:CGPointMake(0, sectionNumber*sectionSize)];
    }
    else
    {
        isSelect=NO;
        [self clearCellField];
//        [homePageTableView setFrame:CGRectMake(homePageTableView.frame.origin.x, homePageTableView.frame.origin.y, homePageTableView.frame.size.width, 230)];
//               [homePageTableView setContentOffset:CGPointMake(0, 0)];
//        [tableScrollView setContentOffset:CGPointMake(0,0)];
        didSelected=777;
        [homePageTableView setContentOffset:currentOffset];
    }
   [homePageTableView reloadData];
   
    //[homePageTableView setContentOffset:CGPointMake(0, currentOffset.y)];
    
}
-(void)clearCellField
{
    obj.lblTemp.hidden = YES;
    obj.lblTemp2.hidden=YES;
    obj.firstImageView.image=nil;
    obj.secondImageView.image=nil;
    obj.thirdImageView.image=nil;
    obj.fourthImageView.image=nil;
    obj.productNameTxt.text=nil;
    obj.receiptNoTxt.text=nil;
    obj.purchaseDateTxt.text=nil;
    obj.returnDateTxt.text=nil;
    obj.returnDurationTxt.text=nil;
    obj.returnAlertTextField.text=nil;
    obj.timeLeftDescLbl.text=nil;
    obj.cameraBtn.enabled=YES;
    obj.gallaryBtn.enabled=YES;
    obj.image1Btn.enabled=YES;
    obj.image2Btn.enabled=YES;
    obj.image3Btn.enabled=YES;
    obj.image4Btn.enabled=YES;
    addNotesStr=nil;
    imageArray=nil;
    btnTag=0;
    
}

//Calendar Btn Method For Both Purchase Date and Return Date
-(void)calendarOpen:(id)sender
{
    self.viewPickDate.hidden = NO;
    obj=(HomePageCell*)sender;
    pickerNumber = obj.dateBtnTag;
    if(pickerNumber==1){
        self.pickerView.minimumDate = nil;
        self.pickerView.maximumDate = getCurrentDate();
        if([obj.purchaseDateTxt.text length]>0){
            self.pickerView.date = [self.pickDateFormatter dateFromString:obj.purchaseDateTxt.text];
        }
        else{
            self.pickerView.date = getCurrentDate();
        }
    }
    else if(pickerNumber==2){
        if([obj.purchaseDateTxt.text length]>0){
            self.pickerView.minimumDate = [self.pickDateFormatter dateFromString:obj.purchaseDateTxt.text];
        }
        else{
            self.pickerView.minimumDate = getCurrentDate();
        }
        self.pickerView.maximumDate = nil;
        if([obj.returnDateTxt.text length]>0){
            self.pickerView.date = [self.pickDateFormatter dateFromString:obj.returnDateTxt.text];
        }
        else{
            self.pickerView.date = getCurrentDate();
        }
    }
    else if(pickerNumber==3){
        if([obj.purchaseDateTxt.text length]>0){
            self.pickerView.minimumDate = [self.pickDateFormatter dateFromString:obj.purchaseDateTxt.text];
        }
        else{
            self.pickerView.minimumDate = getCurrentDate();
        }
        
        if([obj.returnDateTxt.text length]>0){
            self.pickerView.maximumDate = [self.pickDateFormatter dateFromString:obj.returnDateTxt.text];
        }
        else{
            self.pickerView.maximumDate = getCurrentDate();
        }
        
        if([obj.returnAlertTextField.text length]>0){
            self.pickerView.date = [self.pickDateFormatter dateFromString:obj.returnAlertTextField.text];
        }
        else{
            self.pickerView.date = getCurrentDate();
        }
    }
    
//    obj=(HomePageCell*)sender;
//    if(aac){
//        aac = nil;
//        [aac release];
//    }
//    aac = [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n\n"  delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
//    //[aac setFrame:CGRectMake(aac.frame.origin.x, aac.frame.origin.y, aac.frame.size.width+60, aac.frame.size.height)]
//    [aac setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
//    if(theDatePicker){
//        theDatePicker=nil;
//        [theDatePicker release];
//    }
//    theDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 44.0, 0.0, 0.0)];
//    theDatePicker.datePickerMode=UIDatePickerModeDate;
//    [theDatePicker addTarget:self action:@selector(pickDate:) forControlEvents:UIControlEventValueChanged];
//    //theDatePicker.date=
//    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
//    [dateFormatter1 setDateFormat:@"dd-MMM-yy HH:mm:ss"];
//    //seting datepicker display
//    if (obj.dateBtnTag==1)
//    {
//        if ([obj.purchaseDateTxt.text length]>0) {
//            theDatePicker.date=[dateFormatter1 dateFromString:obj.purchaseDateTxt.text];
//            [obj.purchaseDateTxt setText:[dateFormatter1 stringFromDate:theDatePicker.date]];
//        }
//        [theDatePicker setMaximumDate: getCurrentDate()];
//    }
//    else if(obj.dateBtnTag==2)
//    {
//        if ([obj.returnDateTxt.text length]>0) {
//            
//            theDatePicker.date=[dateFormatter1 dateFromString:obj.returnDateTxt.text];
//            [obj.returnDateTxt setText:[dateFormatter1 stringFromDate:theDatePicker.date]];
//        }
//        [theDatePicker setMinimumDate:getCurrentDate()];
//    }
//    
//    else if (obj.dateBtnTag==3)
//    {
//        if ([obj.returnDateTxt.text length]>0 && [obj.purchaseDateTxt.text length]>0) {
//            
//            if ([obj.returnAlertTextField.text length]>0) {
//                theDatePicker.date=[dateFormatter1 dateFromString:obj.returnAlertTextField.text];
//            }
//            [theDatePicker setMinimumDate:[dateFormatter1 dateFromString:obj.purchaseDateTxt.text]];
//            [theDatePicker setMaximumDate:[dateFormatter1 dateFromString:obj.returnDateTxt.text]];
//            //[obj.returnDateTxt setText:[dateFormatter1 stringFromDate:theDatePicker.date]];
//        }
//        else
//        {
//            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"Purchase Date & Return Date Should be Select first" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alertView show];
//            [alertView release];
//            return;
//        }
//
//    }
//    UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Cancel"]];
//    closeButton.momentary = YES;
//   
//    closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
//    closeButton.tintColor = [UIColor blackColor];
//    [closeButton addTarget:self action:@selector(DatePickercancelClick:) forControlEvents:UIControlEventValueChanged];
//    [aac addSubview:closeButton];
//    [closeButton release];
//    
//    
//    UISegmentedControl *doneButton=[[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"Done", nil]];
//    doneButton.momentary=YES;
//   
//    doneButton.segmentedControlStyle=UISegmentedControlStyleBar;
//    doneButton.tintColor = [UIColor blackColor];
//    [doneButton addTarget:self action:@selector(DatePickerDoneClick:) forControlEvents:UIControlEventValueChanged];
//    [aac addSubview:doneButton];
//    [doneButton release];
//    
//
//     if ([[[UIDevice currentDevice] model] hasPrefix:@"iPad"]) {
//         closeButton.frame = CGRectMake(100, 7.0f, 80.0f, 30.0f);
//         doneButton.frame=CGRectMake(185, 7.0f, 80.0f, 30.0f);
//     }
//    else
//    {
//        closeButton.frame = CGRectMake(100, 7.0f, 100.0f, 30.0f);
//        doneButton.frame=CGRectMake(210, 7.0f, 100.0f, 30.0f);
//    }
//    [aac addSubview:theDatePicker];
//    [aac showFromTabBar:self.tabBarController.tabBar];
//    [UIView beginAnimations:nil context:nil];
//    if ([[[UIDevice currentDevice] model] hasPrefix:@"iPad"]) {
//        // This app is an iPhone app running on an iPad
//        [aac showFromTabBar:self.tabBarController.tabBar];
//        //[aac showFromRect:CGRectMake(0, 300, 320, 600) inView:self.view animated:YES];
//        [theDatePicker setFrame:CGRectMake(-30, 40, 0, 90)];
//    }
//    //ActionSheet Custom scaling
//    if([self interfaceOrientation] == UIInterfaceOrientationPortraitUpsideDown || [self interfaceOrientation] == UIInterfaceOrientationPortrait)
//        [aac showFromTabBar:self.tabBarController.tabBar];
//    else
//        [aac setBounds:CGRectMake(0,0,480, 400)];
//       [UIView commitAnimations];
//    
//    dateFormatter1 = nil;
//    [dateFormatter1 release];
}



#pragma mark - HomePageCell Delegate Method

//Delegate Method of HomePageCell For Camera Functionality
-(void)setCameraImage:(id)sender withSenderTag:(NSInteger)tag
{
    
//  
//    if (obj) {
//        obj=nil;
//    }
    obj=(HomePageCell*)sender;
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [self setGallary:sender withSenderTag:tag];
    }
    else
    {
        btnTag=tag;
        UIImagePickerController *picker1 = [[[UIImagePickerController alloc] init] autorelease];
        picker1.delegate = self;
        picker1.allowsEditing = YES;
        picker1.sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            popover = [[UIPopoverController alloc] initWithContentViewController:picker1];
            popover.delegate=self;
            [popover presentPopoverFromRect:CGRectMake(10, 40, 100, 400.0)
                                     inView:self.view
                   permittedArrowDirections:UIPopoverArrowDirectionAny
                                   animated:YES];
        } else {
            [self presentViewController:picker1 animated:YES completion:NULL ];
        }
        
        
    }
}

//Delegate Method of HomePageCell For Gallary Functionality
-(void)setGallary:(id)sender withSenderTag:(NSInteger)tag
{

    obj=(HomePageCell*)sender;
    btnTag=tag;
    UIImagePickerController *picker1=[[[UIImagePickerController alloc]init] autorelease];
    picker1.delegate=self;
    picker1.allowsEditing=YES;
    picker1.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        popover = [[UIPopoverController alloc] initWithContentViewController:picker1];
        popover.delegate=self;
        [popover presentPopoverFromRect:CGRectMake(10, 40, 100, 400.0)
                                 inView:self.view
               permittedArrowDirections:UIPopoverArrowDirectionAny
                               animated:YES];
    } else {
        [self presentViewController:picker1 animated:YES completion:NULL ];
    }
    
}

//Delegate Method Of HomepageCell for Submit Btn Method
-(void)submitBtnClick:(id)sender
{
    
    obj=(HomePageCell*)sender;
    [[AppDelegate sharedAppDelegate] startActivityIndicatorAnimationWithMsg:@"Loading..."];
    [self performSelectorInBackground:@selector(submitSelector) withObject:nil];
}

-(void)submitSelector
{
    RecordData *records=[[RecordData alloc]init];
    StoreData *data=[[AppDelegate sharedAppDelegate].cellItemArr objectAtIndex:shopNo];
    records.shopID=data.shopId;
    records.productNameStr=[obj.productNameTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];;
    records.receiptNumberStr=[obj.receiptNoTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];;
    records.purchaseDateStr=[obj.purchaseDateTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    records.returnAlertDate=[obj.returnAlertTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([obj.returnDateTxt.text length]>0) {
        records.returnDate=[obj.returnDateTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if([obj.returnDurationTxt.text length]>0)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd-MMM-yy HH:mm:ss"];
        NSDate *dateFromString = [[[NSDate alloc] init]autorelease];
        dateFromString = [dateFormatter dateFromString:obj.purchaseDateTxt.text];
        
        
        NSDate *newDate1 = [dateFromString dateByAddingTimeInterval:60*60*24*([obj.returnDurationTxt.text intValue])];
        NSString *dateString = [[dateFormatter stringFromDate:newDate1]autorelease];
        
        records.returnDate=dateString;
    }
    
    records.notes=addNotesStr;
//    records.img1=([imageArray count]>0)?[imageArray objectAtIndex:0]:NULL;
//    records.img2=([imageArray count]>1)?[imageArray objectAtIndex:1]:NULL;
//    records.img3=([imageArray count]>2)?[imageArray objectAtIndex:2]:NULL;
//    records.img4=([imageArray count]>3)?[imageArray objectAtIndex:3]:NULL;
    NSString *msg;
    if (records.productNameStr==nil || records.receiptNumberStr==nil || records.purchaseDateStr==nil || records.returnDate==nil) {
        msg=AllFieldFill;
    }
    else
    {
        BOOL success=[[DataBaseClass getSharedInstance]saveData:records];
        if (success) {
            msg=RecordInsertSuccessMsg;
            int notificationId=[[DataBaseClass getSharedInstance]getMaxId];
            // Save all images in product record folder.
            if([imageArray count]>0){
                [[AppDelegate sharedAppDelegate] saveProductImageWithName:@"1.png" andImage:[imageArray objectAtIndex:0] andProductID:[NSString stringWithFormat:@"%d",notificationId]];
            }
            if([imageArray count]>1){
                [[AppDelegate sharedAppDelegate] saveProductImageWithName:@"2.png" andImage:[imageArray objectAtIndex:1] andProductID:[NSString stringWithFormat:@"%d",notificationId]];
            }
            if([imageArray count]>2){
                [[AppDelegate sharedAppDelegate] saveProductImageWithName:@"3.png" andImage:[imageArray objectAtIndex:2] andProductID:[NSString stringWithFormat:@"%d",notificationId]];
            }
            if([imageArray count]>3){
                [[AppDelegate sharedAppDelegate] saveProductImageWithName:@"4.png" andImage:[imageArray objectAtIndex:3] andProductID:[NSString stringWithFormat:@"%d",notificationId]];
            }
            [self clearCellField];
            isSelect=NO;
            didSelected=777;
            [homePageTableView reloadData];
            //Apply Norification
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"dd-MMM-yy HH:mm:ss"];
            if ([AppDelegate sharedAppDelegate].notificationIsOn) {
                //[self notification:records.returnDate purchaseDate:records.purchaseDateStr];
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setValue:records.receiptNumberStr forKey:@"receiptNumber"];
                [dict setValue:records.productNameStr forKey:@"productName"];
                [dict setValue:[NSString stringWithFormat:@"%i",notificationId] forKey:@"productId"];
                [dict setValue:[[AppDelegate sharedAppDelegate] getShopNameWithID:records.shopID] forKey:@"companyName"];
                NotificationClass *notificationObj = [[NotificationClass alloc] init];
                [notificationObj setNotificationWithPurchaseDate:[dateFormatter dateFromString:records.purchaseDateStr] ReturnDate:[dateFormatter dateFromString:records.returnDate] msgDictionary:dict];
                [notificationObj scheduleNotificationWithDate:[dateFormatter dateFromString:obj.returnAlertTextField.text] andDictionar:dict :40];
            }
        }
        else
        {
            msg=RecordNotInsertMsg;
            
            obj.receiptNoTxt.text=nil;
        }
    }
    [[AppDelegate sharedAppDelegate] endActivityIndicatorAnimation];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
    [alert release];
    records = nil;
    [records release];
}

- (void)showImageViewController:(UIImage*)img{
   // isShowImage=YES;
    ShowImageViewController *sivc = [[ShowImageViewController alloc] init];
    [self presentModalViewController:sivc animated:YES];
    [sivc setImg:img];
    [sivc release];
}


#pragma mark - Date Picker Related Code

//When cancel btn click on DatePicker Contrller
- (void)DatePickercancelClick:(id)sender{
    
    [aac dismissWithClickedButtonIndex:0 animated:YES];
}
//When Done btn click of Date Picker
-(void)DatePickerDoneClick:(id)sender {
    
    NSDateFormatter *df=[[[NSDateFormatter alloc]init] autorelease];
    df.dateFormat = @"dd-MMM-yy HH:mm:ss";
    NSArray *temp=[[NSString stringWithFormat:@"%@",[df stringFromDate:theDatePicker.date]] componentsSeparatedByString:@""];
    
    [dateString1 release];
    dateString1=nil;
    dateString1 = [[NSString alloc]initWithString:[temp objectAtIndex:0]];
    [aac dismissWithClickedButtonIndex:0 animated:YES];
    
    //dateString1 = [[dateString1 componentsSeparatedByString:@" "] objectAtIndex:0];
    
    if (obj.dateBtnTag==1) {
        [obj.purchaseDateTxt setText:dateString1];
    }
    else if(obj.dateBtnTag==2)
    {
        NSDate *newDate1 = theDatePicker.date;
        

        NSDateFormatter *dateformatter=[[NSDateFormatter alloc]init];
        [dateformatter setDateFormat:@"dd-MMM-yy HH:mm:ss"];
//        
        if ([obj.purchaseDateTxt.text length]<=0) {
            obj.purchaseDateTxt.text=[dateformatter stringFromDate:getCurrentDate()];
            obj.lblTemp.hidden=NO;
        }
        [obj.returnDateTxt setText:dateString1];
        
        
        obj.timeLeftDescLbl.text = [[AppDelegate sharedAppDelegate] getInterBetweenTwoDate:getCurrentDate() ReturnDate:newDate1];
        
    }
    else if (obj.dateBtnTag==3)
    {
            [obj.returnAlertTextField setText:dateString1];
        obj.lblTemp2.hidden=NO;
    }
    obj.lblTemp.hidden = NO;
    
}

-(void)pickDate:(id)sender
{
    
    NSDateFormatter *df=[[[NSDateFormatter alloc]init] autorelease];
    df.dateFormat = @"dd-MMM-yy HH:mm:ss";
    NSArray *temp=[[NSString stringWithFormat:@"%@",[df stringFromDate:theDatePicker.date]] componentsSeparatedByString:@""];
    
    [dateString1 release];
    dateString1=nil;
    dateString1 = [[NSString alloc]initWithString:[temp objectAtIndex:0]];
    
    if (obj.dateBtnTag==1) {
        [obj.purchaseDateTxt setText:dateString1];
    }
    else if(obj.dateBtnTag==2)
    {
        
        
        NSDate *newDate1 = theDatePicker.date;
        
        
        

        
        obj.lblTemp.hidden = NO;
        [obj.returnDateTxt setText:dateString1];
        obj.timeLeftDescLbl.text = [[AppDelegate sharedAppDelegate] getInterBetweenTwoDate:getCurrentDate() ReturnDate:newDate1];
    }
    obj.lblTemp.hidden = NO;

}

#pragma mark - ImagePicker Delegate Method

// This method createImage Picker Controller delegate methods
-(void)imagePickerController:(UIImagePickerController *)picker  didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:NO];

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        [popover dismissPopoverAnimated:YES];
    }
    if (!imageArray) {
        imageArray=[[NSMutableArray alloc]init];
    }
    if (btnTag==1) {
        obj.firstImageView.image=scaleImage([info objectForKey:@"UIImagePickerControllerOriginalImage"], 500);
        [imageArray addObject:obj.firstImageView.image];
    }
    else if (btnTag==2)
    {
        obj.secondImageView.image=scaleImage([info objectForKey:@"UIImagePickerControllerOriginalImage"], 500);
        [imageArray addObject:obj.secondImageView.image];
    }
    else if (btnTag==3)
    {
        obj.thirdImageView.image=scaleImage([info objectForKey:@"UIImagePickerControllerOriginalImage"], 500);

        [imageArray addObject:obj.thirdImageView.image];
    }
    else if (btnTag==4)
    {
        obj.fourthImageView.image=scaleImage([info objectForKey:@"UIImagePickerControllerOriginalImage"], 500);

        [imageArray addObject:obj.fourthImageView.image];
    }
}

// This method cancel the imagepicker object
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        [popover dismissPopoverAnimated:YES];
    }
    isSelect=YES;
}

//********************Notification Code******************
#pragma mark - Notification set up related code
//Notification Method Code
-(void)notification:(NSString*)returnDate purchaseDate:(NSString*)purchaseDate
{
    
    //***********difference b/w two date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd-MMM-yy HH:mm:ss";
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    dateFormatter1.dateFormat = @"dd-MMM-yy";
    NSDate *purDate = [dateFormatter dateFromString:purchaseDate];
    
    purDate = [dateFormatter1 dateFromString:[dateFormatter1 stringFromDate:purDate]];
    
    NSDate *retDate = [dateFormatter dateFromString:returnDate];
    
    retDate = [dateFormatter1 dateFromString:[dateFormatter1 stringFromDate:retDate]];
    
    NSCalendar *calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    NSDateComponents *components = [calendar components:NSDayCalendarUnit
                                               fromDate:purDate
                                                 toDate:retDate
                                                options:0];
    
    ///////////Schedule Return Date Alert Final Alert//////////////
    NSDateFormatter *timeFormatter=[[NSDateFormatter alloc]init];
    timeFormatter.dateFormat=@"HH:mm:ss";
   //
    //
    NSDate *alertTime=[timeFormatter dateFromString:[AppDelegate sharedAppDelegate].defualtTimeStr];
    NSDate *finalAlertDate=[self getDate:retDate withTime:alertTime];
    [self scheduleNotificationWithDate:finalAlertDate withMsg:@"Today Your Return Date is Finish"];
    [dateFormatter release];
    [timeFormatter release];
    
    /////////Schedule Alert According to set days///////////////////
    NSInteger alertCount;
        NSDate *periodAlertDate=purDate;
    if ([AppDelegate sharedAppDelegate].notificationIsOn) {
        alertCount=components.day/[[AppDelegate sharedAppDelegate].defaultDaysStr integerValue];
        while (alertCount>0) {
            periodAlertDate=[periodAlertDate dateByAddingTimeInterval:60*60*24*[[AppDelegate sharedAppDelegate].defaultDaysStr integerValue]];
            [self scheduleNotificationWithDate:periodAlertDate withMsg:[NSString stringWithFormat:@"You can return Your Item till %@ date",retDate]];
                    alertCount--;
            }
    }
    
    //*******************Alert Started From This Days********************
    
    NSInteger startAlertCount=[[AppDelegate sharedAppDelegate].startAlertFromStr integerValue];
    
    while (startAlertCount>0) {
        NSDate *startAlertDate=[retDate dateByAddingTimeInterval:-60*60*24*(startAlertCount)];
        [self scheduleNotificationWithDate:startAlertDate withMsg:[NSString stringWithFormat:@"%i days remain Only",startAlertCount]];
        startAlertCount--;
    }
}

//It take date and time seprately and return it with margeing them
-(NSDate*)getDate:(NSDate*)date withTime:(NSDate*)time
{
    NSCalendar *calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];

    NSDateComponents *timeComponent=[calendar components:NSHourCalendarUnit | NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:time];
    NSDateComponents *dateComponent=[calendar components:NSMonthCalendarUnit|NSYearCalendarUnit|NSDayCalendarUnit fromDate:date];
    NSDateComponents *returnComp=[[NSDateComponents alloc]init];
    [returnComp setDay:dateComponent.day];
    [returnComp setMonth:dateComponent.month];
    [returnComp setYear:dateComponent.year];
    [returnComp setHour:timeComponent.hour];
    [returnComp setMinute:timeComponent.minute];
    [returnComp setSecond:timeComponent.second];
    NSDate *finalAlertDate=[calendar dateFromComponents:returnComp];
    return finalAlertDate;
}

//It takes date and msg and schedule notification
-(void)scheduleNotificationWithDate:(NSDate*)date withMsg:(NSString*)msg
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[NSString stringWithFormat:@"%@",date] forKey:@"returnDate"];
    
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = date;
    localNotification.alertBody =msg;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.soundName=UILocalNotificationDefaultSoundName;
    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    localNotification.userInfo = dict;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:self];
}

///////////////////////////////////////////////////////////

//textField set according to keyboard by uikeyboard controller class///

- (void)keyborardDidShow{
    [homePageTableView setContentOffset:CGPointMake(0, sectionNumber*sectionSize)];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)clickedStar:(id)sender
{
    UIButton *tmpBtn=(UIButton*)sender;
    StoreData *data=(StoreData*)[[AppDelegate sharedAppDelegate].cellItemArr objectAtIndex:tmpBtn.tag];
    if (data.favourite==1) {
        data.favourite=0;
        [[DataBaseClass getSharedInstance]updateHomePageData:data];
    }
    else
    {
        data.favourite=1;
        [[DataBaseClass getSharedInstance]updateHomePageData:data];
    }
    [self shortAsPerFavourite];
}

- (IBAction)clickedSettingIconButton:(id)sender {
   // UIView *settingBtnView=[[UIView alloc]initWithFrame:CGRectMake(50, 50, 150, 100)];
    [self keyBoardHide];
    if (!settingView) {
        NSArray *arrMenu = [[NSArray alloc] initWithObjects:@"Add store",@"Settings", nil];
        settingView=[[SettingMenuView alloc]initWithFrame:CGRectMake(200, 35, 116, 86) andMenuArray:arrMenu];
        settingView.delegate=self;
        [self.view addSubview:settingView];
        [settingView setDesignWithType:2];
    }
    else
    {
        [settingView removeFromSuperview];
        [settingView release];
        settingView=nil;
    }
    
    //[[AppDelegate sharedAppDelegate].tabBarController setSelectedIndex:2];
}


- (void)clickeOutSideFromMenu
{
    if (settingView)
    {
        [settingView removeFromSuperview];
        [settingView release];
        settingView=nil;
    }
    if (menuView) {
        [menuView removeFromSuperview];
        [menuView release];
        menuView=nil;
    }
}
// setting menu delegate method
- (void)selectMenuAtIndex:(int)index{
    if (settingView) {
        if(index==0){
            AddStoreViewController *asvc = [[AddStoreViewController alloc] initWithNibName:@"AddStoreViewController" bundle:nil];
            [self presentModalViewController:asvc animated:YES];
            [asvc release];
        }
        else if(index==1){
            [[AppDelegate sharedAppDelegate].tabBarController setSelectedIndex:2];
        }
        
        [settingView removeFromSuperview];
        [settingView release];
        settingView=nil;
    }
    else if(menuView)
    {
        [menuView removeFromSuperview];
        [menuView release];
        menuView=nil;
        if (index==0) {
            StoreData *data=(StoreData*)[[AppDelegate sharedAppDelegate].cellItemArr objectAtIndex:sectionNumber];
            //int deleteId=data.favourite;
            if (data.favourite==1) {
                data.favourite=0;
                [[DataBaseClass getSharedInstance]updateHomePageData:data];
            }
            else
            {
                data.favourite=1;
                [[DataBaseClass getSharedInstance]updateHomePageData:data];
            }
            [self shortAsPerFavourite];
            
            
        }
        else if (index==1)
        {
            AddStoreViewController *asvc = [[AddStoreViewController alloc] initWithNibName:@"AddStoreViewController" bundle:nil];
            StoreData *updateData=(StoreData*)[[AppDelegate sharedAppDelegate].cellItemArr objectAtIndex:sectionNumber];
            
            [self presentModalViewController:asvc animated:YES];
            
            [asvc updateStoreViewType:1 shopID:updateData.shopId ShopName:updateData.shopName Description:updateData.description andImage:[[AppDelegate sharedAppDelegate] getStoreImageFromName:updateData.imagePath] imageName:updateData.imagePath favourite:updateData.favourite];
            [asvc release];
           
            
        }
        else if (index==2)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"If you are delete store then all corresponding product record will also deleted. Do you want to delete store." delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
            [alert show];
            [alert release];
        }
        else if (index==3)
        {
            
            //[self.view setUserInteractionEnabled:YES];
            //[homePageTableView setUserInteractionEnabled:YES];
        }
    
    }
   
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if([alertView.message isEqualToString:@"If you are delete store then all corresponding product record will also deleted. Do you want to delete store."]){
        if(buttonIndex==0){
            StoreData *deleteData=(StoreData*)[[AppDelegate sharedAppDelegate].cellItemArr objectAtIndex:sectionNumber];
            int deleteId=deleteData.shopId;
            [[DataBaseClass getSharedInstance]deleteStoredData:deleteId];
            // [homePageTableView reloadData];
            if ([mainSectionElementArray count]>0) {
                [mainSectionElementArray removeAllObjects];
            }
            for (StoreData *data in [AppDelegate sharedAppDelegate].cellItemArr) {
                [mainSectionElementArray addObject:data];
            }
            [self shortAsPerFavourite];
        }
    }
}

- (void)dealloc {
    [addNotesStr release];
    //[picker release];
    [strTemp release];
    [viewControllerDelegate release];
    [dateString1 release];
    [imageArray release];
    [aac release];
    [theDatePicker release];
    [homePageTableView release];
    [_searchBar release];
    
    [tableScrollView release];
    
    [_bannerImageView release];
    [_viewAdvertisement release];
    [_viewPickDate release];
    [super dealloc];
}
- (void)viewDidUnload {
//[[AppDelegate sharedAppDelegate].addView.adView cancelAd];
    [self setSearchBar:nil];
    [self setTableScrollView:nil];
    [self setBannerImageView:nil];
    [self setViewAdvertisement:nil];
    [self setViewPickDate:nil];
    [super viewDidUnload];
}
-(void)longPressClickTag:(int)tag
{
    sectionNumber=tag;
    if (!menuView) {
        NSArray *arrMenu;
        StoreData *data=[[AppDelegate sharedAppDelegate].cellItemArr objectAtIndex:sectionNumber];
        if (data.favourite==1) {
            arrMenu = [[NSArray alloc] initWithObjects:@"Remove To Favorites",@"Edit",@"Delete", nil];
        }
        else
        {
            arrMenu = [[NSArray alloc] initWithObjects:@"Add To Favorites",@"Edit",@"Delete", nil];
        }
      
        menuView = [[SettingMenuView alloc] initWithFrame:CGRectMake(homePageTableView.center.x-100,homePageTableView.center.y-20, homePageTableView.frame.size.width-100, homePageTableView.frame.size.height-150) andMenuArray:arrMenu];
        StoreData *element=(StoreData*)[   [AppDelegate sharedAppDelegate].cellItemArr objectAtIndex:sectionNumber];
        [menuView setIsSection:YES andTitle:element.shopName];
        menuView.delegate = self;
        [self.view addSubview:menuView];
        menuView.layer.masksToBounds=YES;
        menuView.layer.cornerRadius = 5.0f;
        
        //[self.view setUserInteractionEnabled:NO];
        //[homePageTableView setUserInteractionEnabled:NO];
        
    }
    

    
}
- (void)longPress:(UILongPressGestureRecognizer*)gesture {
    
    if (!menuView) {
        NSArray *arrMenu;
        StoreData *data=[[AppDelegate sharedAppDelegate].cellItemArr objectAtIndex:sectionNumber];
        if (data.favourite==1) {
            arrMenu = [[NSArray alloc] initWithObjects:@"Remove To Favorites",@"Edit",@"Delete", nil];
        }
        else
        {
            arrMenu = [[NSArray alloc] initWithObjects:@"Add To Favorites",@"Edit",@"Delete", nil];
        }
        
//        longPressMenuView=[[UIView alloc]initWithFrame:CGRectMake(homePageTableView.frame.origin.x,homePageTableView.frame.origin.y, homePageTableView.frame.size.width, homePageTableView.frame.size.height)];
        menuView = [[SettingMenuView alloc] initWithFrame:CGRectMake(homePageTableView.center.x-100,homePageTableView.center.y-20, homePageTableView.frame.size.width-120, homePageTableView.frame.size.height-160) andMenuArray:arrMenu];
        menuView.delegate = self;
        //menuView.hidden=YES;
        [self.view addSubview:menuView];
        menuView.layer.masksToBounds=YES;
        menuView.layer.cornerRadius = 5.0f;
        //[self.view addSubview:menuView];
        //[longPressMenuView addSubview:menuView];
        
        
//        UITapGestureRecognizer *touchLongPressMenuTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchLongPressMenuTapMethod:)];
//        [longPressMenuView setUserInteractionEnabled:YES];
//        [longPressMenuView addGestureRecognizer:touchLongPressMenuTap ];
//    
//        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressOnlongPressMenu:)];
//        
//        [longPressMenuView addGestureRecognizer:longPress];

    }
   
    
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
- (void)showImageViewController:(HomePageCell*)cellData andTag:(int)tag andCellDelegate:(id)cellDelegate{
    ShowImageViewController *sivc = [[ShowImageViewController alloc] init];
    [self presentModalViewController:sivc animated:YES];
    sivc.delegate = self;
    [sivc designViewForImageAndSelectImageTag:tag andHomeCellData:cellData andCellDelegate:cellDelegate];
    [sivc release];
}


- (void)setImageFinished:(RecordData*)imgRecord{
    [imageArray removeAllObjects];
    if(imgRecord.img1){
        [imageArray addObject:imgRecord.img1];
    }
    if(imgRecord.img2){
        [imageArray addObject:imgRecord.img2];
    }
    if(imgRecord.img3){
        [imageArray addObject:imgRecord.img3];
    }
    if(imgRecord.img4){
        [imageArray addObject:imgRecord.img4];
    }
}
//-(void)sortByLeftDays
//{
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"dd-MMM-yy HH:mm:ss"];
//    NSInteger tempInterval;
//    for(int i=0;i<[[AppDelegate sharedAppDelegate].cellItemArr count];i++){
//        RecordData *record = [[AppDelegate sharedAppDelegate].cellItemArr objectAtIndex:i];
//        for(int j=i;j<[[AppDelegate sharedAppDelegate].cellItemArr count];j++){
//            RecordData *data = [[AppDelegate sharedAppDelegate].cellItemArr objectAtIndex:j];
//            
//            if(i==j){
//                tempInterval = interval;
//            }
//            if(tempInterval>=interval){
//                tempInterval=interval;
//                [self.arrRecord exchangeObjectAtIndex:i withObjectAtIndex:j];
//            }
//        }
//    }
//    [self.tblRecord reloadData];
//}
-(void)shortAsPerFavourite
{
    
    //For sort an element
    NSMutableArray *tempArr=[[NSMutableArray alloc]init];
    //
    [[AppDelegate sharedAppDelegate].cellItemArr removeAllObjects];
    
    NSLocale *locale=[[NSLocale alloc] initWithLocaleIdentifier:@"sv_SE"];
    NSArray *sorted=[mainSectionElementArray sortedArrayUsingComparator:^(StoreData *first, StoreData *second) {
        return [first.shopName compare:second.shopName
                                     options:0
                                       range:NSMakeRange(0, [first.shopName length])
                                      locale:locale];
    }];
    for (RecordData *rec in sorted) {
        
        [[AppDelegate sharedAppDelegate].cellItemArr addObject:rec];
        
    }

    //
    
    
    
    
    

    for (StoreData *data in [AppDelegate sharedAppDelegate].cellItemArr) {
        if (data.favourite==1) {
            [tempArr addObject:data];
            //[mainSectionElementArray addObject:data];
        }
    }
    for (StoreData *data in [AppDelegate sharedAppDelegate].cellItemArr) {
        if (data.favourite==0) {
            [tempArr addObject:data];
        }
    }
    if ([[AppDelegate sharedAppDelegate].cellItemArr count]>0) {
        [[AppDelegate sharedAppDelegate].cellItemArr removeAllObjects];
        //[mainSectionElementArray removeAllObjects];
    }
    for (StoreData *data in tempArr) {
        [[AppDelegate sharedAppDelegate].cellItemArr addObject:data];
        //[mainSectionElementArray addObject:data];
    }
    [tempArr release];
    [homePageTableView reloadData];

}
// View Picker Date delegate method
- (IBAction)clickedPickDateDone:(id)sender {
    self.viewPickDate.hidden = YES;
    if(pickerNumber==1){
        obj.purchaseDateTxt.text = [self.pickDateFormatter stringFromDate:self.pickerView.date];
        obj.lblTemp.hidden = NO;
    }
    else if(pickerNumber==2){
        obj.returnDateTxt.text = [self.pickDateFormatter stringFromDate:self.pickerView.date];
        obj.timeLeftDescLbl.text = [[AppDelegate sharedAppDelegate] getInterBetweenTwoDate:getCurrentDate() ReturnDate:self.pickerView.date];
    }
    else if(pickerNumber==3){
        [obj.returnAlertTextField setText:[self.pickDateFormatter stringFromDate:self.pickerView.date]];
        obj.lblTemp2.hidden=NO;
    }
}

- (IBAction)clickedPickDateCancel:(id)sender {
    self.viewPickDate.hidden = YES;
}
@end
