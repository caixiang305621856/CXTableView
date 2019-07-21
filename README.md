# CXTableView

[![CI Status](https://img.shields.io/travis/caixiang305621856/CXTableView.svg?style=flat)](https://travis-ci.org/caixiang305621856/CXTableView)
[![Version](https://img.shields.io/cocoapods/v/CXTableView.svg?style=flat)](https://cocoapods.org/pods/CXTableView)
[![License](https://img.shields.io/cocoapods/l/CXTableView.svg?style=flat)](https://cocoapods.org/pods/CXTableView)
[![Platform](https://img.shields.io/cocoapods/p/CXTableView.svg?style=flat)](https://cocoapods.org/pods/CXTableView)

# 项目中`MVC`架构存在的问题

## 问题阐述

- VC过于臃肿 业务稍微复杂点就代码量`1000+`
- View与Model之间耦合性太强
- bug不易定位
- 业务更改维护成本很高

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
```
### Delegate
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
NSLog(@"%zd",indexPath.row);
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
//给cell 绑定数据
id<CXTableViewDataSourceProtocol> dataSource = (id<CXTableViewDataSourceProtocol>)self.dataSource;
id object = [dataSource tableView:tableView objectForRowAtIndexPath:indexPath];
[(CXBaseTableViewCell *)cell setItem:object];
//因为CXTableViewDataSourceProtocol 是继承UITableViewDelegate 的 所有这里可以做一层中转
if ([self.cxdelegate respondsToSelector:@selector(tableView:willDisplayCell:forRowAtIndexPath:)]) {
[self.cxdelegate tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
}
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section NS_AVAILABLE_IOS(6_0) {
if([self.cxdelegate respondsToSelector:@selector(tableView:willDisplayHeaderView:forSection:)]) {
[self.cxdelegate tableView:tableView willDisplayHeaderView:view forSection:section];
}
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section NS_AVAILABLE_IOS(6_0) {
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
@protocol CXTableViewControllerDelegate <NSObject>

@required
- (void)configDataSource;
@end

@interface CXTableViewController : UIViewController<CXTableViewDelegateProtocol,CXTableViewControllerDelegate>

@property (nonatomic, strong) CXTableView *tableView;
@property (nonatomic, strong) CXTableViewDataSource *tableViewDataSource;
@property (nonatomic, assign) UITableViewStyle tableViewStyle;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)initWithStyle:(UITableViewStyle)style;

@end
```

用户使用只要做几件事就行

* 首先你需要创建一个继承自
`CXTableViewController` 的视图控制器，并且调用它的
initWithStyle## 方法。

* 实现`CXTableViewDataSource`的子类
```objc
@implementation CXDemoDataSource

//模拟网络请求
- (void)requestDatas:(void(^)(void))loading
succeedHandler:(void(^)(NSString * result))succeedHandler
failHandler:(void(^)(NSString * result))failHandler
completeHandler:(void(^)(void))completeHandler {
!loading?:loading();
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
[self loadData];
!succeedHandler?:succeedHandler(@"请求成功");
!completeHandler?:completeHandler();
});
}

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
@end
```

```objc
@implementation CXDemoViewController

- (void)viewDidLoad {
[super viewDidLoad];
}

//配置
- (void)configDataSource {
CXDemoDataSource *demoDataSource = [[CXDemoDataSource alloc] init];
[self.activityIndicatorView startAnimating];
[demoDataSource requestDatas:^{
NSLog(@"正在加载");
} succeedHandler:^(NSString * _Nonnull result) {
NSLog(@"加载成功");
[self.tableView reloadData];
} failHandler:^(NSString * _Nonnull result) {
} completeHandler:^{
[self.activityIndicatorView stopAnimating];
}];
self.tableViewDataSource = demoDataSource;
}

```

到目前为止，我们实现了对`UITableView`以及相关协议、方法的封装，使它更容易使用，避免了很多重复、无意义的代码。
M 只关心数据
C 只负责调度
V 只负责展示数据

demo地址：[轻量级UITableView的封装](https://github.com/caixiang305621856/CXTableView)

参照链接： [如何写好一个 UITableView](https://github.com/bestswifter/blog/blob/master/articles/ios-tableview.md) 











