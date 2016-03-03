//
//  TopCell.m
//  新闻
//
//  Created by gyh on 16/3/2.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "TopCell.h"

@implementation TopCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"Topcell";
    TopCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[TopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.textLabel.text = @"123";
    }
    return self;
}

@end
