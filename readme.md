## 个推消息推送ANE

* ios库项目
    - [个推 ios sdk 下载](http://www.igetui.com/download/iOS/GETUI_IOS_SDK.zip)
    - 路径： ios/GetuiPushNotification
    - 生成 .a文件 (生成的路径??? /Users/xxx/Library/Developer/Xcode/DerivedData/GetuiPushNotification-gmhqnsxyqheawteuypjyzctojmbh/Build/Products/Debug-iphoneos/libGetuiPushNotification.a)

* andorid库项目
    - [个推 android sdk 下载](http://www.igetui.com/download/android/GETUI_ANDROID_SDK.zip)
    - 路径：android/GetuiPushNotification
    - 生成 .jar文件

* actionscript库项目
    - 路径：actionscript
    - 生成 .swc文件


* ane打包
    - 路径： build
    - 资源目录参考：

            ├── Android-ARM
            │   ├── libGetuiAndroid.jar
            │   ├── library.swf
            │   └── libs
            │       ├── armeabi
            │       │   └── libgetuiext.so
            │       └── armeabi-v7a
            │           └── libgetuiext.so
            ├── Android-x86
            │   ├── libGetuiAndroid.jar
            │   ├── library.swf
            │   └── libs
            │       └── x86
            │           └── libgetuiext.so
            ├── GetuiAne.swc
            ├── build.sh
            ├── extension.xml
            ├── iPhone-ARM
            │   ├── libGetuiPushNotification.a
            │   └── library.swf
            ├── library.swf
            └── platformIOSARM.xml

    - 运行 ./build.sh 生成 .ane文件 (需要先把adt添加到环境变量)


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
                    android:authorities="downloads.com.alo7.iclass.tots"/>
                    <!-- android:authorities="downloads.第三方包名" -->
                <!-- ====================================================== -->

    * 项目中启用：

            if(GetuiPushNotification.isPushNotificationSupported){
                var getuiInstance:GetuiPushNotification = GetuiPushNotification.getInstance();
                // 事件监听
                getuiInstance.addEventListener(GetuiPushNotificationEvent.TOKEN_SUCCESS,onTokenSuccess);
                getuiInstance.addEventListener(GetuiPushNotificationEvent.TOKEN_FAIL,onTokenFail);
                getuiInstance.addEventListener(GetuiPushNotificationEvent.GETUI_DID_REGISTER_CLIENT,onGetuiDidRegisterClient);
                getuiInstance.addEventListener(GetuiPushNotificationEvent.GETUI_DID_RECEIVE_PAYLOAD,onGetuiDidReceivePayload);
                getuiInstance.addEventListener(GetuiPushNotificationEvent.GETUI_DID_OCCUR_ERROR,onGetuiDidOccurError);

                // ios必须要传入前三位参数，android端前三位参数是从app.xml中获取，这里传不传都可以
               	getuiInstance.initializePushNotificaiton("aaaa","bbb","sdfdsf");
            }

## 一些问题
* android 的推送icon图标push.png是打包在ane中的，无法在实际项目中配置，几种解决办法：
    * 修改实际项目生成的apk文件，替换其中的push.png文件，参考 scripts/replace_apk_res.sh，apk解包、打包、重签名过程可能出问题，不推荐
    * 打包apk前，修改个推ane，替换其中的push.png文件，参考 scripts/replace_ane_android_res.sh, 推荐使用此方式

* 和其他基于第三方sdk开发的ane混用的会有冲突
    * 目前只能去掉一些res下的资源来避免打包失败，比如安卓项目中的res目录下的资源无法全部打包进ane中，寻求更好的解决办法。。。






