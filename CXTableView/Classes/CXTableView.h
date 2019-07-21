//
//  CXTableView.h
//  CXTableView_Example
//
//  Created by caixiang on 2019/7/20.
//  Copyright © 2019年 caixiang305621856. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXTableViewDelegateProtocol.h"
#import "CXTableViewDataSource.h"

NS_ASSUME_NONNULL_BEGIN

@interface CXTableView : UITableView<UITableViewDelegate>

@property (nonatomic, weak) id<CXTableViewDataSourceProtocol> cxdataSource;
@property (nonatomic, weak) id<CXTableViewDelegateProtocol> cxdelegate;

@end

NS_ASSUME_NONNULL_END
