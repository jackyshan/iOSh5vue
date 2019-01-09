
 iOS内实现h5原生开发

![](https://upload-images.jianshu.io/upload_images/301129-68cf18d5d54faf90.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### 介绍

Xcode可以直接引入h5的界面，实现原生界面内嵌h5开发。其实这里不止iOS可以这样做，安卓也可以引用同样的h5界面，实现界面使用同一份h5代码。

为什么要写h5的界面呢，原因是第一Xcode很卡，画图效果也不如h5方便。第二是调试h5直接通过浏览器调试就行了，不像Xcode每次编译跑起来真是卡的一批，时间又长。
所以我就研究了这一套本地h5开发的逻辑，既能很好的实现业务逻辑的开发，又能方便开发，统一多端，效率大大提升。

步骤如下

![](https://upload-images.jianshu.io/upload_images/301129-151e4006ead9d4c4.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

把目录导入到Xcode中，选择Create folder references点击完成

![](https://upload-images.jianshu.io/upload_images/301129-54e0530428f5fab8.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

引入h5目录效果如上

下面从实现界面和实现逻辑两个部分讲解。

### 实现界面

![](https://upload-images.jianshu.io/upload_images/301129-c0b4d0d620e9d21b.gif?imageMogr2/auto-orient/strip)

上面是实现的h5界面，通过webview引入项目，可以看到效果和原生几乎一样。

当然需要达到和原生效果一样，还要对h5的界面做一些配置。

```
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" />
<meta name="format-detection" content="telephone=no" />
<meta name="apple-mobile-web-app-capable" content="yes" />
<meta name="apple-mobile-web-app-status-bar-style" content="black">
```

上面的配置规定了页面的不能缩放，数字不会直接显示号码的样式，还要状态栏的显示颜色为黑色

```
/* 禁用长按 */
body {-webkit-touch-callout:none;/*系统默认菜单被禁用*/-webkit-user-select:none;/*webkit浏览器*/-khtml-user-select:none;/*早起浏览器*/-moz-user-select:none;/*火狐浏览器*/-ms-user-select:none;/*IE浏览器*/user-select:none;/*用户是否能够选中文本*/}

html{
    font-family:PingFangSC-Regular;
}
```

上面是一些通用的css配置，我放到了style.css里面，一是禁止用户长按显示放大显示器的效果，二是统一使用苹方字体。

有了以上配置，基本就可以好好实现界面的开发了，开发h5的流程没有和正常h5开发没有什么流程。

iOS引入资源的方式如下

```
let configuration = WKWebViewConfiguration()
configuration.preferences = WKPreferences()
configuration.preferences.javaScriptEnabled = true
configuration.userContentController = WKUserContentController()

let webview = WKWebView.init(frame: self.view.bounds, configuration: configuration)
self.view.addSubview(webview)
webview.navigationDelegate = self
webview.load(URLRequest.init(url: URL.init(fileURLWithPath: Bundle.main.path(forResource: "licheng", ofType: "html", inDirectory: "h5")!)))
```

webview引入licheng.html，通过urlrequest请求资源，渲染到当前的webview界面上，由于是本地直接加载，不存在网络延迟的问题，所以加载速度很快，几乎和原生界面一样。


下面讲讲逻辑部分，比如网络，点击跳转，传值等。

### 实现逻辑

之前的博客也有讲过wkwebview混合开发，怎么实现传值的方式。主要过程就是实现js和原生交互，有了交互外加一层封装，就可以方便的通过接口实现我们传值功能。

![](https://upload-images.jianshu.io/upload_images/301129-a9c5231609377c9e.gif?imageMogr2/auto-orient/strip)

添加一个name的handler，h5可以通过发送这个handler，调用原生的代理方法

```
func addJsFunc(_ name: String, _ callback:@escaping ((Any)->Void)) {
    wkconfiguration.userContentController.add(self, name: name)
    
    jsFuncArr.append(JsFuncModel.init(name: name, callback: callback))
}
```

h5发送handler

```
window.webkit.messageHandlers.openvc.postMessage({name:'aa', sex:'male', age:21})

```

原生代理方法接收，匹配到相应的name，执行原生的callback

```
public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    
    print(message.name)
    print(message.body)
    
    for jsFunc in jsFuncArr {
        if jsFunc.name == message.name {
            jsFunc.callback(message.body)
            break
        }
    }
}
```

以上是添加一个handler的方式，可以使js调用原生并传值。这样就能实现界面之间的跳转的action，以及js一些传值动作的执行了。

下面实现原生传值给js环境

```
func addJsObj(_ key: String, _ value: String) {
    wkwebview.evaluateJavaScript("vm.\(key) = \(value)", completionHandler: nil)
}
```

通过kv的方式设置vm的属性值，vm是我们vue全局环境的实例。我们的h5的组件是通过vue完成双向绑定的，通过设置vm的属性的值，
可以把data迅速的渲染到我们的页面上。这里引入vue这个框架的好处是，我们不用那么频繁的操作dom了，
有vue做mvvm的架构，界面的渲染真是比原生实现轻松太多了。

以上是原生通过evaluateJavaScript传值给js环境，这样就能实现在原生实现网络请求回来的数据，直接给到h5界面去渲染。或者原生的一些动作可以通知到h5去执行。

注意这里网络请求是放在原生环境实现的，原因是浏览器和后台部署都是不支持跨域访问的，这个问题可以具体google。

通过上面的开发基本上可以实现h5的原生开发了，因为h5是打包到项目里面的，所以性能很好。
我对这一套渲染和传值的逻辑进行了封装，放在了JWebViewController里面，继承该类就可以使用了。
代码参考[iOSh5vue](https://github.com/jackyshan/iOSh5vue)

### 注意事项

* 顶层文件夹名字要命名为h5，因为JWebViewController底层封装写死了h5的目录。

* 在页面返回时，要做合适的时机调用clearJs方法，这样vc才会被析构。不然会出现内存泄露。

* 相关逻辑都封装在JWebViewController里面了，需要继承JWebViewController，实现业务逻辑的部分。