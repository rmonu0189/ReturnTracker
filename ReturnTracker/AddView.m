//
//  AddView.m
//  ReturnTracker
//
//  Created by monu on 15/11/13.
//  Copyright (c) 2013 Ranjeeta Rajput. All rights reserved.
//

#import "AddView.h"

@implementation AddView
@synthesize adView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)showAdvertisementView{
    if(!self.adView){
         if ([[[UIDevice currentDevice] model] hasPrefix:@"iPad"]) {
             self.adView = [[MobclixAdViewiPad_728x90 alloc] initWithFrame:CGRectMake(0, 0, 728, 90)];
         }
        else
        {
            self.adView = [[MobclixAdViewiPhone_320x50 alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
        }
        
        self.adView.delegate = self;
        [self addSubview:self.adView];
        [self setBackgroundColor:[UIColor blackColor]];
    }
    [self.adView getAd];
    [self resumeAdAutoRefresh];
}

- (void)resumeAdAutoRefresh{
    [self.adView resumeAdAutoRefresh];
}

- (void)pauseAdAutoRefresh{
    [self.adView pauseAdAutoRefresh];
}

#pragma mark - Ad delegate method
- (void)adViewDidFinishLoad:(MobclixAdView*)adView{
    NSLog(@"..............Loading ad..............");
}
- (void)adView:(MobclixAdView*)adView didFailLoadWithError:(NSError*)error{
    //NSLog(@"%@",error);
}

@end
