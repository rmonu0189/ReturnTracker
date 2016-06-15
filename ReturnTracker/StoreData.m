//
//  StoreData.m
//  ReturnTracker
//
//  Created by mac-001 on 28/11/13.
//  Copyright (c) 2013 Ranjeeta Rajput. All rights reserved.
//

#import "StoreData.h"

@implementation StoreData
@synthesize shopName,description,imagePath,favourite;
@synthesize shopId;

- (void)dealloc{
    [self.shopName release];
    [self.description release];
    [self.imagePath release];
    [super dealloc];
}
@end
