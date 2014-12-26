package com.alo7.ane.getuiPushNotification;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.alo7.ane.getuiPushNotification.function.InitializeGetuiFunction;
import com.alo7.ane.getuiPushNotification.function.SetTagFunction;
import com.alo7.ane.getuiPushNotification.function.StartGetuiSdkFunction;
import com.alo7.ane.getuiPushNotification.function.StopGetuiSdkFunction;

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
        map.put("startGetuiSdk",new StartGetuiSdkFunction());
        map.put("stopGetuiSdk",new StopGetuiSdkFunction());
        map.put("setTag",new SetTagFunction());
        return map;
    }

    @Override
    public void dispose() {

    }
}
