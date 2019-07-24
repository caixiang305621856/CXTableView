//
//  CXDemoDataSource.h
//  CXTableView_Example
//
//  Created by caixiang on 2019/7/20.
//  Copyright © 2019年 caixiang305621856. All rights reserved.
//

#import "CXTableViewDataSource.h"

NS_ASSUME_NONNULL_BEGIN

@interface CXDemoDataSource : CXTableViewDataSource

- (void)loadData;
- (void)loadMoreData;

@end

NS_ASSUME_NONNULL_END
