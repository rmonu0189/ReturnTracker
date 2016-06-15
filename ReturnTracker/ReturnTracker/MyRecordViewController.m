//
//  MyRecordViewController.m
//  ReturnTracker
//
//  Created by Ranjeeta Rajput on 08/10/13.
//  Copyright (c) 2013 Ranjeeta Rajput. All rights reserved.
//

#import "MyRecordViewController.h"
#import "AddNotesViewController.h"
@interface MyRecordViewController ()
{
    //NSArray *demoArray;
       int didSelected;
    myRecordTableViewCell *myRecordTableViewCellObj;

    NSMutableArray *mainSectionElementArray;
    
    //myRecordTableViewCell *cell;
    
    
    //For Calendar
    UIActionSheet *aac;
    UIDatePicker *theDatePicker;
    UIPopoverController *popover;
     NSString *dateString1;
    NSInteger sectonID;
    
    //Current Cell record hold by currentRecord
    RecordData *currentRecord;
    
    
    //OrderBy Array
    NSMutableArray *orderByBtnData;
    BOOL orderByFlag;
    
    //For searchbar functionality
    BOOL isSearchActive;
    
    NSMutableArray *imageArray;


    BOOL updateFlag;

//Days Left
    NSString *daysLeft;
    NSInteger shopId;
    
//Activity Indicator View
    
    
    //IMagees Btn Tag
    NSInteger btnTag;
    
    //Order by
    UIPickerView *orderPickerView;
    UIActionSheet  *pickerActionSheet;
    NSArray *pickerElement;
    NSInteger selectedOrderInt;
    
    CGPoint currentOffSet;
}
@end

@implementation MyRecordViewController
@synthesize orderByBtn,sectionElementArray;

@synthesize myRecordTableView;
@synthesize menuView;
@synthesize tableScrollView;
@synthesize addNotesStr;
@synthesize menuSetting;
@synthesize dateFormatterSection;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"My Record", @"My Record");
        self.tabBarItem.image = [UIImage imageNamed:@"record-icon.png"];
        

         self.view.transform = CGAffineTransformMakeScale([UIScreen mainScreen].applicationFrame.size.width / 320.0f, [UIScreen mainScreen].applicationFrame.size.height / 480.0f);
        // Custom initialization
    }
    return self;
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
    
    self.dateFormatterSection = [[NSDateFormatter alloc] init] ;
    [self.dateFormatterSection setDateFormat:@"dd-MMM-yy HH:mm:ss"];
    
     NSArray *arrMenu = [[NSArray alloc] initWithObjects:@"Default",@"Product name",@"Left days", nil];
    self.menuView = [[SettingMenuView alloc] initWithFrame:CGRectMake(170, 35, 146, 88) andMenuArray:arrMenu];
    self.menuView.delegate = self;
    [self.view addSubview:self.menuView];
    [self.menuView setHidden:YES];
    [self.menuView setDesignWithType:2];
    
    NSArray *arrMenu1 = [[NSArray alloc] initWithObjects:@"Sort by",@"Settings", nil];
    self.menuSetting = [[SettingMenuView alloc] initWithFrame:CGRectMake(200, 35, 116, 88) andMenuArray:arrMenu1];
    self.menuSetting.delegate = self;
    [self.view addSubview:self.menuSetting];
    [self.menuSetting setHidden:YES];
    [self.menuSetting setDesignWithType:2];
    
    //It is Assingn so that no any row select
    didSelected=1000;

    [tableScrollView setScrollEnabled:NO];
    
    //Order table view data
    orderByBtnData=[[NSMutableArray alloc]initWithObjects:@"Product Name",@"Left Days", nil];
    
    //OrderTable view hidden mode set by orderByFlag variable
    orderByFlag=NO;
    
        [DataBaseClass getSharedInstance].delegate=self;
    
    
    //Picker View Code
    pickerElement=[[NSArray alloc]initWithObjects:@"  Default Order",@"  Product Name",@"  Left days", nil];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(keyBoardHide)];
    [self.bannerImageView setUserInteractionEnabled:YES];
    [self.bannerImageView addGestureRecognizer:tap];
    selectedOrderInt=0;
    
    if ([[AppDelegate sharedAppDelegate]getOsVersion]==7) {
        self.searchBarProducts.placeholder = @"Search products....                                   ";
    }
    else
    {
        self.searchBarProducts.placeholder = @"Search products....";
    }

}
-(void)keyBoardHide
{
    [self.view endEditing:YES];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    if (!isFirstTime)
    {
        if(isShowImage){
            isShowImage = NO;
            return;
        }
        [[AppDelegate sharedAppDelegate] startActivityIndicatorAnimationWithMsg:@"Loading..."];
        [self performSelector:@selector(loadData) withObject:nil afterDelay:1];
    }
   
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

//For Fetching data from data base
-(void)loadData
{
    if (fetchRecord) {
        fetchRecord=nil;
    }
    if ([mainSectionElementArray count]>0) {
         [mainSectionElementArray removeAllObjects ];
    }
    //if ([fetchDataArray count]>0) {
        //[fetchDataArray removeAllObjects];
    //}
    [DataBaseClass getSharedInstance].delegate=self;

    fetchRecord=[[RecordData alloc]init];
    mainSectionElementArray=[[NSMutableArray alloc]init];
    //fetchDataArray=[[NSMutableArray alloc]init];
    //fetchDataArray=[[DataBaseClass getSharedInstance]receiveAllData];
    
    
    sectionElementArray=[[NSMutableArray alloc]init];
    for (RecordData *record in [DataBaseClass getSharedInstance].arrRecord) {
        [sectionElementArray addObject:record];
        [mainSectionElementArray addObject:record];
    }
    [myRecordTableView reloadData];
//    if([fetchDataArray count]<=3){
//        orderByBtn.enabled=NO;
//    }
//    else{
//        orderByBtn.enabled=YES;
//    }
    [[AppDelegate sharedAppDelegate] endActivityIndicatorAnimation];

}

//**********Table Delegate Method*******************//

//This return no of Section in table view
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

        return [sectionElementArray count];
   
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
         return myRecordSectionHeight;
}

//it Define the Containt of 'Section'
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [self sectionViewWithTag:section];
}

- (UIView*)sectionViewWithTag:(int)tag{
    
    RecordData *record = (RecordData*)[sectionElementArray objectAtIndex:tag];
    UIView *sectionView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 70)] autorelease];
    
    UIImageView *backImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, myRecordSectionHeight )] ;
    if (tag%2==0)
        [backImageView setImage:[UIImage imageNamed:SectionImage2]];
    else
        [backImageView setImage:[UIImage imageNamed:SectionImage1]];
    [sectionView addSubview:backImageView];
    [backImageView release];
    
     UIImageView *productImageView=[[UIImageView alloc]init] ;
    [productImageView setFrame:CGRectMake(7, 5, 46, myRecordSectionHeight-10)];
    [sectionView addSubview:productImageView];
    productImageView.layer.masksToBounds=YES;
    productImageView.layer.cornerRadius = 3.0f;
    productImageView.contentMode = IMAGE_ASPECT;
    [productImageView setImage:[[AppDelegate sharedAppDelegate] getProductImageFromName:[NSString stringWithFormat:@"%d",tag+1] andImageName:@"1.png"]];
    if(!productImageView.image){
        [productImageView setImage:[UIImage imageNamed:@"defaultLogo.png"]];
    }

    UILabel *staticProductLbl=[[UILabel alloc]initWithFrame:CGRectMake(59,CGRectGetMinY(productImageView.frame),53,20)] ;
    [staticProductLbl setText:@"Product:"];
    [staticProductLbl setBackgroundColor:[UIColor clearColor]];
    [staticProductLbl setFont:[UIFont systemFontOfSize:12]];
    [sectionView addSubview:staticProductLbl];
    
    
    UILabel *productNameLbl=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(staticProductLbl.frame),CGRectGetMinY(staticProductLbl.frame),110,staticProductLbl.frame.size.height)] ;
    [productNameLbl setFont:[UIFont systemFontOfSize:13]];
    [productNameLbl setText:[record productNameStr]];
    [productNameLbl setBackgroundColor:[UIColor clearColor]];
    [productNameLbl setTextColor:[UIColor myGreenColor]];
    [sectionView addSubview:productNameLbl];
    
    
    //day Left Label
    UILabel *dayLeftLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(productNameLbl.frame)+5,CGRectGetMinY(productNameLbl.frame)-8, 90,30)] ;
    dayLeftLabel.numberOfLines=2;
    [dayLeftLabel setBackgroundColor:[UIColor clearColor]];
    [dayLeftLabel setFont:[UIFont systemFontOfSize:10]];
    [dayLeftLabel setTextColor:[UIColor redColor]];
    [sectionView addSubview:dayLeftLabel];
    if (record.returnDate) {
        dayLeftLabel.text = [[AppDelegate sharedAppDelegate] getInterBetweenTwoDate:getCurrentDate() ReturnDate:[self.dateFormatterSection dateFromString:[record returnDate]]];
    }
    if(record.productReturnedStatus==1){
        dayLeftLabel.text = MSG_PRODUCT_RETURN;
    }
    
    UILabel *staticShopNameLbl=[[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(staticProductLbl.frame),CGRectGetMaxY(staticProductLbl.frame)+1,70,10)] autorelease];
    [staticShopNameLbl setText:@"Shop:"];
    [staticShopNameLbl setTextColor:[UIColor subTitleColor]];
    [staticShopNameLbl setBackgroundColor:[UIColor clearColor]];
    [staticShopNameLbl setFont:[UIFont systemFontOfSize:10]];
    [sectionView addSubview:staticShopNameLbl];
    
    UILabel *shopNameLbl=[[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(staticShopNameLbl.frame)+5,CGRectGetMinY(staticShopNameLbl.frame),150,10)] autorelease];
    [shopNameLbl setFont:[UIFont systemFontOfSize:10]];
    StoreData *element=[[StoreData alloc]init];
    for (StoreData *data in [AppDelegate sharedAppDelegate].cellItemArr) {
        if (record.shopID==data.shopId) {
            element   =data;
        }
    }
    [shopNameLbl setBackgroundColor:[UIColor clearColor]];
    [shopNameLbl setTextColor:[UIColor subTitleColor]];
    [shopNameLbl setText:element.shopName];
    [sectionView addSubview:shopNameLbl];
    
    UILabel *staticPurchaseDateLbl=[[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(staticShopNameLbl.frame), CGRectGetMaxY(staticShopNameLbl.frame)+2, staticShopNameLbl.frame.size.width+8,staticShopNameLbl.frame.size.height)] autorelease];
    [staticPurchaseDateLbl setText:@"Purchase Date:"];
    [staticPurchaseDateLbl setBackgroundColor:[UIColor clearColor]];
    [staticPurchaseDateLbl setTextColor:[UIColor subTitleColor]];
    [staticPurchaseDateLbl setFont:[UIFont systemFontOfSize:10]];
    [sectionView addSubview:staticPurchaseDateLbl];
    
    
    
    UILabel *purchaseDateLbl=[[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(shopNameLbl.frame),CGRectGetMinY(staticPurchaseDateLbl.frame),shopNameLbl.frame.size.width, shopNameLbl.frame.size.height)] autorelease];
    [purchaseDateLbl setFont:[UIFont systemFontOfSize:10]];
    [purchaseDateLbl setBackgroundColor:[UIColor clearColor]];
    [purchaseDateLbl setTextColor:[UIColor subTitleColor]];
    if ([record purchaseDateStr]) {
        [purchaseDateLbl setText:[[record.purchaseDateStr componentsSeparatedByString:@" "] objectAtIndex:0]];
    }
    
    [sectionView addSubview:purchaseDateLbl];
    
    UILabel *staticreturnDateLbl=[[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(staticPurchaseDateLbl.frame), CGRectGetMaxY(staticPurchaseDateLbl.frame)+2,staticPurchaseDateLbl.frame.size.width,staticPurchaseDateLbl.frame.size.height)] autorelease];
    [staticreturnDateLbl setText:@"Return Date:"];
    [staticreturnDateLbl setBackgroundColor:[UIColor clearColor]];
    [staticreturnDateLbl setTextColor:[UIColor subTitleColor]];
    [staticreturnDateLbl setFont:[UIFont systemFontOfSize:10]];
    [sectionView addSubview:staticreturnDateLbl];
    
    UILabel *returnDateLbl=[[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(purchaseDateLbl.frame),CGRectGetMinY(staticreturnDateLbl.frame), purchaseDateLbl.frame.size.width,purchaseDateLbl.frame.size.height)] autorelease];
    [returnDateLbl setFont:[UIFont systemFontOfSize:10]];
    [returnDateLbl setTextColor:[UIColor subTitleColor]];
    [returnDateLbl setBackgroundColor:[UIColor clearColor]];
    if ([record returnDate]) {
        [returnDateLbl setText:[[record.returnDate componentsSeparatedByString:@" "] objectAtIndex:0]];
    }
    [sectionView addSubview:returnDateLbl];
    
    //Add & Minus Button on Section
    UIButton *addBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setFrame:CGRectMake(0,0,320,myRecordSectionHeight)];
    addBtn.selected=NO;
    addBtn.tag=tag;
    [addBtn setUserInteractionEnabled:YES];
    [addBtn addTarget:self action:@selector(clickOnSectionBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [sectionView addSubview:addBtn];
    
    UIImageView *addBtnImageView;
    if([UIScreen mainScreen].bounds.size.height == 568.0)
    {
        //move to your iphone5 storyboard
        addBtnImageView=[[[UIImageView alloc]initWithFrame:CGRectMake(290,(sectionSize/2)-10, 20, 17)] autorelease];
    }
    else{
        //move to your iphone4s storyboard
        addBtnImageView=[[[UIImageView alloc]initWithFrame:CGRectMake(290,(sectionSize/2)-10, 20, 20)] autorelease];
    }
    [addBtnImageView setImage:[UIImage imageNamed:@"plush-icon"]];
    [sectionView addSubview:addBtnImageView];
    
    
    if (tag==didSelected)
    {
        addBtn.selected=YES;
        [addBtnImageView setImage:[UIImage imageNamed:@"minus-icon"]];
        
        [myRecordTableView setContentOffset:CGPointMake(0, tag*myRecordSectionHeight)];
    }else
    {
        [addBtnImageView setImage:[UIImage imageNamed:@"plush-icon"]];
        addBtn.selected=NO;
    }
    
    [productImageView release];
    [staticProductLbl release];
    [productNameLbl release];
    [dayLeftLabel release];
    
    return sectionView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return rowSize;
}

//Define the row containt
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([imageArray count]>0) {
        [imageArray removeAllObjects];
        
    }
    sectonID=indexPath.section;
    static NSString *cellIdentifier=@"cell";
    myRecordTableViewCell *cell=(myRecordTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil)
    {
        cell=[[[myRecordTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:cellIdentifier] autorelease];
    }
    currentRecord=(RecordData*)[sectionElementArray objectAtIndex:indexPath.section];
    cell.productNameTxt.text=currentRecord.productNameStr;
    cell.receiptNoTxt.text=currentRecord.receiptNumberStr;
    cell.purchaseDateTxt.text=currentRecord.purchaseDateStr;
    cell.returnDateTxt.text=currentRecord.returnDate;
    addNotesStr=currentRecord.notes;
    shopId=currentRecord.shopID;
    
    if ([currentRecord.returnAlertDate length]>0) {
        cell.returnAlertTextField.text=currentRecord.returnAlertDate;
        cell.lblTemp2.hidden=NO;
    }
    else
    {
        cell.lblTemp2.hidden=YES;
    }
    
    recNumber = currentRecord.receiptNumberStr;
    if (currentRecord.productReturnedStatus==1) {
        cell.productReturnValue=1;
        [cell.productReturnedImageView setImage:[UIImage imageNamed:@"GreenCheckBoxWithSelect"] ];
        [cell.timeLeftDescLbl setText:@"Procuct returned"];
    }
    else
    {
        cell.productReturnValue=0;
        cell.timeLeftDescLbl.text=daysLeft;
        [cell.productReturnedImageView setImage:[UIImage imageNamed:@"GreenCheckBox"] ];
    }
    
    imageArray=[[NSMutableArray alloc]init];
    [cell.image1Btn setEnabled:YES];
    [cell.image2Btn setEnabled:YES];
    [cell.image3Btn setEnabled:YES];
    [cell.image4Btn setEnabled:YES];
    if ([[AppDelegate sharedAppDelegate] CheckProductImageIsExist:@"1.png" andProductID:currentRecord.productID]) {
        [cell.firstImageView setImage:[[AppDelegate sharedAppDelegate] getProductImageFromName:[NSString stringWithFormat:@"%d",currentRecord.productID] andImageName:@"1.png"]];
        [imageArray addObject:cell.firstImageView.image];
    }
    else
    {
        cell.firstImageView.image=nil;
    }
    if ([[AppDelegate sharedAppDelegate] CheckProductImageIsExist:@"2.png" andProductID:currentRecord.productID]) {
        [cell.secondImageView setImage:[[AppDelegate sharedAppDelegate] getProductImageFromName:[NSString stringWithFormat:@"%d",currentRecord.productID] andImageName:@"2.png"]];
        [imageArray addObject:cell.secondImageView.image];
    }
    else
    {
        cell.secondImageView.image=nil;
    }
    if ([[AppDelegate sharedAppDelegate] CheckProductImageIsExist:@"3.png" andProductID:currentRecord.productID]) {
        [cell.thirdImageView setImage:[[AppDelegate sharedAppDelegate] getProductImageFromName:[NSString stringWithFormat:@"%d",currentRecord.productID] andImageName:@"3.png"]];
        [imageArray addObject:cell.thirdImageView.image];
    }
    else
    {
        cell.thirdImageView.image=nil;
    }
    if ([[AppDelegate sharedAppDelegate] CheckProductImageIsExist:@"4.png" andProductID:currentRecord.productID]) {
        [cell.fourthImageView setImage:[[AppDelegate sharedAppDelegate] getProductImageFromName:[NSString stringWithFormat:@"%d",currentRecord.productID] andImageName:@"4.png"]];
        [imageArray addObject:cell.fourthImageView.image];
    }
    else{
        cell.fourthImageView.image=nil;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate=self;
    cell.keyBoardController.keyBoardDelegate=self;
    
    //
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MMM-yy HH:mm:ss"];
    NSDate *returnDate= [dateFormatter dateFromString:currentRecord.returnDate];
    
    cell.timeLeftDescLbl.text = [[AppDelegate sharedAppDelegate] getInterBetweenTwoDate:getCurrentDate() ReturnDate:returnDate];
    
    //[dateFormatter setDateFormat:@"dd-MMM-yy HH:mm:ss"];
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
                                                        fromDate:getDateWithFormate_ddMMMyy([dateFormatter dateFromString:currentRecord.purchaseDateStr])
                                                          toDate:getDateWithFormate_ddMMMyy([dateFormatter dateFromString:currentRecord.returnDate])
                                                         options:0];
    cell.returnDurationTxt.text=[NSString stringWithFormat:@"%i",components.day];
    
    
    if(currentRecord.productReturnedStatus==1){
        cell.timeLeftDescLbl.text = MSG_PRODUCT_RETURN;
    }
    
    
    //For Initially hide return duration
    [cell.returnDateImgView setImage:[UIImage imageNamed:@"radioActive"] ];
    [cell.returnDurationImgView setImage:[UIImage imageNamed:@"radioUnActive"]];
    
    
    [cell.returnDateTxt setHidden:NO];
    [cell.returnDateTxtImage setHidden:NO];
    [cell.calendarBtn2 setHidden:NO];
    [cell.cal2ImageView setHidden:NO];
    [cell.returnDurationTxt setHidden:YES];
    [cell.returnDurationTxtImage setHidden:YES];
    [cell.returnDurationTxt setEnabled:NO];
    //updateFlag=YES;
    return cell;
}


////******************SearchBar Delegate********************
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [myRecordTableView setContentOffset:CGPointMake(0, 0)];
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
    [sectionElementArray removeAllObjects];
    sectionElementArray=[[NSMutableArray alloc]init];
    for (RecordData *rec in mainSectionElementArray) {
        [sectionElementArray addObject:rec];
    }
    [myRecordTableView reloadData];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    if(searchText.length==0)
    {
        isSearchActive=false;
        [sectionElementArray removeAllObjects];
        sectionElementArray=[[NSMutableArray alloc]init];
        for (RecordData *rec in mainSectionElementArray) {
            [sectionElementArray addObject:rec];
        }

        [myRecordTableView reloadData];
        [myRecordTableView resignFirstResponder];
        [searchBar performSelector: @selector(resignFirstResponder)
                        withObject: nil
                        afterDelay: 0.1];
    }else
    {
        //    isFiltered=true;
        isSearchActive=TRUE;
        [sectionElementArray removeAllObjects];
        sectionElementArray=[[NSMutableArray alloc]init];
        
        for (RecordData *rec in mainSectionElementArray)
        {
            NSString *strSearch = searchBar.text;
            
            strSearch = [strSearch lowercaseString];
            strSearch = [strSearch stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[strSearch substringToIndex:1] uppercaseString]];
            NSString *matchString = rec.productNameStr;
            matchString = [matchString lowercaseString];
            matchString = [matchString stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[matchString substringToIndex:1] uppercaseString]];
            NSRange strtitlerange=[matchString rangeOfString:strSearch options:(NSLiteralSearch)];
            if(strtitlerange.location != NSNotFound)
            {
                [sectionElementArray addObject:rec];
            }
        }
        [myRecordTableView reloadData];
    }
}

//-------------------------------------------------------------

//*************************Delegate Method of MyRecordTableViewCell******************************


//Add Notes Click Method
-(void)addNotesClick:(id)sender
{
    myRecordTableViewCellObj=(myRecordTableViewCell*)sender;
    NSString *productName=myRecordTableViewCellObj.productNameTxt.text;
    NSString *purchaseDate=myRecordTableViewCellObj.purchaseDateTxt.text;
    NSString *returnDate=myRecordTableViewCellObj.returnDateTxt.text;
    AddNotesViewController *addNotesView=[[AddNotesViewController alloc]initWithNibName:@"AddNotesViewController" bundle:nil currentDate:[NSDate date] productName:productName shopName:[[AppDelegate sharedAppDelegate] getShopNameWithID:shopId] purchaseDate:purchaseDate returnDate:returnDate image:([imageArray count]>0)?[imageArray objectAtIndex:0]:nil withAddNotesStr:addNotesStr];
    
    isShowImage=YES;
    addNotesView.delegate=self;
//    
    [self presentModalViewController:addNotesView animated:YES];
}

//Method call by AddNotesViewController
-(void)assingAddNote:(NSString*)note
{
    addNotesStr=nil;
    addNotesStr=[[NSString alloc]initWithString:note];
   
}


//Calendar Btn Method
-(void)calendarOpen:(id)sender
{
    myRecordTableViewCellObj=(myRecordTableViewCell*)sender;
    
    self.viewPickDate.hidden = NO;
    pickerNumber = myRecordTableViewCellObj.dateBtnTag;
    if(pickerNumber==1){
        self.pickerView.minimumDate = nil;
        self.pickerView.maximumDate = getCurrentDate();
        if([myRecordTableViewCellObj.purchaseDateTxt.text length]>0){
            self.pickerView.date = [self.pickDateFormatter dateFromString:myRecordTableViewCellObj.purchaseDateTxt.text];
        }
        else{
            self.pickerView.date = getCurrentDate();
        }
    }
    else if(pickerNumber==2){
        if([myRecordTableViewCellObj.purchaseDateTxt.text length]>0){
            self.pickerView.minimumDate = [self.pickDateFormatter dateFromString:myRecordTableViewCellObj.purchaseDateTxt.text];
        }
        else{
            self.pickerView.minimumDate = getCurrentDate();
        }
        self.pickerView.maximumDate = nil;
        if([myRecordTableViewCellObj.returnDateTxt.text length]>0){
            self.pickerView.date = [self.pickDateFormatter dateFromString:myRecordTableViewCellObj.returnDateTxt.text];
        }
        else{
            self.pickerView.date = getCurrentDate();
        }
    }
    else if(pickerNumber==3){
        if([myRecordTableViewCellObj.purchaseDateTxt.text length]>0){
            self.pickerView.minimumDate = [self.pickDateFormatter dateFromString:myRecordTableViewCellObj.purchaseDateTxt.text];
        }
        else{
            self.pickerView.minimumDate = getCurrentDate();
        }
        
        if([myRecordTableViewCellObj.returnDateTxt.text length]>0){
            self.pickerView.maximumDate = [self.pickDateFormatter dateFromString:myRecordTableViewCellObj.returnDateTxt.text];
        }
        else{
            self.pickerView.maximumDate = getCurrentDate();
        }
        
        if([myRecordTableViewCellObj.returnAlertTextField.text length]>0){
            self.pickerView.date = [self.pickDateFormatter dateFromString:myRecordTableViewCellObj.returnAlertTextField.text];
        }
        else{
            self.pickerView.date = getCurrentDate();
        }
    }
    
    
//    aac = [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n\n"  delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
//    theDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 44.0, 0.0, 0.0)];
//
//    theDatePicker.datePickerMode=UIDatePickerModeDate;
//    [theDatePicker addTarget:self action:@selector(datePick:) forControlEvents:UIControlEventValueChanged];
//    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
//    [dateFormatter1 setDateFormat:@"dd-MMM-yy HH:mm:ss"];
//    
//    
//    //seting datepicker display
//    if (myRecordTableViewCellObj.dateBtnTag==1)
//    {
//        if ([myRecordTableViewCellObj.purchaseDateTxt.text length]>0) {
//            theDatePicker.date=[dateFormatter1 dateFromString:myRecordTableViewCellObj.purchaseDateTxt.text];
//        }
//        [theDatePicker setMaximumDate: getCurrentDate()];
//    }
//    else if(myRecordTableViewCellObj.dateBtnTag==2)
//    {
//        if ([myRecordTableViewCellObj.returnDateTxt.text length]>0) {
//            theDatePicker.date=[dateFormatter1 dateFromString:myRecordTableViewCellObj.returnDateTxt.text];
//        }
//        [theDatePicker setMinimumDate:getCurrentDate()];
//    }
//    else if (myRecordTableViewCellObj.dateBtnTag==3)
//    {
//       
//        if ([myRecordTableViewCellObj.returnAlertTextField.text length]>0) {
//            theDatePicker.date=[dateFormatter1 dateFromString:myRecordTableViewCellObj.returnAlertTextField.text];
//
//        }
//        [theDatePicker setMinimumDate:[dateFormatter1 dateFromString:myRecordTableViewCellObj.purchaseDateTxt.text]];
//        [theDatePicker setMaximumDate:[dateFormatter1 dateFromString:myRecordTableViewCellObj.returnDateTxt.text]];
//    }
//
//        
////    UIToolbar *pickerDateToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
////    pickerDateToolbar.barStyle = UIBarStyleBlackOpaque;
////    [pickerDateToolbar sizeToFit];
////    
////    NSMutableArray *barItems = [[NSMutableArray alloc] init];
////    
////    
////    
////    
////    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
////    
////    UILabel *toolBarItemlabel;
////    if([self interfaceOrientation] == UIInterfaceOrientationPortraitUpsideDown || [self interfaceOrientation] == UIInterfaceOrientationPortrait)
////        toolBarItemlabel= [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 180,30)];
////    else
////        toolBarItemlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200,30)];
////    
////    [toolBarItemlabel setTextAlignment:UITextAlignmentCenter];
////    [toolBarItemlabel setTextColor:[UIColor whiteColor]];
////    [toolBarItemlabel setFont:[UIFont boldSystemFontOfSize:16]];
////    [toolBarItemlabel setBackgroundColor:[UIColor clearColor]];
////    toolBarItemlabel.text = [NSString stringWithFormat:@"Select Expire Date"];
////    
////    UIBarButtonItem *buttonLabel =[[UIBarButtonItem alloc]initWithCustomView:toolBarItemlabel];
////    [toolBarItemlabel release];
////    [barItems addObject:buttonLabel];
////    [buttonLabel release];
////    
////    [barItems addObject:flexSpace];
////    UIBarButtonItem *SelectBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(DatePickercancelClick:)];
////    [barItems addObject:SelectBtn];
////    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(DatePickerDoneClick:)];
////    [barItems addObject:doneBtn];
//    
//    
//   // [pickerDateToolbar setItems:barItems animated:YES];
////    [aac addSubview:pickerDateToolbar];
//    
//    UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Cancel"]];
//    closeButton.momentary = YES;
//    
//    closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
//    closeButton.tintColor = [UIColor blackColor];
//    [closeButton addTarget:self action:@selector(DatePickercancelClick:) forControlEvents:UIControlEventValueChanged];
//    [aac addSubview:closeButton];
//    [closeButton release];
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
//    if ([[[UIDevice currentDevice] model] hasPrefix:@"iPad"]) {
//        closeButton.frame = CGRectMake(150, 7.0f, 50.0f, 30.0f);
//        doneButton.frame=CGRectMake(210, 7.0f, 50.0f, 30.0f);
//    }
//    else
//    {
//        closeButton.frame = CGRectMake(200, 7.0f, 50.0f, 30.0f);
//        doneButton.frame=CGRectMake(260, 7.0f, 50.0f, 30.0f);
//    }
//    
//
//    [aac addSubview:theDatePicker];
//    
//    
////    CGRect myImageRect = CGRectMake(0.0f, 300.0f, 320.0f, 175.0f);
////    [aac showFromRect:myImageRect inView:self.view animated:YES ];
//    [aac showFromTabBar:self.tabBarController.tabBar];
//    [UIView beginAnimations:nil context:nil];
//    
//    
//    if ([[[UIDevice currentDevice] model] hasPrefix:@"iPad"]) {
//        // This app is an iPhone app running on an iPad
//        
//        //[aac showFromRect:CGRectMake(0, 300, 320, 600) inView:self.view animated:YES];
//        [aac showFromTabBar:self.tabBarController.tabBar];
//        [theDatePicker setFrame:CGRectMake(-30, 40, 0, 90)];
//    }
//    //ActionSheet Custom scaling
//    
//    if([self interfaceOrientation] == UIInterfaceOrientationPortraitUpsideDown || [self interfaceOrientation] == UIInterfaceOrientationPortrait)
//        [aac showFromTabBar:self.tabBarController.tabBar];
//    else
//        [aac setBounds:CGRectMake(0,0,480, 400)];
//    
//    [UIView commitAnimations];
//    
//   
//
//    
}


//When user press click btn
-(void)clickOnSectionBtn:(id)sender
{
    
    
    UIButton *tmp=(UIButton *)sender;
    [self keyBoardHide];
    tmp.selected=!tmp.selected;
    sectionNumber = tmp.tag;
    if (tmp.selected)
    {
       currentOffSet=myRecordTableView.contentOffset;
        didSelected=tmp.tag;
        CGRect frame=myRecordTableView.frame;
        frame.size.height=320;
        myRecordTableView.frame=frame;
        
        [tableScrollView setContentSize:CGSizeMake(0, CGRectGetMaxY(frame))];
        
        tableScrollView.contentOffset=CGPointMake(0, myRecordTableView.frame.origin.y);
        [myRecordTableView setContentOffset:CGPointMake(0, sectionNumber*myRecordSectionHeight+10)];
        
    }else
    {
        didSelected=777;
        //[myRecordTableView setFrame:CGRectMake(myRecordTableView.frame.origin.x, myRecordTableView.frame.origin.y, myRecordTableView.frame.size.width, 250)];
//        [tableScrollView setContentOffset:CGPointMake(0,0)];
        [myRecordTableView setContentOffset:currentOffSet];

    }
    
    [myRecordTableView reloadData];
    //[myRecordTableView setContentOffset:currentOffSet];
    
}


//Update Btn Click
-(void)updateBtnMethod:(id)sender
{
    
    myRecordTableViewCellObj=(myRecordTableViewCell*)sender;
   
    if(![recNumber isEqualToString:myRecordTableViewCellObj.receiptNoTxt.text]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"You can not change receipt number." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        myRecordTableViewCellObj.receiptNoTxt.text = recNumber;
        return;
    }
    [[AppDelegate sharedAppDelegate] startActivityIndicatorAnimationWithMsg:@"Wait"];
    //******It Will Replace by submitSelector Method*********/
    [self performSelector:@selector(submitSelector) withObject:nil afterDelay:2.0f];
   }

-(void)submitSelector
{
    RecordData *record=[[[RecordData alloc]init] autorelease];
    record.shopID=currentRecord.shopID;
    record.productNameStr=myRecordTableViewCellObj.productNameTxt.text;
    record.receiptNumberStr=myRecordTableViewCellObj.receiptNoTxt.text;
    record.purchaseDateStr=myRecordTableViewCellObj.purchaseDateTxt.text;
    record.returnDate=myRecordTableViewCellObj.returnDateTxt.text;
    if ([myRecordTableViewCellObj.returnAlertTextField.text length ]>0) {
        record.returnAlertDate=myRecordTableViewCellObj.returnAlertTextField.text;
    }
    record.productReturnedStatus=myRecordTableViewCellObj.productReturnValue;
    record.productID=currentRecord.productID;
    record.notes=addNotesStr;
    isFirstTime=NO;
    BOOL success=[[DataBaseClass getSharedInstance]updateData:record];
    NSString *alrtMsg;
    if (success) {
        if([imageArray count]>0){
            [[AppDelegate sharedAppDelegate] saveProductImageWithName:@"1.png" andImage:[imageArray objectAtIndex:0] andProductID:[NSString stringWithFormat:@"%d",currentRecord.productID]];
        }
        if([imageArray count]>1){
            [[AppDelegate sharedAppDelegate] saveProductImageWithName:@"2.png" andImage:[imageArray objectAtIndex:1] andProductID:[NSString stringWithFormat:@"%d",currentRecord.productID]];
        }
        if([imageArray count]>2){
            [[AppDelegate sharedAppDelegate] saveProductImageWithName:@"3.png" andImage:[imageArray objectAtIndex:2] andProductID:[NSString stringWithFormat:@"%d",currentRecord.productID]];
        }
        if([imageArray count]>3){
            [[AppDelegate sharedAppDelegate] saveProductImageWithName:@"4.png" andImage:[imageArray objectAtIndex:3] andProductID:[NSString stringWithFormat:@"%d",currentRecord.productID]];
        }
        alrtMsg=@"Details has been updated successfully.";
        [self loadData];
        didSelected=777;
        [myRecordTableView setContentOffset:CGPointMake(0, 0)];
        [tableScrollView setContentOffset:CGPointMake(0,0)];
        [myRecordTableView reloadData];
        
        NotificationClass *noti = [[NotificationClass alloc] init];
        [noti cancelNotificationWithReceiptNumber:[NSString stringWithFormat:@"%i",currentRecord.productID]];
        [noti release];
        NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [dateFormatter setDateFormat:@"dd-MMM-yy HH:mm:ss"];
        if ([AppDelegate sharedAppDelegate].notificationIsOn) {
            //[self notification:records.returnDate purchaseDate:records.purchaseDateStr];
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:record.receiptNumberStr forKey:@"receiptNumber"];
            [dict setValue:record.productNameStr forKey:@"productName"];
            [dict setValue:[NSString stringWithFormat:@"%i",currentRecord.productID] forKey:@"productId"];
            [dict setValue:[[AppDelegate sharedAppDelegate] getShopNameWithID:record.shopID] forKey:@"companyName"];
            NotificationClass *notificationObj = [[NotificationClass alloc] init];
            [notificationObj setNotificationWithPurchaseDate:[dateFormatter dateFromString:record.purchaseDateStr] ReturnDate:[dateFormatter dateFromString:record.returnDate] msgDictionary:dict];
            if([record.returnAlertDate length]>0){
                [notificationObj addNotificationWithDate:[dateFormatter dateFromString:record.returnAlertDate] ReturnDate:[dateFormatter dateFromString:record.returnDate] andDictionar:dict];
            }
            [notificationObj release];
        }
    }
    else
    {
        alrtMsg=@"ther should we some error";
    }
    
    [[AppDelegate sharedAppDelegate] endActivityIndicatorAnimation];
    
    UIAlertView *alert=[[[UIAlertView alloc]initWithTitle:@"" message:alrtMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] autorelease];
    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];

}
-(void)setCameraImage:(id)sender withSenderTag:(NSInteger)tag
{
    [self keyBoardHide];
    btnTag=tag;
    

    myRecordTableViewCellObj=(myRecordTableViewCell*)sender;
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [self setGallary:sender withSenderTag:tag];
        
    }
    else
    {
        isFirstTime=YES;
        picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        //[self presentModalViewController:picker animated:YES];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            popover = [[UIPopoverController alloc] initWithContentViewController:picker];
            popover.delegate=self;
            [popover presentPopoverFromRect:CGRectMake(10, 40, 100, 400.0)
                                     inView:self.view
                   permittedArrowDirections:UIPopoverArrowDirectionAny
                                   animated:YES];
        } else {
            [self presentModalViewController:picker animated:YES];
        }
        
    }
}
-(void)setGallary:(id)sender withSenderTag:(NSInteger)tag
{
    [self keyBoardHide];
    btnTag=tag;

    myRecordTableViewCellObj=(myRecordTableViewCell*)sender;
    isFirstTime=YES;
    picker=[[UIImagePickerController alloc]init];
    picker.delegate=self;
    picker.allowsEditing=YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
   // [self presentModalViewController:picker animated:YES];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        popover = [[UIPopoverController alloc] initWithContentViewController:picker];
        popover.delegate=self;
        [popover presentPopoverFromRect:CGRectMake(10, 40, 100, 400.0)
                                 inView:self.view
               permittedArrowDirections:UIPopoverArrowDirectionAny
                               animated:YES];
        //self.view = popover;
    } else {
        [self presentViewController:picker animated:YES completion:NULL ];
    }
;

}

// This method createImage Picker Controller delegate methods
-(void)imagePickerController:(UIImagePickerController *)picker  didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissModalViewControllerAnimated:YES];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        [popover dismissPopoverAnimated:YES];
    }
    if (btnTag==1) {
        myRecordTableViewCellObj.firstImageView.image=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
        [imageArray addObject:myRecordTableViewCellObj.firstImageView.image];
    }
    else if (btnTag==2)
    {
        myRecordTableViewCellObj.secondImageView.image=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
        [imageArray addObject:myRecordTableViewCellObj.secondImageView.image];
    }
    else if (btnTag==3)
    {
        myRecordTableViewCellObj.thirdImageView.image=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
        [imageArray addObject:myRecordTableViewCellObj.thirdImageView.image];
    }
    else if (btnTag==4)
    {
        myRecordTableViewCellObj.fourthImageView.image=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
        [imageArray addObject:myRecordTableViewCellObj.fourthImageView.image];
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
    
}

-(void)deleteBtnMethod:(id)sender
{
    myRecordTableViewCellObj=(myRecordTableViewCell*)sender;
    [[AppDelegate sharedAppDelegate]startActivityIndicatorAnimationWithMsg:@""];
    [self performSelectorInBackground:@selector(deleteSelector) withObject:nil];
}

-(void)deleteSelector
{
    BOOL success=[[DataBaseClass getSharedInstance]deleteData:currentRecord.productID];
    NSString *alrtMsg;
    if (success) {
        NotificationClass *noti = [[NotificationClass alloc] init];
        //            [noti cancelNotificationWithReceiptNumber:self.receiptNoTxt.text];
        [noti cancelNotificationWithReceiptNumber:[NSString stringWithFormat:@"%i",currentRecord.productID]];
        alrtMsg=@"Product has been deleted. All corresponding Notifications are also deleted.";
        didSelected=777;
        //[myRecordTableView setFrame:CGRectMake(myRecordTableView.frame.origin.x, myRecordTableView.frame.origin.y, myRecordTableView.frame.size.width, 250)];
        [myRecordTableView setContentOffset:CGPointMake(0, 0)];
        [tableScrollView setContentOffset:CGPointMake(0,0)];
        [self loadData];
    }
    else
    {
        alrtMsg=@"There is some internal error. Please try again after sometime.";
    }
    [self performSelectorOnMainThread:@selector(deleteSuccess:) withObject:alrtMsg waitUntilDone:NO];
    
}

-(void)deleteSuccess:(NSString*)alrtMsg
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:alrtMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    [[AppDelegate sharedAppDelegate]endActivityIndicatorAnimation];
}

//When cancel btn click on DatePicker Contrller
- (void)DatePickercancelClick:(id)sender{
    
    [aac dismissWithClickedButtonIndex:0 animated:YES];
    
}


-(void)DatePickerDoneClick:(id)sender {
    
    NSDateFormatter *df=[[[NSDateFormatter alloc]init] autorelease];
    df.dateFormat = @"dd-MMM-yy HH:mm:ss";
    NSArray *temp=[[NSString stringWithFormat:@"%@",[df stringFromDate:theDatePicker.date]] componentsSeparatedByString:@""];
    
    [dateString1 release];
    dateString1=nil;
    dateString1 = [[NSString alloc]initWithString:[temp objectAtIndex:0]];
   
    [aac dismissWithClickedButtonIndex:0 animated:YES];
    
    
    
    if (myRecordTableViewCellObj.dateBtnTag==1) {
        [myRecordTableViewCellObj.purchaseDateTxt setText:dateString1];
    }
    else if(myRecordTableViewCellObj.dateBtnTag==2)
    {
        NSDate *newDate1 = theDatePicker.date;
        [myRecordTableViewCellObj.returnDateTxt setText:dateString1];
        myRecordTableViewCellObj.timeLeftDescLbl.text = [[AppDelegate sharedAppDelegate] getInterBetweenTwoDate:getCurrentDate() ReturnDate:newDate1];
        
    }
    else if (myRecordTableViewCellObj.dateBtnTag==3)
    {
        myRecordTableViewCellObj.lblTemp2.hidden=NO;
        [myRecordTableViewCellObj.returnAlertTextField setText:dateString1];
    }
    


}

-(void)datePick:(id)sender
{
    NSDateFormatter *df=[[[NSDateFormatter alloc]init] autorelease];
    df.dateFormat = @"dd-MMM-yy HH:mm:ss";
    NSArray *temp=[[NSString stringWithFormat:@"%@",[df stringFromDate:theDatePicker.date]] componentsSeparatedByString:@""];
    
    [dateString1 release];
    dateString1=nil;
    dateString1 = [[NSString alloc]initWithString:[temp objectAtIndex:0]];
    
    
    
    if (myRecordTableViewCellObj.dateBtnTag==1) {
        [myRecordTableViewCellObj.purchaseDateTxt setText:dateString1];
    }
    else if(myRecordTableViewCellObj.dateBtnTag==2)
    {
        NSDate *newDate1 = theDatePicker.date;
        [myRecordTableViewCellObj.returnDateTxt setText:dateString1];
        myRecordTableViewCellObj.timeLeftDescLbl.text = [[AppDelegate sharedAppDelegate] getInterBetweenTwoDate:getCurrentDate() ReturnDate:newDate1];
        
    }
    else if (myRecordTableViewCellObj.dateBtnTag==3)
    {
        [myRecordTableViewCellObj.returnAlertTextField setText:dateString1];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [myRecordTableView release];
    [orderByBtn release];
    [myRecordTableViewCellObj release];
    [orderByBtnData release];
    
    //[cell release];
  //  [imageArray release];
    [tableScrollView release];
    [_viewAdvertisement release];
    [_bannerImageView release];
    [_searchBarProducts release];
    [_viewPickDate release];
    [super dealloc];
}
- (void)viewDidUnload {
//    [[AppDelegate sharedAppDelegate].addView.adView cancelAd];
    [self setMyRecordTableView:nil];
    [self setOrderByBtn:nil];
    [self setTableScrollView:nil];
    [self setViewAdvertisement:nil];
    [self setBannerImageView:nil];
    [self setSearchBarProducts:nil];
    [self setViewPickDate:nil];
    [super viewDidUnload];
}

//*********************************ViewController Method********************************
//OrderBy All Functionality Method
- (IBAction)orderByMethod:(id)sender {

//    [self keyBoardHide];
//    pickerActionSheet = [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n\n" delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
//    
//    [pickerActionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
//    
//    CGRect pickerFrame = CGRectMake(0, 40, 0, 0);
//    
//    orderPickerView = [[UIPickerView alloc] initWithFrame:pickerFrame];
//    orderPickerView.showsSelectionIndicator=YES;
//    
//    [orderPickerView setDataSource:self];
//    [orderPickerView setDelegate:self];
//    ;
//    [orderPickerView selectRow:selectedOrderInt inComponent:0 animated:NO];
//
//    
//    [pickerActionSheet addSubview:orderPickerView];
//    
//    UIToolbar *pickerDateToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
//    pickerDateToolbar.barStyle = UIBarStyleBlackOpaque;
//    [pickerDateToolbar sizeToFit];
//    
//    NSMutableArray *barItems = [[NSMutableArray alloc] init];
//    
//    
//    
//    
//    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
//    
//    UILabel *toolBarItemlabel;
//    if([self interfaceOrientation] == UIInterfaceOrientationPortraitUpsideDown || [self interfaceOrientation] == UIInterfaceOrientationPortrait)
//        toolBarItemlabel= [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 180,30)];
//    else
//        toolBarItemlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200,30)];
//    
//    [toolBarItemlabel setTextAlignment:UITextAlignmentCenter];
//    [toolBarItemlabel setTextColor:[UIColor whiteColor]];
//    [toolBarItemlabel setFont:[UIFont boldSystemFontOfSize:16]];
//    [toolBarItemlabel setBackgroundColor:[UIColor clearColor]];
//    toolBarItemlabel.text = [NSString stringWithFormat:@"Order By"];
//    
//    UIBarButtonItem *buttonLabel =[[UIBarButtonItem alloc]initWithCustomView:toolBarItemlabel];
//    [toolBarItemlabel release];
//    [barItems addObject:buttonLabel];
//    [buttonLabel release];
//    
//    [barItems addObject:flexSpace];
//    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissDurationPickerActionSheet:)];
//    [barItems addObject:doneBtn];
//    
//    
//    [pickerDateToolbar setItems:barItems animated:YES];
//   
//    [pickerActionSheet addSubview:pickerDateToolbar];
//
//    
//    CGRect myImageRect = CGRectMake(0.0f, 300.0f, 320.0f, 100.0f);
//    [pickerActionSheet showFromRect:myImageRect inView:self.view animated:YES ];
//    
//    [UIView beginAnimations:nil context:nil];
//    
//    
//    if ([[[UIDevice currentDevice] model] hasPrefix:@"iPad"]) {
//        // This app is an iPhone app running on an iPad
//        
//        [pickerActionSheet showFromRect:CGRectMake(0, 300, 320, 600) inView:self.view animated:YES];
//        [orderPickerView setFrame:CGRectMake(-20, 40, 0, 90)];
//    }
    
    self.menuView.hidden = NO;
}
-(void)dismissDurationPickerActionSheet:(id)sender
{

    [orderPickerView removeFromSuperview];
    [pickerActionSheet dismissWithClickedButtonIndex:0 animated:YES];
    
}


//Picker View Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectedOrderInt=row;
    if (row==0) {
        [self defualtSorting];
            }
    else if (row==1)
    {
        [self sortByProductName];

    }
    else if(row==2)
    {
        [self sortByLeftDays];
    }

    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
	return [pickerElement count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    selectedOrderInt=row;
	return [pickerElement objectAtIndex:row];
}

- (void)clickeOutSideFromMenu{
    self.menuView.hidden=YES;
    self.menuSetting.hidden=YES;
}

- (void)selectMenuAtIndex:(int)index{
    if(self.menuSetting.hidden==NO){
        self.menuSetting.hidden=YES;
        if(index==0){
            self.menuView.hidden=NO;
        }
        else if(index==1){
            [[AppDelegate sharedAppDelegate].tabBarController setSelectedIndex:2];
        }
    }
    else if(self.menuView.hidden==NO){
        self.menuView.hidden=YES;
        if(index==0){
            [self defualtSorting];
        }
        else if(index==1){
            [self sortByProductName];
        }
        else if(index==2){
            [self sortByLeftDays];
        }
    }
}

-(void)defualtSorting
{
    [sectionElementArray removeAllObjects];
    for (RecordData *rec in mainSectionElementArray) {
        [sectionElementArray addObject:rec];
    }
    [myRecordTableView reloadData];
}

-(void)sortByProductName
{
    [sectionElementArray removeAllObjects];
    
    NSLocale *locale=[[NSLocale alloc] initWithLocaleIdentifier:@"sv_SE"];
    NSArray *sorted=[mainSectionElementArray sortedArrayUsingComparator:^(RecordData *first, RecordData *second) {
        return [first.productNameStr compare:second.productNameStr
                      options:0
                        range:NSMakeRange(0, [first.productNameStr length])
                       locale:locale];
    }];
    for (RecordData *rec in sorted) {
        
        [sectionElementArray addObject:rec];
    
    }
    [myRecordTableView reloadData];

}

-(void)sortByLeftDays
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MMM-yy HH:mm:ss"];
    NSInteger tempInterval;
    for(int i=0;i<[sectionElementArray count];i++){
        RecordData *record = [sectionElementArray objectAtIndex:i];
        
        for(int j=i;j<[sectionElementArray count];j++){
            RecordData *data = [sectionElementArray objectAtIndex:j];
            NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
                                                                fromDate:getDateWithFormate_ddMMMyy([dateFormatter dateFromString:record.returnDate])
                                                                  toDate:getDateWithFormate_ddMMMyy([dateFormatter dateFromString:data.returnDate])
                                                                 options:0];
            NSInteger interval = [components day];
            if(i==j){
                tempInterval = interval;
            }
            if(tempInterval>=interval){
                tempInterval=interval;
                [sectionElementArray exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
        }
    }
    [myRecordTableView reloadData];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //  CGFloat sectionHeaderHeight = 40;
    if (scrollView.contentOffset.y<=sectionSize&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionSize) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionSize, 0, 0, 0);
    }
}

//--------------------------------------------------------------------------------

//TextField Position
- (IBAction)clickSettingIconBtn:(id)sender {
    [self keyBoardHide];
    self.menuView.hidden = YES;
    self.menuSetting.hidden = NO;
}

- (void)keyborardDidShow{
    [myRecordTableView setContentOffset:CGPointMake(0, sectionNumber*myRecordSectionHeight+10)];
}

- (void)showImageViewController:(myRecordTableViewCell*)cellData andTag:(int)tag andCellDelegate:(id)cellDelegate{
    isShowImage=YES;
    ShowImageViewController *sivc = [[ShowImageViewController alloc] init];
    [self presentModalViewController:sivc animated:YES];
    sivc.delegate = self;
    [sivc designViewForImageAndSelectImageTag:tag andCellData:cellData andCellDelegate:cellDelegate];
    [sivc release];
}

- (IBAction)clickedPickDateDone:(id)sender {
    [self.viewPickDate setHidden:YES];
    if(pickerNumber==1){
        myRecordTableViewCellObj.purchaseDateTxt.text = [self.pickDateFormatter stringFromDate:self.pickerView.date];
        myRecordTableViewCellObj.lblTemp2.hidden = NO;
    }
    else if(pickerNumber==2){
        myRecordTableViewCellObj.returnDateTxt.text = [self.pickDateFormatter stringFromDate:self.pickerView.date];
        myRecordTableViewCellObj.timeLeftDescLbl.text = [[AppDelegate sharedAppDelegate] getInterBetweenTwoDate:getCurrentDate() ReturnDate:self.pickerView.date];
    }
    else if(pickerNumber==3){
        [myRecordTableViewCellObj.returnAlertTextField setText:[self.pickDateFormatter stringFromDate:self.pickerView.date]];
        myRecordTableViewCellObj.lblTemp2.hidden=NO;
    }
}

- (IBAction)clickedPickDateCancel:(id)sender {
    [self.viewPickDate setHidden:YES];
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

-(BOOL)prefersStatusBarHidden {
    if ([[AppDelegate sharedAppDelegate]getOsVersion]==7) {
        return YES;
    }
    else
    {
        return NO;
    }
}
@end
