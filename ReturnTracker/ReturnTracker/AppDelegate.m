//
//  AppDelegate.m
//  ReturnTracker
//
//  Created by Ranjeeta Rajput on 08/10/13.
//  Copyright (c) 2013 Ranjeeta Rajput. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "MyRecordViewController.h"
#import "SettingViewController.h"
#import "CalendarViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "Mobclix.h"
#import <AVFoundation/AVFoundation.h>
#import "StoreData.h"
@implementation AppDelegate
@synthesize cellItemArr,window,tabBarController,defualtTimeStr,defaultDaysStr,startAlertFromStr,notificationIsOn,isVibrationButtonOn,isSoundButtonOn,activityView,activityIndicator;
@synthesize addView;
@synthesize lview;
@synthesize isDefaultAlert;

- (void)dealloc
{
    [window release];
    [tabBarController release];
    [super dealloc];
}
+(AppDelegate *)sharedAppDelegate{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    sleep(3);
    [self createFolder];
    NSArray * icon=[[NSArray alloc]initWithObjects:@"amazon-logo.png",@"bestbuy_logo.png",@"kohls-logo.png",@"costco_logo.png",@"macys_logo.png",@"marshalls_logo.png",@"overstock_logo.png", nil];
    for (NSString *str in icon) {
        [self saveStoreImageWithName:str andImage:[UIImage imageNamed:str]];
    }
    
    [[DataBaseClass getSharedInstance]loadStoreArr];
    NSMutableArray *tempArr=[[NSMutableArray alloc]init];
    for (StoreData *data in [AppDelegate sharedAppDelegate].cellItemArr) {
        if (data.favourite==1) {
            [tempArr addObject:data];
        }
    }
    for (StoreData *data in [AppDelegate sharedAppDelegate].cellItemArr) {
        if (data.favourite==0) {
            [tempArr addObject:data];
        }
    }
    if ([[AppDelegate sharedAppDelegate].cellItemArr count]>0) {
        [[AppDelegate sharedAppDelegate].cellItemArr removeAllObjects];
    }
    for (StoreData *data in tempArr) {
        [[AppDelegate sharedAppDelegate].cellItemArr addObject:data];
    }
    [tempArr release];
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    // Override point for customization after application launch.
    UIViewController *viewController = [[[ViewController alloc] initWithNibName:@"ViewController" bundle:nil] autorelease];
    UIViewController *myRecordViewController = [[[MyRecordViewController alloc] initWithNibName:@"MyRecordViewController" bundle:nil] autorelease];
    UIViewController *settingViewController=[[[SettingViewController alloc]initWithNibName:@"SettingViewController" bundle:nil]autorelease];
   UIViewController *calendarViewController=[[[CalendarViewController alloc]initWithNibName:@"CalenderViewController" bundle:nil]autorelease];
    
    self.tabBarController = [[[UITabBarController alloc] init] autorelease];
    self.tabBarController.viewControllers=[NSArray arrayWithObjects:viewController,myRecordViewController,settingViewController,calendarViewController, nil];
    
    
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    [Mobclix startWithApplicationId:MOBCLIX_API];
    self.addView = [[AddView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    
    defaultDaysStr=@"15";
    startAlertFromStr=@"3";
    defualtTimeStr=@"09:00:00";
    notificationIsOn=YES;
    isVibrationButtonOn=YES;
    isSoundButtonOn=YES;
    isDefaultAlert=NO;

    //*************Notification code**************************//

    UILocalNotification *clearEpisodeNotification = [[UILocalNotification alloc] init];
    clearEpisodeNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:(0)];
    clearEpisodeNotification.timeZone = [NSTimeZone defaultTimeZone];
    clearEpisodeNotification.applicationIconBadgeNumber = -1;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:clearEpisodeNotification];
    if ([[[UIDevice currentDevice] model] hasPrefix:@"iPad"])
    {
        self.lview=[[loadingView alloc]initWithLoadingFrame:CGRectMake(240, 300, 320, 480)];
        self.lview.transform = CGAffineTransformMakeScale([UIScreen mainScreen].applicationFrame.size.width / 320.0f, [UIScreen mainScreen].applicationFrame.size.height / 480.0f);
    }
    else
    {
        self.lview=[[loadingView alloc] initWithLoadingFrame:CGRectMake(0, 0, 320,480)];
    
    }
    
    [[DataBaseClass getSharedInstance] receiveAllData];
    //[self addShopData];
    return YES;
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
 viewController.view.transform = CGAffineTransformMakeScale([UIScreen mainScreen].applicationFrame.size.width / 320.0f, [UIScreen mainScreen].applicationFrame.size.height / 480.0f);
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive && notification.alertBody!=nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:notification.alertBody
                                                       delegate:self cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:self];
    
    // Set icon badge number to zero
    application.applicationIconBadgeNumber = 0;
    
    //ActivityIndicator
    activityView=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [activityView setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.7]];
    [activityView setHidden:YES];
    [self.window addSubview:activityView];
    
    activityIndicator = [[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
    activityIndicator.frame = CGRectMake(0.0, 0.0, 200, 40.0);
    
    activityIndicator.center = activityView.center;
    [activityView addSubview: activityIndicator];
    
    activityLable=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(activityIndicator.frame)+60, CGRectGetMaxY(activityIndicator.frame)+10,100, 25)];
    activityLable.font=[UIFont systemFontOfSize:20.0f];
    [activityLable setBackgroundColor:[UIColor clearColor]];
    [activityLable setTextColor:[UIColor whiteColor]];
    [activityLable setText:@"Loading...."];
    [activityView addSubview:activityLable];
}

- (void)playPushNotificationAlertSound:(NSString *)soundName
{
    if (![soundName isEqualToString:@"default"]) {
        
        NSURL *soundURL = [[NSBundle mainBundle] URLForResource:soundName withExtension:@"caf"];
        
        if (soundURL) {
            CFURLRef soundFileURLRef = (__bridge CFURLRef)soundURL;
            SystemSoundID soundFileObject = 0;
            OSStatus status = AudioServicesCreateSystemSoundID(soundFileURLRef, &soundFileObject);
            if (status == kAudioServicesNoError) {
                AudioServicesPlayAlertSound(soundFileObject);
                AudioServicesDisposeSystemSoundID(soundFileObject);
            }
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    application.applicationIconBadgeNumber = 0;
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//- (BOOL)applicationShouldLaunch:(UIApplication *)application errorDescription:(NSString**)errorString
//{
//    sleep(5);
//    return TRUE;
//}

//Ipad program
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    

    viewController.view.transform = CGAffineTransformMakeScale([UIScreen mainScreen].applicationFrame.size.width / 320.0f, [UIScreen mainScreen].applicationFrame.size.height / 480.0f);
    
}

//Check OS version
- (int)getOsVersion{
    NSArray *vComp = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    return [[vComp objectAtIndex:0] intValue];
}
//Activity Indicator Method
-(void)startActivityIndicatorAnimationWithMsg:(NSString*)msg
{
    if ([self.lview isDescendantOfView:self.window]) {
        [self.lview removeFromSuperview];
    }
    self.lview.lblMsg.text=@"Please wait...";
    [self.lview.activityIndicator startAnimating];
    self.lview.userInteractionEnabled=NO;
    self.lview.exclusiveTouch=NO;
    self.window.userInteractionEnabled=NO;
    [self.window addSubview:self.lview];
}
-(void)endActivityIndicatorAnimation
{
    if ([self.lview isDescendantOfView:self.window]) {
        [self.lview.activityIndicator stopAnimating];
        [self.lview removeFromSuperview];
    }
    self.window.userInteractionEnabled=YES;
}

- (NSString*)getInterBetweenTwoDate:(NSDate *)currentDate ReturnDate:(NSDate*)returnDate1{
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"dd-MMM-yy HH:mm:ss"];
    NSDate *retDate= returnDate1;
    
    NSCalendar *calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    NSDateComponents *components = [calendar components:NSDayCalendarUnit|NSMonthCalendarUnit | NSYearCalendarUnit
                                               fromDate:currentDate
                                                 toDate:[retDate dateByAddingTimeInterval:60*60*24*1]
                                                options:0];
    NSString *strInterVal=@"";
    NSString *strDay = @"";
    if(components.day==1){
        strDay = @"day";
    }
    else{
        strDay = @"days";
    }
    if (components.year<=0 && components.month<=0 && components.day<=0) {
        strInterVal = @"Return Date Expire";
    }
    else if (components.year!=0 && components.month!=0 && components.day!=0)
    {
        strInterVal = [NSString stringWithFormat:@"%i Year %i Month %i %@ Left",components.year,components.month,components.day,strDay];
    }
    else if (components.year!=0 && components.month!=0 && components.day==0)
    {
        strInterVal = [NSString stringWithFormat:@"%i Year %i Month",components.year,components.month];
    }
    else if (components.year!=0 && components.month==0 && components.day!=0)
    {
        strInterVal = [NSString stringWithFormat:@"%i Year %i %@",components.year,components.day,strDay];
    }
    else if (components.year!=0 && components.month==0 && components.day==0)
    {
        strInterVal = [NSString stringWithFormat:@"%i Year Left",components.year];
    }
    else if (components.year==0 && components.month!=0 && components.day!=0)
    {
        strInterVal = [NSString stringWithFormat:@"%i Month %i %@ Left",components.month,components.day,strDay];
    }
    else if (components.year==0 && components.month!=0 && components.day==0)
    {
        strInterVal = [NSString stringWithFormat:@"%i Month left",components.month];
    }
    else if (components.year==0 && components.month==0 && components.day!=0)
    {
        strInterVal = [NSString stringWithFormat:@"%i %@ left",components.day,strDay];
    }
    
    NSString *strReturnDate = [dateFormatter stringFromDate:retDate];
    retDate = [dateFormatter dateFromString:strReturnDate];
    NSDateFormatter *dateFormatter1 = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter1 setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter1 setDateFormat:@"dd-MMM-yy"];
    strReturnDate = [dateFormatter1 stringFromDate:retDate];
    retDate = [dateFormatter1 dateFromString:strReturnDate];
    currentDate = [dateFormatter1 dateFromString:[dateFormatter1 stringFromDate:currentDate]];
    int interVal = getIntervalBetween(currentDate, retDate);
    if(interVal==0){
        strInterVal = @"Today";
    }
    else if(interVal<0){
        strInterVal = @"Return Date Expire";
    }
    return strInterVal;
}

- (NSString *)getShopNameWithID:(int)shopId{
    for (int i=0; i<[[AppDelegate sharedAppDelegate].cellItemArr count]; i++) {
        StoreData *data = [[[StoreData alloc] init] autorelease];
        data = [[AppDelegate sharedAppDelegate].cellItemArr objectAtIndex:i];
        if (data.shopId==shopId) {
            return data.shopName;
        }
    }
    return @"";
}

- (void)showAdvertisement:(id)adDelegate{
    [self.addView showAdvertisementView];
    [adDelegate addSubview:self.addView];
}

- (void)hideAdvertisement{
    [self.addView pauseAdAutoRefresh];
    [self.addView removeFromSuperview];
}

//- (void)addShopData{
//    [AppDelegate sharedAppDelegate].cellItemArr=[[NSMutableArray alloc]init];
//    //This array contains section data
//    NSArray *icon,*title,*subTitle;
//    icon=[[NSArray alloc]initWithObjects:@"amazon-logo",@"bestbuy_logo",@"kohls-logo",@"costco_logo",@"macys_logo",@"marshalls_logo",@"overstock_logo", nil];
//    title=[[NSArray alloc]initWithObjects:@"Amazon.com",@"Best Buy",@"Kohl's",@"Costco",@"Macys",@"Marshalls",@"OverStock", nil];
//    subTitle=[[NSArray alloc]initWithObjects:@"Amazon's customer service with  24X7 support...... ",@"Best Buy  customer service with  24X7 support...... ",@"Kohl's  customer service with  24X7 support...... ",@"Costco  customer service with  24X7 support...... ",@"Macys's customer service with  24X7 support...... ",@"Marshalls  customer service with  24X7 support...... ",@"OverStock's  customer service with  24X7 support...... ", nil];
//    //here we put all section element inside the one array called cellItem
//    for (int i=0; i<[icon count]; i++) {
//        StoreData *cellItem=[[StoreData alloc]init];
//        cellItem.imagePath=[icon objectAtIndex:i];
//        cellItem.shopName=[title objectAtIndex:i];
//        cellItem.description=[subTitle objectAtIndex:i];
//        //cellItem.imgIcon = [UIImage imageNamed:[icon objectAtIndex:i]];
//        [[AppDelegate sharedAppDelegate].cellItemArr addObject:cellItem];
//    }
//}

- (NSString*)getDocumentDirectoryPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

- (void)createFolderWithName:(NSString*)folderName{
    NSString *dataPath = [NSString stringWithFormat:@"%@/%@",[self getDocumentDirectoryPath],folderName];
    NSError *error=nil;
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]){
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];
    }
}

- (BOOL)folderIsExist:(NSString*)folderPath{
    return [[NSFileManager defaultManager] fileExistsAtPath:folderPath];
}

- (NSArray *)getAllFilesAtPath:(NSString*)path{
    return [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
}

- (void)createFolder{
    [self createFolderWithName:@"ProductImages"];
    [self createFolderWithName:@"StoreImages"];
}

- (NSString*)getNextImageName{
    int count = [[self getAllFilesAtPath:[NSString stringWithFormat:@"%@/StoreImages/",[self getDocumentDirectoryPath]]] count];
    return [NSString stringWithFormat:@"%@/StoreImages/%d.png",[self getDocumentDirectoryPath],count+1];
}

- (UIImage*)getStoreImageFromName:(NSString*)imgName{
    NSData *imageData = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/StoreImages/%@",[self getDocumentDirectoryPath],imgName]];
    return [UIImage imageWithData:imageData];
}

- (UIImage*)getProductImageFromName:(NSString*)productID andImageName:(NSString*)imgName{
    NSString *imgPath = [NSString stringWithFormat:@"%@/ProductImages/%@/%@",[self getDocumentDirectoryPath],productID,imgName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:imgPath]){
        NSData *imageData = [[[NSData alloc] init] autorelease];
        imageData = [NSData dataWithContentsOfFile:imgPath];
        UIImage *img = [[[UIImage alloc] init] autorelease];
        img = [UIImage imageWithData:imageData];
        return img;
    }
    else{
        return NULL;
    }
}

-(void)saveStoreImageWithName:(NSString*)name andImage:(UIImage*)image
{
    NSString *imagePath=[NSString stringWithFormat:@"%@/StoreImages/%@",[[AppDelegate sharedAppDelegate] getDocumentDirectoryPath],name];
    NSData *imgData = [[NSData alloc] init];
    imgData = UIImagePNGRepresentation(image);
    [imgData writeToFile:imagePath atomically:NO];
    imgData=nil;
    [imgData release];
}

- (void)saveProductImageWithName:(NSString*)imgName andImage:(UIImage*)image andProductID:(NSString*)pID{
    NSString *dataPath = [NSString stringWithFormat:@"%@/ProductImages/%@",[self getDocumentDirectoryPath],pID];
    NSError *error=nil;
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]){
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];
    }
    
    NSString *imagePath=[NSString stringWithFormat:@"%@/ProductImages/%@/%@",[[AppDelegate sharedAppDelegate] getDocumentDirectoryPath],pID,imgName];
    
    NSData *imgData = [[[NSData alloc] init] autorelease];
    imgData = UIImagePNGRepresentation(scaleImage(image, 500));
    [imgData writeToFile:imagePath atomically:NO];
}

- (BOOL)CheckProductImageIsExist:(NSString*)imgName andProductID:(int)pid{
    NSString *imagePath=[NSString stringWithFormat:@"%@/ProductImages/%d/%@",[[AppDelegate sharedAppDelegate] getDocumentDirectoryPath],pid,imgName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:imagePath]){
        return NO;
    }
    else{
        return YES;
    }
    return NO;
}

-(NSString*)getImageUrlFromShopId:(int)shopId
{
    for (StoreData *data in [AppDelegate sharedAppDelegate].cellItemArr) {
        if (data.shopId==shopId) {
            return data.imagePath;
        }
    }
    return @"";
}
@end
