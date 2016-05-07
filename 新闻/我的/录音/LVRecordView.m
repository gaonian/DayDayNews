//
//  LVRecordView.m
//  RecordAndPlayVoice
//
//  Created by 刘春牢 on 15/3/15.
//  Copyright (c) 2015年 liuchunlao. All rights reserved.
//

#import "LVRecordView.h"
#import "LVRecordTool.h"

//#import "MBProgressHUD+gyh.h"

@interface LVRecordView () <LVRecordToolDelegate>
/** 录音工具 */
@property (nonatomic, strong) LVRecordTool *recordTool;

/** 录音时的图片 */
@property (weak, nonatomic) UIImageView *imageView;

/** 录音按钮 */
@property (weak, nonatomic) UIButton *recordBtn;

/** 录音状态 */
@property (nonatomic , weak) UILabel *recordLabel;

/** 播放按钮 */
@property (weak, nonatomic) UIButton *playBtn;

/** 重录按钮 */
@property (nonatomic , weak) UIButton *againB;

/** 完成按钮 */
@property (nonatomic , weak) UIButton *doneB;

@property (nonatomic , weak) UILabel *second;  //记录秒数


@end

@implementation LVRecordView
{
    NSTimer *_timer;
    int _sec;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        UIImageView *recordimage = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-150)/2, 1, 150, 150)];
        [self addSubview:recordimage];
        recordimage.userInteractionEnabled = YES;
        self.imageView = recordimage;
        self.imageView.image = [UIImage imageNamed:@"开始录音00录音"];
        
        UILabel *second = [[UILabel alloc]initWithFrame:CGRectMake(25, 15, 100, 10)];
        [recordimage addSubview:second];
        second.textAlignment = NSTextAlignmentCenter;
        second.textColor = [UIColor orangeColor];
        self.second = second;
        
        UIButton *record = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-150)/2, CGRectGetMaxY(recordimage.frame)+10, 150, 20)];
        record.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [self addSubview:record];
        self.recordBtn = record;
        
        // 显示录音的秒数
        UILabel *recordLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-150)/2, CGRectGetMaxY(recordimage.frame)+10, 150, 20)];
        recordLabel.font = [UIFont boldSystemFontOfSize:18];
        recordLabel.textColor = [UIColor whiteColor];
        recordLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:recordLabel];
        self.recordLabel = recordLabel;
        // 重录按钮
        UIButton *againB = [[UIButton alloc]initWithFrame:CGRectMake(20,CGRectGetMaxY(recordimage.frame)+10, 50, 20)];
        [againB setTitle:@"重录" forState:UIControlStateNormal];
        [self addSubview:againB];
        self.againB = againB;
        // 完成按钮
        UIButton *doneB = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-70,CGRectGetMaxY(recordimage.frame)+10, 50, 20)];
        [doneB setTitle:@"完成" forState:UIControlStateNormal];
        [self addSubview:doneB];
        self.doneB = doneB;
        //播放按钮
        UIButton *btn = [[UIButton alloc]initWithFrame:recordimage.frame];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"录音完成"] forState:UIControlStateNormal];
        btn.adjustsImageWhenHighlighted = NO;
        [self addSubview:btn];
        self.playBtn = btn;
        
        // 设置重录，完成，秒数按钮的隐藏
        self.recordLabel.hidden = YES;
        self.againB.hidden = YES;
        self.doneB.hidden = YES;
        self.playBtn.hidden = YES;
        
        
        self.recordTool = [LVRecordTool sharedRecordTool];
        [self setup];
    }
    return self;
}

- (void)setup {
    
    [self.recordBtn setTitle:@"点击开始录音" forState:UIControlStateNormal];
    [self.recordBtn setTitle:@"松开结束录音" forState:UIControlStateHighlighted];
    [self.recordBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.recordBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    self.recordTool.delegate = self;
    // 录音按钮
    [self.recordBtn addTarget:self action:@selector(recordBtnDidTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.recordBtn addTarget:self action:@selector(recordBtnDidTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self.recordBtn addTarget:self action:@selector(recordBtnDidTouchDragExit:) forControlEvents:UIControlEventTouchDragExit];
    
    // 播放按钮
    [self.playBtn addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
    //重录
    [self.againB addTarget:self action:@selector(againRecord) forControlEvents:UIControlEventTouchUpInside];
    //完成
    [self.doneB addTarget:self action:@selector(doneRecord) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 录音按钮事件
// 按下
- (void)recordBtnDidTouchDown:(UIButton *)recordBtn {
    [self.recordTool startRecording];
    
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateSecond) userInfo:nil repeats:YES];
}

- (void)updateSecond
{
    self.second.text = [NSString stringWithFormat:@"%.0lf''",self.recordTool.recorder.currentTime];
}

// 点击
- (void)recordBtnDidTouchUpInside:(UIButton *)recordBtn {
    double currentTime = self.recordTool.recorder.currentTime;
    if (self.delegate &&[self.delegate respondsToSelector:@selector(LVRecordTime:)]) {
        [self.delegate LVRecordTime:currentTime];
    }

    if (currentTime < 2) {
        self.imageView.image = [UIImage imageNamed:@"开始录音00录音"];
        [MBProgressHUD showError:@"说话时间太短,请长按录音"];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            [self.recordTool stopRecording];
            [self.recordTool destructionRecordingFile];
        });
        [self removetimer];
    } else {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self.recordTool stopRecording];            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imageView.image = [UIImage imageNamed:@"开始录音00录音"];
            });
        });
        [self removetimer];
        NSLog(@"已成功录音");
        self.recordBtn.hidden = YES;
        self.imageView.hidden = YES;
        self.recordLabel.hidden = NO;
        self.againB.hidden = NO;
        self.doneB.hidden = NO;
        self.playBtn.hidden = NO;
        self.recordLabel.text = [NSString stringWithFormat:@"%.0lf''",currentTime];
    }
}

// 手指从按钮上移除
- (void)recordBtnDidTouchDragExit:(UIButton *)recordBtn {
    self.imageView.image = [UIImage imageNamed:@"开始录音00录音"];
    [self removetimer];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [self.recordTool stopRecording];
        [self.recordTool destructionRecordingFile];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showError:@"已取消录音"];
        });
    });
}

#pragma mark - 重新录制
- (void)againRecord
{
    if ([self.recordTool.player isPlaying]) [self.recordTool stopRecording];
    [self.recordTool destructionRecordingFile];
    
    self.againB.hidden = YES;
    self.doneB.hidden = YES;
    self.recordLabel.hidden = YES;
    self.playBtn.hidden = YES;
    self.recordBtn.hidden = NO;
    self.imageView.hidden = NO;
}
#pragma mark - 完成录制
- (void)doneRecord
{
    NSLog(@"self.recordTool.recordFileUrl = %@",self.recordTool.recordFileUrl);
    if (self.delegate && [self.delegate respondsToSelector:@selector(LVRecordDoneRecord:)]) {
        [self.delegate LVRecordDoneRecord:self.recordTool.recordFileUrl];
    }
}


#pragma mark - 弹窗提示
- (void)alertWithMessage:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}

#pragma mark - 播放录音
- (void)play {
    [self.recordTool playRecordingFile];
}

- (void)removetimer
{
    if (_timer.isValid) {
        [_timer invalidate];
        _timer = nil;
    }
    self.second.text = @"";
}

- (void)dealloc {
    
    if ([self.recordTool.recorder isRecording]) [self.recordTool stopPlaying];
    if ([self.recordTool.player isPlaying]) [self.recordTool stopRecording];
}

#pragma mark - LVRecordToolDelegate
- (void)recordTool:(LVRecordTool *)recordTool didstartRecoring:(int)no {

        NSString *imageName = [NSString stringWithFormat:@"开始录音0%d录音", no];
        self.imageView.image = [UIImage imageNamed:imageName];
}



@end
