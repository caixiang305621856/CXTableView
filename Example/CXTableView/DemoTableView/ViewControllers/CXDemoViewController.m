//
//  CXDemoViewController.m
//  CXTableView_Example
//
//  Created by caixiang on 2019/7/20.
//  Copyright © 2019年 caixiang305621856. All rights reserved.
//

#import "CXDemoViewController.h"
#import "CXDemoDataSource.h"
#import "CXDemoTableViewDelegate.h"

@interface CXDemoViewController ()

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView ;
@property (strong, nonatomic) CXDemoDataSource *demoDataSource;
@property (strong, nonatomic) CXDemoTableViewDelegate *demoTableViewDelegate;

@end

@implementation CXDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.cxdelegate = self.demoTableViewDelegate;
    self.tableView.isNeedPullUpToRefresh = YES;
    self.tableView.isNeedPullDownToRefresh = YES;
    self.navigationItem.title = @"CXTableView";
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"数据加载失败" style:UIBarButtonItemStylePlain target:self action:@selector(failClick)];
    [self.navigationItem setRightBarButtonItem:item];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView triggerPullToRefresh];
}

- (void)failClick {
    [self.tableViewDataSource reamoveAllItems];
    [self.tableView reloadData];
}

#pragma mark - CXTableViewControllerDelegate
- (void)configDataSource {
    //设置数据源代理
    self.tableViewDataSource = self.demoDataSource;
}

- (void)loadData {
    [self.demoDataSource loadData];
    CXTableViewSectionModel *sectionModel =  self.demoDataSource.sections[0];
    NSLog(@"🚀%@",sectionModel.items);
    [self.tableView reloadData];
}

- (CXDemoDataSource *)demoDataSource{
    if (!_demoDataSource) {
        _demoDataSource = [[CXDemoDataSource alloc] init];
    }
    return _demoDataSource;
}

- (CXDemoTableViewDelegate *)demoTableViewDelegate{
    if (!_demoTableViewDelegate) {
        _demoTableViewDelegate = [[CXDemoTableViewDelegate alloc] init];
        _demoTableViewDelegate.tableView = self.tableView;
        __weak typeof(self)weakSelf = self;
        _demoTableViewDelegate.reloadData = ^{
            [weakSelf loadData];
        };
    }
    return _demoTableViewDelegate;
}

@end
