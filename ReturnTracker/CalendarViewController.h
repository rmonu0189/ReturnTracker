//
//  CalendarViewController.h
//  ReturnTracker
//
//  Created by Ranjeeta Rajput on 08/10/13.
//  Copyright (c) 2013 Ranjeeta Rajput. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KalView.h"       // for the KalViewDelegate protocol
#import "KalDataSource.h" // for the KalDataSourceCallbacks protocol
#import "ImageAndString.h"
#import "DataBaseClass.h"
#import "CalenderRecordCell.h"
#import "StoreData.h"
#import "UpdateProductViewController.h"

@class KalLogic, KalDate;

/*
 *    KalViewController
 *    ------------------------
 *
 *  KalViewController automatically creates both the calendar view
 *  and the events table view for you. The only thing you need to provide
 *  is a KalDataSource so that the calendar system knows which days to
 *  mark with a dot and which events to list under the calendar when a certain
 *  date is selected (just like in Apple's calendar app).
 *
 */
@interface CalendarViewController : UIViewController <KalViewDelegate, KalDataSourceCallbacks,UITableViewDataSource,UITableViewDelegate,CalendarRecordCellDelegate>
{
    KalLogic *logic;
   
   // id <UITableViewDelegate> delegate;
    id <KalDataSource> dataSource;
    NSDate *initialDate;                    // The date that the calendar was initialized with *or* the currently selected date when the view hierarchy was torn down in order to satisfy a low memory warning.
    NSDate *selectedDate;                   // I cache the selected date because when we respond to a memory warning, we cannot rely on the view hierarchy still being alive, and thus we cannot always derive the selected date from KalView's selectedDate property.
    NSArray *dateArr;
    NSArray *imageStringArr;
    NSArray *dateArr1;
    NSArray *imageStringArr1;
    CGFloat calendarHeight;
    KalView *kalView;
    UITableView *tblRecord;
    NSMutableArray *arrRecord,*selectedRecord;
    UIView *viewAdvertisement;
    int btnTag;
}
@property (nonatomic, retain) UIView *viewAdvertisement;
@property (nonatomic, retain) UITableView *tblRecord;
@property (nonatomic, retain) NSMutableArray *arrRecord,*selectedRecord;
@property (retain, nonatomic) IBOutlet UIView *subView;

@property (nonatomic, assign) id<UITableViewDelegate> delegate;
@property (nonatomic, assign) id<KalDataSource> dataSource;
@property (nonatomic, retain, readonly) NSDate *selectedDate;
@property (nonatomic, retain)NSArray *dateArr1;
@property (nonatomic, retain) NSArray *imageStringArr1;
@property (nonatomic, retain)ImageAndString *imageandStringObj;
- (id)initWithSelectedDate:(NSDate *)date dateArray:(NSArray *)dateArr imageStringArray:(NSArray*)imageStringArr productStringArray:(NSArray*)productStringArr;  // designated initializer. When the calendar is first displayed to the user, the month that contains 'selectedDate' will be shown and the corresponding tile for 'selectedDate' will be automatically selected.
//- (void)reloadData;                                 // If you change the KalDataSource after the KalViewController has already been displayed to the user, you must call this method in order for the view to reflect the new data.
//- (id)initWithSelectedDate:(NSDate *)date;
- (void)showAndSelectDate:(NSDate *)date;           // Updates the state of the calendar to display the specified date's month and selects the tile for that date.
-(void)dateWithImg:(NSDate *)date imgdate:(NSString*)imgString;
@end
