# Getui Push Notification ANE (IOS + Andorid)

- This is an [Air native extension](http://www.adobe.com/devnet/air/native-extensions-for-air.html) for receive push notifications on iOS and Android from [getui](http://www.getui.com/).
- It is derived from [freshplanet/ANE-Push-Notification](https://github.com/freshplanet/ANE-Push-Notification).
- It is distributed under the [Apache Licence, version 2.0](http://www.apache.org/licenses/LICENSE-2.0).

## Introduce

- [Getui Push Notification](http://www.getui.com/)

## Features:

- AIR apps in IOS receive push notification from Getui ( Getui IOS SDK 1.6.1.0)  [download](http://www.getui.com/download/docs/iOS/GETUI_IOS_SDK.zip)
- AIR apps in Android receive push notification from Getui ( Getui Andorid SDK 2.10.2.0) [download](http://www.getui.com/download/docs/android/GETUI_ANDROID_SDK.zip)

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
    
            <!-- ====================config start==================== -->                       
                       
            <uses-permission android:name="getui.permission.GetuiService.your_app_package_name"/>
            <permission
                android:name="getui.permission.GetuiService.your_app_package_name"
                android:protectionLevel="normal" >
            </permission>
           
            <application android:enabled="true" >
                
                <meta-data android:name="PUSH_APPID" android:value="your APPID" />
                <meta-data android:name="PUSH_APPSECRET" android:value="your APPSECRET" />
                <meta-data android:name="PUSH_APPKEY" android:value="your APPKEY" />
    
                <service android:name="com.igexin.sdk.PushService"
                    android:exported="true"
                    android:label="NotificationCenter"
                    android:process=":pushservice" >
                    <intent-filter>
                           <action android:name="com.igexin.sdk.action.service.message"/> 
                       </intent-filter>
                </service>
                
                <receiver android:name="com.igexin.sdk.PushReceiver">
                    <intent-filter>
                        <action android:name="android.intent.action.BOOT_COMPLETED" />
                        <action android:name="android.net.conn.CONNECTIVITY_CHANGE" />
                        <action android:name="android.intent.action.USER_PRESENT" />
                        <action android:name="com.igexin.sdk.action.refreshls" />
                        <action android:name="android.intent.action.MEDIA_MOUNTED" />
                        <action android:name="android.intent.action.ACTION_POWER_CONNECTED" />
                        <action android:name="android.intent.action.ACTION_POWER_DISCONNECTED" />
                    </intent-filter>
                </receiver>
                
                <activity
                       android:name="com.igexin.sdk.PushActivity"
                       android:excludeFromRecents="true"
                       android:exported="false"
                       android:process=":pushservice"
                       android:taskAffinity="com.igexin.sdk.PushActivityTask"
                       android:theme="@android:style/Theme.Translucent.NoTitleBar"/>
                   <activity
                       android:name="com.igexin.sdk.GActivity"
                       android:excludeFromRecents="true"
                       android:exported="true"
                       android:process=":pushservice"
                       android:taskAffinity="com.igexin.sdk.PushActivityTask"
                       android:theme="@android:style/Theme.Translucent.NoTitleBar"/>
                   <service
                       android:name="com.igexin.download.DownloadService"
                       android:process=":pushservice"/>
                   <receiver android:name="com.igexin.download.DownloadReceiver">
                       <intent-filter>
                           <action android:name="android.net.conn.CONNECTIVITY_CHANGE"/>
                       </intent-filter>
                   </receiver>  
                
                <provider android:name="com.igexin.download.DownloadProvider" 
                    android:process=":pushservice" 
                    android:exported="true"
                    android:authorities="downloads.your_app_package_name"/>
    
                   <!-- ane中自定义的service -->
                   <service
                       android:name="com.alo7.ane.getuiPushNotification.GetuiPushService"
                    android:exported="true"
                       android:label="PushService"
                       android:process=":pushservice" />
    
                   <service
                       android:name="com.alo7.ane.getuiPushNotification.GetuiIntentService" />
                       
             </application >
            <!-- ====================config end==================== -->

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
             		
             // only for ios
            public function onActivate():void{
                    GetuiPushNotification.getInstance().resumeGetuiSdk();
            }
             	
             // only for ios
            public function onDeActivate():void{
                GetuiPushNotification.getInstance().pauseGetuiSdk(); 
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
    - IOS 接受个推消息推送 (个推 IOS SDK 1.6.1.0)
    - Android 接受个推消息推送 (个推 Andorid SDK 2.10.2.0)

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
        * 需要修改app.xml,添加权限和服务配置，详见[个推安卓sdk的接入文档：在AndroidManifest.xml 里添加相关声明](http://docs.getui.com/mobile/android/overview/)
        * 配置参考:
                
                
            <!-- ====================个推SDK配置开始==================== -->
           
           
            <!--个推自定义权限-->
            <uses-permission android:name="getui.permission.GetuiService.你的应用包名"/>
            <permission
                android:name="getui.permission.GetuiService.你的应用包名"
                android:protectionLevel="normal" >
            </permission>
           
            <application android:enabled="true" >
                
                <!-- 配置的第三方参数属性 -->
                <meta-data android:name="PUSH_APPID" android:value="你的APPID" />
                <meta-data android:name="PUSH_APPSECRET" android:value="你的APPSECRET" />
                <meta-data android:name="PUSH_APPKEY" android:value="你的APPKEY" />

                <!--配置SDK核心服务-->
                <service android:name="com.igexin.sdk.PushService"
                    android:exported="true"
                    android:label="NotificationCenter"
                    android:process=":pushservice" >
                    <intent-filter>
                           <action android:name="com.igexin.sdk.action.service.message"/> 
                       </intent-filter>
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
                
                <activity
                       android:name="com.igexin.sdk.PushActivity"
                       android:excludeFromRecents="true"
                       android:exported="false"
                       android:process=":pushservice"
                       android:taskAffinity="com.igexin.sdk.PushActivityTask"
                       android:theme="@android:style/Theme.Translucent.NoTitleBar"/>
                   <activity
                       android:name="com.igexin.sdk.GActivity"
                       android:excludeFromRecents="true"
                       android:exported="true"
                       android:process=":pushservice"
                       android:taskAffinity="com.igexin.sdk.PushActivityTask"
                       android:theme="@android:style/Theme.Translucent.NoTitleBar"/>
                   <service
                       android:name="com.igexin.download.DownloadService"
                       android:process=":pushservice"/>
                   <receiver android:name="com.igexin.download.DownloadReceiver">
                       <intent-filter>
                           <action android:name="android.net.conn.CONNECTIVITY_CHANGE"/>
                       </intent-filter>
                   </receiver>  
                
                <provider android:name="com.igexin.download.DownloadProvider" 
                    android:process=":pushservice" 
                    android:exported="true"
                    android:authorities="downloads.你的应用包名"/>

                   <!-- ane中自定义的service -->
                   <service
                       android:name="com.alo7.ane.getuiPushNotification.GetuiPushService"
                    android:exported="true"
                       android:label="PushService"
                       android:process=":pushservice" />

                   <service
                       android:name="com.alo7.ane.getuiPushNotification.GetuiIntentService" />
                       
             </application >
            <!-- ====================个推SDK配置结束==================== -->

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
            
            
            // 把获取到的clienId 发送给应用自己的服务端，服务端就可以给改设备发通知了
            private function onGetuiDidRegisterClient(e:GetuiPushNotificationEvent):void{
                var clientId:String = String(e.data);
                ...                
            }  
            
            /**
             * 切回来时重新初始化
             */		
            public function onActivate():void{
                    GetuiPushNotification.getInstance().resumeGetuiSdk();
            }
            
            /**
             * ios切到后台时关闭个推 
             */		
            public function onDeActivate():void{
                GetuiPushNotification.getInstance().pauseGetuiSdk();//安卓不能调用这个，会收不到通知
            }	
            
            

## 一些问题

* android 的推送icon图标push.png是打包在ane中的，无法在实际项目中配置，几种解决办法：
    * 打包apk前，修改个推ane，替换其中的push.png文件，参考 scripts/replace_ane_android_res.sh
    
* 和其他基于第三方sdk开发的ane混用的会有冲突
    * 目前只能去掉一些res下的资源来避免app打包失败。
    
* 出现Error: This attribute must be localized. (at 'text' with value 'xxxx').
    * 修改对应的文本,字string.xml中添加string,替代布局文件中出错的文本,     

        For example, in res/values/string.xml:    
        
        <string name="topLeftContent">TOP_LEFT</string>
            
        And in your main.xml layout, refer to the content by name: 
           
        android:text="@string/topLeftContent"