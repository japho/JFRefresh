//
//  JFRefreshHeaderView.h
//  TableViewRefreshDemo
//
//  Created by Japho on 2018/9/25.
//  Copyright © 2018年 Japho. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, JFRefreshShowType) {
    // 刷新状态
    JFRefreshShowTypeWillRefresh = 0,
    JFRefreshShowTypeRefreshing = 1,
    JFRefreshShowTypeCancelRefresh = 2,
    JFRefreshShowTypeDidFinished = 3
};

@interface JFRefreshHeaderView : UIView

@property (nonatomic, assign) JFRefreshShowType type;

@property (nonatomic , strong) UILabel *lblTitle;
@property (nonatomic , strong) UIImageView *imgView;
@property (nonatomic , strong) UIActivityIndicatorView *refreshView;

@end

NS_ASSUME_NONNULL_END
