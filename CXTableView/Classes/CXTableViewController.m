//
//  CXTableViewController.m
//  CXTableView_Example
//
//  Created by caixiang on 2019/7/20.
//  Copyright © 2019年 caixiang305621856. All rights reserved.
//

#import "CXTableViewController.h"

@interface CXTableViewController ()

@end

@implementation CXTableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super init];
    if(self) {
        [self configCXDataSource];
    }
    return self;
}

- (void)configCXDataSource {
    /*
     子类实现
     self.tableView.cxdataSource = self.tableViewDataSource的子类
     */
    @throw [NSException exceptionWithName:@"Cann't use this method"
                                   reason:@"You can only call this method in subclass"
                                 userInfo:nil];
}

- (void)configCXDelegate {
    /*
     子类实现
     若不实现默认 self.tableView.cxdelegate = self;
     */
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.tableView.autoPullDownToRefresh && self.tableView.isNeedPullDownToRefresh) {
        [self.tableView triggerPullToRefresh];
    }
}

- (void)createTableView {
    if (!self.tableView) {
        self.tableView = [[CXTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        self.tableView.contentInset = UIEdgeInsetsMake([UIApplication sharedApplication].statusBarFrame.size.height + 44.0f, 0, 0, 0);
        self.tableView.cxdelegate = self;
        self.tableView.cxdataSource = self.tableViewDataSource;
        [self configCXDelegate];
        self.tableView.tableFooterView = [UIView new];
        [self.view addSubview:self.tableView];
    }
}

@end
