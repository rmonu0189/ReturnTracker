//
//  CalendarViewController.m
//  ReturnTracker
//
//  Created by Ranjeeta Rajput on 08/10/13.
//  Copyright (c) 2013 Ranjeeta Rajput. All rights reserved.
//

#import "CalendarViewController.h"
#import "KalLogic.h"
#import "KalDataSource.h"
#import "KalDate.h"
#import "KalPrivate.h"
#import "ImageAndString.h"
#import "KalTileView.h"
#define PROFILER 0
#if PROFILER
#include <mach/mach_time.h>
#include <time.h>
#include <math.h>


void mach_absolute_difference(uint64_t end, uint64_t start, struct timespec *tp)
{
    uint64_t difference = end - start;
    static mach_timebase_info_data_t info = {0,0};
    
    if (info.denom == 0)
        mach_timebase_info(&info);
    
    uint64_t elapsednano = difference * (info.numer / info.denom);
    tp->tv_sec = elapsednano * 1e-9;
    tp->tv_nsec = elapsednano - (tp->tv_sec * 1e9);
}
#endif

NSString *const KalDataSourceChangedNotification = @"KalDataSourceChangedNotification";

@interface CalendarViewController ()
@property (nonatomic, retain, readwrite) NSDate *initialDate;
@property (nonatomic, retain, readwrite) NSDate *selectedDate;
- (KalView*)calendarView;

@end

@implementation CalendarViewController
@synthesize arrRecord;
@synthesize tblRecord;
@synthesize dataSource, delegate, initialDate, selectedDate;
@synthesize viewAdvertisement;

@synthesize imageStringArr1,dateArr1,imageandStringObj;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Calendar", @"Calendar");
        self.tabBarItem.image = [UIImage imageNamed:@"calendar-icon.png"];
        
        
        // Custom initialization
    }
    //imageandStringObj=[[ImageAndString alloc]init];
//    NSDate *currentDate=[[NSDate date ]dateByAddingTimeInterval:24*60*60*2 ];
//    NSDate *date1=[[NSDate date ] dateByAddingTimeInterval:24*60*60*3];
//    NSDate *date2=[[NSDate date ] dateByAddingTimeInterval:24*60*60*40];
//    NSDate *date3=[[NSDate date ]dateByAddingTimeInterval:24*60*60*60];
//    NSDate *date4=[[NSDate date ]dateByAddingTimeInterval:24*60*60*365];
//    NSDate *date5=[[NSDate date ]dateByAddingTimeInterval:24*60*60*730];
//    NSDate *date6=[[NSDate date ]dateByAddingTimeInterval:24*60*60*1];
//    dateArr=[[NSArray alloc]initWithObjects:currentDate,date1,date2,date3,date4,date5,date6 ,nil];
  

//    return [self initWithSelectedDate:[NSDate date]:dateArr:imageStringArr];
     //  [self initWithSelectedDate:getCurrentDate() dateArray:nil  imageStringArray:nil];
    return self;
}
- (id)initWithSelectedDate:(NSDate *)date dateArray:(NSArray *)dateArr imageStringArray:(NSArray*)imageStringArr productStringArray:(NSArray *)productStringArr
{

    logic = [[KalLogic alloc] initForDate:date ];
        self.initialDate = nil;
        self.selectedDate = nil;
//    KalTileView *tileObj=[[KalTileView alloc]init];
//    dateArr1=[NSArray arrayWithArray:dateArr];
//    imageStringArr1=[NSArray arrayWithArray:imageStringArr];
   // imageandStringObj *tileObj=[[KalTileView alloc]init];
    
        [ImageAndString getSharedInstance].imageDate =[NSArray arrayWithArray:dateArr];
[ImageAndString getSharedInstance].imageString=[NSArray arrayWithArray:imageStringArr];
    [ImageAndString getSharedInstance].productString =[NSArray arrayWithArray:productStringArr];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(significantTimeChangeOccurred) name:UIApplicationSignificantTimeChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:KalDataSourceChangedNotification object:nil];
    
    return self;
}

//- (id)init
//{
//    
//}

- (KalView*)calendarView { return (KalView*)self.view; }

- (void)setDataSource:(id<KalDataSource>)aDataSource
{
    if (dataSource != aDataSource) {
        dataSource = aDataSource;
       // tableView.dataSource = dataSource;
    }
}

- (void)setDelegate:(id<UITableViewDelegate>)aDelegate
{
    if (delegate != aDelegate) {
        delegate = aDelegate;
      //  tableView.delegate = delegate;
    }
}

//- (void)clearTable
//{
//    [dataSource removeAllItems];
//    [tableView reloadData];
//}

//- (void)reloadData
//{
//    [dataSource presentingDatesFrom:logic.fromDate to:logic.toDate delegate:self];
//}

- (void)significantTimeChangeOccurred
{
    [[self calendarView] jumpToSelectedMonth];
   // [self reloadData];
}

// -----------------------------------------
#pragma mark KalViewDelegate protocol

- (void)didSelectDate:(KalDate *)date
{
    self.selectedDate = [date NSDate];
    NSDate *from = [[date NSDate] cc_dateByMovingToBeginningOfDay];
    NSDate *to = [[date NSDate] cc_dateByMovingToEndOfDay];
    
    [dataSource loadItemsFromDate:from toDate:to];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:@"dd-MMM-yy"];
    
    NSString *selectedDateStr=[[[dateFormatter stringFromDate:self.selectedDate] componentsSeparatedByString:@" "] objectAtIndex:0];
    
    
    
    NSDateFormatter *dateFormatter1= [[NSDateFormatter alloc] init];
    [dateFormatter1 setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter1 setDateFormat:@"dd-MMM-yy hh:mm:ss"];
    
    
    
    //
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
//    [dateFormatter setDateFormat:@"dd-MMM-yy"];
    [self.arrRecord removeAllObjects];
    for(RecordData *record in [DataBaseClass getSharedInstance].arrRecord){
        NSString *strReturnDate = [record returnDate];
        strReturnDate=[[strReturnDate componentsSeparatedByString:@" "]objectAtIndex:0];
        NSDate *returnDate = [dateFormatter dateFromString:strReturnDate];
       
        NSDate *slectDate=[dateFormatter dateFromString:selectedDateStr];
        if ([returnDate isEqualToDate:slectDate]) {
            if (record.productReturnedStatus==0) {
                record.remainDay=[[AppDelegate sharedAppDelegate]getInterBetweenTwoDate:getCurrentDate() ReturnDate:returnDate];
            }
            else
            {
                record.remainDay=@"Product returned";
            }
            [self.arrRecord addObject:record];
        }
        
//        NSDate *currentDate = [dateFormatter dateFromString:[dateFormatter stringFromDate:[NSDate date]]];
//        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
//        [dateFormatter1 setTimeZone:[NSTimeZone localTimeZone]];
//        [dateFormatter1 setDateFormat:@"dd-MMM-yy"];
//        strReturnDate = [dateFormatter1 stringFromDate:returnDate];
//        returnDate = [dateFormatter1 dateFromString:strReturnDate];
//        currentDate = [dateFormatter1 dateFromString:[dateFormatter1 stringFromDate:currentDate]];
//        int interVal = getIntervalBetween(currentDate, returnDate);
//        if(interVal==0){
//            record.remainDay = @"(Today)";
//            [self.arrRecord addObject:record];
//        }
//        else if(interVal>0 && interVal<=5){
//            if(interVal==1){
//                record.remainDay = @"(1 day left)";
//            }
//            else{
//                record.remainDay = [NSString stringWithFormat:@"(%d days left)",interVal];
//            }
//            [self.arrRecord addObject:record];
//        }
    }
   // [self sortByLeftDays];
    [self.tblRecord reloadData];
    
    
    
    //

    //[tableView reloadData];
    //[tableView flashScrollIndicators];
}

- (void)showPreviousMonth
{
    [logic retreatToPreviousMonth];
    [[self calendarView] slideDown];
   // [self reloadData];
}

- (void)showFollowingMonth
{
    [logic advanceToFollowingMonth];
    [[self calendarView] slideUp];
}

- (void)calenderHeight:(CGFloat)kalHeight{
    calendarHeight=kalHeight;
    if([[AppDelegate sharedAppDelegate] getOsVersion] == 7){
        [self.subView setFrame:CGRectMake(0, kalHeight+86, 320, 442-kalHeight-86)];
        self.tblRecord.frame = CGRectMake(0, 0, 320, self.subView.frame.size.height-44);
        [self.viewAdvertisement setFrame:CGRectMake(0, self.tblRecord.frame.size.height, 320, 50)];
        
    }
    else{
        if ([[[UIDevice currentDevice] model] hasPrefix:@"iPad"]){
            [self.subView setFrame:CGRectMake(0, kalHeight+86, 320, 442-kalHeight-86)];
            self.tblRecord.frame = CGRectMake(0, 0, 320, self.subView.frame.size.height-36);
            self.viewAdvertisement.frame = CGRectMake(0, self.tblRecord.frame.size.height, 320, 50);
        }
        else
        {
            [self.subView setFrame:CGRectMake(0, kalHeight+86, 320, 442-kalHeight-86)];
            self.tblRecord.frame = CGRectMake(0, 0, 320, self.subView.frame.size.height-64);
            self.viewAdvertisement.frame = CGRectMake(0, self.tblRecord.frame.size.height, 320, 50);
        }
        
    }
}

// -----------------------------------------
#pragma mark KalDataSourceCallbacks protocol

- (void)loadedDataSource:(id<KalDataSource>)theDataSource;
{
    NSArray *markedDates = [theDataSource markedDatesFrom:logic.fromDate to:logic.toDate];
    NSMutableArray *dates = [[markedDates mutableCopy] autorelease];
    for (int i=0; i<[dates count]; i++)
        [dates replaceObjectAtIndex:i withObject:[KalDate dateFromNSDate:[dates objectAtIndex:i]]];
    
    [[self calendarView] markTilesForDates:dates];
    [self didSelectDate:self.calendarView.selectedDate];
}

// ---------------------------------------
#pragma mark -

- (void)showAndSelectDate:(NSDate *)date
{
    if ([[self calendarView] isSliding])
        return;
    
    [logic moveToMonthForDate:date];
    
#if PROFILER
    uint64_t start, end;
    struct timespec tp;
    start = mach_absolute_time();
#endif
    
    [[self calendarView] jumpToSelectedMonth];
    
#if PROFILER
    end = mach_absolute_time();
    mach_absolute_difference(end, start, &tp);
    printf("[[self calendarView] jumpToSelectedMonth]: %.1f ms\n", tp.tv_nsec / 1e6);
#endif
    
    [[self calendarView] selectDate:[KalDate dateFromNSDate:date]];
}

- (NSDate *)selectedDate
{
    return [self.calendarView.selectedDate NSDate];
}


// -----------------------------------------------------------------------------------
#pragma mark UIViewController

- (void)didReceiveMemoryWarning
{
    self.initialDate = self.selectedDate; // must be done before calling super
    [super didReceiveMemoryWarning];
}

- (void)loadView
{
    if (!self.title)
        self.title = @"Calendar";
    
    kalView = [[[KalView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] delegate:self logic:logic] autorelease];
    self.view = kalView;
    [kalView selectDate:[KalDate dateFromNSDate:self.initialDate]];
}
-(void)viewDidLoad
{
    [super viewDidLoad];
   
    UIImageView *headView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    headView.image=[UIImage imageNamed:@"header_bg.png"];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        headView.frame=CGRectMake(0 ,0,330,40);
    }
    [self.view addSubview:headView];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [headView release];
    self.subView=[[UIView alloc]initWithFrame:CGRectMake(0,221+88 , self.view.frame.size.width, 135)];
    self.arrRecord = [[NSMutableArray alloc] init];
    self.tblRecord = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.subView.frame.size.height-50)];
    [self.subView addSubview:self.tblRecord];
    self.tblRecord.dataSource = self;
    self.tblRecord.delegate = self;
    self.tblRecord.backgroundColor = [UIColor clearColor];
    self.subView.backgroundColor = [UIColor clearColor];
    
    self.viewAdvertisement = [[UIView alloc] initWithFrame:CGRectMake(0, self.subView.frame.size.height-50, 320, 300)];
    [self.subView addSubview:self.viewAdvertisement];
    
}

- (void)viewDidUnload
{
    [self setSubView:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //imageStringArr=[[NSArray alloc]initWithObjects:@"Red1.png",@"Green1.png",@"Yellow1.png",@"Red1.png",@"Green1.png",@"Yellow1.png" ,@"Red1.png",nil];
    //NSMutableArray *array=[[NSMutableArray alloc]init];
    //array=[[DataBaseClass getSharedInstance] receiveAllData ];
    NSMutableArray *dateArray=[[NSMutableArray alloc]init];
    NSMutableArray *leftDaysArray=[[NSMutableArray alloc]init];
    NSMutableArray *shopImageArray=[[NSMutableArray alloc]init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:@"dd-MMM-yy HH:mm:ss"];
    [self.arrRecord removeAllObjects];

    for (RecordData *record in [DataBaseClass getSharedInstance].arrRecord) {
        NSString *retStr = [record returnDate];
        if ([record returnDate]) {
            [dateArray addObject:retStr];
        }
        NSDate *retDate=[dateFormatter dateFromString:retStr];
        
        if (retDate==nil) {
            [dateFormatter setDateFormat: @"dd-MMM-yy HH:mm:ss"];
            retDate=[dateFormatter dateFromString:retStr];
        }
        
        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
                                                            fromDate:getCurrentDate()
                                                              toDate:[retDate dateByAddingTimeInterval:60*60*24*3]
                                                             options:0];
        NSInteger interval = [components day];
       
        [shopImageArray addObject:[[AppDelegate sharedAppDelegate]getImageUrlFromShopId:record.shopID] ];
       
        //[shopImageArray addObject:[AppDelegate sharedAppDelegate].cellItemArr ]
        [leftDaysArray addObject:[NSString stringWithFormat:@"%i",interval]];
    }
    NSMutableArray *sendingDateArray=[[NSMutableArray alloc]init];
    NSMutableArray *sendingImages=[[NSMutableArray alloc]init];
    int i=0;
    for (NSString *str in leftDaysArray) {
        if ([str intValue]>20) {
            [sendingDateArray addObject:[dateFormatter dateFromString:[dateArray objectAtIndex:i]]];
            [sendingImages addObject:@"green.png"];
        }
        
        
        if ([str intValue]>10 && [str intValue]<=20) {
            [sendingDateArray addObject:[dateFormatter dateFromString:[dateArray objectAtIndex:i]]];
            [sendingImages addObject:@"yellow.png"];
        }
        if ([str intValue]>=0 && [str intValue]<=10) {
            [sendingDateArray addObject:[dateFormatter dateFromString:[dateArray objectAtIndex:i]]];
            [sendingImages addObject:@"red.png"];
        }
        i++;
    }
    [self initWithSelectedDate:getCurrentDate() dateArray:sendingDateArray imageStringArray:sendingImages productStringArray:shopImageArray ];
    [self loadView];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UIImageView *headView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 35)];
    headView.image=[UIImage imageNamed:@"header_bg.png"];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        headView.frame=CGRectMake(0 , 0, 320, 35);
    }
    
    UIButton *btnGoSetting=[[UIButton alloc]initWithFrame:CGRectMake(271, 0, 46, 36)];
    [btnGoSetting addTarget:self action:@selector(clickOnImageBtnmtd:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnGoSetting];
    
    [self.view addSubview:headView];
    [headView release];
    
    [kalView addSubview:self.subView];
    [self getCurrentDateRecord];
}

-(void)clickOnImageBtnmtd:(id)sender
{
    [[AppDelegate sharedAppDelegate].tabBarController setSelectedIndex:2];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[AppDelegate sharedAppDelegate] showAdvertisement:self.viewAdvertisement];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear: animated];
    
    [[AppDelegate sharedAppDelegate] hideAdvertisement];
}

#pragma mark -

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationSignificantTimeChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KalDataSourceChangedNotification object:nil];
    [initialDate release];
    [selectedDate release];
    [logic release];
    [_subView release];
    [super dealloc];
}

//**********Table Delegate Method*******************//
//This return no of Section in table view
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//this returnno of row in section here we want only one section row is display, this this control by 'didselected' variable
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrRecord count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.0f;
}

//Define the row containt
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    CalenderRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        cell = [[[CalenderRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    RecordData *record = [self.arrRecord objectAtIndex:indexPath.row];
    cell.lblProductName.text = record.productNameStr;
    
   // StoreData *element=(StoreData*)[[AppDelegate sharedAppDelegate].cellItemArr objectAtIndex:record.shopID];
    
    cell.lblShopName.text = [[AppDelegate sharedAppDelegate]getShopNameWithID:record.shopID];
    cell.lblPurchaseDate.text = [[record.purchaseDateStr componentsSeparatedByString:@" "] objectAtIndex:0];
    cell.lblReturnDate.text = [[record.returnDate componentsSeparatedByString:@" "] objectAtIndex:0];
    cell.lblRemainDay.text = record.remainDay;
    if([[AppDelegate sharedAppDelegate] CheckProductImageIsExist:@"1.png" andProductID:record.productID]){
        cell.imgProduct.image = [[AppDelegate sharedAppDelegate] getProductImageFromName:[NSString stringWithFormat:@"%d",record.productID] andImageName:@"1.png"];
    }
    else{
        cell.imgProduct.image = [UIImage imageNamed:@"defaultLogo.png"];
    }
    cell.btnDelete.tag=record.productID;
    cell.delegate=self;
    return cell;
}

-(void)clickDelete:(int)tag
{
    btnTag=tag;
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Do you want to delete record." delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if([alertView.message isEqualToString:@"Do you want to delete record."]){
        if(buttonIndex==0){
            [[DataBaseClass getSharedInstance]deleteData:btnTag];
            [self viewWillAppear:YES];
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RecordData *record = [self.arrRecord objectAtIndex:indexPath.row];
    UpdateProductViewController *urvc = [[UpdateProductViewController alloc] initWithNibName:@"UpdateProductViewController" bundle:nil andRecordData:record];
    [self presentModalViewController:urvc animated:YES];
    [urvc release];
}

-(void)showSelectedDateComponent:(NSDate*)selectedDate
{
    
}
-(void)sortByLeftDays
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MMM-yy HH:mm:ss"];
    NSInteger tempInterval;
    for(int i=0;i<[self.arrRecord count];i++){
        RecordData *record = [self.arrRecord objectAtIndex:i];
        for(int j=i;j<[self.arrRecord count];j++){
            RecordData *data = [self.arrRecord objectAtIndex:j];
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
                [self.arrRecord exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
        }
    }
    [self.tblRecord reloadData];
}

- (void)getCurrentDateRecord{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:@"dd-MMM-yy"];
    
    NSDateFormatter *dateFormatter1= [[NSDateFormatter alloc] init];
    [dateFormatter1 setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter1 setDateFormat:@"dd-MMM-yy hh:mm:ss"];
    NSString *selectedDateStr=[[[dateFormatter stringFromDate:getCurrentDate()] componentsSeparatedByString:@" "] objectAtIndex:0];
    [self.arrRecord removeAllObjects];
    for(RecordData *record in [DataBaseClass getSharedInstance].arrRecord){
        NSString *strReturnDate = [record returnDate];
        strReturnDate=[[strReturnDate componentsSeparatedByString:@" "]objectAtIndex:0];
        NSDate *returnDate = [dateFormatter dateFromString:strReturnDate];
        
        NSDate *slectDate=[dateFormatter dateFromString:selectedDateStr];
        if ([returnDate isEqualToDate:slectDate]) {
            if (record.productReturnedStatus==0) {
                record.remainDay=[[AppDelegate sharedAppDelegate]getInterBetweenTwoDate:getCurrentDate() ReturnDate:returnDate];
            }
            else
            {
                record.remainDay=@"Product returned";
            }
            [self.arrRecord addObject:record];
        }

    }
    [self.tblRecord reloadData];
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
