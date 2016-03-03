//
//顶部栏
//


#define SCREENW  ([UIScreen mainScreen].bounds.size.width)


#import "SCNavTabBar.h"
#import "NSString+Extension.h"


@interface SCNavTabBar ()
{
    UIScrollView    *_navgationTabBar;
    UIView          *_line;                 // underscore show which item selected
               // SCNavTabBar pressed item
    NSArray         *_itemsWidth;           // an array of items' width

}
@property (nonatomic , weak) UIButton *btn;

@end

@implementation SCNavTabBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
      
        [self initConfig];
       // self.backgroundColor = [UIColor clearColor];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pianyiClick:) name:@"偏移" object:nil];
    }
    return self;
}


- (void)initConfig
{
    _items = [@[] mutableCopy];
  
    [self viewConfig];

}

- (void)viewConfig
{
    
    #pragma mark  scrollview
    _navgationTabBar = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, SCREENW - 40, 44)];
    _navgationTabBar.backgroundColor = [UIColor clearColor];
    _navgationTabBar.showsHorizontalScrollIndicator = NO;
    [self addSubview:_navgationTabBar];
       
}

- (void)updateData
{
    
    _itemsWidth = [self getButtonsWidthWithTitles:_itemTitles];
    if (_itemsWidth.count)
    {
        CGFloat contentWidth = [self contentWidthAndAddNavTabBarItemsWithButtonsWidth:_itemsWidth];
        _navgationTabBar.contentSize = CGSizeMake(contentWidth, 0);
    }
}




- (CGFloat)contentWidthAndAddNavTabBarItemsWithButtonsWidth:(NSArray *)widths
{
    CGFloat buttonX = 0;
    
    for (NSInteger index = 0; index < [_itemTitles count]; index++)
    {
        
        #pragma mark  设置字体

        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:_itemTitles[index] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        CGSize textMaxSize = CGSizeMake(SCREENW, MAXFLOAT);
        CGSize textRealSize = [_itemTitles[index] sizeWithFont:[UIFont systemFontOfSize:16] maxSize:textMaxSize ];

        textRealSize = CGSizeMake(textRealSize.width + 15*2, 44);
        button.frame = CGRectMake(buttonX, 0,textRealSize.width, 44);
        
        //字体颜色
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        [button addTarget:self action:@selector(itemPressed:type:) forControlEvents:UIControlEventTouchUpInside];
        [_navgationTabBar addSubview:button];
        [_items addObject:button];
        buttonX += button.frame.size.width;
        self.btn = button;
    }
    
    [self showLineWithButtonWidth:[widths[0] floatValue]];
    return buttonX;
}


- (void)pianyiClick:(NSNotification *)noti
{
    NSLog(@"%@",noti.object);
    int index = [noti.object intValue];
    UIButton *btn = _items[index];
//    [self itemPressed:btn type:1];
}

#pragma mark  下划线
- (void)showLineWithButtonWidth:(CGFloat)width
{
    //第一个线的位置
    _line = [[UIView alloc] initWithFrame:CGRectMake(15, 45 - 3.0f, width, 2.0f)];
    _line.backgroundColor = [UIColor redColor];
    [_navgationTabBar addSubview:_line];
    
    UIButton *btn = _items[0];
    [self itemPressed:btn type:0];
//    btn.selected = YES;
//    [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    
}


- (void)itemPressed:(UIButton *)button type:(int)type
{
    button.selected = YES;
    self.btn.selected = NO;
    self.btn = button;
    [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    
//    if (type == 0) {
        NSInteger index = [_items indexOfObject:button];
        [_delegate itemDidSelectedWithIndex:index withCurrentIndex:_currentItemIndex];
//    }
}




//计算数组内字体的宽度
- (NSArray *)getButtonsWidthWithTitles:(NSArray *)titles;
{
    NSMutableArray *widths = [@[] mutableCopy];
    
    for (NSString *title in titles)
    {
        CGSize textMaxSize = CGSizeMake(SCREENW, MAXFLOAT);
        CGSize textRealSize = [title sizeWithFont:[UIFont systemFontOfSize:16] maxSize:textMaxSize ];
       
        NSNumber *width = [NSNumber numberWithFloat:textRealSize.width];
        [widths addObject:width];
    }
  
    return widths;
}






#pragma mark 偏移
- (void)setCurrentItemIndex:(NSInteger)currentItemIndex
{
    _currentItemIndex = currentItemIndex;
    UIButton *button = _items[currentItemIndex];

    
    CGFloat flag = SCREENW - 40;
    
    if (button.frame.origin.x + button.frame.size.width + 50 >= flag)
    {
        CGFloat offsetX = button.frame.origin.x + button.frame.size.width - flag;
        if (_currentItemIndex < [_itemTitles count]-1)
        {
            offsetX = offsetX + button.frame.size.width;
        }
        [_navgationTabBar setContentOffset:CGPointMake(offsetX, 0) animated:YES];
        
    }
    else
    {
        [_navgationTabBar setContentOffset:CGPointMake(0, 0) animated:YES];
    }
       //下划线的偏移量
    [UIView animateWithDuration:0.1f animations:^{
        _line.frame = CGRectMake(button.frame.origin.x + 15, _line.frame.origin.y, [_itemsWidth[currentItemIndex] floatValue], _line.frame.size.height);
    }];
//    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//
//    UIButton *btn1 = _items[currentItemIndex-1];
//    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}





@end
