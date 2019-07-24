//
//  CXDemoTableViewDelegate.h
//  CXTableView_Example
//
//  Created by caixiang on 2019/7/23.
//  Copyright © 2019年 caixiang305621856. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CXTableViewDelegateProtocol.h"
#import "CXTableView.h"
#import "CXDemoDataSource.h"

NS_ASSUME_NONNULL_BEGIN

@interface CXDemoTableViewDelegate : NSObject<CXTableViewDelegateProtocol>

@property (weak, nonatomic) CXTableView*tableView;
@property (weak, nonatomic) CXDemoDataSource *demoDataSource;

@end

NS_ASSUME_NONNULL_END
