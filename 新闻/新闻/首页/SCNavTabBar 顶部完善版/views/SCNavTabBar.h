//
//顶部栏

#import <UIKit/UIKit.h>

@protocol SCNavTabBarDelegate <NSObject>

@optional

- (void)itemDidSelectedWithIndex:(NSInteger)index;
- (void)itemDidSelectedWithIndex:(NSInteger)index withCurrentIndex:(NSInteger)currentIndex;

@end

@interface SCNavTabBar : UIView

@property (nonatomic, weak)    id<SCNavTabBarDelegate>delegate;

@property (nonatomic, assign)   NSInteger   currentItemIndex;

@property (nonatomic, strong)   NSArray     *itemTitles;
@property (nonatomic, strong)   UIColor     *lineColor;


- (id)initWithFrame:(CGRect)frame;


- (void)updateData;



@end

