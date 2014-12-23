package com.alo7.ane.getuiPushNotification;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.igexin.sdk.PushManager;

/**
 * Created by jiongli on 14/12/22.
 */
public class StartGetuiSdkFunction implements FREFunction {

    @Override
    public FREObject call(FREContext freContext, FREObject[] freObjects) {
        // 开启push推送
        if(PushManager.getInstance().isPushTurnedOn(freContext.getActivity().getApplicationContext())){
            GetuiExtension.doAsLog("sdk is started");
        }else{
            GetuiExtension.doAsLog("start sdk...");
            PushManager.getInstance().turnOnPush(freContext.getActivity().getApplicationContext());
        }
        return null;
    }
}
