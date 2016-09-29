//
//  ScrollMenu.m
//  Menu
//
//  Created by lvdl on 16/9/29.
//  Copyright © 2016年 www.palcw.com. All rights reserved.
//

#import "ScrollMenu.h"
#import "UIScrollView+VisibleCenterScroll.h"

#define MenuButtonBaseTag 100
#define IndicatorViewHeight 2

#define  RGBA(r, g, b, a)       [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a]

@interface ScrollMenu ()  

@property (nonatomic, strong) NSMutableArray *menuButtons;

@end


@implementation ScrollMenu

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
//        self.layer.borderColor = kLineColor.CGColor;
//        self.layer.borderWidth = .5;
        
        [self creatView];
        /*
         //添加按钮
         [self addBUttons];
         不能在此处调用添加按钮方法,因为当初始化XHScrollMenu时,进行数据传递的代码还没有执行,数组menus 为空 ,应在menus的set方法中
         */
    }
    return self;
}

- (void)setButtonWidth:(CGFloat)buttonWidth
{
    _buttonWidth = buttonWidth;
    
    if (_titles && [_titles count] > 0) {
        
        [self addBUttons];
    }
}

- (void)setButtonFont:(UIFont *)buttonFont
{
    _buttonFont = buttonFont;
    
    if (_titles && [_titles count] > 0) {
        
        [self addBUttons];
    }
}

- (void)setTitles:(NSArray *)titles
{
    
    _titles = titles;
    
    //填充数据
    [self addBUttons];
}

- (void)creatView
{
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _selectedIndex = 0;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    
    //创建菜单栏标题 下方的标记视图
    
    _indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, IndicatorViewHeight)];
    _indicatorView.backgroundColor = RGBA(255, 100, 100, 1);
    
    //    _indicatorView.alpha = 0.;
    [_scrollView addSubview:_indicatorView];
    
    [self addSubview:_scrollView];
}

//添加按钮
- (void)addBUttons
{
    //移除_scrollView上已有的子视图
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UIButton class]]) {
            [((UIButton *)obj) removeFromSuperview];
        }
    }];
    if (self.menuButtons.count)
        [self.menuButtons removeAllObjects];
    
    _menuButtons = [[NSMutableArray alloc] initWithCapacity:_titles.count];
    
    if (!_buttonWidth) {
        
        _buttonWidth = 100;
    }

    // layout subViews
    CGFloat contentWidth = 0;
    for (NSString *title in _titles) {
        NSUInteger index = [_titles indexOfObject:title];
        
        //创建Button
        //根据标题文本内容、字体大小,计算button的尺寸
//        CGSize buttonSize = [menu.title sizeWithFont:menu.titleFont constrainedToSize:CGSizeMake(MAXFLOAT, CGRectGetHeight(self.bounds) - 10) lineBreakMode:NSLineBreakByCharWrapping];
        
        
        CGSize buttonSize = CGSizeMake(_buttonWidth, CGRectGetHeight(self.bounds));
        
        UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, buttonSize.width, buttonSize.height)];
        [self.scrollView addSubview:menuButton];
        menuButton.tag = index;
        menuButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        menuButton.titleLabel.font = _buttonFont;
        
        [menuButton setTitle:title forState:UIControlStateNormal];
        [menuButton setTitle:title forState:UIControlStateHighlighted];
        [menuButton setTitle:title forState:UIControlStateSelected];
        
        [menuButton setTitleColor:RGBA(30, 30, 30, 1) forState:UIControlStateNormal];
        [menuButton setTitleColor:RGBA(255, 100, 100, 1) forState:UIControlStateSelected];
        
        [menuButton addTarget:self action:@selector(menuButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        CGRect menuButtonFrame = menuButton.frame;
        CGFloat buttonX = 0;
        
        //计算button的起始x坐标,改变menuButton的原点坐标,使button显示在上一个按钮的右边
        if (index) {  //第 1 --- self.menus.count 个按钮
            
            buttonX = MenuButtonPaddingX + CGRectGetMaxX(((UIButton *)(self.menuButtons[index - 1])).frame);
        } else {   //第 0 个按钮
            buttonX = MenuButtonStarX;
        }
        menuButtonFrame.origin = CGPointMake(buttonX, CGRectGetMidY(self.bounds) - (CGRectGetHeight(menuButtonFrame) / 2.0));
        menuButton.frame = menuButtonFrame;
    
        [self.menuButtons addObject:menuButton];
        
        if (index != 0) {
            CGRect frame = CGRectMake(0, 15, 0.5, 16);
            UIView *verticalBar = [[UIView alloc] initWithFrame:frame];
            [menuButton addSubview:verticalBar];
            verticalBar.backgroundColor = RGBA(220, 221, 221, 1);
        }
        
        // 计算scrollView的contentSize
        if (index == _titles.count - 1) {
            contentWidth += CGRectGetMaxX(menuButtonFrame);
        }
        
        if (self.selectedIndex == index) {
            menuButton.selected = YES;
            [self delegateRespondsToSelector:menuButtonFrame animated:NO callDelegate:NO];
        }
    }
    [_scrollView setContentSize:CGSizeMake(contentWidth, CGRectGetHeight(self.scrollView.frame))];
    [self setSelectedIndex:self.selectedIndex animated:NO calledDelegate:YES];
}

#pragma mark - 公开的方法

//被调用时接收到参数菜单下表索引selectedIndex
- (void)setSelectedIndex:(NSUInteger)selectedIndex animated:(BOOL)aniamted calledDelegate:(BOOL)calledDelgate
{
    UIButton *lastMenuButton = self.menuButtons[_selectedIndex];
    lastMenuButton.selected = NO;
    
    _selectedIndex = selectedIndex;
    //根据被选中的button下标,获取到MenuButton对象
    UIButton *selectedMenuButton = self.menuButtons[_selectedIndex];
    selectedMenuButton.selected = YES;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        //scrollRectToVisibleCenteredOn 使滑动到特定区域，并使得它的内容在屏幕中间显示。 (类目UIScrollView+XHVisibleCenterScroll)
        [self.scrollView scrollRectToVisibleCenteredOn:selectedMenuButton.frame animated:NO];
    } completion:^(BOOL finished) {
        
        [self delegateRespondsToSelector:selectedMenuButton.frame animated:aniamted callDelegate:calledDelgate];
    }];
}

#pragma mark - Propertys

- (NSMutableArray *)menuButtons {
    if (!_menuButtons) {
        _menuButtons = [[NSMutableArray alloc] initWithCapacity:_titles.count];
    }
    return _menuButtons;
}

#pragma mark - button点击事件
- (void)menuButtonSelected:(UIButton *)sender {
    
    [self setSelectedIndex:sender.tag animated:YES calledDelegate:YES];
}

#pragma mark - 代理方法的调用

//改变indicatorView的frame,并调用代理协议方法
- (void)delegateRespondsToSelector:(CGRect)menuButtonFrame animated:(BOOL)animated callDelegate:(BOOL)called
{
    [UIView animateWithDuration:(animated ? 0.15 : 0) delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        //改变indicatorView的frame,使红色标记视图显示在被选中的菜单标题下方,并且长度与标题长度相等
        _indicatorView.frame = CGRectMake(CGRectGetMinX(menuButtonFrame) + 4.5, CGRectGetHeight(self.bounds) - IndicatorViewHeight, CGRectGetWidth(menuButtonFrame) - 9, IndicatorViewHeight);
    } completion:^(BOOL finished) {
        if (called) {
            
            if ([self.delegate respondsToSelector:@selector(scrollMenuDidSelected:menuIndex:)]) {
                
                //调用类ViewControllerscroll的方法scrollMenuDidSelected: menuIndex: ,使ViewController中显示内容的scrollView滑动到被点击的菜单所对应的内容
                [self.delegate scrollMenuDidSelected:self menuIndex:self.selectedIndex];
            }
        }
    }];
}

- (void)managerMenusButtonClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(scrollMenuDidManagerSelected:)]) {
        [self.delegate scrollMenuDidManagerSelected:self];
    }
}

- (void)dealloc
{
    _scrollView.delegate = nil;
}

@end
