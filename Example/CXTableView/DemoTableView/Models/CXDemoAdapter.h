//
//  CXDemoAdapter.h
//  CXTableView_Example
//
//  Created by caixiang on 2019/7/21.
//  Copyright © 2019年 caixiang305621856. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol ContentViewAdapterProtocol <NSObject>

@required
- (NSString *)cellIdentifier;

@optional
- (CGFloat)rowHeight;

- (NSString*)title;

- (NSString*)content;

@end
NS_ASSUME_NONNULL_BEGIN

@interface CXDemoAdapter : NSObject <ContentViewAdapterProtocol>

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
/**
 *  与输入对象建立联系
 *
 *  @param data 输入的对象
 *
 *  @return 实例对象
 */
- (instancetype)initWithData:(id)data;

@end

NS_ASSUME_NONNULL_END
