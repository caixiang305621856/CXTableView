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
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView ;

@end

@implementation CXDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.activityIndicatorView];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.activityIndicatorView.frame = CGRectMake(0, 0, 40, 40);
    self.activityIndicatorView.center = self.view.center;
}

- (UIActivityIndicatorView *)activityIndicatorView {
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityIndicatorView.hidesWhenStopped = YES;
    }
    return _activityIndicatorView;
}

//配置
- (void)configDataSource {
    CXDemoDataSource *demoDataSource = [[CXDemoDataSource alloc] init];
    [self.activityIndicatorView startAnimating];
    [demoDataSource requestDatas:^{
        NSLog(@"正在加载");
    } succeedHandler:^(NSString * _Nonnull result) {
        NSLog(@"加载成功");
        [self.tableView reloadData];
    } failHandler:^(NSString * _Nonnull result) {
    } completeHandler:^{
        [self.activityIndicatorView stopAnimating];
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
