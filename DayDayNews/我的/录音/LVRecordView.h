//
//  LVRecordView.h
//  RecordAndPlayVoice
//
//  Created by 刘春牢 on 15/3/15.
//  Copyright (c) 2015年 liuchunlao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LVRcordViewDelegate <NSObject>

- (void)LVRecordTime:(double)time;
- (void)LVRecordDoneRecord:(NSURL *)recordURL;

@end

@interface LVRecordView : UIView

@property (nonatomic , weak) id<LVRcordViewDelegate> delegate;

@end
