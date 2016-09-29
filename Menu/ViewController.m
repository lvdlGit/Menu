//
//  ViewController.m
//  Menu
//
//  Created by lvdl on 16/9/29.
//  Copyright © 2016年 www.palcw.com. All rights reserved.
//

#import "ViewController.h"
#import "ScrollMenu.h"


#define SCREEN_WIDTH        [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT       [UIScreen mainScreen].bounds.size.height
#define  RGBA(r, g, b, a)       [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a]

@interface ViewController () <ScrollMenuDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) ScrollMenu *menu ;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, assign) NSInteger selectIndex;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"Menu";
    self.view.backgroundColor = RGBA(255, 100, 100, 1);
    
    _titles = @[@"购买记录", @"转让记录", @"生息记录", @"本金记录"];
    _menu = [[ScrollMenu alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 46)];
    [self.view addSubview:_menu];
    _menu.delegate = self;
    
    _menu.titles = _titles;
    _menu.backgroundColor = [UIColor whiteColor];
    _menu.buttonWidth = 105.0f;
    _menu.buttonFont = [UIFont systemFontOfSize:15];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 45.5, SCREEN_WIDTH, 0.5)];
    [_menu addSubview:line];
    line.backgroundColor = RGBA(220, 221, 221, 1);
    
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 110, SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(_menu.frame))];
    [self.view addSubview:_scrollView];
    _scrollView.backgroundColor = RGBA(246, 246, 248, 1);
    
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * _titles.count, CGRectGetHeight(_scrollView.bounds));
    
    for (NSString *title in _titles) {
        
        NSInteger index = [_titles indexOfObject:title];
        
        CGRect frame = CGRectMake(CGRectGetWidth(_scrollView.bounds) * index + 50 , 50, SCREEN_WIDTH - 100, CGRectGetHeight(_scrollView.bounds) - 100);
        UILabel *label = [[UILabel alloc] initWithFrame:frame];
        [_scrollView addSubview:label];
        label.backgroundColor = [UIColor whiteColor];
        
        label.font = [UIFont systemFontOfSize:19];
        label.textColor = RGBA(0, 200, 200, 1);
        label.textAlignment = NSTextAlignmentCenter;
        
        label.text = title;
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //每页宽度
    CGFloat pageWidth = scrollView.frame.size.width;
    //根据当前的坐标与页宽计算当前页码
    int currentPage = (scrollView.contentOffset.x + pageWidth/2)/pageWidth;
    //调用类XHScrollMenu中setSelectedIndex方法,参数为当前页码currentPage,使菜单栏滑动到对应位置
    
    [self.menu setSelectedIndex:currentPage animated:YES calledDelegate:NO];   // ScrollMenu
    //    [self flowListViewScrollToDidSelected:currentPage];  // SegmentedControl
}

// ScrollMenu
#pragma mask - XHScrollMenuDelegate
//使scrollView滑动到被点击的菜单所对应的内容
- (void)scrollMenuDidSelected:(ScrollMenu *)scrollMenu menuIndex:(NSUInteger)selectIndex
{
    _selectIndex = selectIndex;
    
    //根据接收的参数被选中的菜单索引index,计算要在屏幕上显示的scrollView内容区域
    CGRect visibleRect = CGRectMake(_selectIndex * CGRectGetWidth(_scrollView.bounds), 0, CGRectGetWidth(_scrollView.bounds), CGRectGetHeight(_scrollView.bounds));
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        //Scrolls a specific area of the content so that it is visible in the receiver.  滚动到特定区域visibleRect，使得它的内容在屏幕上显示。
        [_scrollView scrollRectToVisible:visibleRect animated:YES];
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
