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
#import "CXTableViewDataSource.h"
#import "SVPullToRefresh.h"

NS_ASSUME_NONNULL_BEGIN

@interface CXTableView : UITableView<UITableViewDelegate>

@property (nonatomic, weak) id<CXTableViewDataSourceProtocol> cxdataSource;
@property (nonatomic, weak) id<CXTableViewDelegateProtocol> cxdelegate;

@property (nonatomic, assign) BOOL isNeedPullDownToRefresh;
@property (nonatomic, assign) BOOL isNeedPullUpToRefresh;
@property (assign, nonatomic) BOOL autoPullDownToRefresh;
@property (assign, nonatomic) BOOL loadCompleted;

- (void)stopRefreshingAnimation;
- (void)triggerRefreshing;

@end

NS_ASSUME_NONNULL_END
