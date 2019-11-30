//
//  UIView+GestureRecongnizer.m
//  Guru
//
//  Created by wtj on 16/7/19.
//  Copyright © 2016年 com.techwolf.guru. All rights reserved.
//

#import "UIView+GestureRecongnizer.h"
#import <objc/runtime.h>
static const void *tapActionEventBlockkey = "tapActionEventBlockkey";
@implementation UIView (GestureRecongnizer)

-(void)setTapActionBlock:(TapActionBlock)tapActionBlock{

    objc_setAssociatedObject(self, tapActionEventBlockkey, tapActionBlock, OBJC_ASSOCIATION_COPY);
    
    if (![self gestureRecognizers]) {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [self addGestureRecognizer:tap];
    }
}

-(TapActionBlock)tapActionBlock{

    return objc_getAssociatedObject(self, tapActionEventBlockkey);
}

-(void)addTapBlock:(TapActionBlock)tapAction{

    self.tapActionBlock = tapAction;
    
}

- (void)tap{
    if (self.tapActionBlock) {
        self.tapActionBlock(self);
    }
}
@end
