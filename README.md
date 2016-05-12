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
- 2016-4-26 初步完善了收藏，现在支持首页新闻模式的收藏。<br>
- 2016-4-29 终结了收藏功能 <br>
- 2016-5-7  在帮助与反馈界面初步增加了环信即时通讯
- 2016-5-9  在设置界面显示当前未读的消息数，实时监听并改变
- 2016-5-9  增加了本地通知

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
- 自定义视频界面（后续修改）<br>
![image](https://raw.githubusercontent.com/gaoyuhang/DayDayNews/master/photo/video.png)


##我的界面实现第三方登陆以及注销，界面优化。下方数据暂时为假数据，即将修改
![image](https://raw.githubusercontent.com/gaoyuhang/DayDayNews/master/photo/login.png)
![image](https://raw.githubusercontent.com/gaoyuhang/DayDayNews/master/photo/me.png)


##夜间模式和收藏功能图片
![image](https://raw.githubusercontent.com/gaoyuhang/DayDayNews/master/photo/yejian.png)
![image](https://raw.githubusercontent.com/gaoyuhang/DayDayNews/master/photo/collect.png)

##帮助与反馈界面《环信即时通讯》
设计的思路是在用户第三方登录成功的时候，利用uid去注册环信账户，注册成功就登录，如果是第二次登录，现在做的还是首先是注册，判断是否是因为账号存在而失败，如果是就进行登录，登录成功之后，在帮助与反馈界面才能进行即时通讯。 <br>
没有加好友，直接利用好友的名字来进行聊天，现在所有登录上的账户都是直接和gaoyuhang这个账号进行通信的。<br>
进入程序的时候获取当前用户未读的消息数，如果有改变实时显示出来
后期如果有需要，可以增加更多功能。<br><br>
关于环信即时通讯，请参考我另外一个demo[环信3.0Demo](https://github.com/gaoyuhang/HuanXinTest) <br>

![image](https://raw.githubusercontent.com/gaoyuhang/DayDayNews/master/photo/chat.png)


##小结
- 过几天我会把程序的目录结构进行一下介绍
- 关于设置界面，我想实现一个帮助的即时通讯功能，现在还在考虑是用环信还是xmpp开发。。
- 在帮助与反馈的地方做一个即时通讯吧，让用户和开发者实时进行交互

---

[简书地址](http://www.jianshu.com/users/85973c3d2045/latest_articles)





