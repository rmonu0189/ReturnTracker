//
//  ProductData.h
//  ReturnTracker
//
//  Created by monu on 12/11/13.
//  Copyright (c) 2013 Ranjeeta Rajput. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductData : NSObject
{
    UIImage *imgProduct;
    NSString *productName,*shopName,*returnDate,*purchaseDate,*remailDays;
}

@property (nonatomic, retain) UIImage *imgProduct;
@property (nonatomic, retain) NSString *productName,*shopName,*returnDate,*purchaseDate,*remailDays;
@end
