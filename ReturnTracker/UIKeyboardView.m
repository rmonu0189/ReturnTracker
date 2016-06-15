//
//  UIKeyboardView.m
//
//
//  Created by  YFengchen on 13-1-4.
//  Copyright 2013 __zhongyan__. All rights reserved.
//

#import "UIKeyboardView.h"


@implementation UIKeyboardView

@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        //ran change
//		keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width+10, frame.size.height)];
		CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;

        keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, screenWidth, frame.size.height)];

		keyboardToolbar.barStyle = UIBarStyleBlackTranslucent;
		
		UIBarButtonItem *previousBarItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Previous", @"")
																			style:UIBarButtonItemStyleBordered
																		   target:self
																		   action:@selector(toolbarButtonTap:)];
		previousBarItem.tag=1;
		
		UIBarButtonItem *nextBarItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Next", @"")
																		style:UIBarButtonItemStyleBordered
																	   target:self
																	   action:@selector(toolbarButtonTap:)];
		nextBarItem.tag=2;
		
		UIBarButtonItem *spaceBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
																					  target:nil
																					  action:nil];
		
		UIBarButtonItem *doneBarItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", @"")
																		style:UIBarButtonItemStyleDone
																	   target:self
																	   action:@selector(toolbarButtonTap:)];
		doneBarItem.tag=3;
		
		[keyboardToolbar setItems:[NSArray arrayWithObjects:previousBarItem, nextBarItem, spaceBarItem, doneBarItem, nil]];
		[previousBarItem release];
		[nextBarItem release];
		[spaceBarItem release];
		[doneBarItem release];
		[self addSubview:keyboardToolbar];
		[keyboardToolbar release];
    }
    return self;
}

- (void)toolbarButtonTap:(UIButton *)button {
	if ([self.delegate respondsToSelector:@selector(toolbarButtonTap:)]) {
		[self.delegate toolbarButtonTap:button];
	}
}

@end

@implementation UIKeyboardView (UIKeyboardViewAction)

//According to index Find the corresponding UIBarButtonItem
- (UIBarButtonItem *)itemForIndex:(NSInteger)itemIndex {
	if (itemIndex < [[keyboardToolbar items] count]) {
		return [[keyboardToolbar items] objectAtIndex:itemIndex];
	}
	return nil;
}

@end
