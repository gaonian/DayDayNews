//
//  MyPlayer.h
//  TBPlayer
//
//  Created by SL on 18/05/2017.
//  Copyright © 2017 SF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface MyPlayer : UIView
+ (instancetype)sharedInstance;
- (void)playWithUrl:(NSURL *)url showView:(UIView *)showView;
@end
