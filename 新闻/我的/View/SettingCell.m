//
//  SettingCell.m
//  新闻
//
//  Created by gyh on 16/2/29.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "SettingCell.h"
#import "SettingItem.h"
#import "SettingArrowItem.h"
#import "SettingSwitchItem.h"
#import "SettingLabelItem.h"

@interface SettingCell()
@property(nonatomic,strong)UIImageView *myarrow;
@property(nonatomic,strong)UISwitch *myswitch;
@property(nonatomic,strong)UILabel *mylabel;

@end

@implementation SettingCell

-(UIImageView *)myarrow
{
    if (_myarrow == nil) {
        _myarrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"CellArrow"]];
    }
    return _myarrow;
}

-(UISwitch *)myswitch
{
    if (_myswitch == nil) {
        _myswitch = [[UISwitch alloc]init];
        [_myswitch addTarget:self action:@selector(switchchange) forControlEvents:UIControlEventValueChanged];
    }
    return _myswitch;
    
}
-(UILabel *)mylabel
{
    if (_mylabel == nil) {
        _mylabel = [[UILabel alloc]init];
        _mylabel.bounds = CGRectMake(0, 0, 50, 20);
//        _mylabel.backgroundColor = [UIColor blueColor];
    }
    return _mylabel;
    
}


-(void)switchchange
{
    //存储开关的状态
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:self.myswitch.isOn forKey:self.item.title];
    [defaults synchronize];
    
    if (self.myswitch.isOn) {
        ThemeManager *defaultManager = [ThemeManager sharedInstance];
        [defaultManager changeThemeWithName:@"高贵紫"];
    }else{
        ThemeManager *defaultManager = [ThemeManager sharedInstance];
        [defaultManager changeThemeWithName:@"系统默认"];
    }
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor colorWithRed:237/255.0 green:233/255.0 blue:218/255.0 alpha:1];
        self.selectedBackgroundView = view;
    }
    return self;
}


//返回一个cell
+(instancetype)cellWithTableView:(UITableView *)tableview
{
    static NSString *ID = @"setting";
    SettingCell *cell = [tableview dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[SettingCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    return cell;
}


//返回cell的数据

-(void)setItem:(SettingItem *)item
{
    _item = item;
    
    //设置cell
    [self setupCell];
    
    //设置cell右边内容
    [self setupRight];
    
}

-(void)setupRight
{
    if ([self.item isKindOfClass:[SettingArrowItem class]]) //箭头
    {
        self.accessoryView = self.myarrow;
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        
    }else if([self.item isKindOfClass:[SettingSwitchItem class]])//开关
    {
        self.accessoryView = self.myswitch;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // 设置开关的状态
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        self.myswitch.on = [defaults boolForKey:self.item.title];
        
        
    }else if([self.item isKindOfClass:[SettingLabelItem class]])//标签
    {
        self.accessoryView = self.myarrow;
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        
    }else
    {
        self.accessoryView = nil;
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
}

-(void)setupCell
{
    if (self.item.icon) {
        self.imageView.image = [UIImage imageNamed:self.item.icon];
    }
    
    self.textLabel.text = self.item.title;
    self.detailTextLabel.text = self.item.subtitle;
    self.detailTextLabel.textColor = [UIColor redColor];
}


@end
