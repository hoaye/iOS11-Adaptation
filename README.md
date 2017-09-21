

iOS 11适配源码 [Demo地址](https://github.com/stackhou/iOS11-Adaptation)

# 安全区域的适配

用Xcode 9 创建storyboard或者xib时，最低版本支持iOS 8时会报: <font color=Red>Safe Area Layout Guide before iOS 9.0</font> 如图：

![](https://ws4.sinaimg.cn/large/006tNc79ly1fjpyydjr0mj30b103j74n.jpg)

原因：在iOS7中引入的Top Layout Guide和Bottom Layout Guide,这些布局指南在iOS 11中被弃用，取而代之的是Safe Area Layout Guide.

当一个Viewcontroller 被嵌入到UINavigationcontroller 、Tab bar 或者ToolBar  中时, 我们可以使用 `Top Layout Guide` 和 `Bottom Layout Guide` 让 view根 据上下锚点自适应内容。如图：

![](https://ws2.sinaimg.cn/large/006tNc79ly1fjqyr027ykj30im0kkgmb.jpg)

在iOS 11中取而代之的是Safe Area Layout Guide，在iOS11中苹果用单独的Safe Area属性代替了上面的属性.安全区域限制于顶部和底部的锚点。如图：

![](https://ws2.sinaimg.cn/large/006tNc79ly1fjqytaszk5j30in0kujs1.jpg)

解决办法：适配最低支持版本iOS 8，将图中的 Use Safe Area Layout Guide 取消即可

![](https://ws1.sinaimg.cn/large/006tNc79ly1fjqyvinaxlj307605hmxh.jpg)

可以通过一个新的属性：addtionalSafeAreaInsets来改变safeAreaInsets的值，当你的viewController改变了它的safeAreaInsets值时，有两种方式获取到回调：

```objc
UIView.safeAreaInsetsDidChange()
UIViewController.viewSafeAreaInsetsDidChange()
```

# TableView适配

- 首先结构发生了变化：对比

<img src="https://ws4.sinaimg.cn/large/006tNc79ly1fjr7u6y98fj30q50meq5f.jpg" width="470" height="403" />
<img src="https://ws4.sinaimg.cn/large/006tNc79ly1fjr81hjawbj30rj0mddip.jpg" width="470" height="403" />

适配：设置TableView的高度为全屏，会自动适配。

- 有点Eclipse的味道了，遵守代理后，点击fix会自动填充完所需方法

![](https://ws1.sinaimg.cn/large/006tNc79ly1fjqzrpw8fpj30x908amz5.jpg)

自动实现所需方法效果(貌似实现了很多不常用的)：

![](https://ws4.sinaimg.cn/large/006tNc79ly1fjr6zqkptuj30ww0ieae8.jpg)

- 代理方法的优化：

iOS 11之前不设置sectionHeaderView或者sectionFooterView会走设置高度的方法。
iOS 11 如果不实现下面这两个方法，不会走设置高度的方法，即：设置高度失效。

当TableView时分组样式Grouped，设置高度为不等0的很小的数也会失效。所以必须实现下面两个方法和并设置高度。

`- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;`

`- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section`

- iOS 11默认开启了Self-Sizing(在WWDC 2017 session204 Updating Your App for iOS 11 中有介绍)，也是造成上面代理方法优化的问题的根本原因，同时在获取TableView的ContentSize也不再准确的大小。均是UITableViewAutomaticDimension 预估高度造成。

解决办法：

将`estimatedRowHeight`、`estimatedSectionHeaderHeight`、`estimatedSectionFooterHeight`均设置为0，即将默认开启关闭。

# 导航适配

- iOS 11增加了大标题的显示，通过UINavigationBar的prefersLargeTitles属性控制，默认是不开启的。可以忽略不用做适配。

可以通过navigationItem的largeTitleDisplayMode属性控制不同页面大标题的显示，枚举如下：

```objc
typedef NS_ENUM(NSInteger, UINavigationItemLargeTitleDisplayMode) {
	// 默认自动模式依赖上一个 item 的特性
    UINavigationItemLargeTitleDisplayModeAutomatic,
    // 针对当前 item 总是启用大标题特性
    UINavigationItemLargeTitleDisplayModeAlways,
    // Never 
    UINavigationItemLargeTitleDisplayModeNever,
} NS_SWIFT_NAME(UINavigationItem.LargeTitleDisplayMode);
```
- Navigation 集成 UISearchController

把你的UISearchController赋值给navigationItem，就可以实现将UISearchController集成到Navigation。

```objc
navigationItem.searchController  //iOS 11 新增属性
navigationItem.hidesSearchBarWhenScrolling //决定滑动的时候是否隐藏搜索框；iOS 11 新增属性
```

- UINavigationController和滚动交互

滚动的时候，以下交互操作都是由UINavigationController负责调动的：

1. UIsearchController搜索框效果更新
2. 大标题效果的控制
3. Rubber banding效果 //当你开始往下拉，大标题会变大来回应那个滚轮

所以，如果你使用navigation bar，组装push和pop体验，你不会得到searchController的集成、大标题的控制更新和Rubber banding效果，因为这些都是由UINavigationController控制的。

- UIToolbar and UINavigationBar— Layout

在 iOS 11 中，当苹果进行所有这些新特性时，也进行了其他的优化，针对 UIToolbar 和 UINavigaBar 做了新的自动布局扩展支持，自定义的bar button items、自定义的title都可以通过layout来表示尺寸。 需要注意的是，你的constraints需要在view内部设置，所以如果你有一个自定义的标题视图，你需要确保任何约束只依赖于标题视图及其任何子视图。当你使用自动布局，系统假设你知道你在做什么。

- Avoiding Zero-Sized Custom Views

自定义视图的size为0是因为你有一些模糊的约束布局。要避免视图尺寸为0，可以从以下方面做：

1. UINavigationBar 和 UIToolbar 提供位置

2. 开发者则必须提供视图的size，有三种方式：

	a. 对宽度和高度的约束；
	b. 实现 intrinsicContentSize；
	c. 通过约束关联你的子视图；