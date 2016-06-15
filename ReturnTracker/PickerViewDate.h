//
//  PickerViewDate.h
//  ReturnTracker
//
//  Created by monu on 04/12/13.
//  Copyright (c) 2013 Ranjeeta Rajput. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickerViewDate : UIView
{
    UIDatePicker *pickerView;
    NSDateFormatter *dateFormatter;
}
@property (nonatomic,retain) UIDatePicker *pickerView;
@property (nonatomic,retain) NSDateFormatter *dateFormatter;
@end
