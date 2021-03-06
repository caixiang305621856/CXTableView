//
//  CXTableView.m
//  CXTableView_Example
//
//  Created by caixiang on 2019/7/20.
//  Copyright © 2019年 caixiang305621856. All rights reserved.
//

#import "CXTableView.h"
#import "CXTableViewDataSource.h"
#import "CXBaseTableViewCell.h"

@implementation CXTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.autoresizingMask =  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.showsVerticalScrollIndicator = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.sectionHeaderHeight = 0;
        self.sectionFooterHeight = 0;
        self.delegate = self;
        self.estimatedRowHeight = 0;
        self.estimatedSectionHeaderHeight = 0;
        self.estimatedSectionFooterHeight = 0;
        self.isNeedPullDownToRefresh = NO;
        self.isNeedPullUpToRefresh = NO;
        self.autoPullDownToRefresh = NO;
#ifdef __IPHONE_11_0
        if (@available(iOS 11.0, *)) {
            [self setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
        }
#endif
    }
    return self;
}

-(void)setIsNeedPullDownToRefresh:(BOOL)isNeedPullDownToRefresh {
    if (_isNeedPullDownToRefresh == isNeedPullDownToRefresh) {
        return;
    }

    _isNeedPullDownToRefresh = isNeedPullDownToRefresh;
    __block typeof(self) weakSelf = self;
    if (_isNeedPullDownToRefresh) {
        [self addPullToRefreshWithActionHandler:^{
            if ([weakSelf.cxdelegate respondsToSelector:@selector(pullDownToRefresh)]) {
                [weakSelf.cxdelegate pullDownToRefresh];
            }
        }];
        [self.pullToRefreshView setTitle:@"松开刷新" forState:SVPullToRefreshStateTriggered];
        [self.pullToRefreshView setTitle:@"下拉刷新" forState:SVPullToRefreshStateStopped];
        [self.pullToRefreshView setTitle:@"正在加载" forState:SVPullToRefreshStateLoading];
    }
}

- (void)setIsNeedPullUpToRefresh:(BOOL)isNeedPullUpToRefresh {
    if (_isNeedPullUpToRefresh == isNeedPullUpToRefresh) {
        return;
    }
    _isNeedPullUpToRefresh = isNeedPullUpToRefresh;
    __block typeof(self) weakSelf = self;
    if (_isNeedPullUpToRefresh) {
        [self addInfiniteScrollingWithActionHandler:^{
            if ([weakSelf.cxdelegate respondsToSelector:@selector(pullUpToRefresh)]) {
                [weakSelf.cxdelegate pullUpToRefresh];
            }
        }];
    }
}

- (void)setLoadCompleted:(BOOL)loadCompleted {
    if (_loadCompleted == loadCompleted || self.isNeedPullUpToRefresh == NO) {
        return;
    }
    _loadCompleted = loadCompleted;
    if (loadCompleted) {
        UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60)];
        NSString *noMoreText = @"没有更多数据了";
        UIFont *font = [UIFont systemFontOfSize:14];
        UILabel *desLabel = [[UILabel alloc]initWithFrame:bottomView.bounds];
        desLabel.textColor = UIColorFromRGBA(0xA0A0A0,1);
        desLabel.textAlignment = NSTextAlignmentCenter;
        desLabel.font = font;
        desLabel.text = noMoreText;
        [bottomView addSubview:desLabel];
        [self.infiniteScrollingView setCustomView:bottomView forState:SVInfiniteScrollingStateStopped];
    }
    self.infiniteScrollingView.enabled = !loadCompleted;
}

- (void)stopRefreshingAnimation {
    [self.pullToRefreshView stopAnimating];
    [self.infiniteScrollingView stopAnimating];
}

- (void)triggerRefreshing {
    [self.infiniteScrollingView stopAnimating];
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<CXTableViewDataSourceProtocol> dataSource = (id<CXTableViewDataSourceProtocol>)self.dataSource;
    id object = [dataSource tableView:tableView objectForRowAtIndexPath:indexPath];
    /*
     理论上现在已经知道了高度，但由于object是id类型
     需要子类提前异步计算好返回
     如果子类没有计算，则认为这里是固定高度，可由Cell自己配置
     */
    Class cls = [dataSource tableView:tableView cellClassForObject:object];
    return [dataSource rowHeightForObject:object] > 0?[dataSource rowHeightForObject:object]:[cls rowHeightForItem:object];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.cxdelegate && [self.cxdelegate respondsToSelector:@selector(didSelectObject:atIndexPath:)]) {
        id<CXTableViewDataSourceProtocol> dataSource = (id<CXTableViewDataSourceProtocol>)self.dataSource;
        id object = [dataSource tableView:tableView objectForRowAtIndexPath:indexPath];
        [self.cxdelegate didSelectObject:object atIndexPath:indexPath];
    } else if([self.cxdelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [self.cxdelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    id<CXTableViewDataSourceProtocol> dataSource = (id<CXTableViewDataSourceProtocol>)self.dataSource;
    id object = [dataSource tableView:tableView objectForRowAtIndexPath:indexPath];
    //给cell 绑定数据
    [(CXBaseTableViewCell *)cell setItem:object];
    if ([self.cxdelegate respondsToSelector:@selector(tableView:willDisplayCell:forRowAtIndexPath:)]) {
        [self.cxdelegate tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if([self.cxdelegate respondsToSelector:@selector(tableView:willDisplayHeaderView:forSection:)]) {
        [self.cxdelegate tableView:tableView willDisplayHeaderView:view forSection:section];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    if([self.cxdelegate respondsToSelector:@selector(tableView:willDisplayFooterView:forSection:)]) {
        [self.cxdelegate tableView:tableView willDisplayFooterView:view forSection:section];
    }
}

// 后续还可以继续添加代理 或者自己定义子类去实现 中转传递

#pragma mark - set&get
- (void)setCxdataSource:(id<CXTableViewDataSourceProtocol>)cxdataSource {
    if(_cxdataSource != cxdataSource) {
        _cxdataSource = cxdataSource;
        self.dataSource = cxdataSource;
    }
}

UIKIT_STATIC_INLINE UIColor *UIColorFromRGBA(uint32_t rgbValue, CGFloat a) {
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0f
                           green:((float)((rgbValue & 0xFF00) >> 8))/255.0f
                            blue:((float)(rgbValue & 0xFF))/255.0f
                           alpha:a];
}

@end
