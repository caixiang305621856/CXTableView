//
//  CXTableViewSectionModel.h
//  CXTableView_Example
//
//  Created by caixiang on 2019/7/20.
//  Copyright © 2019年 caixiang305621856. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CXTableViewSectionModel : NSObject

/**
 section唯一标示
 */
@property (nonatomic, copy) NSString *sectionIdentifier;

/**
 section头部标题
 */
@property (nonatomic, copy) NSString *headerTitle;

/**
 section尾部标题
 */
@property (nonatomic, copy) NSString *footerTitle;

/**
 真实的数据源
 */
@property (nonatomic, strong) NSMutableArray *items;

- (instancetype)initWithItemArray:(NSArray *)items;

@end

NS_ASSUME_NONNULL_END
