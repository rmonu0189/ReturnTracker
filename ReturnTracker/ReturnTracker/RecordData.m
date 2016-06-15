//
//  RecordData.m
//  Return Tracker
//
//  Created by Ranjeeta Rajput on 08/10/13.
//  Copyright (c) 2013 Ranjeeta Rajput. All rights reserved.
//

#import "RecordData.h"

@implementation RecordData
@synthesize productNameStr,purchaseDateStr,receiptNumberStr,returnDate,notes,shopID,img1,img2,img3,img4,remainDay,productReturnedStatus,productID,returnAlertDate;
@synthesize imageName1,imageName2,imageName3,imageName4;

- (void)dealloc
{
    [self.img1 release];
    [self.img2 release];
    [self.img3 release];
    [self.img4 release];
    [self.productNameStr release];
    [self.purchaseDateStr release];
    [self.receiptNumberStr release];
    [self.returnDate release];
    [self.notes release];
    [self.returnAlertDate release];
    [self.imageName1 release];
    [self.imageName2 release];
    [self.imageName3 release];
    [self.imageName4 release];
    [super dealloc];
}

@end
