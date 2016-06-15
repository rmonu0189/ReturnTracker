//
//  MyRecordViewController.h
//  ReturnTracker
//
//  Created by Ranjeeta Rajput on 08/10/13.
//  Copyright (c) 2013 Ranjeeta Rajput. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyRecordSectionView.h"
#import "myRecordTableViewCell.h"
#import "DataBaseClass.h"
#import "RecordData.h"
#import "ShowImageViewController.h"
#import "SettingMenuView.h"

@interface MyRecordViewController : UIViewController<myRecordTableViewCellDelegate,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,DataBaseDelegate,UIPickerViewDataSource,UIPickerViewDelegate,SettingMenuDelegate,ShowImageViewDelegate>
{
    RecordData *fetchRecord;
    
    NSMutableArray *sectionElementArray;
    UIImagePickerController *picker;
    NSMutableArray *fetchDataArray;
    
    NSString *addNotesStr;
    BOOL isFirstTime;
    
    //For Textfield position
    int sectionNumber;
    NSString *recNumber;
    
    BOOL isShowImage;
    
    SettingMenuView *menuView;
    SettingMenuView *menuSetting;
    
    NSDateFormatter *dateFormatterSection;
    
    UIDatePicker *pickerView;
    NSDateFormatter *pickDateFormatter;
    int pickerNumber;
    
}
@property (nonatomic, assign) int pickerNumber;
@property (nonatomic,retain) UIDatePicker *pickerView;
@property (nonatomic,retain) NSDateFormatter *pickDateFormatter;
@property (nonatomic, retain) NSDateFormatter *dateFormatterSection;
@property (nonatomic, retain) SettingMenuView *menuSetting;
@property (nonatomic, retain) SettingMenuView *menuView;
@property(nonatomic,copy)NSMutableArray *sectionElementArray;
@property (retain, nonatomic) IBOutlet UIButton *orderByBtn;
@property (retain, nonatomic) IBOutlet UITableView *myRecordTableView;
@property (retain, nonatomic) IBOutlet UIImageView *bannerImageView;

@property (retain, nonatomic) IBOutlet UIScrollView *tableScrollView;
@property (retain, nonatomic) IBOutlet UISearchBar *searchBarProducts;

@property (retain, nonatomic) IBOutlet UIView *viewAdvertisement;
@property(nonatomic,retain)NSString *addNotesStr;
//Order by table view method
- (IBAction)orderByMethod:(id)sender;
 //For Textfield position
- (IBAction)clickSettingIconBtn:(id)sender;
- (void)keyborardDidShow;
@property (retain, nonatomic) IBOutlet UIView *viewPickDate;
- (void)showImageViewController:(myRecordTableViewCell*)cellData andTag:(int)tag andCellDelegate:(id)cellDelegate;
- (IBAction)clickedPickDateDone:(id)sender;
- (IBAction)clickedPickDateCancel:(id)sender;

@end
