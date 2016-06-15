//
//  NotificationClass.h
//  ReturnTracker
//
//  Created by monu on 14/11/13.
//  Copyright (c) 2013 Ranjeeta Rajput. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationClass : NSObject
{
    BOOL isSettingClass;
}
@property (nonatomic,assign) BOOL isSettingClass;
// You can pass key in dictionary- receiptNumber, productName, companyName
- (void)setNotificationWithPurchaseDate:(NSDate*)purDate ReturnDate:(NSDate*)retDate msgDictionary:
(NSDictionary*)dict;
-(void)scheduleNotificationWithDate:(NSDate*)date andDictionar:(NSDictionary *)dict :(int)numberOfDay;
- (void)cancelNotificationWithReceiptNumber:(NSString*)productId;
- (NSDate*)getDateWithDefaultTime:(NSDate*)date;
- (BOOL)checkDateIsExpire:(NSDate *)returnDate;
- (void)addNotificationWithDate:(NSDate*)aDate ReturnDate:(NSDate*)returnDate andDictionar:(NSDictionary *)dict;
- (void)updateNotification;
@end
