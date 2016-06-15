//
//  ShowImageViewController.m
//  ReturnTracker
//
//  Created by monu on 14/11/13.
//  Copyright (c) 2013 Ranjeeta Rajput. All rights reserved.
//

#import "ShowImageViewController.h"

@interface ShowImageViewController ()
{
    UIPopoverController *popover;
}
@end

@implementation ShowImageViewController
@synthesize imgView1,imgView2,imgView3,imgView4;
@synthesize menuView;
@synthesize delegate;
@synthesize cellDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)setImg:(UIImage*)img{
    self.imgView.image = img;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    self.imgView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, self.scrollImage.frame.size.height)];
    self.imgView2 = [[UIImageView alloc] initWithFrame:CGRectMake(320, 0, 320, self.scrollImage.frame.size.height)];
    self.imgView3 = [[UIImageView alloc] initWithFrame:CGRectMake(640, 0, 320, self.scrollImage.frame.size.height)];
    self.imgView4 = [[UIImageView alloc] initWithFrame:CGRectMake(960, 0, 320, self.scrollImage.frame.size.height)];
    
    self.imgView1.contentMode = UIViewContentModeScaleAspectFit;
    self.imgView2.contentMode = UIViewContentModeScaleAspectFit;
    self.imgView3.contentMode = UIViewContentModeScaleAspectFit;
    self.imgView4.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.scrollImage addSubview:self.imgView1];
    [self.scrollImage addSubview:self.imgView2];
    [self.scrollImage addSubview:self.imgView3];
    [self.scrollImage addSubview:self.imgView4];
    self.imgView1.userInteractionEnabled=YES;
    self.imgView2.userInteractionEnabled=YES;
    self.imgView3.userInteractionEnabled=YES;
    self.imgView4.userInteractionEnabled=YES;
    
    NSArray *arrMenu = [[NSArray alloc] initWithObjects:@"Camera",@"Gallery",@"Default",@"Delete", nil];
    self.menuView = [[SettingMenuView alloc] initWithFrame:CGRectMake(100, 150, 120, 88) andMenuArray:arrMenu];
    self.menuView.delegate = self;
    [self.view addSubview:self.menuView];
    [self.menuView setHidden:YES];
    
    self.menuView.transform = CGAffineTransformMakeScale([UIScreen mainScreen].applicationFrame.size.width / 320.0f, [UIScreen mainScreen].applicationFrame.size.height / 480.0f);
    self.menuView.center = self.view.center;
    
    self.scrollImage.transform = CGAffineTransformMakeScale([UIScreen mainScreen].applicationFrame.size.width / 320.0f, [UIScreen mainScreen].applicationFrame.size.height / 480.0f);
    self.scrollImage.center = self.view.center;
}

- (void)viewWillAppear:(BOOL)animated{
    //self.scrollImage.transform = CGAffineTransformMakeScale([UIScreen mainScreen].applicationFrame.size.width / 320.0f, [UIScreen mainScreen].applicationFrame.size.height / 480.0f);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_imgView release];
    [_scrollImage release];
    [self.imgView1 release];
    [self.imgView2 release];
    [self.imgView3 release];
    [self.imgView4 release];
    
    [super dealloc];
}
- (void)viewDidUnload {
    [self setImgView:nil];
    [self setScrollImage:nil];
    self.imgView1=nil;
    self.imgView2=nil;
    self.imgView3=nil;
    self.imgView4=nil;
    [super viewDidUnload];
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

- (void)designViewForImageAndSelectImageTag:(int)tag andHomeCellData:(HomePageCell *)data andCellDelegate:(id)cellDel{
    myRecordTableViewCell *cellData = [[myRecordTableViewCell alloc] init];
    cellData.firstImageView.image = data.firstImageView.image;
    cellData.secondImageView.image = data.secondImageView.image;
    cellData.thirdImageView.image = data.thirdImageView.image;
    cellData.fourthImageView.image = data.fourthImageView.image;
    [self designViewForImageAndSelectImageTag:tag andCellData:cellData andCellDelegate:cellDel];
}

- (void)designViewForImageAndSelectImageTag:(int)tag andCellData:(myRecordTableViewCell*)data andCellDelegate:(id)cellDel{
    self.cellDelegate = cellDel;
    CGFloat xPos=0;
    CGFloat offSetXPos=0;
    CGFloat tmpOffSet=0;
    CGFloat scrollWidth=0;
    
    self.imgView1.image = data.firstImageView.image;
    self.imgView2.image = data.secondImageView.image;
    self.imgView3.image = data.thirdImageView.image;
    self.imgView4.image = data.fourthImageView.image;
    if(data.firstImageView.image){
        xPos=320;
        scrollWidth=320;
        if(tag==1){
            offSetXPos=tmpOffSet;
        }
        tmpOffSet=tmpOffSet+320;
    }
    else{
        self.imgView1.hidden=YES;
    }
    
    if(data.secondImageView.image){
        self.imgView2.frame = CGRectMake(xPos, 0, 320, self.imgView2.frame.size.height);
        xPos=xPos+320;
        scrollWidth=scrollWidth+320;
        if(tag==2){
            offSetXPos=tmpOffSet;
        }
        tmpOffSet=tmpOffSet+320;
        
    }
    else{
        self.imgView2.hidden=YES;
    }
    
    if(data.thirdImageView.image){
        self.imgView3.frame = CGRectMake(xPos, 0, 320, self.imgView3.frame.size.height);
        xPos=xPos+320;
        scrollWidth=scrollWidth+320;
        if(tag==3){
            offSetXPos=tmpOffSet;
        }
        tmpOffSet=tmpOffSet+320;
        
    }
    else{
        self.imgView3.hidden=YES;
    }
    if(data.fourthImageView.image){
        self.imgView4.frame = CGRectMake(xPos, 0, 320, self.imgView4.frame.size.height);
        xPos=xPos+320;
        scrollWidth=scrollWidth+320;
        if(tag==4){
            offSetXPos=tmpOffSet;
        }
        tmpOffSet=tmpOffSet+320;
        
    }
    else{
        self.imgView4.hidden=YES;
    }
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        [self.scrollImage setContentSize:CGSizeMake(scrollWidth, self.scrollImage.frame.size.height/2)];
    }
    else{
        [self.scrollImage setContentSize:CGSizeMake(scrollWidth, self.scrollImage.frame.size.height)];
    }
    
    [self.scrollImage setContentOffset:CGPointMake(offSetXPos, 0)];
    
    UILongPressGestureRecognizer *longPressImgFirst = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressFirstImage:)];
    [self.imgView1 addGestureRecognizer:longPressImgFirst];
    [longPressImgFirst release];
    
    UILongPressGestureRecognizer *longPressImgSecond = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressSecondImage:)];
    [self.imgView2 addGestureRecognizer:longPressImgSecond];
    [longPressImgSecond release];
    
    UILongPressGestureRecognizer *longPressImgThird = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressThirdImage:)];
    [self.imgView3 addGestureRecognizer:longPressImgThird];
    [longPressImgThird release];
    
    UILongPressGestureRecognizer *longPressImgFourth = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressFourthImage:)];
    [self.imgView4 addGestureRecognizer:longPressImgFourth];
    [longPressImgFourth release];
}

- (void)redesignAtTag:(int)tag{
    CGFloat xPos=0;
    CGFloat offSetXPos=0;
    CGFloat tmpOffSet=0;
    CGFloat scrollWidth=0;
    if(self.imgView1.image){
        xPos=320;
        scrollWidth=320;
        if(tag==1){
            offSetXPos=tmpOffSet;
        }
        tmpOffSet=tmpOffSet+320;
    }
    else{
        self.imgView1.hidden=YES;
    }
    
    if(self.imgView2.image){
        self.imgView2.frame = CGRectMake(xPos, 0, 320, self.imgView2.frame.size.height);
        xPos=xPos+320;
        scrollWidth=scrollWidth+320;
        tmpOffSet=tmpOffSet+320;
        if(tag==2){
            offSetXPos=tmpOffSet;
        }
    }
    else{
        self.imgView2.hidden=YES;
    }
    
    if(self.imgView3.image){
        self.imgView3.frame = CGRectMake(xPos, 0, 320, self.imgView3.frame.size.height);
        xPos=xPos+320;
        scrollWidth=scrollWidth+320;
        tmpOffSet=tmpOffSet+320;
        if(tag==3){
            offSetXPos=tmpOffSet;
        }
    }
    else{
        self.imgView3.hidden=YES;
    }
    if(self.imgView4.image){
        self.imgView4.frame = CGRectMake(xPos, 0, 320, self.imgView4.frame.size.height);
        xPos=xPos+320;
        scrollWidth=scrollWidth+320;
        tmpOffSet=tmpOffSet+320;
        if(tag==4){
            offSetXPos=tmpOffSet;
        }
    }
    else{
        self.imgView4.hidden=YES;
    }
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        [self.scrollImage setContentSize:CGSizeMake(scrollWidth, self.scrollImage.frame.size.height/2)];
    }
    else{
        [self.scrollImage setContentSize:CGSizeMake(scrollWidth, self.scrollImage.frame.size.height)];
    }
    [self.scrollImage setContentOffset:CGPointMake(offSetXPos, 0)];
}

#pragma mark - Gesture delegate method
-(void)longPressFirstImage:(UILongPressGestureRecognizer*)gesture{
    imgNumber=1;
    self.menuView.hidden=NO;
}

-(void)longPressSecondImage:(UILongPressGestureRecognizer*)gesture{
    imgNumber=2;
    self.menuView.hidden=NO;
}

-(void)longPressThirdImage:(UILongPressGestureRecognizer*)gesture{
    imgNumber=3;
    self.menuView.hidden=NO;
}

-(void)longPressFourthImage:(UILongPressGestureRecognizer*)gesture{
    imgNumber=4;
    self.menuView.hidden=NO;
}

#pragma mark - Menuview delegate method
- (void)selectMenuAtIndex:(int)index{
    self.menuView.hidden=YES;
    if(index==0){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
        }
        else{
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            popover = [[UIPopoverController alloc] initWithContentViewController:picker];
            popover.delegate=self;
            [popover presentPopoverFromRect:CGRectMake(10, 40, 100, 400.0)
                                     inView:self.view
                   permittedArrowDirections:UIPopoverArrowDirectionAny
                                   animated:YES];
        } else {
            [self presentViewController:picker animated:YES completion:NULL ];
        }
        [picker release];
    }
    else if(index==1){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            popover = [[UIPopoverController alloc] initWithContentViewController:picker];
            popover.delegate=self;
            [popover presentPopoverFromRect:CGRectMake(10, 40, 100, 400.0)
                                     inView:self.view
                   permittedArrowDirections:UIPopoverArrowDirectionAny
                                   animated:YES];
        } else {
            [self presentViewController:picker animated:YES completion:NULL ];
        }
        [picker release];
    }
    else if(index==2){
        [self setImageAtImageIndex:imgNumber andImage:[UIImage imageNamed:@"defaultLogo.png"]];
    }
    else if(index==3){
        [self deleteImage:imgNumber];
        [self redesignAtTag:imgNumber];
    }
}

- (void)deleteImage:(int)index{
    if(index==1){
        self.imgView1.image = nil;
    }
    else if(index==2){
        self.imgView2.image = nil;
    }
    else if(index==3){
        self.imgView3.image = nil;
    }
    else if(index==4){
        self.imgView4.image = nil;
    }
}

- (void)setImageAtImageIndex:(int)index andImage:(UIImage*)img{
    if(index==1){
        self.imgView1.image = img;
    }
    else if(index==2){
        self.imgView2.image = img;
    }
    else if(index==3){
        self.imgView3.image = img;
    }
    else if(index==4){
        self.imgView4.image = img;
    }
}

- (void)clickeOutSideFromMenu{
    self.menuView.hidden=YES;
}

-(void)imagePickerController:(UIImagePickerController *)picker  didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissModalViewControllerAnimated:YES];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        [popover dismissPopoverAnimated:YES];
    }
    [self setImageAtImageIndex:imgNumber andImage:[info objectForKey:@"UIImagePickerControllerOriginalImage"]];
    //[info objectForKey:@"UIImagePickerControllerOriginalImage"];
}

// This method cancel the imagepicker object
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        [popover dismissPopoverAnimated:YES];
    }
}

#pragma mark - Done button method
- (IBAction)clickedDone:(id)sender {
    RecordData *imgRecord = [[RecordData alloc] init];
    imgRecord.img1 = self.imgView1.image;
    imgRecord.img2 = self.imgView2.image;
    imgRecord.img3 = self.imgView3.image;
    imgRecord.img4 = self.imgView4.image;
    if([self.cellDelegate respondsToSelector:@selector(setImageFinished:)]){
        [self.cellDelegate setImageFinished:imgRecord];
    }
    if([self.delegate respondsToSelector:@selector(setImageFinished:)]){
        [self.delegate setImageFinished:imgRecord];
    }
    [self dismissModalViewControllerAnimated:YES];
}

@end
