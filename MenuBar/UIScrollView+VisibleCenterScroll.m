//
//  UIScrollView+XHVisibleCenterScroll.m
//  Menu
//
//  Created by lvdl on 16/9/29.
//  Copyright © 2016年 www.palcw.com. All rights reserved.
//

#import "UIScrollView+VisibleCenterScroll.h"

@implementation UIScrollView (VisibleCenterScroll)

- (void)scrollRectToVisibleCenteredOn:(CGRect)visibleRect
                             animated:(BOOL)animated {
    CGRect centeredRect = CGRectMake(visibleRect.origin.x + visibleRect.size.width/2.0 - self.frame.size.width/2.0,
                                     visibleRect.origin.y + visibleRect.size.height/2.0 - self.frame.size.height/2.0,
                                     self.frame.size.width,
                                     self.frame.size.height);
    [self scrollRectToVisible:centeredRect
                     animated:animated];
}

@end
