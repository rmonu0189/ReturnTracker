//
//  RecordData.h
//  Return Tracker
//
//  Created by Ranjeeta Rajput on 08/10/13.
//  Copyright (c) 2013 Ranjeeta Rajput. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecordData : NSObject
{
    int shopID,productID;
    NSInteger productReturnedStatus;
    NSString *productNameStr,*receiptNumberStr,*purchaseDateStr,*notes,*returnDate,*returnAlertDate;
    UIImage *img1,*img2,*img3,*img4;
    NSString *remainDay;
    NSString *imageName1,*imageName2,*imageName3,*imageName4;
}
@property (nonatomic, retain) NSString *imageName1,*imageName2,*imageName3,*imageName4;
@property(assign)int shopID,productID;
@property(nonatomic,retain)    NSString *productNameStr,*receiptNumberStr,*purchaseDateStr,*notes,*returnDate,*remainDay,*returnAlertDate;
//@property(nonatomic,retain)NSData *image1,*image2,*image3,*image4;
@property(nonatomic,retain)UIImage *img1,*img2,*img3,*img4;
@property(nonatomic,assign)NSInteger productReturnedStatus;
@end
