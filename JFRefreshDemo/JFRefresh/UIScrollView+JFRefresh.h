//
//  UIScrollView+JFRefresh.h
//  TableViewRefreshDemo
//
//  Created by Japho on 2018/9/25.
//  Copyright © 2018年 Japho. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JFRefreshHeaderView;
@class JFRefreshFooterView;

typedef NS_ENUM(NSInteger , JFRefreshStatus)
{
    // 刷新状态
    JFRefreshStatusWillRefresh = 0,
    JFRefreshStatusRefreshing = 1,
    JFRefreshStatusCancelRefresh = 2,
    JFRefreshStatusDidFinished = 3,
    JFRefreshStatusWillLoad = 4,
    JFRefreshStatusLoading = 5,
    JFRefreshStatusCancelLoad = 6
};

// 刷新的回调
typedef void(^HeaderRefreshBlock)(void);
//typedef void(^FooterRefreshBlock)(void);

@interface UIScrollView (JFRefresh)

@property (nonatomic, copy) HeaderRefreshBlock headerBlock;
//@property (nonatomic, copy) FooterRefreshBlock footerBlock;
@property (nonatomic, copy) NSString *refreshStatus;

// 下拉刷新
- (void)jf_addHeaderRefreshWithBlock:(HeaderRefreshBlock)block;
- (void)startHeaderFresh;
- (void)endHeaderRefresh;

@end

NS_ASSUME_NONNULL_END
