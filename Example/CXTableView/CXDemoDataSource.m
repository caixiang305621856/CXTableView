//
//  CXDemoDataSource.m
//  CXTableView_Example
//
//  Created by caixiang on 2019/7/20.
//  Copyright © 2019年 caixiang305621856. All rights reserved.
//

#import "CXDemoDataSource.h"
#import "CXDemoItem.h"
#import "CXDemo1Item.h"
#import "CXDemoAdapter.h"
#import "CXDemo1TableViewCell.h"
#import "CXDemoTableViewCell.h"

@implementation CXDemoDataSource

//模拟网络请求
- (void)requestDatas:(void(^)(void))loading
      succeedHandler:(void(^)(NSString * result))succeedHandler
         failHandler:(void(^)(NSString * result))failHandler
     completeHandler:(void(^)(void))completeHandler {
    !loading?:loading();
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loadData];
        !succeedHandler?:succeedHandler(@"请求成功");
        !completeHandler?:completeHandler();
    });
}

- (void)loadData {
    //业务数据处理  这里还可以抽离出一个p层
    NSArray *cellIdentifers = @[NSStringFromClass([CXDemo1TableViewCell class]),NSStringFromClass([CXDemoTableViewCell class])];
    NSMutableArray *items = [@[] mutableCopy];
    id<ContentViewAdapterProtocol> demoAdapter;
    for (NSInteger i = 0; i < 40; i ++) {
        if (i%5 > 2) {
            CXDemoItem *item = [CXDemoItem new];
            item.cellIdentifier = cellIdentifers[i%2];
            item.rowHeight = 150;
            item.name = item.cellIdentifier;
            item.subName = [NSString stringWithFormat:@"%zd",i];
            demoAdapter = [[CXDemoAdapter alloc] initWithData:item];
        } else{
            CXDemo1Item *item = [CXDemo1Item new];
            item.identifier = cellIdentifers[i%2];
            item.rowHeight = 70;
            item.contentName = item.identifier;
            item.titleName = [NSString stringWithFormat:@"%zd",i];
            demoAdapter = [[CXDemoAdapter alloc] initWithData:item];
        }
        [items addObject:demoAdapter];
    }
    CXTableViewSectionModel *sectionModel = [[CXTableViewSectionModel alloc] initWithItemArray:items];
    self.sections = [NSMutableArray arrayWithObject:sectionModel];
}

#pragma mark - CXTableViewDataSourceProtocol
//注册cell类型
- (UITableViewCell *)registerTableView:(UITableView*)tableView cellClassForObject:(id<ContentViewAdapterProtocol>)object {
    return [self loadFromXib:object.cellIdentifier];
}

//确立Cell的类型
- (Class)tableView:(UITableView *)tableView cellClassForObject:(id<ContentViewAdapterProtocol>)object {
    return [NSClassFromString(object.cellIdentifier) class];
}

//异步计算好高度
- (CGFloat)rowHeightForObject:(id<ContentViewAdapterProtocol>)object {
    return object.rowHeight;
}

@end
