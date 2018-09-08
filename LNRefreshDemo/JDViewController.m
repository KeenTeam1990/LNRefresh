//
//  JDViewController.m
//  LNRefreshDemo
//
//  Created by keenteam on 2018/9/8.
//  Copyright © 2018年 vvusu. All rights reserved.
//
#import "LNHeaderJDAnimator.h"
#import <LNRefresh/LNRefresh.h>
#import "JDViewController.h"

#define LNViewW self.view.frame.size.width
#define LNViewH self.view.frame.size.height - 64
#define LNViewBGColor [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.00]
#define KIS_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define LNViewY KIS_iPhoneX ? 88 : 64

@interface JDViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArr;
@end

@implementation JDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.dataArr = [NSMutableArray array];
    self.navigationItem.title = @"京东";
    [self createTableView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSString *)randomUnicodeString {
    NSString *icon = @"🐶🐱🐼🐷🐮🐽🐸🐙🐵🐤🐦🐣🦅🦉🐺🐗🦋🐛🦄🐴🍏🍐🍊🍋🍇🍓🍒🍑🍍🥝🥑🍅🍆🥒🥕🌽🍠🥜";
    NSInteger num = arc4random_uniform((int)icon.length - 2);
    num = num%2 == 0 ? num : num - 1;
    return [icon substringWithRange:NSMakeRange(num, 2)];
}

- (void)pullToRefresh {
    NSLog(@"下拉刷新");
    [self.dataArr removeAllObjects];
    for (NSInteger i = 0; i < 16; i++) {
        [self.dataArr addObject:[self randomUnicodeString]];
    }
    __weak UITableView *wtableView = self.tableView;
  
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        num = 0;
       
        [wtableView reloadData];
        [wtableView pullDownDealFooterWithItemCount:self.dataArr.count cursor:@"11"];
        
    });
}

static NSUInteger num = 0;

- (void)loadMoreRefresh {
    NSLog(@"上拉加载更多");
    for (NSInteger i = 0; i < 1; i++) {
        [self.dataArr addObject:[self randomUnicodeString]];
    }
    __weak UITableView *wtableView = self.tableView;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (num > 2) {
           
            [wtableView noticeNoMoreData];
            return;
        }
        num++;
       
            [wtableView reloadData];
            [wtableView endLoadingMore];
       
    });
}

#pragma mark - UITableView datasource and delegate

- (void)createTableView {
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, LNViewY, LNViewW, LNViewH) style:UITableViewStylePlain];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableVCCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = LNViewBGColor;
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:self.tableView];
    __weak typeof(self) wself = self;
    [self.tableView addInfiniteScrolling:^{
        [wself loadMoreRefresh];
    }];
    self.tableView.ln_footer.autoBack = YES;
    [self.tableView addPullToRefresh:[LNHeaderJDAnimator createAnimator] block:^{
    [wself pullToRefresh];
    }];
    
    [self.tableView startRefreshing];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableVCCell"];
    if (indexPath.row < self.dataArr.count) {
        cell.textLabel.text = self.dataArr[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
