//
//  JFRefreshFooterView.m
//  TableViewRefreshDemo
//
//  Created by Japho on 2018/9/25.
//  Copyright © 2018年 Japho. All rights reserved.
//

#import "JFRefreshFooterView.h"
#import "JFRefreshMacro.h"

@interface JFRefreshFooterView ()

@property (nonatomic, strong) UILabel *lblTitle;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIActivityIndicatorView *refreshView;

@end

@implementation JFRefreshFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self creatViews];
        [self addObserver:self forKeyPath:@"type" options:NSKeyValueObservingOptionNew context:nil];
    }
    
    return self;
}

- (void)creatViews
{
    if (self.lblTitle == nil)
    {
        self.lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 3, 0, SCREEN_WIDTH / 3, 50)];
        [self addSubview:self.lblTitle];
    }
    if (self.imgView == nil)
    {
        self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 3 - 30, 10, 30, 30)];
        self.imgView.image = [UIImage imageNamed:@"JFRefresh_arrow"];
        [self addSubview:self.imgView];
    }
    if (self.refreshView == nil)
    {
        self.refreshView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.refreshView.center = CGPointMake(SCREEN_WIDTH / 3 - 15, 25);
        self.refreshView.hidden = YES;
        [self addSubview:self.refreshView];
    }
    
    self.lblTitle.font = [UIFont systemFontOfSize:18];
    self.lblTitle.text = REFRESH_CANCLE_LOAD_STR;
    self.lblTitle.textAlignment = NSTextAlignmentCenter;
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    
    // 处理刷新视图的改变
    if ([keyPath isEqualToString:@"type"])
    {
        self.lblTitle.text = [self getRefreshStatus:_type];
        if (_type == JFLoadShowTypeWillLoad)
        {
            self.imgView.hidden = NO;
            self.refreshView.hidden = YES;
            [UIView animateWithDuration:0.3 animations:^{
                self.imgView.transform=CGAffineTransformMakeRotation(M_PI);
            }];
        }
        else if (_type == JFLoadShowTypeLoading)
        {
            self.imgView.hidden = YES;
            self.refreshView.hidden = NO;
            [self.refreshView startAnimating];
        }
        else
        {
            self.imgView.hidden = NO;
            self.refreshView.hidden = YES;
            [UIView animateWithDuration:0.3 animations:^{
                self.imgView.transform=CGAffineTransformMakeRotation(0);
            }];
        }
    }
    
}

- (NSString *)getRefreshStatus:(JFLoadShowType)status
{
    switch (status)
    {
        case JFLoadShowTypeWillLoad:
            return REFRESH_WILL_LOAD_STR;
        case JFLoadShowTypeLoading:
            return REFRESH_LOADING_STR;
        case JFLoadShowTypeCancelLoad:
            return REFRESH_CANCLE_LOAD_STR;
        default:
            break;
    }
}

@end
