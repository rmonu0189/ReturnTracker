//
//  AppDelegate.h
//  ReturnTracker
//
//  Created by Ranjeeta Rajput on 08/10/13.
//  Copyright (c) 2013 Ranjeeta Rajput. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddView.h"
#import "loadingView.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>
{
    BOOL notificationIsOn;
    BOOL isVibrationButtonOn;
    BOOL isSoundButtonOn;
    BOOL isDefaultAlert;
    
    NSString *defualtTimeStr;
    NSString *defaultDaysStr;
    NSString *startAlertFromStr;
    
    //Activity Indicator
    
    UIActivityIndicatorView *activityIndicator;
    UIView *activityView;
    UILabel *activityLable;
    
    AddView *addView;
    
    loadingView *lview;
    
}
@property (nonatomic, assign) BOOL isDefaultAlert;

@property (nonatomic, retain) loadingView *lview;

@property (nonatomic, retain) AddView *addView;

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *tabBarController;
//For Company data
@property(strong,nonatomic)NSMutableArray *cellItemArr;

@property(nonatomic,assign)BOOL notificationIsOn,isVibrationButtonOn,isSoundButtonOn;
//For Product Alert Setting is on or not
@property(nonatomic,retain)NSString *defualtTimeStr,*defaultDaysStr,*startAlertFromStr;


@property(nonatomic,retain) UIActivityIndicatorView *activityIndicator;
@property(nonatomic,retain) UIView *activityView;
+(AppDelegate *)sharedAppDelegate;


-(void)startActivityIndicatorAnimationWithMsg:(NSString*)msg;
-(void)endActivityIndicatorAnimation;
- (NSString *)getShopNameWithID:(int)shopId;
- (NSString*)getInterBetweenTwoDate:(NSDate *)currentDate ReturnDate:(NSDate*)returnDate;

- (void)showAdvertisement:(id)adDelegate;
- (void)hideAdvertisement;
- (int)getOsVersion;

- (NSString*)getNextImageName;
- (UIImage*)getStoreImageFromName:(NSString*)imgName;
- (UIImage*)getProductImageFromName:(NSString*)productID andImageName:(NSString*)imgName;
- (NSString*)getDocumentDirectoryPath;
-(NSString*)getImageUrlFromShopId:(int)shopId;
- (void)saveProductImageWithName:(NSString*)imgName andImage:(UIImage*)image andProductID:(NSString*)pID;
- (BOOL)CheckProductImageIsExist:(NSString*)imgName andProductID:(int)pid;
@end
