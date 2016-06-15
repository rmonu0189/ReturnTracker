//
//  ImageAndString.h
//  ReturnTracker
//
//  Created by Prashant Khatri on 07/11/13.
//  Copyright (c) 2013 Ranjeeta Rajput. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageAndString : NSObject
@property(nonatomic,strong)NSArray *imageDate;
@property(nonatomic,strong)NSArray *imageString;
@property(nonatomic,strong)NSArray *productString;
+ (ImageAndString*)getSharedInstance;
@end
