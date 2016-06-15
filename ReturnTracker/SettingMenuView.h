//
//  SettingMenuView.h
//  ReturnTracker
//
//  Created by mac-001 on 25/11/13.
//  Copyright (c) 2013 Ranjeeta Rajput. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol SettingMenuDelegate <NSObject>
@required
- (void)selectMenuAtIndex:(int)index;
- (void)clickeOutSideFromMenu;
@end

@interface SettingMenuView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *element;
    UITableView *settingMenuTable;
    BOOL isSection;
    id<SettingMenuDelegate> delegate;
    UIView *headerView;
    int menuType;
}
@property (nonatomic, assign) int menuType;
@property (nonatomic, retain) UIView *headerView;
@property (nonatomic, assign) BOOL isSection;
@property (nonatomic, assign) id<SettingMenuDelegate> delegate;
@property(nonatomic,retain)UITableView *settingMenuTable;
- (id)initWithFrame:(CGRect)frame andMenuArray:(NSArray*)arrMenu;
- (void)setIsSection:(BOOL)isSec andTitle:(NSString*)title;
- (void)setDesignWithType:(int)type;
@end
