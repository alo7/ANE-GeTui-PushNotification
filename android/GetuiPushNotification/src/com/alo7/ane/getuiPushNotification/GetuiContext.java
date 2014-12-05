package com.alo7.ane.getuiPushNotification;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;

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
        return map;
    }

    @Override
    public void dispose() {

    }
}
