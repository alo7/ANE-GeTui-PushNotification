package com.alo7.ane.getuiPushNotification;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.igexin.sdk.PushManager;

/**
 * Created by jiongli on 14/12/3.
 */
public class InitializeGetuiFunction implements FREFunction {
    private static String TAG = "initialize_getui";

    @Override
    public FREObject call(FREContext freContext, FREObject[] freObjects) {

        // SDK初始化，第三方程序启动时，都要进行SDK初始化工作
        GetuiExtension.doAsLog("initialize sdk...");
        PushManager.getInstance().initialize(freContext.getActivity().getApplicationContext());

        return null;
    }
}
