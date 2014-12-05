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

    - 运行 ./build.sh 生成 .ane文件


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

    * android平台，需要修改app.xml,添加权限和服务配置，详见[个推安卓sdk的接入文档：在AndroidManifest.xml 里添加相关声明](http://docs.igetui.com/pages/viewpage.action?pageId=589991)

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







