//
//  UIScrollView+XHVisibleCenterScroll.h
//  Menu
//
//  Created by lvdl on 16/9/29.
//  Copyright © 2016年 www.palcw.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (VisibleCenterScroll)

- (void)scrollRectToVisibleCenteredOn:(CGRect)visibleRect
                             animated:(BOOL)animated;

@end
