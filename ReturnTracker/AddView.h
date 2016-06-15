//
//  AddView.h
//  ReturnTracker
//
//  Created by monu on 15/11/13.
//  Copyright (c) 2013 Ranjeeta Rajput. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MobclixAds.h"

@interface AddView : UIView <MobclixAdViewDelegate>
{
    MobclixAdView* adView;
}
@property(nonatomic,retain) IBOutlet MobclixAdView* adView;
- (void)showAdvertisementView;
- (void)pauseAdAutoRefresh;

@end
