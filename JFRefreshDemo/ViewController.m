//
//  ViewController.m
//  JFRefreshDemo
//
//  Created by Japho on 2018/10/25.
//  Copyright © 2018 Japho. All rights reserved.
//

#import "ViewController.h"
#import "JFRefresh.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *arrOriginalData;
@property (nonatomic, strong) NSMutableArray *arrData;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"JFRefresh";
    
    self.arrOriginalData = @[@"美今日将首次尝试洲际导弹拦截 明确称针对朝",@"揭秘：当年日本发动全面侵华战争前做了什么准",@"中国限制出口造岛用挖泥船：出于国家安全考虑",@"细数军校毕业综合演练中的那些感人瞬间",@"日“准航母”越造越大，欲冲破枷笼",@"中国095核潜艇采用喷水推进 或追平美水平",@"歼20发动机之谜揭晓，美俄大惊失色",@"中国095核潜艇有一性能 或能追平美海狼级核潜",@"众议苑 | 中东一团乱麻，特朗普凑啥热闹？",@"美国首次尝试洲际导弹拦截 明确针对朝导弹",@"IS成杜特尔特心腹大患 中俄2武器可助菲律宾",@"美：已邀中国参加2018年环太军演及准备会议",@"特朗普密友涉嫌逃税13亿 曾为其总统选举提供助力",@"明天起，一批新规将改变你我的生活",@"公安部部署机动车号牌管理改革：机动车号牌可网上选号",@"卖房离京去河北养老：燕郊养老试点九成为京籍老人",@"台军拟成立无人机侦察中队 或将执行军事侦察任务",@"国家赔偿新标准：侵犯人身自由权日赔258.89元",@"美军首次洲际弹道导弹拦截测试获得成功",@"央视记者携带防弹衣在泰国被拘 面临最高5年监禁",@"“男孩成长女性化”趋势明显：家长担心变成娘娘腔"];
    
    for (int i = 0; i < 10; i++)
    {
        int randomIndex = arc4random() % 20;
        [self.arrData addObject:self.arrOriginalData[randomIndex]];
    }
    
    [self.view addSubview:self.tableView];
}

- (void)loadAction
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.arrData removeAllObjects];
        
        for (int i = 0; i < 10; i++)
        {
            int randomIndex = arc4random() % 20;
            [self.arrData addObject:self.arrOriginalData[randomIndex]];
        }
        
        [self.tableView endHeaderRefresh];
        [self.tableView reloadData];
        
    });
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    
    cell.textLabel.text = self.arrData[indexPath.row];
    
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s",__func__);
}

#pragma mark - --- Setter & Getter ---

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 80;
        _tableView.tableFooterView = [[UIView alloc] init];
        
        __weak typeof(self)weakSelf = self;
        
        [_tableView jf_addHeaderRefreshWithBlock:^{
            
            [weakSelf loadAction];
            
        }];
    }
    
    return _tableView;
}

- (NSMutableArray *)arrData
{
    if (!_arrData)
    {
        _arrData = [[NSMutableArray alloc] init];
    }
    
    return _arrData;
}

@end
