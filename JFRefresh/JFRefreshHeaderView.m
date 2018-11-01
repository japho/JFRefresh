//
//  JFRefreshHeaderView.m
//  TableViewRefreshDemo
//
//  Created by Japho on 2018/9/25.
//  Copyright © 2018年 Japho. All rights reserved.
//

#import "JFRefreshHeaderView.h"
#import "JFRefreshMacro.h"

@interface JFRefreshHeaderView ()

@end

@implementation JFRefreshHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.frame = CGRectMake(0, -REFRESH_VIEW_HEIGHT, SCREEN_WIDTH, REFRESH_VIEW_HEIGHT);
        self.layer.masksToBounds = YES;
        [self creatViews];
        [self addObserver:self forKeyPath:@"type" options:NSKeyValueObservingOptionNew context:nil];
    }
    
    return self;
}

// 添加刷新视图
- (void)creatViews
{
    if (self.lblTitle == nil)
    {
        self.lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 3, 0, SCREEN_WIDTH / 3, REFRESH_VIEW_HEIGHT)];
        [self addSubview:self.lblTitle];
    }
    if (self.imgView == nil)
    {
        self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 3 - 10, 10, 25, 25)];
        self.imgView.center = CGPointMake(SCREEN_WIDTH / 2 - 50, 25);
        self.imgView.image = [UIImage imageNamed:@"JFRefresh_arrow"];
        self.imgView.transform = CGAffineTransformMakeRotation(M_PI);
        [self addSubview:self.imgView];
    }
    if (self.refreshView == nil)
    {
        self.refreshView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.refreshView.center = CGPointMake(SCREEN_WIDTH / 2 - 50, 25);
        self.refreshView.hidden = YES;
        [self.refreshView startAnimating];
        [self addSubview:self.refreshView];
    }
    self.lblTitle.font = [UIFont systemFontOfSize:15];
    self.lblTitle.text = REFRESH_CANCLE_REFRESH_STR;
    self.lblTitle.textColor = [UIColor lightGrayColor];
    self.lblTitle.textAlignment = NSTextAlignmentCenter;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    // 处理刷新视图的改变
    if ([keyPath isEqualToString:@"type"])
    {
        self.lblTitle.text = [self getRefreshStatus:_type];
        if (_type == JFRefreshShowTypeWillRefresh)
        {
            self.imgView.hidden = NO;
            self.refreshView.hidden = YES;
        }
        else if (_type == JFRefreshShowTypeRefreshing)
        {
            self.imgView.hidden = YES;
            self.refreshView.hidden = NO;
        }
        else if (_type == JFRefreshShowTypeCancelRefresh)
        {
            self.imgView.hidden = NO;
            self.refreshView.hidden = YES;
        }
        else
        {
            self.imgView.hidden = YES;
            self.refreshView.hidden = YES;
        }
    }
}
- (NSString *)getRefreshStatus:(JFRefreshShowType)status
{
    switch (status)
    {           
        case JFRefreshShowTypeWillRefresh:
            return REFRESH_WILL_FRESH_STR;
        case JFRefreshShowTypeRefreshing:
            return REFRESH_REFRESHING_STR;
        case JFRefreshShowTypeCancelRefresh:
            return REFRESH_CANCLE_REFRESH_STR;
        case JFRefreshShowTypeDidFinished:
            return REFRESH_FINISHI_REFRESH_STR;
        default:
            break;
    }
}

@end
