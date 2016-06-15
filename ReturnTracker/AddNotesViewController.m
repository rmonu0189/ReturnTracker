//
//  AddNotesViewController.m
//  ReturnTracker
//
//  Created by Ranjeeta Rajput on 09/10/13.
//  Copyright (c) 2013 Ranjeeta Rajput. All rights reserved.
//

#import "AddNotesViewController.h"

@interface AddNotesViewController ()
{
    
    NSString *productNameStr;
    
    NSString *shopNameStr;
    NSString *purchaseDateStr;
    NSString *returnDateStr;
    NSString *imageNameStr;
    UIImage *fetchImage;
    
    NSString *addNoteString;
    UIButton *done;
}
@end

@implementation AddNotesViewController
@synthesize purchaseDateLbl,productNameLbl,returnDateLbl,addNotesTextView,productImageView,shopNameLbl,delegate,currentDateLbl;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//         self.view.transform = CGAffineTransformMakeScale([UIScreen mainScreen].applicationFrame.size.width / 320.0f, [UIScreen mainScreen].applicationFrame.size.height / 480.0f);
        // Custom initialization
    }
    return self;
}




-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil currentDate:(NSString*)date productName:(NSString*)productName shopName:(NSString *)shopName purchaseDate:(NSString*)purchaseDate returnDate:(NSString*)returndDate image:(UIImage*)image withAddNotesStr:(NSString*)addNoteStr
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
         
        productNameStr=productName;
        shopNameStr=shopName;
        purchaseDateStr=purchaseDate;
        returnDateStr=returndDate;
        
        fetchImage=[[UIImage alloc]init];
        fetchImage=image;
        addNoteString=addNoteStr;
        
        
        
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.addNotesTextView becomeFirstResponder];
    self.view.transform = CGAffineTransformMakeScale([UIScreen mainScreen].applicationFrame.size.width / 320.0f, [UIScreen mainScreen].applicationFrame.size.height / 480.0f);
    [addNotesTextView setDelegate:self];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if([[AppDelegate sharedAppDelegate] getOsVersion] == 7){
        [self.viewAdvertisement setFrame:CGRectMake(0, 450, 320, 50)];
    }
    else{
        [self.viewAdvertisement setFrame:CGRectMake(0, 430, 320, 50)];
    }
    [self.viewAdvertisement setFrame:CGRectMake(0, self.view.frame.size.height-50, 320, 50)];
    [[AppDelegate sharedAppDelegate] showAdvertisement:self.viewAdvertisement];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    [[AppDelegate sharedAppDelegate] hideAdvertisement];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [productNameLbl setText:productNameStr];
    [purchaseDateLbl setText:purchaseDateStr];
    [returnDateLbl setText:returnDateStr];
    [shopNameLbl setText:shopNameStr];
    [productImageView setImage:[UIImage imageNamed:imageNameStr]];
    [productImageView setImage:[UIImage imageNamed:@""]];
    NSDateFormatter *formate=[[NSDateFormatter alloc]init];
    [formate setDateFormat:@"dd MMMM yyyy"];
 
    [currentDateLbl setText:[formate stringFromDate:getCurrentDate()]];
    [currentDateLbl setTextColor:[UIColor myGreenColor]];
    
    done=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 56, 30)];
    [done setTitle:@"Done" forState:UIControlStateNormal];
    [done setFont:[UIFont systemFontOfSize:15]];
    
    [done addTarget: self action:@selector(doneWithNumberPad) forControlEvents:UIControlEventTouchUpInside];
    if (addNoteString) {
        [addNotesTextView setText:addNoteString];
        [done setBackgroundImage:[UIImage imageNamed:@"button_blank.png"] forState:UIControlStateNormal];
    }
    else
    {
        [done setBackgroundImage:[UIImage imageNamed:@"submitbtn"] forState:UIControlStateNormal];
    }
    if (fetchImage==nil) {
        [productImageView setImage:[UIImage imageNamed:@"userImage.png"]];
    }
    else
    {
        [productImageView setImage:fetchImage];
    }
   

    
    
    //Toolbar code
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320,30)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    //UIBarButtonItem *done=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)];
//  UIBarButtonItem *done=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"submitbtn.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(doneWithNumberPad)];
    
//    done=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 56, 30)];
//    [done setTitle:@"Done" forState:UIControlStateNormal];
//    [done setFont:[UIFont systemFontOfSize:15]];
//    [done setBackgroundImage:[UIImage imageNamed:@"button_blank.png"] forState:UIControlStateNormal];
//    [done addTarget: self action:@selector(doneWithNumberPad) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *done1=[[UIBarButtonItem alloc]initWithCustomView:done];
    
//    [done setTitle:@"Done"];
    
    
//
    
//    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"submitbtn" style:UIBarButtonItemStyleBordered target:self action:@selector(action)];
   // [done setBackgroundImage:[UIImage imageNamed:@"GreenCheckBox"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//    numberToolbar.items = [NSArray arrayWithObjects:
//                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
//                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(doneWithNumberPad)],
//                           nil];
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           done1,
                           nil];

    [numberToolbar sizeToFit];
    addNotesTextView.inputAccessoryView = numberToolbar;
   
   }


-(void)doneWithNumberPad{
    NSString *numberFromTheKeyboard = addNotesTextView.text;
    [addNotesTextView resignFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)btnClick:(id)sender {
    //[self.view removeFromSuperview];
    [self dismissModalViewControllerAnimated:YES];
    
}

- (IBAction)submitBtnClick:(id)sender {
    
    [delegate assingAddNote:addNotesTextView.text];
    
    [self goBack];
}

-(void)goBack
{
    //[self.view removeFromSuperview];
    [self dismissModalViewControllerAnimated:YES];
}
- (IBAction)removeBtnClick:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
    //[self.view removeFromSuperview];
}
- (void)dealloc {
    [productNameLbl release];
    [purchaseDateLbl release];
    [returnDateLbl release];
    [addNotesTextView release];
    [productImageView release];
    [shopNameLbl release];
    [currentDateLbl release];
    [_viewAdvertisement release];
    [super dealloc];
}
- (void)viewDidUnload {
//    [[AppDelegate sharedAppDelegate].addView.adView cancelAd];
    [self setProductNameLbl:nil];
    [self setPurchaseDateLbl:nil];
    [self setReturnDateLbl:nil];
    [self setAddNotesTextView:nil];
    [self setProductImageView:nil];
    [self setShopNameLbl:nil];
    [self setCurrentDateLbl:nil];
    [self setViewAdvertisement:nil];
    [super viewDidUnload];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
//    if ([textView.text length]>0) {
//        [done setBackgroundImage:[UIImage imageNamed:@"button_blank.png"] forState:UIControlStateNormal];
//        
//    }
//    else
//    {
//        [done setBackgroundImage:[UIImage imageNamed:@"submitbtn.png"] forState:UIControlStateNormal];
//        
//    }
    if ([text isEqualToString:@"\n"]) {
        // User has pressed 'return' and entered a new line
        // change the content offset + height of line text
        NSLog(@"%f",textView.contentOffset.y);
        
        if (textView.contentOffset.y+23>=23) {
            textView.contentOffset = CGPointMake(0, textView.contentOffset.y+25);
        }
        
        
        
    }
    NSString *trimmedString = [text stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceCharacterSet]];
    
    if ([trimmedString length]==0){
        if([textView.text length]>=2){
            [done setBackgroundImage:[UIImage imageNamed:@"button_blank.png"] forState:UIControlStateNormal];

        }
        else{
            [done setBackgroundImage:[UIImage imageNamed:@"submitbtn.png"] forState:UIControlStateNormal];
        }
    }
    else{
        [done setBackgroundImage:[UIImage imageNamed:@"button_blank.png"] forState:UIControlStateNormal];
    }
//    if (textView.contentSize.height>130) {
//        [textView setContentOffset:CGPointMake(0, textView.contentSize.height-130)];
//    }
    
    
    
    
//    if([text isEqualToString:@"\n"]) {
//        textView.text=[NSString stringWithFormat:@"%@\n",textView.text];
//        return NO;
//    }
//    
    return YES;
}

-(BOOL)prefersStatusBarHidden {
    if ([[AppDelegate sharedAppDelegate]getOsVersion]==7) {
        return YES;
    }
    else
    {
        return NO;
    }
}
@end
