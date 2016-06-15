//
//  AddStoreViewController.h
//  ReturnTracker
//
//  Created by monu on 26/11/13.
//  Copyright (c) 2013 Ranjeeta Rajput. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingMenuView.h"
#import <QuartzCore/QuartzCore.h>
//#import "HomePageCellElement.h"
#import "DataBaseClass.h"

@interface AddStoreViewController : UIViewController<SettingMenuDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    SettingMenuView *menuView;
    int viewType,shopID; //1 for add record and 2 for edit record
}
@property (nonatomic, assign) int viewType,shopID;
@property (nonatomic, retain) SettingMenuView *menuView;
- (IBAction)clickedCancel:(id)sender;
- (IBAction)clickedAddStore:(id)sender;
@property (retain, nonatomic) IBOutlet UIView *viewAdvertisement;
- (IBAction)clickedAddImage:(id)sender;
@property (retain, nonatomic) IBOutlet UIImageView *imgStore;
@property (retain, nonatomic) IBOutlet UITextField *txtStoreName;
@property (retain, nonatomic) IBOutlet UITextField *txtDescription;
@property (retain, nonatomic) IBOutlet UIButton *btnAddStore;

- (void)updateStoreViewType:(int)type shopID:(int)sID ShopName:(NSString*)shopName Description:(NSString*)desc andImage:(UIImage*)img imageName:(NSString*)imageName favourite:(int)favValue;

@end
