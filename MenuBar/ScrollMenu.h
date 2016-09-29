//
//  ScrollMenu.h
//  Menu
//
//  Created by lvdl on 16/9/29.
//  Copyright © 2016年 www.palcw.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Menu.h"


#define MenuButtonPaddingX 0   //按钮之间的距离
#define MenuButtonStarX 0          //第一个按钮的起始x坐标

@class ScrollMenu;

@protocol ScrollMenuDelegate <NSObject>

@optional

- (void)scrollMenuDidSelected:(ScrollMenu *)scrollMenu menuIndex:(NSUInteger)selectIndex;
- (void)scrollMenuDidManagerSelected:(ScrollMenu *)scrollMenu;

@end


@interface ScrollMenu : UIView <UIScrollViewDelegate>

@property (nonatomic, assign) id <ScrollMenuDelegate> delegate;

// UI
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *indicatorView;

// DataSource
@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, assign) CGFloat buttonWidth;

@property (nonatomic, strong) UIFont *buttonFont;

// select
@property (nonatomic, assign) NSUInteger selectedIndex;

- (void)setSelectedIndex:(NSUInteger)selectedIndex animated:(BOOL)aniamted calledDelegate:(BOOL)calledDelgate;

//- (void)loadData;

@end
