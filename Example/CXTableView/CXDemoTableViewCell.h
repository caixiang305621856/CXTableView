//
//  CXDemoTableViewCell.h
//  CXTableView_Example
//
//  Created by caixiang on 2019/7/20.
//  Copyright © 2019年 caixiang305621856. All rights reserved.
//

#import "CXBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface CXDemoTableViewCell : CXBaseTableViewCell

@property (nonatomic, copy) void(^clickHandler)(void);

@end

NS_ASSUME_NONNULL_END
