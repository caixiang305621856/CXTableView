//
//  CXTableViewDataSource.m
//  CXTableView_Example
//
//  Created by caixiang on 2019/7/20.
//  Copyright © 2019年 caixiang305621856. All rights reserved.
//

#import "CXTableViewDataSource.h"
#import "CXBaseTableViewCell.h"
#import "CXTableViewSectionModel.h"
#import <objc/runtime.h>

@implementation CXTableViewDataSource

#pragma mark - CXTableViewDataSourceProtocol
- (id)tableView:(UITableView *)tableView objectForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.sections.count > indexPath.section) {
        CXTableViewSectionModel *tableViewSectionModel = [self.sections objectAtIndex:indexPath.section];
        if ([tableViewSectionModel.items count] > indexPath.row) {
            return [tableViewSectionModel.items objectAtIndex:indexPath.row];
        }
    }
    return nil;
}

- (UITableViewCell *)registerTableView:(UITableView*)tableView cellClassForObject:(id)object {
    //子类实现
    Class cellClass = [self tableView:tableView cellClassForObject:object];
    NSString *className = [NSString stringWithUTF8String:class_getName(cellClass)];
    return [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:className];
}

- (Class)tableView:(UITableView*)tableView cellClassForObject:(id)object {
    //子类实现
    return [CXBaseTableViewCell class];
}

- (CGFloat)rowHeightForObject:(id)object {
    //子类实现
    return 0;
}

#pragma mark - public
- (void)reamoveAllItems {
    self.sections = [NSMutableArray arrayWithObject:[CXTableViewSectionModel new]];
}

- (void)addItem:(id)item {
    [self addItem:item section:0];
}

- (void)addItem:(id)item section:(NSInteger)section {
    CXTableViewSectionModel *sectionModel = [self.sections objectAtIndex:section];
    [sectionModel.items addObject:item];
}

- (id)loadFromXib:(NSString *)class_name {
    return [[[NSBundle mainBundle] loadNibNamed:class_name owner:nil options:nil] firstObject];
}

#pragma mark - UITableViewDataSource Required
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.sections.count > section) {
        CXTableViewSectionModel *tableViewSectionModel =  [self.sections objectAtIndex:section];
        return tableViewSectionModel.items.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //通过获得数据来确定Cell的样式
     id object = [self tableView:tableView objectForRowAtIndexPath:indexPath];
    Class cellClass = [self tableView:tableView cellClassForObject:object];
    NSString *className = [NSString stringWithUTF8String:class_getName(cellClass)];
    CXBaseTableViewCell* cell = (CXBaseTableViewCell*)[tableView dequeueReusableCellWithIdentifier:className];
    if (!cell) {
        cell = (CXBaseTableViewCell *)[self registerTableView:tableView cellClassForObject:object];
        NSLog(@"%zd",indexPath.row);
    }
    return cell;
}

#pragma mark - UITableViewDataSource Optional
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections ? self.sections.count : 0;
}

@end
