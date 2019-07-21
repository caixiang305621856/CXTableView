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

@property (nonatomic, copy) void(^loading)(id result);
@property (nonatomic, copy) void(^succeedHandler)(id result);
@property (nonatomic, copy) void(^failHandler)(id result);
@property (nonatomic, copy) void(^completeHandler)(id result);

- (void)requestDatas:(void(^)(void))loading
      succeedHandler:(void(^)(NSString * result))succeedHandler
      failHandler:(void(^)(NSString * result))failHandler
     completeHandler:(void(^)(void))completeHandler;

@end

NS_ASSUME_NONNULL_END
