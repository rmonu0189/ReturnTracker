//
//  SettingMenuView.m
//  ReturnTracker
//
//  Created by mac-001 on 25/11/13.
//  Copyright (c) 2013 Ranjeeta Rajput. All rights reserved.
//

#import "SettingMenuView.h"

@implementation SettingMenuView
@synthesize settingMenuTable;
@synthesize delegate;
@synthesize isSection;
@synthesize headerView;
@synthesize menuType;

- (id)initWithFrame:(CGRect)frame andMenuArray:(NSArray*)arrMenu
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, 320, 480);
        element=arrMenu;//[[NSArray alloc] initWithObjects:@"Add Stores",@"Setting", nil];
        self.settingMenuTable=[[UITableView alloc]initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, [arrMenu count]*44)];
        [self.settingMenuTable setDelegate:self];
        [self.settingMenuTable setDataSource:self];
        self.settingMenuTable.scrollEnabled=NO;
        
        [self addSubview:self.settingMenuTable];
        // Initialization code
    }
//    self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, [arrMenu count]*44);
    return self;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(menuType!=2){
        self.settingMenuTable.layer.masksToBounds=YES;
        self.settingMenuTable.layer.cornerRadius = 3.0f;
        self.settingMenuTable.backgroundColor = [UIColor colorWithRed:23.0/255.0 green:34.0/255.0 blue:46.0/255.0 alpha:1.0];
        self.settingMenuTable.layer.borderWidth = 2.0;
        [self.settingMenuTable.layer setBorderColor:[UIColor colorWithRed:91.0/255 green:91.0/255 blue:91.0/255 alpha:1.0].CGColor];
    }
    else{
        self.settingMenuTable.backgroundColor = [UIColor grayColor];
    }
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(isSection){
        return self.headerView;
    }
    else{
        return nil;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    //[tableView setSeparatorColor:[UIColor colorWithRed:48.0/255 green:60.0/255 blue:91.0/255 alpha:1.0]]
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(isSection){
        return 43;
    }
    else{
        return 0;
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [element count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text=[element objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont fontWithName:@"Arial" size:18];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.frame.size.height-2, cell.frame.size.width, 2)];
    if(menuType!=2){
        separatorView.backgroundColor = [UIColor colorWithRed:48.0/255 green:60.0/255 blue:61.0/255 alpha:1.0];
    }
    else{
        separatorView.backgroundColor = [UIColor blackColor];
    }
    [cell addSubview:separatorView];
    [separatorView release];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.delegate respondsToSelector:@selector(selectMenuAtIndex:)]){
        [self.delegate selectMenuAtIndex:indexPath.row];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if([self.delegate respondsToSelector:@selector(clickeOutSideFromMenu)]){
        [self.delegate clickeOutSideFromMenu];
    }
}

- (void)setIsSection:(BOOL)isSec andTitle:(NSString*)title{
    isSection = isSec;
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.settingMenuTable.frame.size.width, 44)];
    
    UIImageView *imgBack = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.settingMenuTable.frame.size.width, self.headerView.frame.size.height)];
    imgBack.image = [UIImage imageNamed:@"imgHeader.png"];
    [self.headerView addSubview:imgBack];
    
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 200, 20)];
    lblTitle.font = [UIFont fontWithName:@"Arial" size:18];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.text = title;
    lblTitle.textColor = [UIColor whiteColor];
    [self.headerView addSubview:lblTitle];
    
    self.settingMenuTable.frame = CGRectMake(self.settingMenuTable.frame.origin.x,self.settingMenuTable.frame.origin.y, self.settingMenuTable.frame.size.width, 44+[element count]*44);
    [self.settingMenuTable reloadData];
}

- (void)setDesignWithType:(int)type{
    menuType = 2;
    if(type==2){
        [self.settingMenuTable reloadData];
    }
}

@end
