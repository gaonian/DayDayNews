//
//  DOPNavbarMenu.m
//  DOPNavbarMenu
//
//  Created by weizhou on 5/14/15.
//  Copyright (c) 2015 weizhou. All rights reserved.
//

#import "DOPNavbarMenu.h"

@implementation UITouchGestureRecognizer

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    self.state = UIGestureRecognizerStateRecognized;
}

@end

@implementation DOPNavbarMenuItem

- (instancetype)initWithTitle:(NSString *)title icon:(UIImage *)icon {
    self = [super init];
    if (self == nil) return nil;
    _title = title;
    _icon = icon;
    return self;
}

+ (DOPNavbarMenuItem *)ItemWithTitle:(NSString *)title icon:(UIImage *)icon {
    return [[self alloc] initWithTitle:title icon:icon];
}

@end

static NSInteger rowHeight = 100;
static CGFloat titleFontSize = 15.0;

@interface DOPNavbarMenu ()

@property (strong, nonatomic) UIView *background;
@property (assign, nonatomic) CGRect beforeAnimationFrame;
@property (assign, nonatomic) CGRect afterAnimationFrame;
@property (assign, nonatomic) NSInteger numberOfRow;

@end

@implementation DOPNavbarMenu

- (instancetype)initWithItems:(NSArray *)items width:(CGFloat)width maximumNumberInRow:(NSInteger)max {
    self = [super initWithFrame:CGRectMake(0, 0, width, 0)];
    if (self == nil) return nil;
    _items = items;
    _open = NO;
    _maximumNumberInRow = max;
    _numberOfRow = (_items.count-1)/_maximumNumberInRow + 1;
    self.dop_height = (_numberOfRow+1) * rowHeight;
    self.dop_y = -self.dop_height;
    _beforeAnimationFrame = self.frame;
    _afterAnimationFrame = self.frame;
    self.backgroundColor = [UIColor whiteColor];
    _background = [[UIView alloc] initWithFrame:CGRectZero];
    _background.backgroundColor = [UIColor clearColor];
    UITouchGestureRecognizer *gr = [[UITouchGestureRecognizer alloc] initWithTarget:self action:@selector(dismissMenu)];
    [_background addGestureRecognizer:gr];
    _textColor = [UIColor whiteColor];
    _separatarColor = [UIColor colorWithWhite:0.0 alpha:0.8];
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat buttonWidth = self.dop_width/self.maximumNumberInRow;
    CGFloat buttonHeight = rowHeight;
    [self.items enumerateObjectsUsingBlock:^(DOPNavbarMenuItem *obj, NSUInteger idx, BOOL *stop) {
        CGFloat buttonX = (idx % self.maximumNumberInRow) * buttonWidth;
        CGFloat buttonY = ((idx / self.maximumNumberInRow)+1) * buttonHeight;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(buttonX, buttonY, buttonWidth, buttonHeight);
        button.tag = idx;
        [self addSubview:button];
        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *icon = [[UIImageView alloc] initWithImage:obj.icon];
        icon.center = CGPointMake(buttonWidth/2, buttonHeight/2-15);
        [button addSubview:icon];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, buttonHeight-30, buttonWidth, 20)];
        label.text = obj.title;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = self.textColor;
        label.font = [UIFont systemFontOfSize:titleFontSize];
        [button addSubview:label];
        
//        if ((idx+1)%self.maximumNumberInRow != 0) {
//            UIView *separatar = [[UIView alloc] initWithFrame:CGRectMake(buttonWidth-0.5, 0, 0.5, buttonHeight)];
//            separatar.backgroundColor = self.separatarColor;
//            [button addSubview:separatar];
//        }
//        if (self.numberOfRow > 1 && idx/self.maximumNumberInRow < (self.numberOfRow-1)) {
//            UIView *separatar = [[UIView alloc] initWithFrame:CGRectMake(0, buttonHeight-0.5, buttonWidth, 0.5)];
//            separatar.backgroundColor = self.separatarColor;
//            [button addSubview:separatar];
//        }
    }];
}

- (void)showInNavigationController:(UINavigationController *)nvc {
    
    [nvc.view insertSubview:self.background belowSubview:nvc.navigationBar];
    [nvc.view insertSubview:self belowSubview:nvc.navigationBar];
    if (CGRectEqualToRect(self.beforeAnimationFrame, self.afterAnimationFrame)) {
        CGRect tmp = self.afterAnimationFrame;
        tmp.origin.y += ([UIApplication sharedApplication].statusBarFrame.size.height+nvc.navigationBar.dop_height+rowHeight*self.numberOfRow);
        self.afterAnimationFrame = tmp;
    }
    self.background.frame = nvc.view.frame;
    [UIView animateWithDuration:1.0
                          delay:0.0
         usingSpringWithDamping:1.0
          initialSpringVelocity:1.0
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.dop_y = self.afterAnimationFrame.origin.y;
                     } completion:^(BOOL finished) {
                         if (self.delegate != nil) {
                             [self.delegate didShowMenu:self];
                         }
                         self.open = YES;
                     }];
}

- (void)dismissWithAnimation:(BOOL)animation {
    void (^completion)(void) = ^void(void) {
        [self removeFromSuperview];
        [self.background removeFromSuperview];
        if (self.delegate != nil) {
            [self.delegate didDismissMenu:self];
        }
        self.open = NO;
    };
    if (animation) {
        [UIView animateWithDuration:0.2 animations:^{
            self.dop_y += 20;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                self.dop_y = self.beforeAnimationFrame.origin.y;
            } completion:^(BOOL finished) {
                completion();
            }];
        }];
    } else {
        self.dop_y = self.beforeAnimationFrame.origin.y;
        completion();
    }
}

- (void)dismissMenu {
    [self dismissWithAnimation:YES];
}

- (void)buttonTapped:(UIButton *)button {
    if (self.delegate) {
        [self.delegate didSelectedMenu:self atIndex:button.tag];
    }
    [self dismissMenu];
}
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com