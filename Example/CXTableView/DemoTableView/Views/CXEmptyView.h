//
//  CXEmptyView.h
//  CXTableView_Example
//
//  Created by caixiang on 2019/7/23.
//  Copyright © 2019年 caixiang305621856. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CXEmptyView : UIView
@property (copy, nonatomic) void(^reloadData)(void);
@end

