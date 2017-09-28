

iOS 11适配源码 [简书地址](http://www.jianshu.com/p/de19e9cda481)

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

如果你的APP中是自定义的Navigationbar，隐藏掉系统的Navigationbar，并且tableView的frame为(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)开始，那么系统会自动调整SafeAreaInsets值为(20,0,0,0)，如果使用了系统的navigationbar，那么SafeAreaInsets值为(64,0,0,0)，如果也使用了系统的tabbar，那么SafeAreaInsets值为(64,0,49,0)


# UIScrollView、UITableView、UICollectionView适配

## UITableView

Tableview莫名奇妙的偏移20pt或者64pt, 原因是iOS11弃用了automaticallyAdjustsScrollViewInsets属性，取而代之的是UIScrollView新增了contentInsetAdjustmentBehavior属性，这一切的罪魁祸首都是新引入的safeArea

适配：

```objc
// 定义宏
#define  adjustsScrollViewInsets(scrollView)\
do {\
_Pragma("clang diagnostic push")\
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")\
if ([scrollView respondsToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) {\
    NSMethodSignature *signature = [UIScrollView instanceMethodSignatureForSelector:@selector(setContentInsetAdjustmentBehavior:)];\
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];\
    NSInteger argument = 2;\
    invocation.target = scrollView;\
    invocation.selector = @selector(setContentInsetAdjustmentBehavior:);\
    [invocation setArgument:&argument atIndex:2];\
    [invocation retainArguments];\
    [invocation invoke];\
}\
_Pragma("clang diagnostic pop")\
} while (0)
```
如果你使用了Masonry，那么你需要适配safeArea

```objc
if (@available(iOS 11.0, *)) {
    make.edges.equalTo()(self.view.safeAreaInsets)
} else {
    make.edges.equalTo()(self.view)
}
```

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

## UIScrollView
- scrollView在iOS11新增的两个属性：`adjustContentInset` 和 `contentInsetAdjustmentBehavior`。

`adjustContentInset`表示contentView.frame.origin偏移了scrollview.frame.origin多少；是系统计算得来的，计算方式由contentInsetAdjustmentBehavior决定。有以下几种枚举计算方式：

1. `UIScrollViewContentInsetAdjustmentAutomatic`：如果scrollview在一个automaticallyAdjustsScrollViewContentInset = YES 的controller上，并且这个Controller包含在一个Navigation controller中，这种情况下会设置在top & bottom上 adjustedContentInset = safeAreaInset + contentInset不管是否滚动。其他情况下与UIScrollViewContentInsetAdjustmentScrollableAxes相同

2. `UIScrollViewContentInsetAdjustmentScrollableAxes`: 在可滚动方向上adjustedContentInset = safeAreaInset + contentInset，在不可滚动方向上adjustedContentInset = contentInset；依赖于scrollEnabled和alwaysBounceHorizontal / Vertical = YES，scrollEnabled默认为YES，所以大多数情况下，计算方式还是adjustedContentInset = safeAreaInset + contentInset

3. `UIScrollViewContentInsetAdjustmentNever`: 这种方式下adjustedContentInset = contentInset

4. `UIScrollViewContentInsetAdjustmentAlways`: 这种方式下会这么计算 adjustedContentInset = safeAreaInset + contentInset

当`contentInsetAdjustmentBehavior`设置为UIScrollViewContentInsetAdjustmentNever的时候，adjustContentInset值不受SafeAreaInset值的影响。

## 解决办法总结

### 重新设置tableView的contentInset值，来抵消掉SafeAreaInset值

因为内容下移偏移量 = contentInset + SafeAreaInset，如果之前自己设置了contentInset值为(64,0,0,0),现在系统又设置了SafeAreaInsets值为(64,0,0,0)，那么tableView内容下移了64pt，这种情况下，可以设置contentInset值为(0,0,0,0)，也就是遵从系统的设置了。

### 设置tableView的contentInsetAdjustmentBehavior属性

`contentInsetAdjustmentBehavior`属性也是用来取代`automaticallyAdjustsScrollViewInsets`属性的，推荐使用这种方式
如果不需要系统为你设置边缘距离，可以做以下设置：

```objc
//如果iOS的系统是11.0，会有这样一个宏定义“#define __IPHONE_11_0  110000”；如果系统版本低于11.0则没有这个宏定义
#ifdef __IPHONE_11_0   
if ([tableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
    tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
}
#endif
```
### 通过设置iOS 11新增的属性addtionalSafeAreaInset

iOS 11之前，通过将Controller的automaticallyAdjustsScrollViewInsets属性设置为NO，来禁止系统对tableView调整contentInsets的。如果还是想从Controller级别解决问题，那么可以通过设置Controller的additionalSafeAreaInsets属性，如果SafeAreaInset值为(20,0,0,0)，那么设置additionalSafeAreaInsets属性值为(-20,0,0,0)，则SafeAreaInsets不会对adjustedContentInset值产生影响，tableView内容不会显示异常。这里需要注意的是addtionalSafeAreaInset是Controller的属性，要知道SafeAreaInset的值是由哪个Controller引起的，可能是由自己的Controller调整的，可能是navigationController调整的。是由哪个Controller调整的，则设置哪个Controller的addtionalSafeAreaInset值来抵消掉SafeAreaInset值。

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
	
# 导航栏

## 导航栏高度的变化

iOS11之前导航栏默认高度为64pt(statusBar + NavigationBar)，iOS11之后如果设置了prefersLargeTitles = YES则为96pt，默认情况下还是64pt，但在iPhoneX上由于刘海的出现statusBar由以前的20pt变成了44pt，所以iPhoneX上高度变为88pt，如果项目里隐藏了导航栏加了自定义按钮之类的，注意适配一下。

## 导航栏图层及对titleView布局的影响

iOS11之前导航栏的title是添加在`UINavigationItemView上面，而navigationBarButton则直接添加在UINavigationBar上面，如果设置了titleView，则titleView也是直接添加在UINavigationBar上面。

![](https://ws1.sinaimg.cn/large/006tNc79ly1fjs72xxjecj30bn069dgq.jpg)
![](https://ws1.sinaimg.cn/large/006tNc79ly1fjs718e860j30be0a3abe.jpg)

iOS11之后，大概因为largeTitle的原因，视图层级发生了变化，如果没有给titleView赋值，则titleView会直接添加在_UINavigationBarContentView上面，如果赋值了titleView，则会把titleView添加在_UITAMICAdaptorView上，而navigationBarButton被加在了_UIButtonBarStackView上，然后他们都被加在了_UINavigationBarContentView上

![](https://ws1.sinaimg.cn/large/006tNc79ly1fjs78ugjhaj30bn05qq3p.jpg)
![](https://ws2.sinaimg.cn/large/006tNc79ly1fjs7g6bqotj30bb0b075t.jpg)

如果你的项目是自定义的navigationBar，那么在iOS11上运行就可能出现布局错乱的bug，解决办法是重写UINavigationBar的layoutSubviews方法，调整布局：

```objc
- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 注意导航栏及状态栏高度适配
    self.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), naviBarHeight);
    for (UIView *view in self.subviews) {
        if([NSStringFromClass([view class]) containsString:@"Background"]) {
            view.frame = self.bounds;
        }else if ([NSStringFromClass([view class]) containsString:@"ContentView"]) {
            CGRect frame = view.frame;
            frame.origin.y = statusBarHeight;
            frame.size.height = self.bounds.size.height - frame.origin.y;
            view.frame = frame;
        }
    }
}
```

titleView支持autolayout，这要求titleView必须是能够自撑开的或实现了- intrinsicContentSize方法：

```objc
- (CGSize)intrinsicContentSize {
    return UILayoutFittingExpandedSize;
}
```

# TabBarController

主要是tabBar高度及tabBarItem偏移适配，iPhoneX由于底部安全区的原因UITabBar高度由49pt变成了83pt，可以通过判断机型来修改相关界面代码：

```objc
// UIDevice 分类
- (BOOL)isIPhoneX{
    if ([UIScreen instancesRespondToSelector:@selector(currentMode)]) {
        return CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size);
    }else{
        return NO;
    }
}
```

# 其他适配注意事项

部分项目的轮播图在iOS 11+Xcode编译的情况下，会出现是上下左右任意滚动的bug，推荐使用 YJBannerView轮播图，完全适配iOS 11。Github地址：[YJBannerView](https://github.com/stackhou/YJBannerViewOC)
