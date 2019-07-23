//
//  CXDemoItem.h
//  CXTableView_Example
//
//  Created by caixiang on 2019/7/20.
//  Copyright © 2019年 caixiang305621856. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CXDemoItem : NSObject

@property (nonatomic, copy) NSString *cellIdentifier;

@property (nonatomic, assign) CGFloat rowHeight;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *subName;

@end

NS_ASSUME_NONNULL_END
