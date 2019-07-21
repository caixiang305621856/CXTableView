//
//  CXBaseTableViewCell.m
//  CXTableView_Example
//
//  Created by caixiang on 2019/7/20.
//  Copyright © 2019年 caixiang305621856. All rights reserved.
//

#import "CXBaseTableViewCell.h"

@interface CXBaseTableViewCell()

@end

@implementation CXBaseTableViewCell

- (void)setItem:(id)item {
    //子类
}

+ (CGFloat)rowHeightForItem:(id)item {
    //子类
    return 0;
}

@end
