//
//  CXDemoTableViewDelegate.m
//  CXTableView_Example
//
//  Created by caixiang on 2019/7/23.
//  Copyright © 2019年 caixiang305621856. All rights reserved.
//

#import "CXDemoTableViewDelegate.h"
#import "CXDemoAdapter.h"
#import "CXEmptyView.h"
#import "CXDemoTableViewCell.h"

@implementation CXDemoTableViewDelegate

#pragma mark - CXTableViewDelegateProtocol
- (UIView *)registerEmptyView {
    CXEmptyView *emptyView = [[[NSBundle mainBundle] loadNibNamed:@"CXEmptyView" owner:self options:nil] firstObject];
    emptyView.frame = [UIScreen mainScreen].bounds;
    emptyView.reloadData = self.reloadData;
    return emptyView;
}

- (void)pullDownToRefresh {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView stopRefreshingAnimation];
        !self.reloadData?:self.reloadData();
    });
}


- (void)pullUpToRefresh {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView triggerRefreshing];
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
