//
//  CXBaseTableViewCell.h
//  CXTableView_Example
//
//  Created by caixiang on 2019/7/20.
//  Copyright © 2019年 caixiang305621856. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CXBaseTableViewCell : UITableViewCell

@property (nonatomic, strong) id item;

+ (CGFloat)rowHeightForItem:(id)item;

@end

NS_ASSUME_NONNULL_END
