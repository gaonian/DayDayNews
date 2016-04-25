# DayDayNews
仿网易新闻客户端，实现新闻浏览，视频播放，抓取百度图片，瀑布流显示,自定义视频播放，横屏竖屏切换自如,设置界面优化，第三方登录以及注销

##Update Log
- 适配了iOS9<br />
- 增加了点击tabbar刷新当前页面的功能<br />
- 2016-1-2 修改了首页顶部滚动条的接口 <br />
- 2016-1-14 处理天气预报加载时间长，没页面显示的问题。<br />
- 2016-1-19 更换了corelocation定位，系统定位繁琐速度慢。更换为INTULocationManager第三方定位，block调用简单有效<br />
- 2016-1-20 更改了首页顶部滚动条详情不显示的问题。<br />
- 2016-2-10 优化天气预报城市缓存问题 <br>
- 2016-3-2  完善”我的“界面，实现第三方登录以及注销功能<br>
- 2016-3-3 修改了首页社会的显示数据，抓取网易的数据，并进行解析。 把下拉刷新改成动画效果，更美观<br>
- 2016-3-7 修改了首页imagesCell有时数据不显示的问题<br>
- 2016-4-16 完善了夜间模式的设置。<br>
- 2016-4-25 增加了收藏<br>
- 2016-4-26 初步完善了收藏，现在支持首页新闻模式的收藏。

##修改了视频显示方式
- 点击当前cell播放视频在当前cell上，监听屏幕转动，当屏幕转动的时候，视频自动横屏全屏播放，当屏幕为正的时候，播放在当前cell上<br />
- 增加了活动指示器，采取搜狐视频活动指示器

![image](https://raw.githubusercontent.com/gaoyuhang/DayDayNews/master/photo/加载.png)
![image](https://raw.githubusercontent.com/gaoyuhang/DayDayNews/master/photo/播放.png)
![image](https://raw.githubusercontent.com/gaoyuhang/DayDayNews/master/photo/横屏.png)
_<br />_<br />

![gif](https://raw.githubusercontent.com/gaoyuhang/DayDayNews/master/photo/111.gif)
![gif](https://raw.githubusercontent.com/gaoyuhang/DayDayNews/master/photo/222.gif)

##首页以及顶部新闻详情，高仿网易
![image](https://raw.githubusercontent.com/gaoyuhang/DayDayNews/master/photo/newsfresh.png)
![image](https://raw.githubusercontent.com/gaoyuhang/DayDayNews/master/photo/newsdata.png)
##使用瀑布流实现图片，可以选择分类
![image](https://raw.githubusercontent.com/gaoyuhang/DayDayNews/master/photo/photo.png)
##增加了天气预报的功能，可以实现定位到当前城市。动画效果也没有放过。
![image](https://raw.githubusercontent.com/gaoyuhang/DayDayNews/master/photo/detail.png)
![image](https://raw.githubusercontent.com/gaoyuhang/DayDayNews/master/photo/weather.PNG)

##视频
- 自定义视频界面（后续修改）
![image](https://raw.githubusercontent.com/gaoyuhang/DayDayNews/master/photo/video.png)


##我的界面实现第三方登陆以及注销，界面优化。下方数据暂时为假数据，即将修改
![image](https://raw.githubusercontent.com/gaoyuhang/DayDayNews/master/photo/setting.png)
![image](https://raw.githubusercontent.com/gaoyuhang/DayDayNews/master/photo/login.png)<br>

##小结
- 关于设置界面，我想实现一个帮助的即时通讯功能，现在还在考虑是用环信还是xmpp开发。。
- 在帮助与反馈的地方做一个即时通讯吧，让用户和开发者实时进行交互





