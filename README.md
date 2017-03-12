# 简介：

无侵入式将所有App发起的网络请求，独立记录管理起来，支持界面形式进行查看

- 支持`URLConnection` `URLSession` 
- 支持进行域名过滤嗅探，只截获记录符合过滤规则的网络请求
- 支持界面形式实时查看网络请求记录
- 支持网络请求记录的顺序，倒序查看
- 查看复制网络请求信息到剪切板

# 使用

## VKSniffer

VKSniffer目录是嗅探器的主体逻辑代码，只导入VKSniffer目录，即可让嗅探器正常工作

```objectivec
//基本用法
[VKSniffer setupSnifferHandler:^(VKSnifferResult *result) {
        NSLog(@"%@",result);
    }];
[VKSniffer startSniffer];
```

- `+ startSniffer`

Require方法，一行代码即可开启监听和嗅探。

- `+ setupSnifferHandler:`

Option方法，嗅探到的每一条网络请求结果，会通过Handler回调，传给使用者，如果不设置，网络请求会保存在单例的netResultArray里

- `+ setupHostFilter:`

Option方法，可以让嗅探器有选择的拦截指定域名的网络请求并记录，如果不设置，默认全体拦截

- `+ setupConfiguration:`

Option方法，嗅探器默认支持`NSURLConnection`与系统的`[NSURLSession sharedSession]`，如果需要支持`defaultSessionConfiguration`生成的`NSURLSession`需要调用此函数来进行额外配置（例如：AfNetworking3.0）

```objectiveC
//初始化AfNetworking3.0 配置VKSniffer
NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];

//在创建manager前，调用setupConfiguration
[VKSniffer setupConfiguration:configuration];

//创建manager
AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
self.manager = manager;
```


## VKSnifferUI

VKSnifferUI目录是界面列表功能，同时导入`VKSnifferUI`与`VKSniffer`目录即可让所有的网络请求日志，通过列表界面进行查看

- `+ showSnifferView`
- `+ hideSnifferView`

一行代码，打开网络请求日志界面

__Menu功能包含__

- 暂停/启动 UrlProtocol拦截
- 移除列表中所有内容
- 列表逆序/顺序排列
- 重新设定域名过滤器
- 查看复制网络请求信息到剪切板

__推荐配合VKShakeCommands使用__


VKShakeCommands是工具 [VKKeyCommands](https://github.com/Awhisper/VKKeyCommands) 下的摇一摇组件，可以捕捉真机的摇一摇事件

- 触发VKShakeCommands
- 调用showSnifferView

在真机黑盒调试代码的时候，为了方便的不链接Xcode，也不必charles挂代理，就能看到所有网络日志，可以轻轻摇一摇手机，打开嗅探器界面，实现快速查看网络日志



# 背景

VKSniffer其实是 [VKDevTool](https://github.com/Awhisper/VKDevTool) 的子功能发展而来。VKDevTool内部包含着网络请求日志查看功能。

当初开发VKDevTool的时候，贪心大而全，并且求快，网络请求日志功能，大体逻辑都已经实现，但是界面很糙，功能特别不细致（支持列表查看复制，支持暂停/开启，支持域名过滤）

后来看到了 [Xniffer](https://github.com/xmartlabs/Xniffer) 一款用Swift语言写的针对NSURLSession的嗅探器，他的大体功能VKDevTool的网络日志模块都已实现，他的好处是网络请求日志更加精细，细致记录了很多网络请求细节

- 请求耗时
- 请求状态码
- 请求数据
- 请求Error信息


因此萌生了重写`VKSniffer`的想法，取人之长，补己之短，并且把这个模块从VKDevTool中独立出来，可以独立运作。

PS: VKDevTool逐个模块打算一一重新整理，当初写的太糙了

PPS: 感谢 [Xniffer](https://github.com/xmartlabs/Xniffer) 的精致细节
