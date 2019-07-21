//
//  CXTableViewDelegateProtocol.h
//  CXTableView_Example
//
//  Created by caixiang on 2019/7/20.
//  Copyright © 2019年 caixiang305621856. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CXTableViewDelegateProtocol <UITableViewDelegate>

@optional

/**
 cell点击的回调

 @param object 对象
 @param indexPath 索引
 */
- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath*)indexPath;

@end

NS_ASSUME_NONNULL_END
