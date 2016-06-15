//
//  ViewController.h
//  Return Tracker
//
//  Created by Ranjeeta Rajput on 05/10/13.
//  Copyright (c) 2013 Ranjeeta Rajput. All rights reserved.
//
#import <UIKit/UIKit.h>
//#import "HomePageCellElement.h"
#import "HomePageCell.h"
#import "AddNotesViewController.h"
#import "sectionView.h"
#import "DataBaseClass.h"
#import "RecordData.h"
#import "NotificationClass.h"
#import "SettingMenuView.h"
#import "AddStoreViewController.h"
#import "ShowImageViewController.h"
#import "StoreData.h"
//Keyboard functionality
@interface ViewController : UIViewController<HomePageCellDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UISearchBarDelegate,DataBaseDelegate,UIActionSheetDelegate,SettingMenuDelegate,SectionViewDelegate,ShowImageViewDelegate,UIPopoverControllerDelegate>
{
    NSString *addNotesStr;
    NSInteger shopNo;
    //UIImagePickerController *picker;
    UIActivityIndicatorView *activityIndicator;
    //For searchbar functionality
    BOOL isSearchActive;
    CGRect m1,m2;
    NSString *strTemp;
    int sectionNumber;
    UIDatePicker *pickerView;
    NSDateFormatter *pickDateFormatter;
    int pickerNumber;
}
@property (nonatomic, assign) int pickerNumber;
@property (nonatomic,retain) UIDatePicker *pickerView;
@property (nonatomic,retain) NSDateFormatter *pickDateFormatter;
@property (retain, nonatomic) IBOutlet UIImageView *bannerImageView;
@property (retain, nonatomic) IBOutlet UITableView *homePageTableView;
@property(nonatomic,retain) NSString *addNotesStr;
@property(retain,nonatomic)id viewControllerDelegate;
@property (retain, nonatomic) IBOutlet UIScrollView *tableScrollView;

@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;

@property (retain, nonatomic) IBOutlet UIView *viewAdvertisement;
- (IBAction)clickedSettingIconButton:(id)sender;
- (void)keyborardDidShow;
- (void)showImageViewController:(myRecordTableViewCell*)cellData andTag:(int)tag andCellDelegate:(id)cellDelegate;
-(void)shortAsPerFavourite;
- (IBAction)clickedPickDateDone:(id)sender;
- (IBAction)clickedPickDateCancel:(id)sender;

@property (retain, nonatomic) IBOutlet UIView *viewPickDate;

@end


