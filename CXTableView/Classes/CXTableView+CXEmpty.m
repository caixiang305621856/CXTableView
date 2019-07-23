//
//  UITableView+CXEmpty.m
//  CXTableView_Example
//
//  Created by caixiang on 2019/7/23.
//  Copyright © 2019年 caixiang305621856. All rights reserved.
//

#import "CXTableView+CXEmpty.h"
#import <objc/runtime.h>

@implementation CXTableView (CXEmpty)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[self class] cx_swizzleClassMethodWithOriginalSel:@selector(reloadData) newSel:@selector(cx_reloadData)];
        [[self class] cx_swizzleClassMethodWithOriginalSel:@selector(insertSections:withRowAnimation:) newSel:@selector(cx_insertSections:withRowAnimation:)];
        [[self class] cx_swizzleClassMethodWithOriginalSel:@selector(insertRowsAtIndexPaths:withRowAnimation:) newSel:@selector(cx_insertRowsAtIndexPaths:withRowAnimation:)];
        [[self class] cx_swizzleClassMethodWithOriginalSel:@selector(deleteSections:withRowAnimation:) newSel:@selector(cx_deleteSections:withRowAnimation:)];
        [[self class] cx_swizzleClassMethodWithOriginalSel:@selector(deleteRowsAtIndexPaths:withRowAnimation:) newSel:@selector(cx_deleteRowsAtIndexPaths:withRowAnimation:)];
    });
}

+ (BOOL)cx_swizzleClassMethodWithOriginalSel:(SEL)originalSel newSel:(SEL)newSel{
    return [[self class] cx_swizzleMethodWithClass:[self class] originalSel:originalSel newSel:newSel];
}

+ (BOOL)cx_swizzleMethodWithClass:(Class)selfClass originalSel:(SEL)originalSel newSel:(SEL)newSel{
    Method originalMethod = class_getInstanceMethod(selfClass, originalSel);
    Method swizzingMethod = class_getInstanceMethod(selfClass, newSel);
    if (!originalMethod || !swizzingMethod) return NO;
    
    BOOL addSwizzingMethoded = class_addMethod(selfClass, originalSel, method_getImplementation(swizzingMethod), method_getTypeEncoding(swizzingMethod));
    if (addSwizzingMethoded){
        class_replaceMethod(selfClass, newSel, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else{
        method_exchangeImplementations(originalMethod, swizzingMethod);
    }
    return YES;
}

- (void)cx_insertSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation {
    [self cx_insertSections:sections withRowAnimation:animation];
    [self checkData];
}

- (void)cx_deleteSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation {
    [self cx_deleteSections:sections withRowAnimation:animation];
    [self checkData];
}

- (void)cx_insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
    [self cx_insertRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    [self checkData];
}

- (void)cx_deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
    [self cx_deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    [self checkData];
}

- (void)cx_reloadData {
    [self cx_reloadData];
    //忽略第一次加载
    if (![self isInitFinish]) {
        [self setIsInitFinish:YES];
        return;
    }
    [self checkData];
}

- (void)checkData {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self.emptyView) {
            return;
        }
        NSInteger sections = 1;
        if ([self.cxdataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
            sections = [self.cxdataSource numberOfSectionsInTableView:self];
        }
        if (sections == 0){
            [self.emptyView removeFromSuperview];
            [self addSubview:self.emptyView];
        }else {
            if (sections == 1){
                NSInteger rowNumber = [self.cxdataSource tableView:self numberOfRowsInSection:0];
                if (rowNumber == 0){
                    [self.emptyView removeFromSuperview];
                    [self addSubview:self.emptyView];
                } else {
                    [self.emptyView removeFromSuperview];
                }
            }else {
                [self.emptyView removeFromSuperview];
            }
        }
    });
}

static NSString *const CXRegisterEmptyViewKey = @"CXRegisterEmptyViewKey";
static NSString *const CXTableViewPropertyInitFinishKey = @"CXTableViewPropertyInitFinishKey";

- (UIView *)emptyView {
    if ([self.cxdelegate respondsToSelector:@selector(registerEmptyView)]) {
        if (!objc_getAssociatedObject(self, &CXRegisterEmptyViewKey)) {
            objc_setAssociatedObject(self, &CXRegisterEmptyViewKey, [self.cxdelegate registerEmptyView], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        return objc_getAssociatedObject(self, &CXRegisterEmptyViewKey);
    }
    return nil;
}

- (void)setIsInitFinish:(BOOL)finish{
    objc_setAssociatedObject(self, &CXTableViewPropertyInitFinishKey, @(finish), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)isInitFinish{
    id obj = objc_getAssociatedObject(self, &CXTableViewPropertyInitFinishKey);
    return [obj boolValue];
}

@end
