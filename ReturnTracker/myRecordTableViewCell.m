//
//  myRecordTableViewCell.m
//  ReturnTracker
//
//  Created by Ranjeeta Rajput on 10/10/13.
//  Copyright (c) 2013 Ranjeeta Rajput. All rights reserved.
//

#import "myRecordTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "RecordData.h"

@implementation myRecordTableViewCell

@synthesize productNameTxt,purchaseDateTxt,receiptNoTxt,delegate,returnDateTxt,returnDurationTxt,image1Btn,image2Btn,image3Btn,image4Btn;
//Synthesize all images and view
@synthesize backImage,addNoteImg,firstImageView,secondImageView,thirdImageView,fourthImageView,mainView,imageViw,itemView,returnDateRadioBtn,returnDurationRadioBtn,productReturnedImageView,cal2ImageView,returnDurationImgView,returnDateImgView,returnDateTxtImage,returnDurationTxtImage;
//Synthesize Btn
@synthesize cameraBtn,gallaryBtn,deleteBtn,updateBtn,calendarBtn,addNoteBtn,productReturntBtn,calendarBtn2;
//Synthesis all label of row
@synthesize imageViewHdr,addNoteLbl,timeLeftLbl,returnDateLbl,returnDurationLbl,timeLeftDescLbl,productReturnLbl;
@synthesize keyBoardController;

@synthesize dateBtnTag,radioBtnTag,returnDate;

@synthesize productReturnValue;
@synthesize returnAlert,returnAlertBtn,returnAlertBtnImage,returnAlertTextField,returnAlertTextFieldImageView,lblTemp2;
UIImageView * cal2ImageView;
UIImageView *calImage;
NSInteger imageBtnTag;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        imageBtnTag=4;
        mainView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 315, rowSize)];
        self.keyBoardController=[[UIKeyboardViewController alloc] initWithControllerDelegate:(id)mainView withMainDelegate:self];
        
        
        backImage=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(mainView.frame)+5, CGRectGetMinY(mainView.frame)+2, CGRectGetMaxX(mainView.frame)-3, CGRectGetMaxY(mainView.frame)-8)];
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
        //[imageViw setBackgroundColor:[UIColor redColor]];
        [mainView addSubview:imageViw];

        
        //Back image of imageView
        UIImageView *backImg=[[UIImageView alloc]initWithFrame:CGRectMake( 0, 0, imageViw.frame.size.width, imageViw.frame.size.height)];
        [backImg setImage:[UIImage imageNamed:ImageFrame]];
        [imageViw addSubview: backImg];
        
        //FirstImageView
        firstImageView=[[UIImageView alloc]initWithFrame:CGRectMake(2,3,imageViw.frame.size.width/2-4,imageViw.frame.size.height/2-6)];
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
        
        image4Btn=[[UIButton alloc]initWithFrame:CGRectMake(fourthImageView.frame.origin.x, fourthImageView.frame.origin.y, fourthImageView.frame.size.width, fourthImageView.frame.size.height)];
        [image4Btn setTag:4];
        [image4Btn addTarget:self action:@selector(clickOnImageBtn:) forControlEvents:UIControlEventTouchUpInside];
        [imageViw addSubview:image4Btn];
//        
     
        
        
        
        //******************************** Other Componect of Row **********************
        
        
        //ProductName TextField
        //int widthIncrease=8;
        int textImgWidth=166;
        UIImageView *imgNameText = [[UIImageView alloc] initWithFrame:CGRectMake(143, 25, textImgWidth, 25)];
        imgNameText.image = [UIImage imageNamed:@"imgTextBox"];
        [mainView addSubview:imgNameText];
        [imgNameText release];
        
        productNameTxt=[[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMinX(imgNameText.frame)+5,CGRectGetMinY(imgNameText.frame)+2,160,25)];
        [productNameTxt setBackgroundColor:[UIColor clearColor]];
        productNameTxt.font=[UIFont systemFontOfSize:11];
        [productNameTxt setTag:1];
        [mainView addSubview:productNameTxt];
        
        
        //Receipt No TextField
        imgNameText = [[UIImageView alloc] initWithFrame:CGRectMake(143, 55, textImgWidth, 25)];
        imgNameText.image = [UIImage imageNamed:@"imgTextBox"];
        [mainView addSubview:imgNameText];
        [imgNameText release];
        
        
        receiptNoTxt=[[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMinX(imgNameText.frame)+5,CGRectGetMinY(imgNameText.frame)+2, 160, 25)];
        [receiptNoTxt setBackgroundColor:[UIColor clearColor]];
        receiptNoTxt.font=[UIFont systemFontOfSize:11];
        [receiptNoTxt setTag:2];
        [mainView addSubview:receiptNoTxt];
        
        //Purchase Date TextField
        imgNameText = [[UIImageView alloc] initWithFrame:CGRectMake(143, 85, textImgWidth, 25)];
        imgNameText.image = [UIImage imageNamed:@"imgTextBox"];
        [mainView addSubview:imgNameText];
        [imgNameText release];
        
        purchaseDateTxt=[[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMinX(imgNameText.frame)+5,CGRectGetMinY(imgNameText.frame)+2, 160, 25)];
        [purchaseDateTxt setEnabled:NO];
        [purchaseDateTxt setBackgroundColor:[UIColor clearColor]];
        purchaseDateTxt.font=[UIFont systemFontOfSize:11];

        [mainView addSubview:purchaseDateTxt];
        [purchaseDateTxt setEnabled:NO];
        
        UILabel *lblTemp = [[UILabel alloc] initWithFrame:CGRectMake(202, 90, 100, 18)];
        lblTemp.backgroundColor = [UIColor whiteColor];
        [mainView addSubview:lblTemp];
        
        //Calendar Button
        calendarBtn=[[UIButton alloc]initWithFrame:CGRectMake(163,CGRectGetMinY(imgNameText.frame),140, 25)];
        [calendarBtn addTarget:self action:@selector(calendarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [calendarBtn setTag:1];
        [mainView addSubview:calendarBtn];
        calImage=[[UIImageView alloc]initWithFrame:CGRectMake(284,CGRectGetMinY(purchaseDateTxt.frame), 22, 22)];
        [calImage setImage:[UIImage imageNamed:CalendarImage ]];
        [mainView addSubview:calImage];
        
        //ReturnDate Lable Coding
        returnDateLbl=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(imgNameText.frame),117, 80, 15)];
        [returnDateLbl setText:@"Return Date:"];
        returnDateLbl.font=[UIFont systemFontOfSize:12];
        [returnDateLbl setBackgroundColor:[UIColor clearColor]];
        [mainView addSubview:returnDateLbl];
        
        
        //ReturnDate Radio Button
        returnDateRadioBtn=[[UIButton alloc]initWithFrame:CGRectMake(180, CGRectGetMinY(returnDateLbl.frame)-5,70, 25)];
        //[returnDateRadioBtn setImage:[UIImage imageNamed:RadioBtnActiveImage] forState:UIControlStateNormal];
        [returnDateRadioBtn setTag:1];
        [returnDateRadioBtn addTarget:self action:@selector(radioBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [mainView addSubview:returnDateRadioBtn];
        
        //ReturnDateImageView
        returnDateImgView=[[UIImageView alloc]initWithFrame:CGRectMake(222, CGRectGetMinY(returnDateLbl.frame)+2, 13, 13)];
        [returnDateImgView setImage:[UIImage imageNamed:RadioBtnActiveImage]];
        [mainView addSubview:returnDateImgView];
        
        
        
        
        
        //Retrun date text code###
        returnDateTxtImage=[[UIImageView alloc]initWithFrame:CGRectMake(238, CGRectGetMinY(returnDateLbl.frame),70, 20)];
        [returnDateTxtImage setImage:[UIImage imageNamed:@"text_box.png"]];
        [mainView addSubview:returnDateTxtImage];
        returnDateTxt=[[UITextField alloc]initWithFrame:CGRectMake(244, CGRectGetMinY(returnDateLbl.frame),60, 20)];
//        [returnDateTxt setBackgroundColor:[UIColor whiteColor]];
        [returnDateTxt setEnabled:NO];
        [returnDateTxt setFont:[UIFont systemFontOfSize:9]];
//        returnDateTxt.layer.cornerRadius=3.0f;
//        returnDateTxt.layer.masksToBounds=YES;
//        returnDateTxt.layer.borderColor=[[UIColor subTitleColor]CGColor];
//        returnDateTxt.layer.borderWidth= 0.5f;
        returnDateTxt.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [mainView addSubview:returnDateTxt];
        //Calendar Button
        calendarBtn2=[[UIButton alloc]initWithFrame:CGRectMake(259,CGRectGetMinY(returnDateLbl.frame), 45,22)];
        [calendarBtn2 addTarget:self action:@selector(calendarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [calendarBtn2 setTag:2];
        
        //[calendarBtn2 setHidden:YES];
        [mainView addSubview:calendarBtn2];
        cal2ImageView=[[UIImageView alloc]initWithFrame:CGRectMake(290, CGRectGetMinY(returnDateLbl.frame)+1, 17, 17)];
        [cal2ImageView setImage:[UIImage imageNamed:CalendarImage]];
        [mainView addSubview:cal2ImageView];
        
        //Return Duration Lable Coding
        returnDurationLbl=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(imgNameText.frame),CGRectGetMaxY(returnDateLbl.frame)+8, 80, 15)];
        [returnDurationLbl setText:@"Return Days:"];
        [returnDurationLbl setFont:[UIFont systemFontOfSize:12]];
        [returnDurationLbl setBackgroundColor:[UIColor clearColor]];
        [mainView addSubview:returnDurationLbl];
        
        
        
        //ReturnDuration Radio Button
        //        returnDurationRadioBtn=[[UIButton alloc]initWithFrame: CGRectMake(215, CGRectGetMinY(returnDurationLbl.frame)+1, 15, 15)];
        //        [returnDurationRadioBtn setImage:[UIImage imageNamed:RadioBtnUnactiveImage] forState:UIControlStateNormal];
        //        [returnDurationRadioBtn setTag:2];
        //        [returnDurationRadioBtn addTarget:self action:@selector(radioBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        //        [mainView addSubview:returnDurationRadioBtn];
        
        returnDurationRadioBtn=[[UIButton alloc]initWithFrame: CGRectMake(180, CGRectGetMinY(returnDurationLbl.frame)-3,70, 25)];
        //[returnDurationRadioBtn setImage:[UIImage imageNamed:RadioBtnUnactiveImage] forState:UIControlStateNormal];
        [returnDurationRadioBtn setTag:2];
        [returnDurationRadioBtn addTarget:self action:@selector(radioBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [mainView addSubview:returnDurationRadioBtn];
        
        
        //ReturnDuration ImageView
        returnDurationImgView=[[UIImageView alloc]initWithFrame:CGRectMake(222, CGRectGetMinY(returnDurationLbl.frame)+2, 13, 13)];
        [returnDurationImgView setImage:[UIImage imageNamed:RadioBtnUnactiveImage]];
        [mainView addSubview:returnDurationImgView];
        
        
        //Return Duration Text code
        
        //(238, CGRectGetMinY(returnDateLbl.frame),70, 20)];

        returnDurationTxtImage=[[UIImageView alloc]initWithFrame:CGRectMake(238, CGRectGetMinY(returnDurationLbl.frame)-2, 70, 20)];
        [returnDurationTxtImage setImage:[UIImage imageNamed:@"text_box"]];
        [returnDurationTxtImage setHidden:YES];
        [mainView addSubview:returnDurationTxtImage];
        
        returnDurationTxt=[[UITextField alloc]initWithFrame:CGRectMake(244, CGRectGetMinY(returnDurationLbl.frame)-2, 60, 20)];
        [returnDurationTxt setTag:1];
        [returnDurationTxt setHidden:YES];
        [returnDurationTxt setEnabled:NO];
        [returnDurationTxt setFont:[UIFont systemFontOfSize:10]];
        [returnDurationTxt setKeyboardType:UIKeyboardTypeNumberPad];
        [returnDurationTxt setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        //[returnDurationTxt setBackgroundColor:[UIColor whiteColor]];
        //returnDurationTxt.layer.cornerRadius=3.0f;
        //returnDurationTxt.layer.masksToBounds=YES;
        //returnDurationTxt.layer.borderColor=[[UIColor subTitleColor]CGColor];
        //returnDurationTxt.layer.borderWidth= 0.5f;
        
        [mainView addSubview:returnDurationTxt];
        
        
        //For display done btn in RetrunDuration txt field
        UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
        numberToolbar.barStyle = UIBarStyleBlackTranslucent;
        numberToolbar.items = [NSArray arrayWithObjects:
                               [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                               [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                               [[UIBarButtonItem alloc]initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                               nil];
        [numberToolbar sizeToFit];
        returnDurationTxt.inputAccessoryView = numberToolbar;
        
        
        
        //ran change
        //returnDurationLbl=[[UILabel alloc]initWithFrame:CGRectMake(135,CGRectGetMaxY(returnDateLbl.frame)+6, 80, 15)];
        productReturnLbl=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(returnDurationLbl.frame), CGRectGetMaxY(returnDurationLbl.frame)+8,returnDurationLbl.frame.size.width+6,returnDurationLbl.frame.size.height)];
        [productReturnLbl setText:@"Returned:"];
        [productReturnLbl setFont:[UIFont systemFontOfSize:12]];
        [productReturnLbl setBackgroundColor:[UIColor clearColor]];
        [mainView addSubview:productReturnLbl];
        // returnDurationRadioBtn=[[UIButton alloc]initWithFrame: CGRectMake(216, CGRectGetMinY(returnDurationLbl.frame), 15, 15)];
        
        productReturntBtn=[[UIButton alloc]initWithFrame:CGRectMake(190, CGRectGetMinY(productReturnLbl.frame)-2,65,23)];
        //[productReturntBtn setImage:[UIImage imageNamed:@"GreenCheckBox.png"] forState:UIControlStateNormal];
        [productReturntBtn addTarget:self action:@selector(productReturntBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [mainView addSubview:productReturntBtn];
        
        productReturnedImageView=[[UIImageView alloc]initWithFrame:CGRectMake(223, CGRectGetMinY(productReturnLbl.frame)+2, 12, 12)];
        [productReturnedImageView setImage:[UIImage imageNamed:@"GreenCheckBox.png"]];
        [mainView addSubview:productReturnedImageView];
        
        
        imgNameText = [[UIImageView alloc] initWithFrame:CGRectMake(143,CGRectGetMaxY(productReturnLbl.frame)+8, textImgWidth, 25)];
        imgNameText.image = [UIImage imageNamed:@"imgTextBox"];
        [mainView addSubview:imgNameText];
        [imgNameText release];
        
        returnAlertTextField=[[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMinX(imgNameText.frame)+2, CGRectGetMinY(imgNameText.frame), 160, 25)];
        [returnAlertTextField setEnabled:NO];
        [returnAlertTextField setBackgroundColor:[UIColor clearColor]];
        returnAlertTextField.font=[UIFont systemFontOfSize:11];
        [returnAlertTextField setPlaceholder:@"    Remind Me  "];
        [mainView addSubview:returnAlertTextField];
        
        lblTemp2 = [[UILabel alloc] initWithFrame:CGRectMake(200, CGRectGetMinY(returnAlertTextField.frame)+2, 102, 18)];
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
        
        
        //        productReturnValue=0;
        
        //Submit Button Coding
        updateBtn=[[UIButton alloc]initWithFrame:CGRectMake(250,CGRectGetMaxY(productReturnLbl.frame)+40, 60,25)];
        [updateBtn setBackgroundImage:[UIImage imageNamed:UpdateBtnImage] forState:UIControlStateNormal];
        [updateBtn addTarget:self action:@selector(updateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [mainView addSubview:updateBtn];
        
        
        //Clear Button Coding
        deleteBtn=[[UIButton alloc]initWithFrame:CGRectMake(180,CGRectGetMaxY(productReturnLbl.frame)+40, 60,25)];
        [deleteBtn setBackgroundImage:[UIImage imageNamed:DeleteBtnImage] forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [mainView addSubview:deleteBtn];
        //Add Notes Label
        addNoteLbl=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(backImage.frame)+14, CGRectGetMaxY(imageViw.frame)+24,70, 15)];
        [addNoteLbl setFont:[UIFont systemFontOfSize:12]];
        [addNoteLbl setBackgroundColor:[UIColor clearColor]];
        [addNoteLbl setText:@"View Notes:"];
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
        timeLeftLbl=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(addNoteLbl.frame), CGRectGetMaxY(addNoteLbl.frame)+36,60, 15)];
        [timeLeftLbl setFont:[UIFont systemFontOfSize:12]];
        [timeLeftLbl setText:@"Time Left:"];
        [timeLeftLbl setBackgroundColor:[UIColor clearColor]];
        [mainView addSubview:timeLeftLbl];
        
        //Time Left Description label which is changable
        timeLeftDescLbl=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(timeLeftLbl.frame), CGRectGetMinY(timeLeftLbl.frame)-7,80, 30)];
        [timeLeftDescLbl setFont:[UIFont systemFontOfSize:11]];
        timeLeftDescLbl.numberOfLines=2;
        [timeLeftDescLbl setTextColor:[UIColor myGreenColor]];
        [timeLeftDescLbl setBackgroundColor:[UIColor clearColor]];
        [timeLeftDescLbl setText:@""];
        [mainView addSubview:timeLeftDescLbl];
        
        
        [self.contentView addSubview:mainView];
        [self.keyBoardController addToolbarToKeyboard];
        
        firstImageView.contentMode = IMAGE_ASPECT;
        secondImageView.contentMode = IMAGE_ASPECT;
        thirdImageView.contentMode = IMAGE_ASPECT;
        fourthImageView.contentMode = IMAGE_ASPECT;
                // Initialization code
    }
    return self;
}

//Number keypad method
-(void)cancelNumberPad{
    [returnDurationTxt resignFirstResponder];
    returnDurationTxt.text = @"";
}

-(void)doneWithNumberPad:(id)sender{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // this is imporant - we set our input date format to match our input string
    // if format doesn't match you'll get nil from your string, so be careful
    [dateFormatter setDateFormat:@"dd-MMM-yy HH:mm:ss"];
    NSDate *dateFromString;// = [[NSDate alloc] init];
    dateFromString = [dateFormatter dateFromString:purchaseDateTxt.text];
   
    
    //This shows date when we add days
    NSDate *newDate1 = [dateFromString dateByAddingTimeInterval:60*60*24*[returnDurationTxt.text intValue]];
   
    NSCalendar *gregorian = [[NSCalendar alloc]
                             
                             initWithCalendarIdentifier:NSGregorianCalendar];
    
    
    
    NSUInteger unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit;
    
    
    
    NSDateComponents *components = [[gregorian components:unitFlags
                                    
                                                fromDate:getCurrentDate()
                                    
                                                  toDate:newDate1 options:0]autorelease];
    NSInteger days = [components day];

    NSString *strDate = [dateFormatter stringFromDate:newDate1];
    [dateFormatter release];
    [timeLeftDescLbl setText:[NSString stringWithFormat:@"%i days remains",days+1]];
    
    timeLeftDescLbl.text = [[AppDelegate sharedAppDelegate] getInterBetweenTwoDate:getCurrentDate() ReturnDate:newDate1];
    [returnDurationTxt resignFirstResponder];
}

- (BOOL)validate{
    BOOL isValidate = YES;
    if([productNameTxt.text length]<=0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please enter product name." delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return NO;
    }
    else if([purchaseDateTxt.text length]<=0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please select purchase date." delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return NO;
    }
    else if([returnDateTxt.text length]<=0 && [returnDurationTxt.text length]<=0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please select return date or duration." delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return NO;
    }
    return isValidate;
}

-(void)updateBtnClick:(id)sender
{
    if([self validate]){
        
        [delegate updateBtnMethod:self];
    }
}
-(void)calendarBtnClick:(id)sender
{
    UIButton *btn=(UIButton*)sender;
    dateBtnTag=btn.tag;
    
    [delegate calendarOpen:self];
    
}

-(void)productReturntBtnClick:(id)sender
{
    if (productReturnValue==1) {
        [productReturnedImageView setImage:[UIImage imageNamed:@"GreenCheckBox"]];
       // [productReturnedImageView setImage:[UIImage imageNamed:@"GreenCheckBox"] forState:UIControlStateNormal];
        [self doneBtnMethodOfReturnDuration];
        productReturnValue=0;
    }
    else
    {
        [productReturnedImageView setImage:[UIImage imageNamed:@"GreenCheckBoxWithSelect"]];
        //[productReturntBtn setImage:[UIImage imageNamed:@"GreenCheckBoxWithSelect"] forState:UIControlStateNormal];
        [timeLeftDescLbl setText:@"Product Retured"];
        productReturnValue=1;
    }
}


-(void)radioBtnClick:(id)sender
{//###
    
    UIButton *btn=(UIButton *)sender;
    radioBtnTag=btn.tag;
    if (btn.tag==1) {
        [returnDateImgView setImage:[UIImage imageNamed:@"radioActive"]];
        [returnDurationImgView setImage:[UIImage imageNamed:@"radioUnActive"]];
        
        [returnDateTxt setHidden:NO];
        [returnDateTxtImage setHidden:NO];
        [calendarBtn2 setHidden:NO];
        [cal2ImageView setHidden:NO];
        [returnDurationTxt setHidden:YES];
        [returnDurationTxtImage setHidden:YES];
        [returnDurationTxt setEnabled:NO];
    }
    else
    {
        [returnDurationImgView setImage:[UIImage imageNamed:@"radioActive"]];
        [returnDateImgView setImage:[UIImage imageNamed:@"radioUnActive"]];
        NSDateFormatter *dateFormater=[[NSDateFormatter alloc]init];
        [dateFormater setDateFormat:@"dd-MMM-yy HH:mm:ss"];
        NSDate *purDate=[dateFormater dateFromString:[purchaseDateTxt text]];
       
        NSDate *retDate=[dateFormater dateFromString:returnDateTxt.text];
         NSTimeInterval secs = [retDate timeIntervalSinceDate:purDate];
        [returnDurationTxt setText:[NSString stringWithFormat:@"%i",(int)secs/(60*60*24)]];
        [returnDurationTxt setHidden:NO];
        [returnDurationTxtImage setHidden:NO];
        [returnDurationTxt setEnabled:YES];
        [returnDateTxt setHidden:YES];
        [returnDateTxtImage setHidden:YES];
        [calendarBtn2 setHidden:YES];
        [cal2ImageView setHidden:YES];
    }

}
-(void)clickOnCameraBtn:(id)sender
{
    
    if ([sender isKindOfClass:[UIButton class]]) {
        UIButton *btn=(UIButton*)sender;
        [delegate setGallary:self withSenderTag:btn.tag];
    }
    else{
        [delegate setCameraImage:self withSenderTag:imageBtnTag];
    }

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
    //
    
}
-(void)clickOnImageBtn:(id)sender
{
    UIButton *btn=(UIButton*)sender;
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

-(void)deleteBtnClick:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Do you want to delete record." delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
    [alert show];
    [alert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if([alertView.message isEqualToString:@"Do you want to delete record."]){
        if(buttonIndex==0){
           
            [delegate deleteBtnMethod:self];
        }
    }
}

-(void)doneBtnMethodOfReturnDuration
{
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"dd-MMM-yy HH:mm:ss"];
    NSDate *purchaseDate=[dateformatter dateFromString:purchaseDateTxt.text];
        NSDate *returnDuration=[[NSDate alloc]init];
    returnDuration = [purchaseDate dateByAddingTimeInterval:60*60*24*returnDurationTxt.text.intValue];
    returnDate=[dateformatter stringFromDate:returnDuration];
    
    returnDateTxt.text = [dateformatter stringFromDate:returnDuration];
    
    NSDateComponents *components = getIntervalComponentBetween(getCurrentDate(), returnDuration);
       if (components.year<=0 && components.month<=0 && components.day<=0) {
        [timeLeftDescLbl setText:@"Return Date Expire"];
    }
    else if (components.year!=0 && components.month!=0 && components.day!=0)
    {
        [timeLeftDescLbl setText:[NSString stringWithFormat:@"%i year %i month %i day left",components.year,components.month,components.day]];
    }
    else if (components.year!=0 && components.month!=0 && components.day==0)
    {
        [timeLeftDescLbl setText:[NSString stringWithFormat:@"%i year %i month",components.year,components.month]];
    }
    else if (components.year!=0 && components.month==0 && components.day!=0)
    {
        [timeLeftDescLbl setText:[NSString stringWithFormat:@"%i year %i day",components.year,components.day]];
    }
    else if (components.year!=0 && components.month==0 && components.day==0)
    {
        [timeLeftDescLbl setText:[NSString stringWithFormat:@"%i year Left",components.year]];
    }
    else if (components.year==0 && components.month!=0 && components.day!=0)
    {
        [timeLeftDescLbl setText:[NSString stringWithFormat:@"%i Month %i days Left",components.month,components.day]];
    }
    else if (components.year==0 && components.month!=0 && components.day==0)
    {
        [timeLeftDescLbl setText:[NSString stringWithFormat:@"%i month left",components.month]];
    }
    else if (components.year==0 && components.month==0 && components.day!=0)
    {
        [timeLeftDescLbl setText:[NSString stringWithFormat:@"%i days left",components.day]];
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




-(void)dealloc
{
    
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
    [updateBtn release];
    [imageViewHdr release];
    [returnDateLbl release];
    [returnDurationLbl release];
    [productNameTxt release];
    [receiptNoTxt release];
    [purchaseDateTxt release];
    [addNoteLbl release];
    [timeLeftDescLbl release];
    [timeLeftLbl release];
    [mainView release];
    [super dealloc];
}
//Text Field Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{

    [textField resignFirstResponder];
    if (textField.tag==1) {
        [receiptNoTxt becomeFirstResponder];
    }
    return YES;
}

-(void)addNoteBtnClick:(id)sender
{
    
    [delegate addNotesClick:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
\
@end
