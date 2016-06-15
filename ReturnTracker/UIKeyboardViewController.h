//
//  UIKeyboardViewController.h
//
//
//  Created by  YFengchen on 13-1-4.
//  Copyright 2013 __zhongyan__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIKeyboardView.h"

@protocol UIKeyboardViewControllerDelegate;

@interface UIKeyboardViewController : NSObject <UITextFieldDelegate, UIKeyboardViewDelegate, UITextViewDelegate> {
	CGRect keyboardBounds;
	UIKeyboardView *keyboardToolbar;
    id <UIKeyboardViewControllerDelegate> _boardDelegate;
    id keyBoardDelegate;
    UIView *objectView;
}
@property (nonatomic,assign) id keyBoardDelegate;
@property(nonatomic,assign)id delegate;
@property (nonatomic, assign) id <UIKeyboardViewControllerDelegate> boardDelegate;

@end

@interface UIKeyboardViewController (UIKeyboardViewControllerCreation)

- (id)initWithControllerDelegate:(id <UIKeyboardViewControllerDelegate>)delegateObject withMainDelegate:(id)delegate ;

@end

@interface UIKeyboardViewController (UIKeyboardViewControllerAction)

- (void)addToolbarToKeyboard;

@end

@protocol UIKeyboardViewControllerDelegate <NSObject>

@optional
-(void)alttextFieldShouldStartEditing:(UITextField*)textField;
- (void)alttextFieldDidEndEditing:(UITextField *)textField;
- (void)alttextViewDidEndEditing:(UITextView *)textView;

-(void)doneBtnMethodOfReturnDuration;
@end
