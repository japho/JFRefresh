//
//  JFRefreshFooterView.h
//  TableViewRefreshDemo
//
//  Created by Japho on 2018/9/25.
//  Copyright © 2018年 Japho. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, JFLoadShowType) {
    // 刷新状态
    JFLoadShowTypeWillLoad = 0,
    JFLoadShowTypeLoading = 1,
    JFLoadShowTypeCancelLoad = 2
};

@interface JFRefreshFooterView : UIView

@property (nonatomic, assign) JFLoadShowType type;

@end

NS_ASSUME_NONNULL_END
