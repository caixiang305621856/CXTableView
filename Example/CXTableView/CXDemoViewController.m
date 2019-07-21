//
//  CXDemoViewController.m
//  CXTableView_Example
//
//  Created by caixiang on 2019/7/20.
//  Copyright © 2019年 caixiang305621856. All rights reserved.
//

#import "CXDemoViewController.h"
#import "CXDemoDataSource.h"
#import "CXDemoTableViewCell.h"
#import "CXDemoAdapter.h"

@interface CXDemoViewController ()

@end

@implementation CXDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

//配置
- (void)configDataSource {
    CXDemoDataSource *demoDataSource = [[CXDemoDataSource alloc] init];
    [demoDataSource requestDatas:^{
        NSLog(@"正在加载");
    } succeedHandler:^(NSString * _Nonnull result) {
        NSLog(@"加载成功");
        [self.tableView reloadData];
    } failHandler:^(NSString * _Nonnull result) {
    } completeHandler:^{
    }];
    self.tableViewDataSource = demoDataSource;
}

#pragma mark - CXTableViewDelegateProtocol
- (void)didSelectObject:(CXDemoAdapter *)object atIndexPath:(NSIndexPath*)indexPath {
    
}

#pragma mark - delegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[CXDemoTableViewCell class]]) {
        CXDemoTableViewCell *demoTableViewCell = (CXDemoTableViewCell *)cell;
        demoTableViewCell.clickHandler = ^{
            NSLog(@"点击了%zd",indexPath.row);
        };
    }
};

@end
