//
//  NotificationClass.m
//  ReturnTracker
//
//  Created by monu on 14/11/13.
//  Copyright (c) 2013 Ranjeeta Rajput. All rights reserved.
//

#import "NotificationClass.h"

@implementation NotificationClass
@synthesize isSettingClass;

- (void)setNotificationWithPurchaseDate:(NSDate*)purDate ReturnDate:(NSDate*)retDate msgDictionary:(NSDictionary*)dict{
    NSMutableDictionary *dictionary=[NSMutableDictionary dictionary];
    dictionary=(NSMutableDictionary*)dict;
    [dictionary setValue:[NSString stringWithFormat:@"%@",[self getDateWithDefaultTime:purDate]] forKey:@"purchaseDate"];
    [dictionary setValue:[NSString stringWithFormat:@"%@",[self getDateWithDefaultTime:retDate]] forKey:@"returnDate"];
    [dictionary setValue:[[AppDelegate sharedAppDelegate] getInterBetweenTwoDate:getCurrentDate() ReturnDate:[self getDateWithDefaultTime:retDate]] forKey:@"remainDay"];
    
    for(int i=0; i<=[[AppDelegate sharedAppDelegate].startAlertFromStr integerValue]; i++){
        [self scheduleNotificationWithDate:[[self getDateWithDefaultTime:retDate] dateByAddingTimeInterval:-60*60*24*i] andDictionar:dictionary :i];
    }
}

- (void)addNotificationWithDate:(NSDate*)aDate ReturnDate:(NSDate*)returnDate andDictionar:(NSDictionary *)dict{
    NSDate *date = [self getDateWithDefaultTime:aDate];
    if([self checkDateIsExpire:date]){
        return ;
    }
    int interVal = getIntervalBetween([self getDateWithDefaultTime:date], [self getDateWithDefaultTime:[self getDateWithDefaultTime:returnDate]]);
    if(interVal>=4){
        NSString *companyName = [dict valueForKey:@"companyName"];
        NSString *productName = [dict valueForKey:@"productName"];
        NSString *msg = [[NSString alloc]init];
        msg=@"";
        if(interVal==0){
            msg = @"today.";
        }
        else if(interVal==1){
            msg = [NSString stringWithFormat:@"after 1 day."];
        }
        else if(interVal>28){
            msg = [[AppDelegate sharedAppDelegate]getInterBetweenTwoDate:getCurrentDate() ReturnDate:date];
            msg = [msg stringByReplacingOccurrencesOfString:@" left" withString:@""];
            msg = [@"after " stringByAppendingString:msg];
        }
        else{
            msg = [NSString stringWithFormat:@"after %d days.",interVal];
        }
        msg = [NSString stringWithFormat:@"\"%@\" of \"%@\" is due for return %@",productName,companyName,msg];
        [dict setValue:msg forKey:@"message"];
        
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = date;
        localNotification.alertBody = msg;
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        if([AppDelegate sharedAppDelegate].isDefaultAlert){
            localNotification.soundName= UILocalNotificationDefaultSoundName;
        }
        else{
            if(![AppDelegate sharedAppDelegate].isSoundButtonOn && ![AppDelegate sharedAppDelegate].isVibrationButtonOn){
                localNotification.soundName = nil;
            }
            else if(![AppDelegate sharedAppDelegate].isSoundButtonOn && [AppDelegate sharedAppDelegate].isVibrationButtonOn){
                localNotification.soundName= @"silent.amr";
            }
            else if([AppDelegate sharedAppDelegate].isSoundButtonOn && ![AppDelegate sharedAppDelegate].isVibrationButtonOn){
                localNotification.soundName = nil;
            }
            else if([AppDelegate sharedAppDelegate].isSoundButtonOn && [AppDelegate sharedAppDelegate].isVibrationButtonOn){
                localNotification.soundName= @"beep.mp3";
            }
        }
        [msg release];
        localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
        localNotification.userInfo = dict;
        localNotification.repeatInterval = 0;
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:self];
    }
    
}

-(void)scheduleNotificationWithDate:(NSDate*)date andDictionar:(NSDictionary *)dict :(int)numberOfDay
{
    if([self checkDateIsExpire:date]){
        return ;
    }
    
    NSString *remainDay = [[AppDelegate sharedAppDelegate] getInterBetweenTwoDate:[NSDate date] ReturnDate:date];
    if(![remainDay isEqualToString:@"Return Date Expire"]){
        NSString *companyName = [dict valueForKey:@"companyName"];
        NSString *productName = [dict valueForKey:@"productName"];
        NSString *msg = @"";
        if(numberOfDay==0){
            msg = @"today.";
        }
        else if(numberOfDay==1){
            msg = [NSString stringWithFormat:@"after 1 day."];
        }
        else if(numberOfDay>28){
            msg = [[AppDelegate sharedAppDelegate]getInterBetweenTwoDate:getCurrentDate() ReturnDate:date];
            msg = [msg stringByReplacingOccurrencesOfString:@" left" withString:@""];
            msg = [@"after " stringByAppendingString:msg];
        }
        else{
            msg = [NSString stringWithFormat:@"after %d days.",numberOfDay];
        }
        msg = [NSString stringWithFormat:@"\"%@\" of \"%@\" is due for return %@",productName,companyName,msg];
        [dict setValue:msg forKey:@"message"];
        
        
        
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = date;
        localNotification.alertBody = msg;
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        if([AppDelegate sharedAppDelegate].isDefaultAlert){
            localNotification.soundName= UILocalNotificationDefaultSoundName;
        }
        else{
            if(![AppDelegate sharedAppDelegate].isSoundButtonOn && ![AppDelegate sharedAppDelegate].isVibrationButtonOn){
                localNotification.soundName = nil;
            }
            else if(![AppDelegate sharedAppDelegate].isSoundButtonOn && [AppDelegate sharedAppDelegate].isVibrationButtonOn){
                localNotification.soundName= @"silent.amr";
            }
            else if([AppDelegate sharedAppDelegate].isSoundButtonOn && ![AppDelegate sharedAppDelegate].isVibrationButtonOn){
                localNotification.soundName = nil;
            }
            else if([AppDelegate sharedAppDelegate].isSoundButtonOn && [AppDelegate sharedAppDelegate].isVibrationButtonOn){
                localNotification.soundName= @"beep.mp3";
            }
        }
        
        if([AppDelegate sharedAppDelegate].isSoundButtonOn){
            
        }else{
            
        }
        localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
        localNotification.userInfo = dict;
        localNotification.repeatInterval = 0;
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:self];
        [localNotification release];
    }
}

- (void)cancelNotificationWithReceiptNumber:(NSString*)productId{
    NSArray *arrayOfLocalNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *localNotification in arrayOfLocalNotifications) {
        if([[localNotification.userInfo valueForKey:@"productId"] isEqualToString:productId]){
            [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
        }
    }
}

- (NSArray*)getAllNotification{
    return [[UIApplication sharedApplication] scheduledLocalNotifications];
}

- (void)clearAllNotification{
    [[UIApplication sharedApplication]cancelAllLocalNotifications];
}

- (NSDate*)getDateWithDefaultTime:(NSDate*)date{
    NSDateFormatter *timeFormatter=[[[NSDateFormatter alloc]init] autorelease];
    timeFormatter.dateFormat=@"HH:mm:ss";
    NSDate *alertTime=[timeFormatter dateFromString:[AppDelegate sharedAppDelegate].defualtTimeStr];
    NSCalendar *calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    NSDateComponents *timeComponent=[calendar components:NSHourCalendarUnit | NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:alertTime];
    NSDateComponents *dateComponent=[calendar components:NSMonthCalendarUnit|NSYearCalendarUnit|NSDayCalendarUnit fromDate:date];
    NSDateComponents *returnComp=[[[NSDateComponents alloc]init] autorelease];
    [returnComp setDay:dateComponent.day];
    [returnComp setMonth:dateComponent.month];
    [returnComp setYear:dateComponent.year];
    [returnComp setHour:timeComponent.hour];
    [returnComp setMinute:timeComponent.minute];
    [returnComp setSecond:timeComponent.second];
    NSDate *finalAlertDate=[calendar dateFromComponents:returnComp];
    return finalAlertDate;
}

- (NSDate*)getDateAfterAddingNumberOfDay:(int)numberOfDay andDate:(NSDate*)date{
    return [date dateByAddingTimeInterval:60*60*24*numberOfDay];
}

- (BOOL)checkDateIsExpire:(NSDate *)returnDate{
    NSTimeInterval distanceBetweenDates = [returnDate timeIntervalSinceDate:getCurrentDate()];
    if(distanceBetweenDates>0){
        return NO;
    }
    else{
        return YES;
    }
}

- (void)dealloc{
    
    [super dealloc];
}

- (void)updateNotification{
    for(UILocalNotification *localNotification in [[UIApplication sharedApplication] scheduledLocalNotifications]){
        if([AppDelegate sharedAppDelegate].isDefaultAlert){
            localNotification.soundName= UILocalNotificationDefaultSoundName;
        }
        else{
            if(![AppDelegate sharedAppDelegate].isSoundButtonOn && ![AppDelegate sharedAppDelegate].isVibrationButtonOn){
                localNotification.soundName = nil;
            }
            else if(![AppDelegate sharedAppDelegate].isSoundButtonOn && [AppDelegate sharedAppDelegate].isVibrationButtonOn){
                localNotification.soundName= @"silent.amr";
            }
            else if([AppDelegate sharedAppDelegate].isSoundButtonOn && ![AppDelegate sharedAppDelegate].isVibrationButtonOn){
                localNotification.soundName = nil;
            }
            else if([AppDelegate sharedAppDelegate].isSoundButtonOn && [AppDelegate sharedAppDelegate].isVibrationButtonOn){
                localNotification.soundName= @"beep.mp3";
            }
        }
    }
}

@end
