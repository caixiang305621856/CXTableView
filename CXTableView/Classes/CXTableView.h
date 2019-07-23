//
//  CXTableView.h
//  CXTableView_Example
//
//  Created by caixiang on 2019/7/20.
//  Copyright © 2019年 caixiang305621856. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXTableViewDelegateProtocol.h"
#import "CXTableViewDataSourceProtocol.h"
#import "SVPullToRefresh.h"
#import "CXTableViewDataSource.h"

NS_ASSUME_NONNULL_BEGIN

@interface CXTableView : UITableView<UITableViewDelegate>

@property (nonatomic, weak) id<CXTableViewDataSourceProtocol> cxdataSource;
@property (nonatomic, weak) id<CXTableViewDelegateProtocol> cxdelegate;

@property (nonatomic, assign) BOOL isNeedPullDownToRefresh;
@property (nonatomic, assign) BOOL isNeedPullUpToRefresh;

/**
停止所有刷新动画
 */
- (void)stopRefreshingAnimation;

/**
 停止上拉刷新动画
 */
- (void)triggerRefreshing;

- (void)loadCompelet;

@end

NS_ASSUME_NONNULL_END
