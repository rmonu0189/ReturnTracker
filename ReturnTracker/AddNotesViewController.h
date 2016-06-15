//
//  AddNotesViewController.h
//  ReturnTracker
//
//  Created by Ranjeeta Rajput on 09/10/13.
//  Copyright (c) 2013 Ranjeeta Rajput. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "UIKeyboardViewController.h"
@interface AddNotesViewController : UIViewController<UITextViewDelegate>
@property (retain, nonatomic) IBOutlet UILabel *productNameLbl;
@property (retain, nonatomic) IBOutlet UILabel *purchaseDateLbl;

@property (retain, nonatomic) IBOutlet UILabel *returnDateLbl;
@property (retain, nonatomic) IBOutlet UILabel *shopNameLbl;
@property (retain, nonatomic) IBOutlet UITextView *addNotesTextView;
@property (retain, nonatomic) IBOutlet UIImageView *productImageView;

@property (retain, nonatomic) IBOutlet UILabel *currentDateLbl;
@property (retain, nonatomic) IBOutlet UIView *viewAdvertisement;

@property(nonatomic,retain)id delegate;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil currentDate:(NSString*)date productName:(NSString*)productName shopName:(NSString *)shopName purchaseDate:(NSString*)purchaseDate returnDate:(NSString*)returndDate image:(UIImage*)image withAddNotesStr:(NSString*)addNoteStr;
- (IBAction)btnClick:(id)sender;
- (IBAction)submitBtnClick:(id)sender;
- (IBAction)removeBtnClick:(id)sender;
@end
