/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import <UIKit/UIKit.h>

enum {
  KalTileTypeRegular   = 0,
  KalTileTypeAdjacent  = 1 << 0,
  KalTileTypeToday     = 1 << 1,
};
typedef char KalTileType;

@class KalDate;

@interface KalTileView : UIView
{
    BOOL isintiate;
    BOOL isSelectDate;
    KalDate *date;
  CGPoint origin;
    
  struct {
    unsigned int selected : 1;
    unsigned int highlighted : 1;
    unsigned int marked : 1;
    unsigned int type : 2;
  } flags;
}

@property (nonatomic, retain) KalDate *date;
@property (nonatomic, getter=isHighlighted) BOOL highlighted;
@property (nonatomic, getter=isSelected) BOOL selected;

@property (nonatomic, getter=isMarked) BOOL marked;
@property (nonatomic) KalTileType type;
@property(nonatomic,retain)NSArray *dateArr;
@property(nonatomic,retain)NSArray *imageStingArr;
//@property(nonatomic,retain)CalendarViewController *cal;
@property(nonatomic,assign)BOOL isintiate;
@property(nonatomic,retain)NSMutableArray *markedDateArray;
@property(nonatomic,retain)NSArray *productImageArray;
- (void)resetState;
- (BOOL)isToday;
- (BOOL)belongsToAdjacentMonth;
-(BOOL)compareDate:(NSDate*)date;

- (void)calenderHeight:(CGFloat)kalHeight;


@end
