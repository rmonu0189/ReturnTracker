//
//  sectionView.m
//  MyTableCollapseView
//
//  Created by Ranjeeta Rajput on 07/10/13.
//  Copyright (c) 2013 Ranjeeta Rajput. All rights reserved.
//

#import "sectionView.h"

@implementation sectionView
@synthesize lblTitle,iconImageView,backImageView,addBtn,sectionTag,favouriteImageView;
@synthesize addBtnImageView;
@synthesize sectionDelegate;

- (id)initWithFrame:(CGRect)frame delegate:(id)delegate withTag:(NSInteger)tag
{
    self = [super initWithFrame:frame];
    if (self) {
        sectionTag=tag;
        //Section View
        UIView *sectionView = [[[UIView alloc]initWithFrame:frame]autorelease];
        [sectionView setUserInteractionEnabled:YES];
        //Background Image of Section
        backImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, sectionSize)];
        if (tag%2==0) {
            
            [backImageView setImage:[UIImage imageNamed:SectionImage2]];

        }
        else{
            [backImageView setImage:[UIImage imageNamed:SectionImage1]];
        }
        
        
        sectionDelegate=delegate;
        
        //Icon Image View
        iconImageView=[[[UIImageView alloc]initWithFrame:CGRectMake(10,10, sectionSize-20 , sectionSize-20)] autorelease];
        iconImageView.layer.masksToBounds=YES;
        iconImageView.layer.cornerRadius = 3.0f;
        iconImageView.contentMode = IMAGE_ASPECT;
        //Title Lebel
        lblTitle=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(iconImageView.frame)+20,CGRectGetMinY(backImageView.frame)+13, 190, 40)];
        [lblTitle setBackgroundColor:[UIColor clearColor]];
        lblTitle.font=[UIFont fontWithName:@"Verdana" size:18.0f];
        
        
        addBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [addBtn setFrame:CGRectMake(0,0,320,sectionSize)];

        addBtn.selected=NO;
        addBtn.tag=tag;
        [addBtn setUserInteractionEnabled:YES];
        [addBtn addTarget:delegate action:@selector(clickOnSectionBtn:) forControlEvents:UIControlEventTouchUpInside];
    
        
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressOnSection:)];
        [addBtn addGestureRecognizer:longPress];
        [longPress release];
        
        
        favouriteImageView=[[UIImageView alloc]initWithFrame:CGRectMake(290,(sectionSize/2)-30, 20, 20)];
        [favouriteImageView setImage:[UIImage imageNamed:@"star"]];
        
        
        if([UIScreen mainScreen].bounds.size.height == 568.0)
        {
            //move to your iphone5 storyboard
            addBtnImageView=[[UIImageView alloc]initWithFrame:CGRectMake(290,(sectionSize/2)-8, 20, 17)];
        }
        else{
            //move to your iphone4s storyboard
            addBtnImageView=[[UIImageView alloc]initWithFrame:CGRectMake(290,(sectionSize/2)-8, 20, 20)];
        }
        [addBtnImageView setImage:[UIImage imageNamed:@"plush-icon"]];
        
        
        [sectionView addSubview:backImageView];
        [sectionView addSubview:iconImageView ];
        [sectionView addSubview:lblTitle];
        //[sectionView addSubview:lblSubTitle];
        [sectionView addSubview:addBtnImageView];
        [sectionView addSubview:favouriteImageView];
        [sectionView addSubview:addBtn];
        [self addSubview:sectionView];
        [backImageView release];
        [lblTitle release];
        [favouriteImageView release];
        [addBtnImageView release];
    
        UIButton *btnStar = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnStar setFrame:CGRectMake(280, 0, 40, 40)];
        [btnStar addTarget:self action:@selector(clickedStar:) forControlEvents:UIControlEventTouchUpInside];
        btnStar.tag = tag;
        [sectionView addSubview:btnStar];
        

    }
    return self;
}

- (IBAction)clickedStar:(id)sender{
    if ([sectionDelegate respondsToSelector:@selector(clickedStar:)]) {
        [sectionDelegate clickedStar:sender];
    }
}

-(void)longPressOnSection:(UILongPressGestureRecognizer*)gesture
{
    if ([sectionDelegate respondsToSelector:@selector(longPressClickTag:)]) {
        [sectionDelegate longPressClickTag:addBtn.tag];
    }
}

@end
