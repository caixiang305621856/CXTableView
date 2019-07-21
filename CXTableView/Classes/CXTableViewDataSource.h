//
//  CXTableViewDataSource.h
//  CXTableView_Example
//
//  Created by caixiang on 2019/7/20.
//  Copyright © 2019年 caixiang305621856. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CXTableViewDataSourceProtocol.h"
#import "CXTableViewSectionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CXTableViewDataSource : NSObject<CXTableViewDataSourceProtocol>

/**
 包装setion 是个二维数组
 */
@property (nonatomic, strong) NSMutableArray <CXTableViewSectionModel *>*sections;

/**
 移除数据源
 */
- (void)reamoveAllItems;

/**
 添加数据 默认1个section的情况

 @param item 数据对象
 */
- (void)addItem:(id)item;

/**
 给某个section添加item

 @param item 数据对象
 @param section 索引
 */
- (void)addItem:(id)item section:(NSInteger)section;

/**
 为子类提供XIB注册方式

 @param class_name 类名
 @return xib Cell
 */
- (id)loadFromXib:(NSString *)class_name;

@end

NS_ASSUME_NONNULL_END
