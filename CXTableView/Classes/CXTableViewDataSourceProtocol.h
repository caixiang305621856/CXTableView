//
//  CXTableViewDataSourceProtocol.h
//  CXTabelView_Example
//
//  Created by caixiang on 2019/7/20.
//  Copyright © 2019年 caixiang305621856. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@protocol CXTableViewDataSourceProtocol <UITableViewDataSource>
@optional

/**
 根据object(VModel)来确定cell类型

 @param tableView 列表
 @param object 对象
 @return 自定义Cell类
 */
- (Class)tableView:(UITableView*)tableView cellClassForObject:(id)object;

/**
 根据object(VModel)来注册cell类型 可以Xib,纯代码构建cell

 @param tableView 列表
 @param object 对象
 @return 自定义Cell
 */
- (UITableViewCell *)registerTableView:(UITableView*)tableView cellClassForObject:(id)object;

/**
 获取对应行的数据

 @param tableView 列表
 @param indexPath 索引
 @return UI数据
 */
- (id)tableView:(UITableView *)tableView objectForRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 设置Cell的高度 (提前异步就计算好的)

 @param object 对象
 @return cell高度
 */
- (CGFloat)rowHeightForObject:(id)object;

@end

NS_ASSUME_NONNULL_END
