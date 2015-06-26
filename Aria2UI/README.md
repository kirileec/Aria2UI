> YAAW  
> [https://github.com/binux/yaaw](https://github.com/binux/yaaw)


Kirile 2015-06-26
对yaaw的源文件进行了一些修改
List如下

- `index.html` 中将相对路径的相关代码修改为运行 css/ img/ js/ 以保证css与js的正常加载
- `bootstrap.min.css` 中修改了相对路径的代码，保证图标的加载
- `offline.appcache` 同上，不过未深究有没有用
- `yaaw.js` 中 `location.protocol ＝> "http:"` 否则第一次运行将为 `file://`

PS: 在XCODE中使用Webview访问本地HTML文件,这样应该是最笨的方法了吧

