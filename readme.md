# Getui Push Notification ANE (IOS + Andorid)

- This is an [Air native extension](http://www.adobe.com/devnet/air/native-extensions-for-air.html) for receive push notifications on iOS and Android from [getui](http://www.getui.com/).
- It is derived from [freshplanet/ANE-Push-Notification](https://github.com/freshplanet/ANE-Push-Notification).
- It is distributed under the [Apache Licence, version 2.0](http://www.apache.org/licenses/LICENSE-2.0).

## Introduce

- [Getui Push Notification](http://www.getui.com/)

## Features:

- AIR apps in IOS receive push notification from Getui ( Getui IOS SDK 1.2.1)  [download](http://www.igetui.com/download/iOS/GETUI_IOS_SDK.zip)
- AIR apps in Android receive push notification from Getui ( Getui Andorid SDK 2.6.0) [download](http://www.igetui.com/download/android/GETUI_ANDROID_SDK.zip)

## Build
in build driectory, modify build.properties and run:
> ant all

## Usage
 * for ios apps, modify app.xml, when build for appstore, replace `development` to `production`

                <iPhone>
                    <Entitlements>
                        <![CDATA[
                            <key>aps-environment</key>
                            <string>development</string>
                        ]]>
                    </Entitlements>
                </iPhone>
                
 * for andorid apps, modify app.xml, look up [getui documents](http://docs.igetui.com/pages/viewpage.action?pageId=589991)
    * example:
    
                <!-- getui sdk setting -->
                <!-- 3rd party setting -->
                <meta-data android:name="PUSH_APPID" android:value="u1spWZXtjZ8FxmRUZCPr44" />
                <meta-data android:name="PUSH_APPSECRET" android:value="HxbuotbFct8IBCCjsqkSq1" />
                <meta-data android:name="PUSH_APPKEY" android:value="TicIEPTrGZAFcIFsSbXbG7" />
                <meta-data android:name="PUSH_GROUPID" android:value="" />

                <!-- 3rd party Receiver -->
                <receiver
                        android:name="com.alo7.ane.getuiPushNotification.GetuiPushReceiver"
                        android:exported="false" >
                    <intent-filter>
                        <!--  replace action android:name="com.igexin.sdk.action. 3rd party's APPID" -->
                        <action android:name="com.igexin.sdk.action.u1spWZXtjZ8FxmRUZCPr44" />
                    </intent-filter>
                </receiver>

                <!--SKD core service -->
                <service android:name="com.igexin.sdk.PushService"
                    android:exported="true"
                    android:label="NotificationCenter"
                    android:process=":pushservice" >
                </service>

                <receiver android:name="com.igexin.sdk.PushReceiver">
                    <intent-filter>
                        <action android:name="android.intent.action.BOOT_COMPLETED" />
                        <action android:name="android.net.conn.CONNECTIVITY_CHANGE" />
                        <action android:name="android.intent.action.USER_PRESENT" />
                        <action android:name="com.igexin.sdk.action.refreshls" />
                    </intent-filter>
                </receiver>
                <receiver android:name="com.igexin.sdk.PushManagerReceiver"
                    android:exported="false" >
                    <intent-filter>
                            <action android:name="com.igexin.sdk.action.pushmanager" />
                    </intent-filter>
                </receiver>

                <activity android:name="com.igexin.sdk.PushActivity"
                    android:process=":pushservice"
                    android:theme="@android:style/Theme.Translucent.NoTitleBar"
                    android:taskAffinity="com.igexin.sdk.PushActivityTask"
                    android:excludeFromRecents="true"
                    android:exported="false">
                </activity>

                <!-- popup activity -->
                <activity android:name="com.igexin.getuiext.activity.GetuiExtActivity"
                    android:process=":pushservice"
                    android:configChanges="orientation|keyboard|keyboardHidden"
                    android:excludeFromRecents="true"
                    android:taskAffinity="android.task.myServicetask"
                    android:theme="@android:style/Theme.Translucent.NoTitleBar"
                    android:exported="false" />
                <receiver android:name="com.igexin.getuiext.service.PayloadReceiver"
                    android:exported="false" >
                    <intent-filter>
                        <!-- com.igexin.sdk.action.7fjUl2Z3LH6xYy7NQK4ni4 don't change  -->
                        <action android:name="com.igexin.sdk.action.7fjUl2Z3LH6xYy7NQK4ni4" />
                        <!-- android:name="com.igexin.sdk.action. 3rd party's appId" -->
                        <action android:name="com.igexin.sdk.action.u1spWZXtjZ8FxmRUZCPr44" />
                    </intent-filter>
                </receiver>
                <service android:name="com.igexin.getuiext.service.GetuiExtService"
                    android:process=":pushservice" />

                <!-- download module-->
                <service android:name="com.igexin.download.DownloadService"
                    android:process=":pushservice" />
                <receiver
                    android:exported="false" android:name="com.igexin.download.DownloadReceiver">
                    <intent-filter>
                        <action android:name="android.net.conn.CONNECTIVITY_CHANGE" />
                    </intent-filter>
                </receiver>
                <provider android:name="com.igexin.download.DownloadProvider"
                    android:process=":pushservice"
                    android:authorities="downloads.air.com.alo7.xxxx"/>
                    <!-- android:authorities="downloads.3rd party's package name", add air. for air apps name -->
                <!-- ====================================================== -->
        
   * use in AIR project
   
            public function initializeGetuiPushNotification():void{
                if(GetuiPushNotification.isPushNotificationSupported){
                    var getuiInstance:GetuiPushNotification = GetuiPushNotification.getInstance();
                    // add event listener
                    getuiInstance.addEventListener(GetuiPushNotificationEvent.TOKEN_SUCCESS,onTokenSuccess);
                    getuiInstance.addEventListener(GetuiPushNotificationEvent.TOKEN_FAIL,onTokenFail);
                    getuiInstance.addEventListener(GetuiPushNotificationEvent.GETUI_DID_REGISTER_CLIENT,onGetuiDidRegisterClient);
                    getuiInstance.addEventListener(GetuiPushNotificationEvent.GETUI_DID_RECEIVE_PAYLOAD,onGetuiDidReceivePayload);
                    getuiInstance.addEventListener(GetuiPushNotificationEvent.GETUI_DID_OCCUR_ERROR,onGetuiDidOccurError);
    
                    // arguments is required for ios apps, android apps get then from app.xml 
                    getuiInstance.initializePushNotificaiton("appId","appKey","appSecret");
                }
            }
                        
                        
            // upload clientId to your app's server, then your server can push notification to this device
            private function onGetuiDidRegisterClient(e:GetuiPushNotificationEvent):void{
                var clientId:String = String(e.data);
                ...                
            }
            
            // for ios enter background
            public function onDeActivate():void{                
                GetuiPushNotification.getInstance().pauseGetuiSdk();
            }
            
            // for ios resume from background
            public function onActivate():void{
                GetuiPushNotification.getInstance().resumeGetuiSdk();
            }
        
## Caution
* in Android device, when appid，appsecret ,appkey changed, the getui cliendId maybe won't create new one ,then apps can't receive noticication( bug?), 
we need to uninstall apps and delete apps name .db file in device libs driectory, reinstall apps.
 
* for Android apps, the icon of notificaiton packed in ane is a default image, if need use custom icon, need to replace it by self. look up:
    * scripts/replace_ane_android_res.sh (recommended)
    * scripts/replace_apk_res.sh (not recommended)
    
* for android apps, sometime build apk error when with other ane together, because ane's res driectory has same name files, remove these files if they are useless.


# 个推消息推送ANE(IOS + Andorid)

- 实现移动AIR应用接受[个推](http://www.getui.com/)的消息推送。
- 参考[freshplanet/ANE-Push-Notification](https://github.com/freshplanet/ANE-Push-Notification)的实现方式
- 基于[Apache Licence, version 2.0](http://www.apache.org/licenses/LICENSE-2.0).

## [个推消息推送](http://www.getui.com/)

* 已实现以下功能
    - IOS 接受个推消息推送 (个推 IOS SDK 1.2.1)
    - Android 接受个推消息推送 (个推 Andorid SDK 2.6.0)

* ios库项目
    - [个推 ios sdk 下载](http://www.igetui.com/download/iOS/GETUI_IOS_SDK.zip)
    - 路径： ios/GetuiPushNotification
    - 生成 .a文件

* andorid库项目
    - [个推 android sdk 下载](http://www.igetui.com/download/android/GETUI_ANDROID_SDK.zip)
    - 路径：android/GetuiPushNotification
    - 生成 .jar文件

* actionscript库项目
    - 路径：actionscript
    - 生成 .swc文件


* ane打包
    - ant打包，build目录下运行：ant all


* AIR项目中的使用：
    * ios平台，需要修改app.xml,开启aps环境,发布appstore时,修改`development` 为 `production`

                <iPhone>
                    <Entitlements>
                        <![CDATA[
                            <key>aps-environment</key>
                            <string>development</string>
                        ]]>
                    </Entitlements>
                </iPhone>

    * android平台
        * 需要修改app.xml,添加权限和服务配置，详见[个推安卓sdk的接入文档：在AndroidManifest.xml 里添加相关声明](http://docs.igetui.com/pages/viewpage.action?pageId=589991)
        * 部分配置参考

                <!-- 个推SDK配置开始 -->
                <!-- 配置的第三方参数属性 -->
                <meta-data android:name="PUSH_APPID" android:value="u1spWZXtjZ8FxmRUZCPr44" />
                <meta-data android:name="PUSH_APPSECRET" android:value="HxbuotbFct8IBCCjsqkSq1" />
                <meta-data android:name="PUSH_APPKEY" android:value="TicIEPTrGZAFcIFsSbXbG7" />
                <meta-data android:name="PUSH_GROUPID" android:value="" />

                <!-- 配置第三方Receiver -->
                <receiver
                        android:name="com.alo7.ane.getuiPushNotification.GetuiPushReceiver"
                        android:exported="false" >
                    <intent-filter>
                        <!-- 替换为action android:name="com.igexin.sdk.action.第三方应用APPID" -->
                        <action android:name="com.igexin.sdk.action.u1spWZXtjZ8FxmRUZCPr44" />
                    </intent-filter>
                </receiver>

                <!--配置SDK核心服务-->
                <service android:name="com.igexin.sdk.PushService"
                    android:exported="true"
                    android:label="NotificationCenter"
                    android:process=":pushservice" >
                </service>
                
                <!-- SDK　2.6.1.0版本新增配置项 -->
                <service
                    android:name="com.igexin.sdk.PushServiceUser"
                    android:exported="true"
                    android:label="NotificationCenterUser" >
                </service>

                <receiver android:name="com.igexin.sdk.PushReceiver">
                    <intent-filter>
                        <action android:name="android.intent.action.BOOT_COMPLETED" />
                        <action android:name="android.net.conn.CONNECTIVITY_CHANGE" />
                        <action android:name="android.intent.action.USER_PRESENT" />
                        <action android:name="com.igexin.sdk.action.refreshls" />
                        <!-- 以下三项为可选的action声明，可大大提高service存活率和消息到达速度 -->
                        <action android:name="android.intent.action.MEDIA_MOUNTED" />
                        <action android:name="android.intent.action.ACTION_POWER_CONNECTED" />
                        <action android:name="android.intent.action.ACTION_POWER_DISCONNECTED" />
                    </intent-filter>
                </receiver>
                
                <receiver android:name="com.igexin.sdk.PushManagerReceiver"
                    android:exported="false" >
                    <intent-filter>
                            <action android:name="com.igexin.sdk.action.pushmanager" />
                    </intent-filter>
                </receiver>

                <activity android:name="com.igexin.sdk.PushActivity"
                    android:process=":pushservice"
                    android:theme="@android:style/Theme.Translucent.NoTitleBar"
                    android:taskAffinity="com.igexin.sdk.PushActivityTask"
                    android:excludeFromRecents="true"
                    android:exported="false">
                </activity>

                <!-- 配置弹框activity -->
                <activity android:name="com.igexin.getuiext.activity.GetuiExtActivity"
                    android:process=":pushservice"
                    android:configChanges="orientation|keyboard|keyboardHidden"
                    android:excludeFromRecents="true"
                    android:taskAffinity="android.task.myServicetask"
                    android:theme="@android:style/Theme.Translucent.NoTitleBar"
                    android:exported="false" />
                <receiver android:name="com.igexin.getuiext.service.PayloadReceiver"
                    android:exported="false" >
                    <intent-filter>
                        <!-- 这个com.igexin.sdk.action.7fjUl2Z3LH6xYy7NQK4ni4固定，不能修改  -->
                        <action android:name="com.igexin.sdk.action.7fjUl2Z3LH6xYy7NQK4ni4" />
                        <!-- android:name="com.igexin.sdk.action.第三方的appId" -->
                        <action android:name="com.igexin.sdk.action.u1spWZXtjZ8FxmRUZCPr44" />
                    </intent-filter>
                </receiver>
                <service android:name="com.igexin.getuiext.service.GetuiExtService"
                    android:process=":pushservice" />

                <!-- 个推download模块配置-->
                <service android:name="com.igexin.download.DownloadService"
                    android:process=":pushservice" />
                <receiver
                    android:exported="false" android:name="com.igexin.download.DownloadReceiver">
                    <intent-filter>
                        <action android:name="android.net.conn.CONNECTIVITY_CHANGE" />
                    </intent-filter>
                </receiver>
                <provider android:name="com.igexin.download.DownloadProvider"
                    android:process=":pushservice"
                    android:authorities="downloads.air.com.alo7.xxxx"/>
                    <!-- android:authorities="downloads.第三方包名",AIR应用包名前可能要加air. -->
                <!-- ====================================================== -->

    * 项目中启用：
    
            public function initializeGetuiPushNotification():void{
                if(GetuiPushNotification.isPushNotificationSupported){
                    var getuiInstance:GetuiPushNotification = GetuiPushNotification.getInstance();
                    // 事件监听
                    getuiInstance.addEventListener(GetuiPushNotificationEvent.TOKEN_SUCCESS,onTokenSuccess);
                    getuiInstance.addEventListener(GetuiPushNotificationEvent.TOKEN_FAIL,onTokenFail);
                    getuiInstance.addEventListener(GetuiPushNotificationEvent.GETUI_DID_REGISTER_CLIENT,onGetuiDidRegisterClient);
                    getuiInstance.addEventListener(GetuiPushNotificationEvent.GETUI_DID_RECEIVE_PAYLOAD,onGetuiDidReceivePayload);
                    getuiInstance.addEventListener(GetuiPushNotificationEvent.GETUI_DID_OCCUR_ERROR,onGetuiDidOccurError);
    
                    // ios必须要传入前三位参数，android端前三位参数是从app.xml中获取，这里可以不传
                    getuiInstance.initializePushNotificaiton("appId","appKey","appSecret");
                }
            }
            
            
            // 把获取到的clienId 发送个应用自己的服务端，服务端就可以给改设备发通知了
            private function onGetuiDidRegisterClient(e:GetuiPushNotificationEvent):void{
                var clientId:String = String(e.data);
                ...                
            }
            
            // for ios 切到后台	
            public function onDeActivate():void{                
                GetuiPushNotification.getInstance().pauseGetuiSdk();
            }
            
            // for ios 从后台恢复
            public function onActivate():void{
                GetuiPushNotification.getInstance().resumeGetuiSdk();
            }
            

## 一些问题
* android 应用当个推的appid，appsecret，appkey变化时，产生的clientId仍会使用老的，导致无法收到推送消息，需要删除应用，
  并删除设备libs目录下对应应用名的db文件后再重装应用，才会生成新的clientId（bug?）

* android 的推送icon图标push.png是打包在ane中的，无法在实际项目中配置，几种解决办法：
    * 修改实际项目生成的apk文件，替换其中的push.png文件，参考 scripts/replace_apk_res.sh，apk解包、打包、重签名过程可能出问题，不推荐
    * 打包apk前，修改个推ane，替换其中的push.png文件，参考 scripts/replace_ane_android_res.sh, 推荐使用此方式

* 和其他基于第三方sdk开发的ane混用的会有冲突
    * 目前只能去掉一些res下的资源来避免app打包失败，比如安卓项目中的res目录下的资源无法全部打包进ane中，寻求更好的解决办法。。。