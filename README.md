

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

有点Eclipse的味道了，遵守代理后，点击fix会自动填充完所需方法

![](https://ws1.sinaimg.cn/large/006tNc79ly1fjqzrpw8fpj30x908amz5.jpg)