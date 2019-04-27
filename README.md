# novel_reader
一款使用Flutter实现的小说阅读器Demo。
[下载Demo Apk](https://pan.baidu.com/s/1us_ZNt44bxDKdecu9bI-Zw),提取码: 9bmg


仿：[Novel Reader](https://github.com/newbiechen1024/NovelReader).
主要是参照Novel Reader的页面结构和借用一些图片资源。

### 目前以实现：
1. 主页三个Tab
2. 搜索页
3. 搜索结果页
4. 搜索结果书籍详情页
5. 点击书籍阅读，读取书籍章节目录信息并缓存入数据库

### 待实现：
1. 网络章节内容下载
2. 书籍内容的解码（Flutter目前支持的编、解码格式有限）
3. 本地书籍的解析
4. 书籍页面展示，包括动画、字体大小等
5. 书架书籍信息的编辑、排序等功能

### 使用的库：
1. [dio](https://pub.dartlang.org/packages/dio) => 处理网络请求
2. [cached_network_image](https://pub.dartlang.org/packages/cached_network_image) => 加载网络图片
3. [sqflite](https://pub.dartlang.org/packages/sqflite) => 用于本地数据库存储
4. [path_provider](https://pub.dartlang.org/packages/path_provider) => 提供Android/iOS文件系统的支持


### 截图：
![show1](https://github.com/leimenghao1991/novel_reader/blob/master/show/show1.gif?raw=true)

![show2](https://github.com/leimenghao1991/novel_reader/blob/master/show/show2.gif?raw=true)