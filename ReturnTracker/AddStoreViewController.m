//
//  AddStoreViewController.m
//  ReturnTracker
//
//  Created by monu on 26/11/13.
//  Copyright (c) 2013 Ranjeeta Rajput. All rights reserved.
//

#import "AddStoreViewController.h"
#import "StoreData.h"
@interface AddStoreViewController ()
{
    NSString *documentPath;
    NSString *imageNamed;
    UIPopoverController *popover;
    int favouriteValue;
}
@end

@implementation AddStoreViewController
@synthesize menuView;
@synthesize viewType,shopID;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.txtStoreName becomeFirstResponder];
    NSArray *arrMenu = [[NSArray alloc] initWithObjects:@"Camera",@"Gallery",@"Default", nil];
    self.menuView = [[SettingMenuView alloc] initWithFrame:CGRectMake(self.imgStore.frame.origin.x, self.imgStore.frame.origin.y, 100, 132) andMenuArray:arrMenu];
    self.menuView.delegate = self;
    self.menuView.hidden=YES;
    [self.view addSubview:self.menuView];
    self.imgStore.layer.masksToBounds=YES;
    self.imgStore.layer.cornerRadius = 5.0f;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    self.view.transform = CGAffineTransformMakeScale([UIScreen mainScreen].applicationFrame.size.width / 320.0f, [UIScreen mainScreen].applicationFrame.size.height / 480.0f);
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if([[AppDelegate sharedAppDelegate] getOsVersion] == 7){
        [self.viewAdvertisement setFrame:CGRectMake(0, 450, 320, 50)];
    }
    else{
        [self.viewAdvertisement setFrame:CGRectMake(0, 430, 320, 50)];
    }
    [[AppDelegate sharedAppDelegate] showAdvertisement:self.viewAdvertisement];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    [[AppDelegate sharedAppDelegate] hideAdvertisement];
}

- (void)dealloc {
    [_viewAdvertisement release];
    [_imgStore release];
    [_txtStoreName release];
    [_txtDescription release];
    [self.menuView release];
    [_btnAddStore release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setMenuView:nil];
    [self setViewAdvertisement:nil];
    [self setImgStore:nil];
    [self setTxtStoreName:nil];
    [self setTxtDescription:nil];
    [self setBtnAddStore:nil];
    [super viewDidUnload];
}

-(BOOL)prefersStatusBarHidden {
    if ([[AppDelegate sharedAppDelegate]getOsVersion]==7) {
        return YES;
    }
    else {
        return NO;
    }
}


#pragma mark - IBAction method
- (IBAction)clickedCancel:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)clickedAddStore:(id)sender {
    if([self.txtStoreName.text length]>0){
        NSString *strDesc;
        if([self.txtDescription.text length]<=0){
            strDesc = @"";
        }
        else{
            strDesc = self.txtDescription.text;
        }
        
        if([self.btnAddStore.titleLabel.text isEqualToString:@"Update store"])
        {
            StoreData *data=[[StoreData alloc]init];
            data.shopId=self.shopID;
            data.shopName=self.txtStoreName.text;
            data.description=strDesc ;
            data.imagePath=imageNamed;
            data.favourite=favouriteValue;
            BOOL result=[[DataBaseClass getSharedInstance]updateHomePageData:data ];
            if (result==1) {
                [[AppDelegate sharedAppDelegate] saveStoreImageWithName:imageNamed andImage:self.imgStore.image];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Store has been updated successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                [alert release];

            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"There is some internal error. Please try again after sometime." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                [alert release];

            }
        }
        else
        {
           BOOL result = [[DataBaseClass getSharedInstance] saveStoreDataWithName:self.txtStoreName.text Description:strDesc Image:self.imgStore.image];
            if(result==1){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Store has been added successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
            }
            else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"There is some internal error. Please try again after sometime." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
            }
        }
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please enter store name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if([alertView.message isEqualToString:@"Store has been added successfully."]){
        if(buttonIndex==0){
            [self dismissModalViewControllerAnimated:YES];
        }
    }
    else if([alertView.message isEqualToString:@"Store has been updated successfully."]){
        if(buttonIndex==0){
            [self dismissModalViewControllerAnimated:YES];
        }
    }
}

- (IBAction)clickedAddImage:(id)sender {
    [self resignKeyboard];
    self.menuView.hidden=NO;
}

- (void)selectMenuAtIndex:(int)index{
    self.menuView.hidden=YES;
    UIImagePickerController *picker=[[UIImagePickerController alloc]init];
    picker.delegate=self;
    picker.allowsEditing = YES;
    if(index==0){
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
        self.imgStore.image = [UIImage imageNamed:@"defaultLogo.png"];
    }
    
}
- (void)clickeOutSideFromMenu{
    self.menuView.hidden=YES;
}

#pragma mark - ImagePicker Delegate Method

// This method createImage Picker Controller delegate methods
-(void)imagePickerController:(UIImagePickerController *)picker  didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissModalViewControllerAnimated:YES];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        [popover dismissPopoverAnimated:YES];
    }
    self.imgStore.image = scaleImage([info objectForKey:@"UIImagePickerControllerOriginalImage"], 200);
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if([textField isEqual:self.txtStoreName]){
        [self.txtDescription becomeFirstResponder];
    }
    else if([textField isEqual:self.txtDescription]){
        [self.txtDescription resignFirstResponder];
    }
    return YES;
}

- (void)resignKeyboard{
    [self.txtStoreName resignFirstResponder];
    [self.txtDescription resignFirstResponder];
}

//- (NSString*)getDocumentDirectoryPath{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    return [paths objectAtIndex:0];
//}
//
//- (void)createFolderAtPath:(NSString*)path FolderName:(NSString*)folderName{
//    NSString *dataPath = [NSString stringWithFormat:@"%@/%@",path,folderName];
//    NSError *error=nil;
//    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]){
//        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];
//    }
//}
//
//- (BOOL)folderIsExist:(NSString*)folderPath{
//    return [[NSFileManager defaultManager] fileExistsAtPath:folderPath];
//}
//
//- (NSArray *)getAllFilesAtPath:(NSString*)path{
//    return [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
//}
//
//- (NSString*)getNextImageName{
//    int count = [[self getAllFilesAtPath:[NSString stringWithFormat:@"%@/StoreImages/",[self getDocumentDirectoryPath]]] count];
//    return [NSString stringWithFormat:@"%@/StoreImages/%d.png",[self getDocumentDirectoryPath],count+1];
//}
//
//- (UIImage*)getImageFromName:(NSString*)imgName{
//    NSData *imageData = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/StoreImages/%@.png",[self getDocumentDirectoryPath],imgName]];
//    return [UIImage imageWithData:imageData];
//}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self resignKeyboard];
}

- (void)updateStoreViewType:(int)type shopID:(int)sID ShopName:(NSString*)shopName Description:(NSString*)desc andImage:(UIImage*)img imageName:(NSString *)imageName favourite:(int)favValue{
    self.shopID=sID;
    self.viewType=type;
    self.txtStoreName.text = shopName;
    self.txtDescription.text = desc;
    self.imgStore.image = img;
    imageNamed=imageName;
    favouriteValue=favValue;
    [self.btnAddStore setTitle:@"Update store" forState:UIControlStateNormal];
}

@end
