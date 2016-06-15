//
//  loadingView.m
// class used for create loading view

#import "loadingView.h"

static float LoadingView_Width = 150;
static float LoadingView_Height = 150;
static float ActivityIndicator_Width = 37;
static float ActivityIndicator_Height = 37;

@implementation loadingView

@synthesize activityIndicator,btnCancel,lblMsg;

- (id) initWithLoadingFrame:(CGRect )f
{
	self=[super initWithFrame:f];
    [self setBackgroundColor:[UIColor clearColor]];

    myLoadingView=[[UIView alloc] initWithFrame:CGRectMake((f.size.width-LoadingView_Width)/2, (f.size.height-LoadingView_Height)/2, LoadingView_Width,LoadingView_Width)];
    myLoadingView.layer.masksToBounds=YES;
    myLoadingView.layer.cornerRadius=5.0;
    myLoadingView.layer.borderColor=[UIColor whiteColor].CGColor;

	[myLoadingView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7]];
		
    self.activityIndicator=[[UIActivityIndicatorView alloc] initWithFrame: CGRectMake((LoadingView_Width-ActivityIndicator_Width)/2, (LoadingView_Height-ActivityIndicator_Height-30)/2, ActivityIndicator_Width, ActivityIndicator_Height)];
    [self.activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [myLoadingView addSubview:self.activityIndicator];
    
	lblMsg=[[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.activityIndicator.frame), LoadingView_Width, 30)];
    lblMsg.text=@"Logging...";
    lblMsg.textAlignment=UITextAlignmentCenter;
    lblMsg.backgroundColor=[UIColor clearColor];
    lblMsg.textColor=[UIColor whiteColor];
    lblMsg.font=[UIFont fontWithName:@"Arial-BoldMT" size:15.0f];
    [myLoadingView addSubview:lblMsg];
    [self addSubview:myLoadingView];
    [myLoadingView release];
    

	return self;
}

- (void)dealloc {
	[lblMsg release];
	[btnCancel release];
	[activityIndicator release];
    [super dealloc];
}


@end
