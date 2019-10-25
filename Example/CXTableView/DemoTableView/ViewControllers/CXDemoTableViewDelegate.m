//
//  CXDemoTableViewDelegate.m
//  CXTableView_Example
//
//  Created by caixiang on 2019/7/23.
//  Copyright © 2019年 caixiang305621856. All rights reserved.
//

#import "CXDemoTableViewDelegate.h"
#import "CXEmptyView.h"
#import "CXDemoTableViewCell.h"
#import "CXDemo1TableViewCell.h"

@implementation CXDemoTableViewDelegate

#pragma mark - CXTableViewDelegateProtocol
- (UIView *)registerEmptyView {
    CXEmptyView *emptyView = [[[NSBundle mainBundle] loadNibNamed:@"CXEmptyView" owner:self options:nil] firstObject];
    emptyView.frame = [UIScreen mainScreen].bounds;
    emptyView.reloadData = ^{
        [self.tableView triggerPullToRefresh];
    };
    return emptyView;
}

- (void)pullDownToRefresh {
    //模拟网络请求
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.demoDataSource loadData];
        [self.tableView setLoadCompleted:NO];
        [self.tableView stopRefreshingAnimation];
        [self.tableView reloadData];
    });
}


- (void)pullUpToRefresh {
    //模拟网络请求
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.demoDataSource loadMoreData];
        [self.tableView setLoadCompleted:YES];
        [self.tableView triggerRefreshing];
        [self.tableView reloadData];
    });
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
