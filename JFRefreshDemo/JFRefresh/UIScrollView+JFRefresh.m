//
//  UIScrollView+JFRefresh.m
//  TableViewRefreshDemo
//
//  Created by Japho on 2018/9/25.
//  Copyright © 2018年 Japho. All rights reserved.
//

#import "UIScrollView+JFRefresh.h"
#import "JFRefreshHeaderView.h"
#import "JFRefreshFooterView.h"
#import "JFRefreshMacro.h"
#import <objc/runtime.h>

@interface UIScrollView ()

@property (nonatomic, strong) JFRefreshHeaderView *headerView;
@property (nonatomic, strong) JFRefreshFooterView *footerView;
@property (nonatomic, assign) UIEdgeInsets currentContentInset;
@property (nonatomic, assign) CGFloat offsetY;

@end

@implementation UIScrollView (JFRefresh)

// 下拉刷新
- (void)jf_addHeaderRefreshWithBlock:(HeaderRefreshBlock)block
{
    self.headerBlock = block;
    if (self.headerView == nil)
    {
        self.headerView = [[JFRefreshHeaderView alloc]initWithFrame:CGRectMake(0, -REFRESH_VIEW_HEIGHT, SCREEN_WIDTH, REFRESH_VIEW_HEIGHT)];
    }
    
    [self addSubview:self.headerView];
    
    self.
    
    self.currentContentInset = self.contentInset;
    self.offsetY = -([[UIApplication sharedApplication] statusBarFrame].size.height + 44);
    
    // 监听偏移量
    [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"refreshStatus" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)startHeaderFresh
{
    [self getRefreshStatus:JFRefreshStatusRefreshing];

    [UIView animateWithDuration:0.3 animations:^{
        
        [self setContentOffset:CGPointMake(0, -REFRESH_VIEW_HEIGHT + self.offsetY)];

    }];
}

// 停止下拉刷新
- (void)endHeaderRefresh
{    
    [self performSelector:@selector(hideHeader) withObject:nil afterDelay:0.5];
}

- (void)hideHeader
{
    __weak typeof(self)weakSelf = self;
    
    [UIView animateWithDuration:0.3 animations:^{
    
        [weakSelf getRefreshStatus:JFRefreshStatusDidFinished];
        weakSelf.contentInset = weakSelf.currentContentInset;
        
        CGRect frame = self.headerView.frame;
        frame.origin.y = 0;
        frame.size.height = 0;
        self.headerView.frame = frame;
    
    } completion:^(BOOL finished) {
    }];
}

// 设置刷新状态
- (void)getRefreshStatus:(JFRefreshStatus)status
{
    switch (status)
    {
            // 设置下拉刷新状态
        case JFRefreshStatusWillRefresh:// 将要下拉刷新
        {
            self.refreshStatus = @"JFRefreshStatusWillRefresh";
            self.headerView.type = JFRefreshShowTypeWillRefresh;
            break;
        }
        case JFRefreshStatusRefreshing:// 正在下拉刷新
        {
            self.refreshStatus = @"JFRefreshStatusRefreshing";
            self.headerView.type = JFRefreshShowTypeRefreshing;
            break;
            
        }
        case JFRefreshStatusCancelRefresh:// 取消下拉刷新
        {
            self.refreshStatus = @"JFRefreshStatusCancelRefresh";
            self.headerView.type = JFRefreshShowTypeCancelRefresh;
            break;
        }
        case JFRefreshStatusDidFinished:// 取消下拉刷新
        {
            self.refreshStatus = @"JFRefreshStatusDidFinished";
            self.headerView.type = JFRefreshShowTypeDidFinished;
            break;
        }
        default:
            break;
    }
}
#pragma mark 观察者方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"])
    {
        if (self.contentOffset.y < self.offsetY)
        {
            CGRect frame = self.headerView.frame;
            frame.origin.y = self.contentOffset.y - self.offsetY;
            frame.size.height = self.offsetY - self.contentOffset.y;
            self.headerView.frame = frame;
        }
        
        if (self.dragging)
        {
            if (self.contentOffset.y < 0) {// 处理下拉刷新
                
                
                if (![self.refreshStatus isEqualToString:@"JFRefreshStatusRefreshing"])
                {
                    // 判断是否正在刷新
                    if (self.contentOffset.y <= -REFRESH_VIEW_HEIGHT + self.offsetY)
                    {
                        // 准备下拉刷新
                        [self getRefreshStatus:JFRefreshStatusWillRefresh];
                    }
                    else
                    {
                        // 取消下拉刷新
                        [self getRefreshStatus:JFRefreshStatusCancelRefresh];
                    }
                }
            }
            
            if (self.contentOffset.y < self.offsetY && self.offsetY - self.contentOffset.y <= REFRESH_VIEW_HEIGHT)
            {
                CGFloat margin = fabs(self.contentOffset.y - self.offsetY);
                CGFloat progress = margin / REFRESH_VIEW_HEIGHT;
                self.headerView.imgView.transform = CGAffineTransformMakeRotation(M_PI * (progress + 1));
            }
            else if (self.contentOffset.y < self.offsetY - REFRESH_VIEW_HEIGHT)
            {
                self.headerView.imgView.transform = CGAffineTransformMakeRotation(0);
            }
        }
        else if([self.refreshStatus isEqualToString:@"JFRefreshStatusWillRefresh"])
        {
            //下拉刷新
            [self getRefreshStatus:JFRefreshStatusRefreshing];

            [self setContentOffset:CGPointMake(0, -REFRESH_VIEW_HEIGHT + self.offsetY) animated:YES];
            
            self.headerBlock();
        }
    }
    if ([keyPath isEqualToString:@"refreshStatus"])
    {
        if (!self.dragging)
        {
            if ([self.refreshStatus isEqualToString:@"JFRefreshStatusWillRefresh"])
            {
                [self getRefreshStatus:JFRefreshStatusRefreshing];
                
                CGFloat offsetY = self.contentOffset.y;
                UIEdgeInsets inset = self.currentContentInset;
                inset.top = inset.top + REFRESH_VIEW_HEIGHT;
                self.contentInset = inset;
                [self layoutIfNeeded];
                [self setContentOffset:CGPointMake(0, offsetY) animated:NO];
                [self.headerView.refreshView startAnimating];
            }
            else if ([self.refreshStatus isEqualToString:@"JFRefreshStatusRefreshing"])
            {
                CGFloat offsetY = self.contentOffset.y;
                UIEdgeInsets inset = self.currentContentInset;
                inset.top = inset.top + REFRESH_VIEW_HEIGHT;
                self.contentInset = inset;
                [self layoutIfNeeded];
                [self setContentOffset:CGPointMake(0, offsetY) animated:NO];
                [self.headerView.refreshView startAnimating];
                self.headerBlock();
            }
        }
    }
}

- (void)dealloc
{
    @try {
        [self removeObserver:self forKeyPath:@"contentOffset"];
        [self removeObserver:self forKeyPath:@"refreshStatus"];
        [self removeObserver:self forKeyPath:@"contentSize"];
    } @catch (NSException *exception) {}
}

#pragma mark 动态添加属性

// 利用runtime来添加视图属性
- (void)setHeaderView:(JFRefreshHeaderView *)headerView
{
    objc_setAssociatedObject(self, @selector(headerView), headerView, OBJC_ASSOCIATION_RETAIN);
}

- (JFRefreshHeaderView *)headerView
{
    return objc_getAssociatedObject(self, _cmd);
}

// 添加block属性最好使用copy（栈block -> 堆block）
- (void)setHeaderBlock:(HeaderRefreshBlock)headerBlock
{
    objc_setAssociatedObject(self, @selector(headerBlock), headerBlock, OBJC_ASSOCIATION_COPY);
}

-(HeaderRefreshBlock)headerBlock
{
    return objc_getAssociatedObject(self, _cmd);
}

// 添加刷新状态属性
- (void)setRefreshStatus:(NSString *)refreshStatus
{
    objc_setAssociatedObject(self, @selector(refreshStatus), refreshStatus, OBJC_ASSOCIATION_COPY);
}

- (NSString *)refreshStatus
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setCurrentContentInset:(UIEdgeInsets)currentContentInset
{
    NSValue *value = [NSValue value:&currentContentInset withObjCType:@encode(UIEdgeInsets)];
    
    objc_setAssociatedObject(self, @selector(currentContentInset), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIEdgeInsets)currentContentInset
{
    NSValue *value = objc_getAssociatedObject(self, _cmd);
    
    if (value)
    {
        UIEdgeInsets inset;
        [value getValue:&inset];
        return inset;
    }
    else
    {
        return UIEdgeInsetsZero;
    }
}

- (void)setOffsetY:(CGFloat)offsetY
{
    NSValue *value = [NSValue value:&offsetY withObjCType:@encode(CGFloat)];
    
    objc_setAssociatedObject(self, @selector(offsetY), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)offsetY
{
    NSValue *value = objc_getAssociatedObject(self, _cmd);
    
    if (value)
    {
        CGFloat y;
        [value getValue:&y];
        return y;
    }
    
    return 0.0;
}

@end
