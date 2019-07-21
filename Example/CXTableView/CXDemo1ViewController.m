//
//  CXDemo1ViewController.m
//  CXTableView_Example
//
//  Created by caixiang on 2019/7/21.
//  Copyright © 2019年 caixiang305621856. All rights reserved.
//

#import "CXDemo1ViewController.h"
#import "CXDemoTableViewCell.h"

@interface CXDemo1ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation CXDemo1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createTableView];
}

- (void)createTableView {
    if (!self.tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.tableFooterView = [UIView new];
        [self.view addSubview:self.tableView];
        self.tableView.estimatedRowHeight = 0;
    }
}

#pragma mark - UITableViewDataSource Required
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CXDemoTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CXDemoTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CXDemoTableViewCell" owner:nil options:nil] firstObject];
        NSLog(@"%zd",indexPath.row);
    }
    cell.clickHandler = ^{
        NSLog(@"%zd",indexPath.row);
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}
@end
