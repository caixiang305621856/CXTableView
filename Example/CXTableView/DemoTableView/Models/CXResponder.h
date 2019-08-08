//
//  CXResponder.h
//  CXTableView_Example
//
//  Created by caixiang on 2019/7/25.
//  Copyright © 2019年 caixiang305621856. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CXResponder : NSObject

@property (assign, nonatomic) BOOL handled;
@property (copy, nonatomic) NSString *responderName;

@property (strong, nonatomic) CXResponder *nextResponder;

- (void)handle:(void (^)(CXResponder *responder,BOOL handled))resultBlock;

@end

NS_ASSUME_NONNULL_END
