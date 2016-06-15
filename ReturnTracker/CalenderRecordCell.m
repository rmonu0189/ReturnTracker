//
//  CalenderRecordCell.m
//  ReturnTracker
//
//  Created by monu on 11/11/13.
//  Copyright (c) 2013 Ranjeeta Rajput. All rights reserved.
//

#import "CalenderRecordCell.h"
#import "DataBaseClass.h"
@implementation CalenderRecordCell
@synthesize lblProductName,lblPurchaseDate,lblRemainDay,lblReturnDate,lblShopName,imgProduct;
@synthesize btnDelete;
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIImageView *backImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 70.0f )];
        [backImageView setImage:[UIImage imageNamed:SectionImage2]];
        [self addSubview:backImageView];
        [backImageView release];
        
        self.imgProduct = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 50, 60)];
        self.imgProduct.layer.masksToBounds=YES;
        self.imgProduct.layer.cornerRadius = 3.0f;
        [self addSubview:self.imgProduct];
        [self.imgProduct release];
        self.imgProduct.contentMode = UIViewContentModeScaleAspectFit;
        
        UILabel *lblTemp = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, 60, 15)];
        lblTemp.text = @"Product:";
        lblTemp.backgroundColor = [UIColor clearColor];
        [lblTemp setFont:[UIFont fontWithName:@"Arial-BoldMT" size:13.0f]];
        [self addSubview:lblTemp];
        [lblTemp release];
        
        self.lblProductName = [[UILabel alloc] initWithFrame:CGRectMake(120, 5, 100, 15)];
        self.lblProductName.text = @"Nokia";
        self.lblProductName.backgroundColor = [UIColor clearColor];
        [self.lblProductName setFont:[UIFont fontWithName:@"Arial-BoldMT" size:13.0f]];
        [self addSubview:self.lblProductName];
        
        lblTemp = [[UILabel alloc] initWithFrame:CGRectMake(60, 20, 200, 15)];
        lblTemp.text = @"Shop:";
        lblTemp.backgroundColor = [UIColor clearColor];
        [lblTemp setFont:[UIFont fontWithName:@"Arial" size:12.0f]];
        [self addSubview:lblTemp];
        [lblTemp release];
        
        self.lblShopName = [[UILabel alloc] initWithFrame:CGRectMake(120, 20, 200, 15)];
        self.lblShopName.text = @"Buy";
        self.lblShopName.backgroundColor = [UIColor clearColor];
        [self.lblShopName setFont:[UIFont fontWithName:@"Arial" size:12.0f]];
        [self addSubview:self.lblShopName];
        
        lblTemp = [[UILabel alloc] initWithFrame:CGRectMake(60, 35, 200, 15)];
        lblTemp.text = @"Purchase Date:";
        lblTemp.backgroundColor = [UIColor clearColor];
        [lblTemp setFont:[UIFont fontWithName:@"Arial" size:12.0f]];
        [self addSubview:lblTemp];
        [lblTemp release];
        
        self.lblPurchaseDate = [[UILabel alloc] initWithFrame:CGRectMake(150, 35, 200, 15)];
        self.lblPurchaseDate.text = @"11-Nov-2013";
        self.lblPurchaseDate.backgroundColor = [UIColor clearColor];
        [self.lblPurchaseDate setFont:[UIFont fontWithName:@"Arial" size:12.0f]];
        [self addSubview:self.lblPurchaseDate];
        
        lblTemp = [[UILabel alloc] initWithFrame:CGRectMake(60, 50, 200, 15)];
        lblTemp.text = @"Return Date:";
        lblTemp.backgroundColor = [UIColor clearColor];
        [lblTemp setFont:[UIFont fontWithName:@"Arial" size:12.0f]];
        [self addSubview:lblTemp];
        [lblTemp release];
        
        self.lblReturnDate = [[UILabel alloc] initWithFrame:CGRectMake(150, 50, 200, 15)];
        self.lblReturnDate.text = @"15-Nov-2013";
        self.lblReturnDate.backgroundColor = [UIColor clearColor];
        [self.lblReturnDate setFont:[UIFont fontWithName:@"Arial" size:12.0f]];
        [self addSubview:self.lblReturnDate];
        
        self.lblRemainDay = [[UILabel alloc] initWithFrame:CGRectMake(240, 35,70, 30)];
        self.lblRemainDay.text = @"5 days left.";
        self.lblRemainDay.textColor = [UIColor redColor];
        self.lblRemainDay.backgroundColor = [UIColor clearColor];
        self.lblRemainDay.numberOfLines=2;
        [self.lblRemainDay setFont:[UIFont fontWithName:@"Arial" size:10.0f]];
        [self addSubview:self.lblRemainDay];
        
        self.btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnDelete.frame = CGRectMake(280, 5, 30, 30);
        [self.btnDelete setBackgroundImage:[UIImage imageNamed:@"Delete.png"] forState:UIControlStateNormal];
        [self.btnDelete addTarget:self action:@selector(clickedDelete:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btnDelete];

    }
    return self;
}

- (IBAction)clickedDelete:(id)sender{
    if ([delegate respondsToSelector:@selector(clickDelete:)]) {
        [delegate clickDelete:self.btnDelete.tag];
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
