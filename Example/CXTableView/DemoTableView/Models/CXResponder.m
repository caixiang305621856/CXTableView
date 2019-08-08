//
//  CXResponder.m
//  CXTableView_Example
//
//  Created by caixiang on 2019/7/25.
//  Copyright © 2019年 caixiang305621856. All rights reserved.
//

#import "CXResponder.h"

@implementation CXResponder

/**
 责任链入口

 @param resultBlock 处理责任链的回调
 */
- (void)handle:(void (^)(CXResponder *responder,BOOL handled))resultBlock {
    void (^completionBlock)(BOOL handled) = ^(BOOL handled){
        if (handled) {
            //当前处理掉了 上抛结果
            !resultBlock?:resultBlock(self,handled);
        } else {
            if (self.nextResponder) {
                [self.nextResponder handle:resultBlock];
            } else{
                !resultBlock?:resultBlock(nil,NO);
            }
        }
    };
    //当前业务进行处理
    [self handBusiness:completionBlock];
}

- (void)handBusiness:(void (^)(BOOL handled))completionBlock {
    //业务1
    //业务2
    //业务3
    //业务4
    !completionBlock?:completionBlock(self.handled);
}

@end
