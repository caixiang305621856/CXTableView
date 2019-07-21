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
        [self configDataSource];
    }
    return self;
}

- (void)configDataSource {
    //子类实现
    @throw [NSException exceptionWithName:@"Cann't use this method"
                                   reason:@"You can only call this method in subclass"
                                 userInfo:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];
}

- (void)createTableView {
    if (!self.tableView) {
        self.tableView = [[CXTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        self.tableView.cxdelegate = self;
        self.tableView.cxdataSource = self.tableViewDataSource;
        self.tableView.tableFooterView = [UIView new];
        [self.view addSubview:self.tableView];
    }
}

@end
