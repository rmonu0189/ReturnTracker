//
//  StoreData.h
//  ReturnTracker
//
//  Created by mac-001 on 28/11/13.
//  Copyright (c) 2013 Ranjeeta Rajput. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoreData : NSObject
{
    int shopId,favourite;
    NSString *shopName,*description,*imagePath;
}
@property(assign)int shopId,favourite;
@property(nonatomic,retain)NSString *strShopId,*shopName,*description,*imagePath;
@end
