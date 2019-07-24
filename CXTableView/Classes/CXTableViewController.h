//
//  CXTableViewController.h
//  CXTableView_Example
//
//  Created by caixiang on 2019/7/20.
//  Copyright © 2019年 caixiang305621856. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXTableView.h"

@class CXTableViewDataSource;
NS_ASSUME_NONNULL_BEGIN
@protocol CXTableViewControllerDelegate <NSObject>

@required
- (void)configCXDataSource;
@optional
- (void)configCXDelegate;
@end

@interface CXTableViewController : UIViewController<CXTableViewDelegateProtocol,CXTableViewControllerDelegate>

@property (nonatomic, strong) CXTableView *tableView;
@property (nonatomic, strong) CXTableViewDataSource *tableViewDataSource;
@property (nonatomic, assign) UITableViewStyle tableViewStyle;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)initWithStyle:(UITableViewStyle)style;

@end

NS_ASSUME_NONNULL_END
