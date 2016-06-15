//
//  DataBaseClass.h
//  Return Tracker
//
//  Created by Ranjeeta Rajput on 08/10/13.
//  Copyright (c) 2013 Ranjeeta Rajput. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RecordData.h"
#import "StoreData.h"
#import "NotificationClass.h"

@protocol DataBaseDelegate;
@interface DataBaseClass : NSObject
{
    id <DataBaseDelegate> delegate;
     NSString *databasePath;
    NSMutableArray *arrRecord;
}
@property (nonatomic, retain) NSMutableArray *arrRecord;
@property(nonatomic,assign)id <DataBaseDelegate> delegate;
+(DataBaseClass*)getSharedInstance;
- (BOOL)saveStoreDataWithName:(NSString*)storeName Description:(NSString*)desc Image:(UIImage*)img;
- (BOOL) updateHomePageData:(StoreData *)info;
- (BOOL) deleteStoredData:(int)shopId;
-(void)loadStoreArr;
-(void)receiveHomePageData;
-(void)receiveAllData;
- (BOOL) saveData:(RecordData *)recordInfo;
- (BOOL) updateData:(RecordData *)recordInfo;
- (void)findDBPath;
- (BOOL) deleteData:(int)productId;
-(int)getMaxId;
@end
@protocol DataBaseDelegate <NSObject>
@optional

@end