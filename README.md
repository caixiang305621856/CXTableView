# CXTableView
[CI Status](https://travis-ci.org/caixiang305621856/CXTableView)
[Version](https://cocoapods.org/pods/CXTableView)
[License](https://cocoapods.org/pods/CXTableView)
[Platform](https://cocoapods.org/pods/CXTableView)

# 项目中`MVC`架构存在的问题

## 效果预览
![CXTableView.gif](https://upload-images.jianshu.io/upload_images/1767433-bb53ccfd3ea336e1.gif?imageMogr2/auto-orient/strip)

## 问题阐述

* VC过于臃肿 业务稍微复杂点就代码量`1000+`
* View与Model之间耦合性太强
* bug不易定位
* 业务更改维护成本很高

基于这些问题我们就以一个`UITableView`的列表来进行阐述首先要弄明白 `MVC` 的核心：控制器（以下简称 C）负责模型（以下简称 M）和视图（以下简称 V）的交互。

这里所说的 M，通常不是一个单独的类，很多情况下它是由多个类构成的一个层。最上层的通常是以 Model 结尾的类，它直接被 C 持有。

## 项目版本
在 C 中，我们创建 UITableView 对象，然后将它的数据源和代理设置为自己。也就是自己管理着 UI 逻辑和数据存取的逻辑。在这种架构下，主要存在这些问题：

* 违背 MVC 模式，现在是 V 持有 C 和 M。
* C 做了全部逻辑，耦合太严重。

### DataSource
首先实现一个tableView 我们要实现两个数据源方法

```objc
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
```### Delegate
这里包含一些点击代理，高度返回以及一系列的头部尾部视图的配置，以及`cell`绘制UI的操作
```objc
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath；

```

## 进阶版本
首先的思路是单独把数据源方法抽离出去，单独实现
这里我打算用到`一个遵循UITableViewDataSource的协议`和一个`单独的数据源类`(需要遵循自定义的协议)来实现
结合前面数遇见的传统`DataSource`问题我们可以思考下这个协议api应该怎么设计

```objc
@protocol CXTableViewDataSourceProtocol <UITableViewDataSource>
@optional

- (Class)tableView:(UITableView*)tableView cellClassForObject:(id)object;
- (UITableViewCell *)registerTableView:(UITableView*)tableView cellClassForObject:(id)object;
- (id)tableView:(UITableView *)tableView objectForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)rowHeightForObject:(id)object;

@end
```

* 拿带数据源做对应的事
* 注册cell类型支持多种样式的cell
* 配置cell的高度

再自定义一个遵循`CXTableViewDataSourceProtocol`的数据源类

```objc
@interface CXTableViewDataSource : NSObject<CXTableViewDataSourceProtocol>

/**
包装setion 是个二维数组
*/
@property (nonatomic, strong) NSMutableArray <CXTableViewSectionModel *>*sections;

- (void)reamoveAllItems;

- (void)addItem:(id)item;

- (void)addItem:(id)item section:(NSInteger)section;

- (id)loadFromXib:(NSString *)class_name;

@end
```
内部只需要做好协议实现,部分协议方法以让子类实现的方式暴露给给外界调用，这里我包含了一个设置高度的协议在数据源方法里，这主要是考虑到用户在使用的时候，很多的时候我们的高度并不是固定的，理论上应该配置高度的地方是cell它自己本身，因为涉及UI，目前同样开放了cell设置高度的接口，但协议的高度接口优先级要高于cell配置的接口，使用者只需要在`CXTableViewDataSource`的子类中去处理数据

```objc
#pragma mark - CXTableViewDataSourceProtocol
- (id)tableView:(UITableView *)tableView objectForRowAtIndexPath:(NSIndexPath *)indexPath {
if (self.sections.count > indexPath.section) {
CXTableViewSectionModel *tableViewSectionModel = [self.sections objectAtIndex:indexPath.section];
if ([tableViewSectionModel.items count] > indexPath.row) {
return [tableViewSectionModel.items objectAtIndex:indexPath.row];
}
}
return nil;
}

- (UITableViewCell *)registerTableView:(UITableView*)tableView cellClassForObject:(id)object {
//子类实现
Class cellClass = [self tableView:tableView cellClassForObject:object];
NSString *className = [NSString stringWithUTF8String:class_getName(cellClass)];
return [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:className];
}

- (Class)tableView:(UITableView*)tableView cellClassForObject:(id)object {
//子类实现
return [CXBaseTableViewCell class];
}

- (CGFloat)rowHeightForObject:(id)object {
//子类实现
return 0;
}

```

具体的代理全部交由`CXTableViewDataSource`来处理
```objc
#pragma mark - UITableViewDataSource Required
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
if (self.sections.count > section) {
CXTableViewSectionModel *tableViewSectionModel =  [self.sections objectAtIndex:section];
return tableViewSectionModel.items.count;
}
return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//通过获得数据来确定Cell的样式
id object = [self tableView:tableView objectForRowAtIndexPath:indexPath];
Class cellClass = [self tableView:tableView cellClassForObject:object];
NSString *className = [NSString stringWithUTF8String:class_getName(cellClass)];
CXBaseTableViewCell* cell = (CXBaseTableViewCell*)[tableView dequeueReusableCellWithIdentifier:className];
if (!cell) {
cell = (CXBaseTableViewCell *)[self registerTableView:tableView cellClassForObject:object];
}
return cell;
}

#pragma mark - UITableViewDataSource Optional
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
return self.sections ? self.sections.count : 0;
}
```
现在`dataSource`的数据源代理已全部交由`CXTableViewDataSource`来处理

现在就只剩另外一个问题，那就是`delegate`的抽离，这里的处理方式稍微和`dataSource`的处理方式有些不同，`dataSource`的代理对象是一个我们自定义的`CXTableViewDataSource`对象,而`delegate`的代理对象，我们用`CXTableView`一个继承UITableView的子类，首先首先设置一个`CXTableViewDelegateProtocol`

```objc
@protocol CXTableViewDelegateProtocol <UITableViewDelegate>

@optional

- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath*)indexPath;

@end
```

`CXTableViewDelegateProtocol`协议是继承`UITableViewDelegate`，之说以这样是为了好让`CXTableView`作为一个中间桥接的作用，在系统的代理上层去处理自己的业务的前提下不影响系统的代理，和runtime交换方法有点异曲同工之妙

```objc
//.h
@interface CXTableView : UITableView<UITableViewDelegate>

@property (nonatomic, weak) id<CXTableViewDataSourceProtocol> cxdataSource;
@property (nonatomic, weak) id<CXTableViewDelegateProtocol> cxdelegate;

@end
```

```objc
//.m
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

```

另外给cell 绑定数据的逻辑我放在了`- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath` 方法里，而并没有放在`- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath` 方法中
这是因为cellForRowAtIndexPath做的事情其实就在绑定Cell类型，而willDisplayCell方法中是Cell已经绘制出来了，这会添加数据再合适不过，包括前面提到的Cell设置高度接口这里也做了对应的说明
至此，对`CXTableView`的基本封装就完成了，但远不仅仅是这些

* 下拉刷新
* 空白页
* 带动画的loading页（知乎，简书那种）
* 等等...

这些东西都是业务开发中比较常见的场景 此篇文章中这里就没有进一步封装了（时间问题）思想最重要，要明白为什么这么去抽离，面向接口协议开发

## 完结版本
基于使用层面的考虑， 我们实现一个UIViewController的子类，并且把数据源和代理封装到 C 中

```objc
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
```

用户使用只要做几件事就行

* 首先你需要创建一个继承自
`CXTableViewController` 的视图控制器，并且调用它的
initWithStyle## 方法。

* 实现`CXTableViewDataSource`的子类

```objc
@implementation CXDemoDataSource

- (void)loadData {
//业务数据处理  这里还可以抽离出一个p层
NSArray *cellIdentifers = @[NSStringFromClass([CXDemo1TableViewCell class]),NSStringFromClass([CXDemoTableViewCell class])];
NSMutableArray *items = [@[] mutableCopy];
id<ContentViewAdapterProtocol> demoAdapter;
for (NSInteger i = 0; i < 40; i ++) {
if (i%5 > 2) {
CXDemoItem *item = [CXDemoItem new];
item.cellIdentifier = cellIdentifers[i%2];
item.rowHeight = 150;
item.name = item.cellIdentifier;
item.subName = [NSString stringWithFormat:@"%zd",i];
demoAdapter = [[CXDemoAdapter alloc] initWithData:item];
} else{
CXDemo1Item *item = [CXDemo1Item new];
item.identifier = cellIdentifers[i%2];
item.rowHeight = 70;
item.contentName = item.identifier;
item.titleName = [NSString stringWithFormat:@"%zd",i];
demoAdapter = [[CXDemoAdapter alloc] initWithData:item];
}
[items addObject:demoAdapter];
}
CXTableViewSectionModel *sectionModel = [[CXTableViewSectionModel alloc] initWithItemArray:items];
self.sections = [NSMutableArray arrayWithObject:sectionModel];
}

#pragma mark - CXTableViewDataSourceProtocol
//注册cell类型
- (UITableViewCell *)registerTableView:(UITableView*)tableView cellClassForObject:(id<ContentViewAdapterProtocol>)object {
return [self loadFromXib:object.cellIdentifier];
}

//确立Cell的类型
- (Class)tableView:(UITableView *)tableView cellClassForObject:(id<ContentViewAdapterProtocol>)object {
return [NSClassFromString(object.cellIdentifier) class];
}

//异步计算好高度
- (CGFloat)rowHeightForObject:(id<ContentViewAdapterProtocol>)object {
return object.rowHeight;
}

```

VC的调用就更简单了 在这里我把 `self.tableView.cxdelegate = self.demoTableViewDelegate`;
```objc
@interface CXDemoViewController ()

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView ;
@property (strong, nonatomic) CXDemoDataSource *demoDataSource;
@property (strong, nonatomic) CXDemoTableViewDelegate *demoTableViewDelegate;

@end

@implementation CXDemoViewController

- (void)viewDidLoad {
[super viewDidLoad];
self.navigationItem.title = @"CXTableView";
UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"数据加载失败" style:UIBarButtonItemStylePlain target:self action:@selector(failClick)];
[self.navigationItem setRightBarButtonItem:item];
self.tableView.isNeedPullUpToRefresh = YES;
self.tableView.isNeedPullDownToRefresh = YES;
self.tableView.autoPullDownToRefresh = YES;
}

#pragma mark - CXTableViewControllerDelegate
- (void)configCXDataSource {
//设置数据源
self.tableViewDataSource = self.demoDataSource;
}

- (void)configCXDelegate {
//设置代理
self.tableView.cxdelegate = self.demoTableViewDelegate;
}

#pragma mark - action
- (void)failClick {
[self.tableViewDataSource reamoveAllItems];
[self.tableView reloadData];
}

#pragma mark - set&get
- (CXDemoDataSource *)demoDataSource{
if (!_demoDataSource) {
_demoDataSource = [[CXDemoDataSource alloc] init];
}
return _demoDataSource;
}

- (CXDemoTableViewDelegate *)demoTableViewDelegate{
if (!_demoTableViewDelegate) {
_demoTableViewDelegate = [[CXDemoTableViewDelegate alloc] init];
_demoTableViewDelegate.tableView = self.tableView;
_demoTableViewDelegate.demoDataSource = self.demoDataSource;
}
return _demoTableViewDelegate;
}

@end

```

`self.demoTableViewDelegate` 就比较贴近各自的项目逻辑

到目前为止，我们实现了对`UITableView`以及相关协议、方法的封装，使它更容易使用，避免了很多重复、无意义的代码。
M 只关心数据
C 只负责调度 配置
V 只负责展示数据

`self.demoTableViewDelegate` 可以把一些复杂的业务逻辑，它直接和`CXDemoDataSource`通信 如果业务再复杂点，还可用`self.demoTableViewDelegate`的分类来处理业务分类

## 补充版本
* 下拉刷新的封装

上次提到过的下拉刷新的封装，以及空白页的处理，因为这些从属性构造来讲，它们应该都属于TableView，所以我这边还是基于`CXTableViewDelegateProtocol`,给它增加协议方法

```objc
@protocol CXTableViewDelegateProtocol <UITableViewDelegate>

@optional

/**
cell点击的回调

@param object 对象
@param indexPath 索引
*/
- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath*)indexPath;

/**
空白占位

@return 空白占位图
*/
- (UIView *)registerEmptyView;

/**
下拉刷新触发的方法
*/
- (void)pullDownToRefresh;

/**
上拉加载触发的方法
*/
- (void)pullUpToRefresh;

@end
```

再给CXTableView 增加4个属性 两个关闭动画的方法

```objc
@interface CXTableView : UITableView<UITableViewDelegate>

@property (nonatomic, weak) id<CXTableViewDataSourceProtocol> cxdataSource;
@property (nonatomic, weak) id<CXTableViewDelegateProtocol> cxdelegate;

@property (nonatomic, assign) BOOL isNeedPullDownToRefresh;
@property (nonatomic, assign) BOOL isNeedPullUpToRefresh;
@property (assign, nonatomic) BOOL autoPullDownToRefresh;
@property (assign, nonatomic) BOOL loadCompleted;

- (void)stopRefreshingAnimation;
- (void)triggerRefreshing;

@end
```

这边下拉刷新控件我选择的是`SVPullToRefresh`比较轻量级,其中内部有两个BUG,在源码层级上给它做了修改

```objc
#import "UIScrollView+SVPullToRefresh.h"
- (void)startAnimating{
switch (self.position) {
case SVPullToRefreshPositionTop:
//bug 修复 设置了偏移量后 不能自动刷新的问题
if(fequalzero(self.scrollView.contentOffset.y) + self.originalTopInset) {
[self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, - self.frame.size.height - self.originalTopInset) animated:YES];
self.wasTriggeredByUser = NO;
}
else
self.wasTriggeredByUser = YES;

break;
case SVPullToRefreshPositionBottom:

if((fequalzero(self.scrollView.contentOffset.y) && self.scrollView.contentSize.height < self.scrollView.bounds.size.height)
|| fequal(self.scrollView.contentOffset.y, self.scrollView.contentSize.height - self.scrollView.bounds.size.height)) {
[self.scrollView setContentOffset:(CGPoint){.y = MAX(self.scrollView.contentSize.height - self.scrollView.bounds.size.height, 0.0f) + self.frame.size.height} animated:YES];
self.wasTriggeredByUser = NO;
}
else
self.wasTriggeredByUser = YES;

break;
}
self.state = SVPullToRefreshStateLoading;
}
```

```objc
#import "UIScrollView+SVInfiniteScrolling.h"
id customView = [self.viewForState objectAtIndex:newState];
BOOL hasCustomView = [customView isKindOfClass:[UIView class]];

if(hasCustomView) {
[self addSubview:customView];
CGRect viewBounds = [customView bounds];
CGPoint origin = CGPointMake(roundf((self.bounds.size.width-viewBounds.size.width)/2), roundf((self.bounds.size.height-viewBounds.size.height)/2));
[customView setFrame:CGRectMake(origin.x, origin.y, viewBounds.size.width, viewBounds.size.height)];
//bug 解决设置了自定义View SVInfiniteScrollingStateStopped状态后的 菊花不消失的问题
switch (newState) {
case SVInfiniteScrollingStateStopped:
[self.activityIndicatorView stopAnimating];
break;
}
}
```

原有的下拉刷新箭头不精细，比较喜欢简书那样的下拉刷新，所有就画过了一个箭头

```objc
#pragma mark - SVPullToRefreshArrow

@implementation SVPullToRefreshArrow
@synthesize arrowColor;

- (UIColor *)arrowColor {
if (arrowColor) return arrowColor;
return [UIColor lightGrayColor]; // default Color
}

- (void)drawRect:(CGRect)rect {
CGContextRef c = UIGraphicsGetCurrentContext();
CGContextMoveToPoint(c, 11, 20);
CGContextAddLineToPoint(c, 11, 35);
CGContextMoveToPoint(c, 6, 30);
CGContextAddLineToPoint(c, 11, 35);
CGContextAddLineToPoint(c, 16, 30);
CGContextSetLineWidth(c, 0.8);
CGContextSetStrokeColorWithColor(c, self.arrowColor.CGColor);
CGContextSetLineCap(c, kCGLineCapRound);
CGContextDrawPath(c, kCGPathStroke);
}

@end
```

使用层面很简单, 后续如果想换`MJ`也可以改`CXTableView`的实现，外界调用不用动

```objc
- (void)pullDownToRefresh {
//模拟网络请求
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
[self.demoDataSource loadData];
[self.tableView setLoadCompleted:NO];
[self.tableView stopRefreshingAnimation];
[self.tableView reloadData];
});
}


- (void)pullUpToRefresh {
//模拟网络请求
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
[self.demoDataSource loadMoreData];
[self.tableView setLoadCompleted:YES];
[self.tableView triggerRefreshing];
[self.tableView reloadData];
});
}
```

* 空白页的封装

主要是针对`CXTableView`实现了一个`CXTableView+CXEmpty`分类
主要思路是针对`CXTableView` 刷新数据方法进行交换

```objc
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

```

空白页的配置完全交给了外界,只要实现代理即可,这里还做了一个首次拿数据的时候不检测空白页，因为`tableView`在一开始不配置数据的时候，就会主动触发一次`reloadData`方法

demo地址：[轻量级UITableView的封装](https://github.com/caixiang305621856/CXTableView)

参照链接： [如何写好一个 UITableView](https://github.com/bestswifter/blog/blob/master/articles/ios-tableview.md)

