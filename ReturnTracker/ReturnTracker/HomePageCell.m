//
//  HomePageCell.m
//  Return Tracker
//
//  Created by Ranjeeta Rajput on 05/10/13.
//  Copyright (c) 2013 Ranjeeta Rajput. All rights reserved.
//

#import "HomePageCell.h"
#import <QuartzCore/QuartzCore.h>
@implementation HomePageCell
@synthesize delegate,productNameTxt,purchaseDateTxt,receiptNoTxt,returnDateTxt,returnDurationTxt;
//Synthesize all images and view
@synthesize backImage,addNoteImg,firstImageView,secondImageView,thirdImageView,fourthImageView,mainView,imageViw,itemView,returnDateRadioBtn,returnDurationRadioBtn,returnDurationImgView,returnDateImgView,returnDateTxtImag,returnDurationTxtImg;
//Synthesize Btn
@synthesize cameraBtn,gallaryBtn,clearBtn,submitBtn,calendarBtn,addNoteBtn,calendarBtn2,image1Btn,image2Btn,image3Btn,image4Btn;
//Synthesis all label of row
@synthesize imageViewHdr,addNoteLbl,timeLeftLbl,returnDateLbl,returnDurationLbl,timeLeftDescLbl;



@synthesize  dateBtnTag,radioBtnTag,returnDate;
@synthesize viewControllerDelegate;
@synthesize lblTemp,lblTemp2;
@synthesize returnAlert,returnAlertBtn,returnAlertBtnImage,returnAlertTextField,returnAlertTextFieldImageView;
UIImageView * cal2ImageView;
UIImageView *calImage;
NSInteger imageBtnTag;


#pragma mark - UITableViewCell Init Method
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withDelegate:(id)delgate
{
    viewControllerDelegate=delgate;
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      
        imageBtnTag=4;
        mainView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 315, rowSize)];
        UIKeyboardViewController *keyBoardController;
        keyBoardController=[[UIKeyboardViewController alloc] initWithControllerDelegate:(id)mainView withMainDelegate:self];
        keyBoardController.keyBoardDelegate=delgate;

        backImage=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(mainView.frame)+5, CGRectGetMinY(mainView.frame)+2, CGRectGetMaxX(mainView.frame)-5, CGRectGetMaxY(mainView.frame)-10)];
        [backImage setImage:[UIImage imageNamed:@"Box"]];
        [mainView setUserInteractionEnabled:YES];
        [mainView addSubview:backImage];
        
        
        
        //*****************ImageViewRelated Code here***********************
        
        //Heading lable for image view part
        imageViewHdr=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(backImage.frame)+5,CGRectGetMinY(backImage.frame)+14,160, 15)];
        [imageViewHdr setText:@"Product & Receipt image"];
        [imageViewHdr setFont:[UIFont systemFontOfSize:11]];
        [imageViewHdr setTextColor:[UIColor myGreenColor]];
        [imageViewHdr setBackgroundColor:[UIColor clearColor]];
        [mainView addSubview:imageViewHdr];
        
        
        //ImageView which which contenet four images and 2 button
        imageViw=[[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(imageViewHdr.frame),CGRectGetMaxY(imageViewHdr.frame)+2,125, 110)];
        [mainView addSubview:imageViw];
        
        //Back image of imageView
        UIImageView *backImg=[[UIImageView alloc]initWithFrame:CGRectMake( 0, 0, imageViw.frame.size.width, imageViw.frame.size.height)];
        [backImg setImage:[UIImage imageNamed:ImageFrame]];
        [imageViw addSubview: backImg];
        
        //FirstImageView
        firstImageView=[[UIImageView alloc]initWithFrame:CGRectMake(2,3,imageViw.frame.size.width/2-4,imageViw.frame.size.height/2-6)];
        [firstImageView setAccessibilityIdentifier:@"image1"] ;
        [imageViw addSubview:firstImageView];
        
        image1Btn=[[UIButton alloc]initWithFrame:CGRectMake(firstImageView.frame.origin.x, firstImageView.frame.origin.y, firstImageView.frame.size.width, firstImageView.frame.size.height)];
        [image1Btn setTag:1];
        [image1Btn addTarget:self action:@selector(clickOnImageBtn:) forControlEvents:UIControlEventTouchUpInside];
        [imageViw addSubview:image1Btn];
        
        //SecondImageView
        secondImageView=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxY(firstImageView.frame)+12,3, imageViw.frame.size.width/2-4,imageViw.frame.size.height/2-6)];
        [imageViw addSubview:secondImageView];
        
        image2Btn=[[UIButton alloc]initWithFrame:CGRectMake(secondImageView.frame.origin.x, secondImageView.frame.origin.y, secondImageView.frame.size.width, secondImageView.frame.size.height)];
        [image2Btn setTag:2];
        [image2Btn addTarget:self action:@selector(clickOnImageBtn:) forControlEvents:UIControlEventTouchUpInside];
        [imageViw addSubview:image2Btn];
        
        //Third ImageView
        thirdImageView=[[UIImageView alloc]initWithFrame:CGRectMake(2,CGRectGetMaxY(firstImageView.frame)+3,  imageViw.frame.size.width/2-4,imageViw.frame.size.height/2-6)];
        [imageViw addSubview:thirdImageView];
        
        image3Btn=[[UIButton alloc]initWithFrame:CGRectMake(thirdImageView.frame.origin.x, thirdImageView.frame.origin.y, thirdImageView.frame.size.width, thirdImageView.frame.size.height)];
        [image3Btn setTag:3];
        [image3Btn addTarget:self action:@selector(clickOnImageBtn:) forControlEvents:UIControlEventTouchUpInside];
        [imageViw addSubview:image3Btn];
        //FourthImageView
        fourthImageView=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(secondImageView.frame),CGRectGetMaxY(secondImageView.frame)+3, imageViw.frame.size.width/2-4,imageViw.frame.size.height/2-6)];
        [imageViw addSubview:fourthImageView];
        
        image4Btn=[[UIButton alloc]initWithFrame:CGRectMake(fourthImageView.frame.origin.x, fourthImageView.frame.origin.y, fourthImageView.frame.size.width, fourthImageView.frame.size.height)];[image4Btn setTag:4];
        [image4Btn addTarget:self action:@selector(clickOnImageBtn:) forControlEvents:UIControlEventTouchUpInside];
        [imageViw addSubview:image4Btn];
        
        
        
        
        //******************************** Other Componect of Row **********************
        
        
        //ProductName TextField
        int textImgWidth=166;
        UIImageView *imgNameText = [[UIImageView alloc] initWithFrame:CGRectMake(143, 30, textImgWidth, 25)];
        imgNameText.image = [UIImage imageNamed:@"imgTextBox"];
        [mainView addSubview:imgNameText];
        [imgNameText release];
        
        productNameTxt=[[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMinX(imgNameText.frame)+5, 32,160,25)];
        [productNameTxt setBackgroundColor:[UIColor clearColor]];
        //[productNameTxt setBorderStyle:UITextBorderStyleRoundedRect];
        productNameTxt.font=[UIFont systemFontOfSize:11];
        [productNameTxt setPlaceholder:@"    Product Name                    "];
        [productNameTxt setTextColor:[UIColor blackColor]];
                [mainView addSubview:productNameTxt];
        
        
        //Receipt No TextField
        imgNameText = [[UIImageView alloc] initWithFrame:CGRectMake(143, 60, textImgWidth, 25)];
        imgNameText.image = [UIImage imageNamed:@"imgTextBox"];
        [mainView addSubview:imgNameText];
        [imgNameText release];
        
        receiptNoTxt=[[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMinX(imgNameText.frame)+5,62, 160, 25)];
        [receiptNoTxt setBackgroundColor:[UIColor clearColor]];
        receiptNoTxt.font=[UIFont systemFontOfSize:11];
        [receiptNoTxt setPlaceholder:@"    Receipt Number                 "];
        [mainView addSubview:receiptNoTxt];
        
        
        //Purchase Date TextField
        imgNameText = [[UIImageView alloc] initWithFrame:CGRectMake(143, 90, textImgWidth, 25)];
        imgNameText.image = [UIImage imageNamed:@"imgTextBox"];
        [mainView addSubview:imgNameText];
        [imgNameText release];
        
        purchaseDateTxt=[[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMinX(imgNameText.frame)+5, 92, 160, 25)];
        [purchaseDateTxt setEnabled:NO];
        [purchaseDateTxt setBackgroundColor:[UIColor clearColor]];
        purchaseDateTxt.font=[UIFont systemFontOfSize:11];
        [purchaseDateTxt setPlaceholder:@"    Purchase Date  "];
        [mainView addSubview:purchaseDateTxt];
        
        lblTemp = [[UILabel alloc] initWithFrame:CGRectMake(202, 95, 100, 18)];
        lblTemp.backgroundColor = [UIColor whiteColor];
        lblTemp.font=[UIFont systemFontOfSize:11];
        lblTemp.hidden=YES;
        [mainView addSubview:lblTemp];

        //Calendar Button 
        calendarBtn=[[UIButton alloc]initWithFrame:CGRectMake(163,90,140, 25)];
        [calendarBtn addTarget:self action:@selector(calendarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [calendarBtn setTag:1];
        [mainView addSubview:calendarBtn];
        
        calImage=[[UIImageView alloc]initWithFrame:CGRectMake(284,CGRectGetMinY(purchaseDateTxt.frame), 22, 22)];
        [calImage setImage:[UIImage imageNamed:CalendarImage ]];
        [mainView addSubview:calImage];
        
        
        
        
        //ReturnDate Lable Coding
        returnDateLbl=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(imgNameText.frame),124,79, 15)];
        [returnDateLbl setText:@"Return Date:"];
        returnDateLbl.font=[UIFont systemFontOfSize:12];
        [returnDateLbl setBackgroundColor:[UIColor clearColor]];
        [mainView addSubview:returnDateLbl];
        
        
        //ReturnDate Radio Button
        returnDateRadioBtn=[[UIButton alloc]initWithFrame:CGRectMake(184, CGRectGetMinY(returnDateLbl.frame)-5, 70, 25)];
        //[returnDateRadioBtn setBackgroundColor:[UIColor blackColor]];
        //[returnDateRadioBtn setImage:[UIImage imageNamed:RadioBtnActiveImage] forState:UIControlStateNormal];
        [returnDateRadioBtn setTag:1];
        [returnDateRadioBtn addTarget:self action:@selector(radioBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [mainView addSubview:returnDateRadioBtn];
        
        //Return Date ImageView
        returnDateImgView=[[UIImageView alloc]initWithFrame:CGRectMake(216, CGRectGetMinY(returnDateLbl.frame), 15, 15)];
        [returnDateImgView setImage:[UIImage imageNamed:RadioBtnActiveImage]];
        [mainView addSubview:returnDateImgView];
        
       //Retrun date text code###
        returnDateTxtImag=[[UIImageView alloc]initWithFrame:CGRectMake(238, CGRectGetMinY(returnDateLbl.frame),72, 20)];
        [returnDateTxtImag setImage:[UIImage imageNamed:@"text_box"]];
        [mainView addSubview:returnDateTxtImag];
        
        
        returnDateTxt=[[UITextField alloc]initWithFrame:CGRectMake(241, CGRectGetMinY(returnDateLbl.frame),65, 20)];
        //[returnDateTxt setBackgroundColor:[UIColor whiteColor]];
        [returnDateTxt setEnabled:NO];
        [returnDateTxt setFont:[UIFont systemFontOfSize:10]];
        
       // returnDateTxt.layer.cornerRadius=3.0f;
        //returnDateTxt.layer.masksToBounds=YES;
       // returnDateTxt.layer.borderColor=[[UIColor subTitleColor]CGColor];
        returnDateTxt.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;

        //returnDateTxt.layer.borderWidth= 0.5f;
        
        [mainView addSubview:returnDateTxt];
        //Calendar Button
        calendarBtn2=[[UIButton alloc]initWithFrame:CGRectMake(240,CGRectGetMinY(returnDateLbl.frame),65,22)];
        [calendarBtn2 addTarget:self action:@selector(calendarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [calendarBtn2 setTag:2];
        [mainView addSubview:calendarBtn2];
       cal2ImageView=[[UIImageView alloc]initWithFrame:CGRectMake(292, CGRectGetMinY(returnDateLbl.frame)+1, 17, 17)];
        [cal2ImageView setImage:[UIImage imageNamed:CalendarImage]];
        [mainView addSubview:cal2ImageView];
       
        //Return Duration Lable Coding
        returnDurationLbl=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(imgNameText.frame),CGRectGetMaxY(returnDateLbl.frame)+8,78, 15)];
        [returnDurationLbl setText:@"Return Days:"];
        [returnDurationLbl setFont:[UIFont systemFontOfSize:12]];
        [returnDurationLbl setBackgroundColor:[UIColor clearColor]];
        [mainView addSubview:returnDurationLbl];
        
        
        //ReturnDuration Radio Button
        returnDurationRadioBtn=[[UIButton alloc]initWithFrame: CGRectMake(184, CGRectGetMinY(returnDurationLbl.frame), 70, 25)];
        //[returnDurationRadioBtn setBackgroundColor:[UIColor greenColor]];
        //[returnDurationRadioBtn setImage:[UIImage imageNamed:RadioBtnUnactiveImage] forState:UIControlStateNormal];
        [returnDurationRadioBtn setTag:2];
        [returnDurationRadioBtn addTarget:self action:@selector(radioBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [mainView addSubview:returnDurationRadioBtn];
        
        
        //ReturnDuration Btn
        returnDurationImgView=[[UIImageView alloc]initWithFrame:CGRectMake(216, CGRectGetMinY(returnDurationLbl.frame), 15, 15)];
        [returnDurationImgView setImage:[UIImage imageNamed:RadioBtnUnactiveImage]];
        [mainView addSubview:returnDurationImgView];
        //Return Duration Text code
        
        returnDurationTxtImg=[[UIImageView alloc]initWithFrame:CGRectMake(239, CGRectGetMinY(returnDurationLbl.frame)-5,72, 20)];
        [returnDurationTxtImg setImage:[UIImage imageNamed:@"text_box.png"]];
        [returnDurationTxtImg setHidden:YES];
        [mainView addSubview:returnDurationTxtImg];
        
        returnDurationTxt=[[UITextField alloc]initWithFrame:CGRectMake(244, CGRectGetMinY(returnDurationLbl.frame)-5, 62, 20)];
         returnDurationTxt.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [returnDurationTxt setTag:1];
        [returnDurationTxt setHidden:YES];
        [returnDurationTxt setEnabled:NO];
        [returnDurationTxt setFont:[UIFont systemFontOfSize:10]];
        [returnDurationTxt setKeyboardType:UIKeyboardTypeNumberPad];
        [returnDurationTxt setBackgroundColor:[UIColor clearColor]];
        //returnDurationTxt.layer.cornerRadius=3.0f;
        //returnDurationTxt.layer.masksToBounds=YES;
        //returnDurationTxt.layer.borderColor=[[UIColor subTitleColor]CGColor];
       // returnDurationTxt.layer.borderWidth= 0.5f;
        [mainView addSubview:returnDurationTxt];
        
//        returnAlert=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(imgNameText.frame),CGRectGetMaxY(returnDurationLbl.frame)+8,75, 15)];
//        [returnAlert setText:@"Retrun Alert:"];
//        [returnAlert setFont:[UIFont systemFontOfSize:12]];
//        [returnAlert setBackgroundColor:[UIColor clearColor]];
//        [mainView addSubview:returnAlert];
//        
//        
//        returnAlertTextFieldImageView=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(returnAlert.frame), CGRectGetMinY(returnAlert.frame)-3,93, 20)];
//        [returnAlertTextFieldImageView setImage:[UIImage imageNamed:@"text_box"]];
//        [mainView addSubview:returnAlertTextFieldImageView];
//        
//        returnAlertTextField=[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(returnAlert.frame)+3, CGRectGetMinY(returnAlert.frame), -3, <#CGFloat height#>)
        
        
        
        imgNameText = [[UIImageView alloc] initWithFrame:CGRectMake(143,CGRectGetMaxY(returnDurationLbl.frame)+8, textImgWidth, 25)];
        imgNameText.image = [UIImage imageNamed:@"imgTextBox"];
        [mainView addSubview:imgNameText];
        [imgNameText release];
        
        returnAlertTextField=[[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMinX(imgNameText.frame)+5, CGRectGetMinY(imgNameText.frame), 160, 25)];
        [returnAlertTextField setEnabled:NO];
        [returnAlertTextField setBackgroundColor:[UIColor clearColor]];
        returnAlertTextField.font=[UIFont systemFontOfSize:11];
        [returnAlertTextField setPlaceholder:@"    Remind Me  "];
        [mainView addSubview:returnAlertTextField];

        lblTemp2 = [[UILabel alloc] initWithFrame:CGRectMake(202, CGRectGetMinY(returnAlertTextField.frame)+2, 100, 18)];
        lblTemp2.backgroundColor = [UIColor whiteColor];
        lblTemp2.hidden = YES;
        [mainView addSubview:lblTemp2];
        
        
        returnAlertBtn=[[UIButton alloc]initWithFrame:CGRectMake(163,CGRectGetMinY(returnAlertTextField.frame),140, 25)];
        [returnAlertBtn addTarget:self action:@selector(calendarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [returnAlertBtn setTag:3];
        [mainView addSubview:returnAlertBtn];
        
        returnAlertBtnImage=[[UIImageView alloc]initWithFrame:CGRectMake(284,CGRectGetMinY(returnAlertTextField.frame), 22, 22)];
        [returnAlertBtnImage setImage:[UIImage imageNamed:CalendarImage ]];
        [mainView addSubview:returnAlertBtnImage];
        
       
        

//
     
        //Clear Button Coding
        clearBtn=[[UIButton alloc]initWithFrame:CGRectMake(183,CGRectGetMaxY(returnDurationLbl.frame)+45, 60,30)];
        [clearBtn setTitle:@"Clear" forState:UIControlStateNormal];
        [clearBtn setFont:[UIFont systemFontOfSize:13.0]];
        [clearBtn setBackgroundImage:[UIImage imageNamed:SubmitBtnImage] forState:UIControlStateNormal];
        [clearBtn addTarget:self action:@selector(clearBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [mainView addSubview:clearBtn];
        
        
        //Submit Button Coding
        submitBtn=[[UIButton alloc]initWithFrame:CGRectMake(250,CGRectGetMaxY(returnDurationLbl.frame)+45, 60,30)];
        [submitBtn setTitle:@"Submit" forState:UIControlStateNormal];
        [submitBtn setFont:[UIFont systemFontOfSize:13.0]];
        [submitBtn setBackgroundImage:[UIImage imageNamed:SubmitBtnImage] forState:UIControlStateNormal];
        [submitBtn addTarget:self action:@selector(submitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [mainView addSubview:submitBtn];
        
        
        //Add Notes Label
        addNoteLbl=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(imageViw.frame), CGRectGetMaxY(imageViw.frame)+25,65, 15)];
        [addNoteLbl setFont:[UIFont systemFontOfSize:12]];
        [addNoteLbl setBackgroundColor:[UIColor clearColor]];
        [addNoteLbl setText:@"Add Notes:"];
        [mainView addSubview:addNoteLbl];
        
        
        //Add Notes Button
        UIImageView *addNoteImage=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(addNoteLbl.frame)+3, CGRectGetMinY(addNoteLbl.frame), 20, 20)];
        [addNoteImage setImage:[UIImage imageNamed:AddNotesImage]];
        [mainView addSubview:addNoteImage];
        
        
        addNoteBtn=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(addNoteLbl.frame)+1, CGRectGetMinY(addNoteLbl.frame),45, 40)];
        [addNoteBtn setUserInteractionEnabled:YES];
        [addNoteBtn addTarget:self action:@selector(addNoteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [mainView addSubview:addNoteBtn];
        
        
        
        //TimeLeft Label
        timeLeftLbl=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(addNoteLbl.frame), CGRectGetMaxY(addNoteLbl.frame)+23,60, 15)];
        [timeLeftLbl setFont:[UIFont systemFontOfSize:12]];
        [timeLeftLbl setText:@"Time Left:"];
        [timeLeftLbl setBackgroundColor:[UIColor clearColor]];
        [mainView addSubview:timeLeftLbl];
        
        //Time Left Description label which is changable
        timeLeftDescLbl=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(timeLeftLbl.frame)+3, CGRectGetMinY(timeLeftLbl.frame)-8,85, 30)];
        timeLeftDescLbl.numberOfLines=2;
        [timeLeftDescLbl setFont:[UIFont systemFontOfSize:11]];
        [timeLeftDescLbl setTextColor:[UIColor myGreenColor]];
        [timeLeftDescLbl setBackgroundColor:[UIColor clearColor]];
        [timeLeftDescLbl setText:@""];
        [mainView addSubview:timeLeftDescLbl];
        
        
        [self.contentView addSubview:mainView];
        [keyBoardController addToolbarToKeyboard];
        
        firstImageView.contentMode = IMAGE_ASPECT;
        secondImageView.contentMode = IMAGE_ASPECT;
        thirdImageView.contentMode = IMAGE_ASPECT;
        fourthImageView.contentMode = IMAGE_ASPECT;
        
    }
    
    return self;
}


-(void)clearBtnClick:(id)sender
{
    [delegate clearCellField];
}


-(void)clickOnImageBtn:(id)sender
{
    UIButton *btn=(UIButton*)sender;
    [self keyBoardHide];
    imageBtnTag=btn.tag;
    if(btn.tag==1){
        if(firstImageView.image){
            [delegate showImageViewController:self andTag:1 andCellDelegate:self];
            return;
        }
    }
    else if(btn.tag==2){
        if(secondImageView.image){
            [delegate showImageViewController:self andTag:2 andCellDelegate:self];
            return;
        }
    }
    else if(btn.tag==3){
        if(thirdImageView.image){
            [delegate showImageViewController:self andTag:3 andCellDelegate:self];
            return;
        }
    }
    else if(btn.tag==4){
        if(fourthImageView.image){
            [delegate showImageViewController:self andTag:4 andCellDelegate:self];
            return;
        }
    }
    UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:@"Select Source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Image", nil];
    [actionSheet showInView:mainView];
    [actionSheet release];
}

- (void)setImageFinished:(RecordData *)imgRecord{
    firstImageView.image = imgRecord.img1;
    secondImageView.image = imgRecord.img2;
    thirdImageView.image = imgRecord.img3;
    fourthImageView.image = imgRecord.img4;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Image"]) {
        [self gallaryBtnClick:actionSheet];
    }
    else if([[actionSheet buttonTitleAtIndex:buttonIndex]isEqualToString:@"Camera"])
    {
        [self clickOnCameraBtn:actionSheet];
    }

}
-(void)clickOnCameraBtn:(id)sender
{
    [self keyBoardHide];
    if ([sender isKindOfClass:[UIButton class]]) {
        UIButton *btn=(UIButton*)sender;
        [delegate setCameraImage:self withSenderTag:btn.tag];
    }
    else
    {
        [delegate setCameraImage:self withSenderTag:imageBtnTag];
    }
}
-(void)addNoteBtnClick:(id)sender
{
    [self keyBoardHide];
    [delegate addNotesClick:self];
}
-(void)calendarBtnClick:(id)sender
{
    [self keyBoardHide];
    UIButton *btn=(UIButton*)sender;
    dateBtnTag=btn.tag;
    [delegate calendarOpen:self];
}

-(void)gallaryBtnClick:(id)sender
{
    if ([sender isKindOfClass:[UIButton class]]) {
        UIButton *btn=(UIButton*)sender;
        [delegate setGallary:self withSenderTag:btn.tag];
    }
    else{
        [delegate setGallary:self withSenderTag:imageBtnTag];
    }
}

-(void)radioBtnClick:(id)sender
{
    [self keyBoardHide];
    UIButton *btn=(UIButton *)sender;
    radioBtnTag=btn.tag;
    if (btn.tag==1) {
        [returnDateImgView setImage:[UIImage imageNamed:@"radioActive"] ];
         [returnDurationImgView setImage:[UIImage imageNamed:@"radioUnActive"]];
        
        [returnDateTxt setHidden:NO];
        [returnDateTxtImag setHidden:NO];
        [calendarBtn2 setHidden:NO];
        [cal2ImageView setHidden:NO];
        [returnDurationTxt setHidden:YES];
        [returnDurationTxtImg setHidden:YES];
        [returnDurationTxt setEnabled:NO];
    }
    else
    {
        [returnDurationImgView setImage:[UIImage imageNamed:@"radioActive"]];
         [returnDateImgView setImage:[UIImage imageNamed:@"radioUnActive"] ];
        [returnDurationTxt setHidden:NO];
        [returnDurationTxtImg setHidden:NO];
        NSDateFormatter *dateFormater=[[NSDateFormatter alloc]init];
        [dateFormater setDateFormat:@"dd-MMM-yy HH:mm:ss"];
        NSDate *purDate=[dateFormater dateFromString:[purchaseDateTxt text]];
        
        NSDate *retDate=[dateFormater dateFromString:returnDateTxt.text];
        NSTimeInterval secs = [retDate timeIntervalSinceDate:purDate];
        [returnDurationTxt setText:[NSString stringWithFormat:@"%i",(int)secs/(60*60*24)]];

        [returnDurationTxt setEnabled:YES];
        [returnDateTxt setHidden:YES];
        [returnDateTxtImag setHidden:YES];
        [calendarBtn2 setHidden:YES];
        [cal2ImageView setHidden:YES];
        
    }
}

- (BOOL)validate{
    BOOL isValidate = YES;
    if([productNameTxt.text length]<=0){
        showAlert(@"Please enter product name.", nil);
        return NO;
    }
    else if([receiptNoTxt.text length]<=0){
        showAlert(@"Please enter receipt number.", nil);
        return NO;
    }
    else if([purchaseDateTxt.text length]<=0){
        showAlert(@"Please select purchase date.", nil);
        return NO;
    }
    else if([returnDateTxt.text length]<=0 && [returnDurationTxt.text length]<=0){
        showAlert(@"Please select return date or duration.", nil);
        return NO;
    }
    return isValidate;
}

-(void)submitBtnClick:(id)sender
{
    if([self validate]){
        [self.delegate submitBtnClick:self];
    }
    
}
-(NSString*)getData
{
    return [productNameTxt text];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}
-(void)alttextFieldShouldStartEditing:(UITextField*)textField{
    textField.text=@"   ";
 }
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self keyBoardHide];
}



//When We Enter Text On Return Duration Text
-(void)doneBtnMethodOfReturnDuration
{
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"dd-MMM-yy HH:mm:ss"];
    if ([purchaseDateTxt.text length]<=0) {
        purchaseDateTxt.text=[dateformatter stringFromDate:getCurrentDate()];
        lblTemp.hidden=NO;

    }
    NSDate *purchaseDate=[dateformatter dateFromString:purchaseDateTxt.text];
    NSDate *returnDuration=[[NSDate alloc]init];
    returnDuration = [purchaseDate dateByAddingTimeInterval:60*60*24*(returnDurationTxt.text.intValue)];
    returnDate=[dateformatter stringFromDate:returnDuration];
    [returnDateTxt setText:[dateformatter stringFromDate:returnDuration]];
    NSDateComponents *components = getIntervalComponentBetween(getCurrentDate(), returnDuration);
    
    NSString *strDay = @"";
    if(components.day==1){
        strDay = @"day";
    }
    else{
        strDay = @"days";
    }
    if (components.year<=0 && components.month<=0 && components.day<=0) {
        [timeLeftDescLbl setText:@"Return Date Expire"];
    }
    else if (components.year!=0 && components.month!=0 && components.day!=0)
    {
        [timeLeftDescLbl setText:[NSString stringWithFormat:@"%i year %i month %i %@ left",components.year,components.month,components.day,strDay]];
    }
    else if (components.year!=0 && components.month!=0 && components.day==0)
    {
        [timeLeftDescLbl setText:[NSString stringWithFormat:@"%i year %i month",components.year,components.month]];
    }
    else if (components.year!=0 && components.month==0 && components.day!=0)
    {
        [timeLeftDescLbl setText:[NSString stringWithFormat:@"%i year %i %@",components.year,components.day,strDay]];
    }
    else if (components.year!=0 && components.month==0 && components.day==0)
    {
        [timeLeftDescLbl setText:[NSString stringWithFormat:@"%i year Left",components.year]];
    }
    else if (components.year==0 && components.month!=0 && components.day!=0)
    {
        [timeLeftDescLbl setText:[NSString stringWithFormat:@"%i Month %i %@ Left",components.month,components.day,strDay]];
    }
    else if (components.year==0 && components.month!=0 && components.day==0)
    {
        [timeLeftDescLbl setText:[NSString stringWithFormat:@"%i month left",components.month]];
    }
    else if (components.year==0 && components.month==0 && components.day!=0)
    {
        [timeLeftDescLbl setText:[NSString stringWithFormat:@"%i %@ left",components.day,strDay]];
    }
    NSString *strReturnDate = purchaseDateTxt.text;
    NSDate *retDate = [dateformatter dateFromString:strReturnDate];
    NSDate *currentDate = [dateformatter dateFromString:[dateformatter stringFromDate:[NSDate date]]];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter1 setDateFormat:@"dd-MMM-yy"];
    strReturnDate = [dateFormatter1 stringFromDate:retDate];
    retDate = [dateFormatter1 dateFromString:strReturnDate];
    currentDate = [dateFormatter1 dateFromString:[dateFormatter1 stringFromDate:currentDate]];
    int interVal = getIntervalBetween(currentDate, retDate);
    if(components.day==0 &&components.year==0 && components.month==0){
        [timeLeftDescLbl setText:@"Today"];
    }
}

//Method for hide keyboard when we touch outside of textfield
-(void)keyBoardHide
{
 [[self mainView]endEditing:YES];
}

-(void)dealloc{
    [mainView release];
    [imageViw release];
    [itemView release];
    [addNoteBtn release];
    [addNoteImg release];
    [backImage release];
    [firstImageView release];
    [secondImageView release];
    [thirdImageView release];
    [fourthImageView release];
    [calendarBtn release];
    [gallaryBtn release];
    [returnDateRadioBtn release];
    [returnDurationRadioBtn release];
    [cameraBtn release];
    [delegate release];
    [clearBtn release];
    [submitBtn release];
    [imageViewHdr release];
    [returnDateLbl release];
    [returnDurationLbl release];
    [productNameTxt release];
    [receiptNoTxt release];
    [purchaseDateTxt release];
    [addNoteLbl release];
    [timeLeftDescLbl release];
    [timeLeftLbl release];
    [super dealloc];}
@end
