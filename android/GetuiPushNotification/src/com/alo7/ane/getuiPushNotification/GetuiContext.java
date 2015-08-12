package com.alo7.ane.getuiPushNotification;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.alo7.ane.getuiPushNotification.function.*;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by li on 2014/12/1.
 */
public class GetuiContext extends FREContext {


    @Override
    public Map<String, FREFunction> getFunctions() {
        Map<String, FREFunction> map = new HashMap<String, FREFunction>();
        map.put("initializePushNotificaiton",new InitializeGetuiFunction());
        map.put("resumeGetuiSdk",new ResumeGetuiSdkFunction());
        map.put("pauseGetuiSdk",new PauseGetuiSdkFunction());
        map.put("setTag",new SetTagFunction());
//        map.put("sendLocalNotification",new LocalNotificationFunction());
//        map.put("cancelLocalNotification",new CancelLocalNotificationFunction());
//        map.put("setIsAppInForeground",new SetIsAppInForegroundFunction());
        return map;
    }

    @Override
    public void dispose() {

    }
}
