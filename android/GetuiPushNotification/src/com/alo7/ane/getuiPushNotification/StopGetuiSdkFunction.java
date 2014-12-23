package com.alo7.ane.getuiPushNotification;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.igexin.sdk.PushManager;

/**
 * Created by jiongli on 14/12/22.
 */
public class StopGetuiSdkFunction implements FREFunction{
    private static String TAG = "stop_getui";

    @Override
    public FREObject call(FREContext freContext, FREObject[] freObjects) {
        // 关闭push推送
        if(PushManager.getInstance().isPushTurnedOn(freContext.getActivity().getApplicationContext())){
            GetuiExtension.doAsLog( "stop sdk...");
            PushManager.getInstance().turnOffPush(freContext.getActivity().getApplicationContext());
        }else{
            GetuiExtension.doAsLog("sdk is stoped");
        }
        return null;
    }
}
