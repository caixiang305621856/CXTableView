//
//  CXDemo1Item.h
//  CXTableView_Example
//
//  Created by caixiang on 2019/7/21.
//  Copyright © 2019年 caixiang305621856. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CXDemo1Item : NSObject

@property (nonatomic, copy) NSString *identifier;

@property (nonatomic, assign) CGFloat rowHeight;

@property (nonatomic, copy) NSString *contentName;

@property (nonatomic, copy) NSString *titleName;

@end

NS_ASSUME_NONNULL_END
