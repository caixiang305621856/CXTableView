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
    self.navigationItem.title = @"CXTableView";
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"数据加载失败" style:UIBarButtonItemStylePlain target:self action:@selector(failClick)];
    [self.navigationItem setRightBarButtonItem:item];
    self.tableView.isNeedPullUpToRefresh = YES;
    self.tableView.isNeedPullDownToRefresh = YES;
    self.tableView.autoPullDownToRefresh = YES;
}

#pragma mark - CXTableViewControllerDelegate
- (void)configCXDataSource {
    //设置数据源
    self.tableViewDataSource = self.demoDataSource;
}

- (void)configCXDelegate {
      //设置代理
    self.tableView.cxdelegate = self.demoTableViewDelegate;
}

#pragma mark - action
- (void)failClick {
    [self.tableViewDataSource reamoveAllItems];
    [self.tableView reloadData];
}

#pragma mark - set&get
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
        _demoTableViewDelegate.demoDataSource = self.demoDataSource;
    }
    return _demoTableViewDelegate;
}

@end
