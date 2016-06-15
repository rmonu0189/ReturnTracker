//
//  loadingView.h

// class used for create loading view
#import <UIKit/UIKit.h>


@interface loadingView : UIView {
  
	UIActivityIndicatorView	*activityIndicator;
	UIButton *btnCancel;
    UILabel *lblMsg;
    UIView *myLoadingView;
	
}
@property(nonatomic,retain) UILabel *lblMsg;
@property(nonatomic,retain)	UIButton *btnCancel;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView	*activityIndicator;
- (id) initWithLoadingFrame:(CGRect )f;
@end
