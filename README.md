

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

- iOS 11默认开启了Self-Sizing，也是造成上面代理方法优化的问题的根本原因，同时在获取TableView的ContentSize也不再准确的大小。均是UITableViewAutomaticDimension 预估高度造成。

解决办法：

将`estimatedRowHeight`、`estimatedSectionHeaderHeight`、`estimatedSectionFooterHeight`均设置为0，即将默认开启关闭。


