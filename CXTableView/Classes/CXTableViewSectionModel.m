//
//  CXTableViewSectionModel.m
//  CXTableView_Example
//
//  Created by caixiang on 2019/7/20.
//  Copyright © 2019年 caixiang305621856. All rights reserved.
//

#import "CXTableViewSectionModel.h"

@implementation CXTableViewSectionModel
- (instancetype)init {
    self = [super init];
    if (self) {
        self.sectionIdentifier = @"";
        self.headerTitle = @"";
        self.footerTitle = @"";
        self.items = [NSMutableArray array];
    }
    return self;
}

- (instancetype)initWithItemArray:(NSArray *)items {
    self = [self init];
    if (self) {
        [self.items addObjectsFromArray:items];
    }
    return self;
}

@end
