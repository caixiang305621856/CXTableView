//
//  CXDemoAdapter.m
//  CXTableView_Example
//
//  Created by caixiang on 2019/7/21.
//  Copyright © 2019年 caixiang305621856. All rights reserved.
//

#import "CXDemoAdapter.h"
#import "CXDemoItem.h"
#import "CXDemo1Item.h"

@interface CXDemoAdapter()
@property (nonatomic, strong) id data;
@end

@implementation CXDemoAdapter

- (instancetype)initWithData:(id)data{
    self = [super init];
    if (self) {
        self.data = data;
    }
    return self;
}

- (NSString *)cellIdentifier {
    //业务复杂的话还可以子类实现业务分层
    if ([self.data isKindOfClass:[CXDemoItem class]]) {
        CXDemoItem *model =  self.data;
        return model.cellIdentifier;
    } else if ([self.data isKindOfClass:[CXDemo1Item class]]){
        CXDemo1Item *model =  self.data;
        return model.identifier;
    }
    return nil;
}

- (CGFloat)rowHeight {
    if ([self.data isKindOfClass:[CXDemoItem class]]) {
        CXDemoItem *model =  self.data;
        return model.rowHeight;
    } else if ([self.data isKindOfClass:[CXDemo1Item class]]){
        CXDemo1Item *model =  self.data;
        return model.rowHeight;
    }
    return 0;
}

- (NSString *)content {
    if ([self.data isKindOfClass:[CXDemoItem class]]) {
        CXDemoItem *model =  self.data;
        return model.name;
    } else if ([self.data isKindOfClass:[CXDemo1Item class]]){
        CXDemo1Item *model =  self.data;
        return model.contentName;
    }
    return 0;
}

- (NSString*)title{
    if ([self.data isKindOfClass:[CXDemoItem class]]) {
        CXDemoItem *model =  self.data;
        return model.subName;
    } else if ([self.data isKindOfClass:[CXDemo1Item class]]){
        CXDemo1Item *model =  self.data;
        return model.titleName;
    }
    return 0;
}

@end
