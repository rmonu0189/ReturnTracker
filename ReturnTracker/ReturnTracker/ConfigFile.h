//
//  ConfigFile.h
//  Return Tracker
//
//  Created by Ranjeeta Rajput on 08/10/13.
//  Copyright (c) 2013 Ranjeeta Rajput. All rights reserved.
//

#import <Foundation/Foundation.h>
#define sectionSize 70
#define rowSize 255
//#define orderByTableViewTag 2
#define myRecordSectionHeight 70
//#define myRecordTableViewTag 1
//#define orderByTableViewRowSize 30


//Setting View Table View tag


#define remindMeTableViewTag 1
#define startReturnAlertTableViewTag 2
#define alertTimeTableViewTag 3
#define IMAGE_SCALE_SIZE 200
//Color Value
#define myGreenColor colorWithRed:74.0/255.0f green:150.0/255.0f blue:0.0/255.0f alpha:1.0f

#define subTitleColor colorWithRed:90.0/255.0f green:90.0/255.0f blue:90.0/255.0f alpha:1.0f
//Subtitle Color code



//ViewController Msg
#define RecordInsertSuccessMsg    @"Product has been added Successfully."

#define RecordNotInsertMsg  @"Receipt number already exists."

#define AllFieldFill  @"All field should be filled"

//HomePAge Cell Image
#define BackImage @"Box"
#define HeaderImage  @"Product and Receipt image"
#define ImageFrame  @"img-fram1"

#define CameraBtnImage @"cameraBtn"

#define GallaryBtnImage @"galleryBtn"

#define CalendarImage  @"inputCalendar.png"

#define RadioBtnActiveImage @"radioActive"


#define RadioBtnUnactiveImage  @"radioUnActive"

#define DeleteBtnImage  @"DeleteButton"

#define UpdateBtnImage @"UpdateButton"

#define AddNotesImage @"greenAdnote-icon"

#define ClearBtnImage @"clearBtn"

#define SubmitBtnImage @"submitbtn"
#define SectionImage1 @"cell2BagImg.png"
#define SectionImage2 @"cell1BagImg.png"

#define MOBCLIX_API @"EA25047F-830A-4B4C-B6E9-37546E41CB9E"

#define MSG_PRODUCT_RETURN @"Product returned"

#define IMAGE_ASPECT UIViewContentModeScaleAspectFit

inline static UIImage *scaleImage(UIImage *image,int MaxValue)
{
    float w = image.size.width;
    float h = image.size.height;
    if (w==0||h==0) {
        return nil;
    }
	float ratio;
    if(w>MaxValue && h>MaxValue)
    {
        if(w>h)
        {
            ratio=w/MaxValue;
            w=MaxValue;
            h=h/ratio;
        }
        else
        {
            ratio=h/MaxValue;
            h=MaxValue;
            w=w/ratio;
        }
    }
    else if((w>MaxValue && h<MaxValue )||(w>MaxValue && h==MaxValue))
    {
        ratio=w/MaxValue;
        w=MaxValue;
        h=h/ratio;
    }
    else if((w<MaxValue && h>MaxValue)||(w==MaxValue && h>MaxValue))
    {
        ratio=h/MaxValue;
        h=MaxValue;
        w=w/ratio;
    }
    CGSize newSize=CGSizeMake(w,h);
    
    CGImageRef imageRef = [image CGImage];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, newSize.width, newSize.height, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast);
    CGContextClearRect(context, CGRectMake(0, 0, newSize.width, newSize.height));
    if(image.imageOrientation == UIImageOrientationRight)
    {
        CGContextRotateCTM(context, -M_PI_2);
        CGContextTranslateCTM(context, -newSize.height, 0.0f);
        CGContextDrawImage(context, CGRectMake(0, 0, newSize.height, newSize.width), imageRef);
    }
    else
        CGContextDrawImage(context, CGRectMake(0, 0, newSize.width, newSize.height),imageRef);
    
    CGImageRef scaledImage=CGBitmapContextCreateImage(context);
    
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    UIImage *editImages = [UIImage imageWithCGImage: scaledImage];
    
    CGImageRelease(scaledImage);
    return  editImages;
}

inline static BOOL checkISNullStrings(NSString *checkString)
{
    if ([checkString isKindOfClass:[NSNull class]] || [checkString isEqualToString:@"(null)"] || [checkString isEqualToString:@"null"] || checkString==nil || [checkString isEqualToString:@""] || [checkString isEqualToString:@"<null>"]) {
        return YES;
    }
    return NO;
}


static inline NSDate * getCurrentDate()
{
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MMM-yy HH:mm:ss"];
    NSString *dateString = [dateFormat stringFromDate:today];
    [dateFormat setTimeZone:[NSTimeZone localTimeZone]];
    return [dateFormat dateFromString:dateString];
}

static inline int getIntervalBetween(NSDate *searchDate, NSDate *nowDate)
{
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
                                                        fromDate:searchDate
                                                          toDate:nowDate
                                                         options:0];
    NSInteger interval = [components day];
    return interval;
}

static inline NSDateComponents* getIntervalComponentBetween(NSDate *searchDate, NSDate *returnDate)
{
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter1 setDateFormat:@"dd-MMM-yy"];
    
    NSString *strReturnDate = [dateFormatter1 stringFromDate:returnDate];
    returnDate = [dateFormatter1 dateFromString:strReturnDate];
    
    searchDate = [dateFormatter1 dateFromString:[dateFormatter1 stringFromDate:searchDate]];
    
    NSCalendar *calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    NSDateComponents *components = [calendar components:NSDayCalendarUnit|NSMonthCalendarUnit | NSYearCalendarUnit
                                               fromDate:searchDate
                                                 toDate:returnDate
                                                options:0];
    return components;
}

static inline NSDate * getDateWithFormate_ddMMMyy(NSDate *date){
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MMM-yy"];
    
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter1 setDateFormat:@"dd-MMM-yy"];
    
    return [dateFormatter1 dateFromString:[dateFormatter stringFromDate:date]];
}

static inline void showAlert(NSString *message, id SELF){
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"" message:message delegate:SELF cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] autorelease];
    [alert show];
}
