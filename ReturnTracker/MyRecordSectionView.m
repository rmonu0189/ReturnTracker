//
//  MyRecordSectionView.m
//  ReturnTracker
//
//  Created by Ranjeeta Rajput on 10/10/13.
//  Copyright (c) 2013 Ranjeeta Rajput. All rights reserved.
//

#import "MyRecordSectionView.h"
#import "StoreData.h"
@implementation MyRecordSectionView
@synthesize backImageView;
@synthesize sectionTag;
@synthesize productImageView,dayLeftLabel;
@synthesize addBtn,addBtnImageView;
@synthesize productNameLbl,shopNameLbl,purchaseDateLbl,returnDateLbl;
- (id)initWithFrame:(CGRect)frame delegate:(id)delegate withTag:(NSInteger)tag withRecord:(RecordData*)record
{
    self = [super initWithFrame:frame];
    if (self) {
        sectionTag=tag;
        //Section View
        UIView *sectionView = [[[UIView alloc]initWithFrame:frame]autorelease];
        [sectionView setUserInteractionEnabled:YES];
        //Background Image of Section
        self.backImageView=[[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, myRecordSectionHeight )] autorelease];
        if (tag%2==0) {
            
            [self.backImageView setImage:[UIImage imageNamed:SectionImage2]];
            
        }
        else{
            [self.backImageView setImage:[UIImage imageNamed:SectionImage1]];
        }

    
         [sectionView addSubview:self.backImageView];
        
        self.productImageView=[[UIImageView alloc]init] ;
        [sectionView addSubview:self.productImageView];
        [self.productImageView setFrame:CGRectMake(7, 5, 46, myRecordSectionHeight-10)];
        [sectionView addSubview:self.productImageView];
        self.productImageView.layer.masksToBounds=YES;
        self.productImageView.layer.cornerRadius = 3.0f;
        [self performSelectorInBackground:@selector(setProductImageInBackground:) withObject:[NSString stringWithFormat:@"%d",record.productID]];
        self.productImageView.contentMode = IMAGE_ASPECT;
        
        staticProductLbl=[[[UILabel alloc]initWithFrame:CGRectMake(59,CGRectGetMinY(self.productImageView.frame),53,20)] autorelease];
        [staticProductLbl setText:@"Product:"];
        [staticProductLbl setBackgroundColor:[UIColor clearColor]];
        [staticProductLbl setFont:[UIFont systemFontOfSize:12]];
        [sectionView addSubview:staticProductLbl];
        
        
        productNameLbl=[[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(staticProductLbl.frame),CGRectGetMinY(staticProductLbl.frame),110,staticProductLbl.frame.size.height)] autorelease];
        [productNameLbl setFont:[UIFont systemFontOfSize:13]];
        [productNameLbl setText:[record productNameStr]];
        [productNameLbl setBackgroundColor:[UIColor clearColor]];
        [productNameLbl setTextColor:[UIColor myGreenColor]];
        [sectionView addSubview:productNameLbl];
        
        
        //day Left Label
        dayLeftLabel=[[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(productNameLbl.frame)+5,CGRectGetMinY(productNameLbl.frame)-8, 90,30)] autorelease];
        dayLeftLabel.numberOfLines=2;
        [dayLeftLabel setBackgroundColor:[UIColor clearColor]];
        [dayLeftLabel setFont:[UIFont systemFontOfSize:10]];
        [dayLeftLabel setTextColor:[UIColor redColor]];
        [sectionView addSubview:dayLeftLabel];
        //day Left Label Text
        if ([record returnDate]) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"dd-MMM-yy HH:mm:ss"];
            NSDate *returnDate= [dateFormatter dateFromString:[record returnDate]];

            
            dayLeftLabel.text = [[AppDelegate sharedAppDelegate] getInterBetweenTwoDate:getCurrentDate() ReturnDate:returnDate];
            
        }
        
        if(record.productReturnedStatus==1){
            dayLeftLabel.text = MSG_PRODUCT_RETURN;
        }
        
        
        staticShopNameLbl=[[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(staticProductLbl.frame),CGRectGetMaxY(staticProductLbl.frame)+1,70,10)] autorelease];
        [staticShopNameLbl setText:@"Shop:"];
        //[staticProductLbl setTextColor:subTitleColor];
        [staticShopNameLbl setTextColor:[UIColor subTitleColor]];
        [staticShopNameLbl setBackgroundColor:[UIColor clearColor]];
        [staticShopNameLbl setFont:[UIFont systemFontOfSize:10]];
        [sectionView addSubview:staticShopNameLbl];
        
        shopNameLbl=[[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(staticShopNameLbl.frame)+5,CGRectGetMinY(staticShopNameLbl.frame),150,10)] autorelease];
        [shopNameLbl setFont:[UIFont systemFontOfSize:10]];
        StoreData *element=[[StoreData alloc]init];
        for (StoreData *data in [AppDelegate sharedAppDelegate].cellItemArr) {
            if ([record shopID]==data.shopId) {
                element   =data;//(StoreData*)[[AppDelegate sharedAppDelegate].cellItemArr objectAtIndex:[record shopID]];
            }
        }
        
        [shopNameLbl setBackgroundColor:[UIColor clearColor]];
        [shopNameLbl setTextColor:[UIColor subTitleColor]];
        [shopNameLbl setText:element.shopName];
        [sectionView addSubview:shopNameLbl];
        
        
        staticPurchaseDateLbl=[[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(staticShopNameLbl.frame), CGRectGetMaxY(staticShopNameLbl.frame)+2, staticShopNameLbl.frame.size.width+8,staticShopNameLbl.frame.size.height)] autorelease];
        [staticPurchaseDateLbl setText:@"Purchase Date:"];
        [staticPurchaseDateLbl setBackgroundColor:[UIColor clearColor]];
        [staticPurchaseDateLbl setTextColor:[UIColor subTitleColor]];
        [staticPurchaseDateLbl setFont:[UIFont systemFontOfSize:10]];
        [sectionView addSubview:staticPurchaseDateLbl];
        
        
        
        purchaseDateLbl=[[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(shopNameLbl.frame),CGRectGetMinY(staticPurchaseDateLbl.frame),shopNameLbl.frame.size.width, shopNameLbl.frame.size.height)] autorelease];
        [purchaseDateLbl setFont:[UIFont systemFontOfSize:10]];
        [purchaseDateLbl setBackgroundColor:[UIColor clearColor]];
        [purchaseDateLbl setTextColor:[UIColor subTitleColor]];
        if ([record purchaseDateStr]) {
            [purchaseDateLbl setText:[[record.purchaseDateStr componentsSeparatedByString:@" "] objectAtIndex:0]];
        }
        
        [sectionView addSubview:purchaseDateLbl];
        
        staticreturnDateLbl=[[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(staticPurchaseDateLbl.frame), CGRectGetMaxY(staticPurchaseDateLbl.frame)+2,staticPurchaseDateLbl.frame.size.width,staticPurchaseDateLbl.frame.size.height)] autorelease];
        [staticreturnDateLbl setText:@"Return Date:"];
        [staticreturnDateLbl setBackgroundColor:[UIColor clearColor]];
        [staticreturnDateLbl setTextColor:[UIColor subTitleColor]];
        [staticreturnDateLbl setFont:[UIFont systemFontOfSize:10]];
        [sectionView addSubview:staticreturnDateLbl];
        
        returnDateLbl=[[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(purchaseDateLbl.frame),CGRectGetMinY(staticreturnDateLbl.frame), purchaseDateLbl.frame.size.width,purchaseDateLbl.frame.size.height)] autorelease];
        [returnDateLbl setFont:[UIFont systemFontOfSize:10]];
        [returnDateLbl setTextColor:[UIColor subTitleColor]];
        [returnDateLbl setBackgroundColor:[UIColor clearColor]];
        if ([record returnDate]) {
            [returnDateLbl setText:[[record.returnDate componentsSeparatedByString:@" "] objectAtIndex:0]];
        }
        
        [sectionView addSubview:returnDateLbl];
        
        //Add & Minus Button on Section
        addBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [addBtn setFrame:CGRectMake(0,0,320,myRecordSectionHeight)];
        addBtn.selected=NO;
        addBtn.tag=tag;
        [addBtn setUserInteractionEnabled:YES];
        [addBtn addTarget:delegate action:@selector(clickOnSectionBtn:) forControlEvents:UIControlEventTouchUpInside];
        [sectionView addSubview:addBtn];
        
        if([UIScreen mainScreen].bounds.size.height == 568.0)
        {
            //move to your iphone5 storyboard
            addBtnImageView=[[[UIImageView alloc]initWithFrame:CGRectMake(290,(sectionSize/2)-10, 20, 17)] autorelease];
        }
        else{
            //move to your iphone4s storyboard
            addBtnImageView=[[[UIImageView alloc]initWithFrame:CGRectMake(290,(sectionSize/2)-10, 20, 20)] autorelease];
        }
        [addBtnImageView setImage:[UIImage imageNamed:@"plush-icon"]];
        [sectionView addSubview:addBtnImageView];

        [sectionView addSubview:self.productImageView];
        [self addSubview:sectionView];
        
        [self.backImageView release];
        [self.productImageView release];
        [staticProductLbl release];
        [staticPurchaseDateLbl release];
        [staticreturnDateLbl release];
        [staticShopNameLbl release];
        [addBtn release];
        [productNameLbl release];
        [shopNameLbl release];
        [purchaseDateLbl release];
        [returnDateLbl release];
        [dayLeftLabel release];
        
    }
    return self;
}

- (void)setProductImageInBackground:(id)pid{
    if([self CheckProductImageIsExist:[[NSString stringWithFormat:@"%@",pid] integerValue] andImageName:@"1.png"]){
        [self.productImageView performSelectorOnMainThread:@selector(setImage:) withObject:[[AppDelegate sharedAppDelegate] getProductImageFromName:[NSString stringWithFormat:@"%@",pid] andImageName:@"1.png"] waitUntilDone:NO];
    }
    else{
        self.productImageView.image=[UIImage imageNamed:@"userImage"];
    }
}

- (BOOL)CheckProductImageIsExist:(int)pid andImageName:(NSString*)imgName{
    NSString *imgPath = [NSString stringWithFormat:@"%@/ProductImages/%d/%@",[self getDocumentDirectoryPath],pid,imgName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:imgPath]){
        return NO;
    }
    else{
        return YES;
    }
}

- (NSString*)getDocumentDirectoryPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}



-(void)dealloc
{
    
    [super dealloc];
}


@end
