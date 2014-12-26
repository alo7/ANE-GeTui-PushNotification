package com.alo7.ane.getuiPushNotification.function;

import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.alo7.ane.getuiPushNotification.GetuiExtension;
import com.igexin.sdk.PushManager;

/**
 * Created by jiongli on 14/12/3.
 */
public class InitializeGetuiFunction implements FREFunction {

    @Override
    public FREObject call(FREContext freContext, FREObject[] freObjects) {
        try {
            ApplicationInfo appInfo = freContext.getActivity().getPackageManager().getApplicationInfo(freContext.getActivity().getPackageName(), PackageManager.GET_META_DATA);
            if (appInfo.metaData != null) {

                String appid = appInfo.metaData.getString("PUSH_APPID");
                String appsecret = appInfo.metaData.getString("PUSH_APPSECRET");
                String appkey = (appInfo.metaData.get("PUSH_APPKEY") != null) ? appInfo.metaData.get("PUSH_APPKEY").toString() : null;
                GetuiExtension.doAsLog("initialize sdk: appid:"+appid + ", appkey:"+appkey + ", appsecret:" + appsecret);

            }
        }catch (PackageManager.NameNotFoundException e){
            GetuiExtension.doAsLog(e.getMessage());
        }

        // SDK初始化，第三方程序启动时，都要进行SDK初始化工作
        PushManager.getInstance().initialize(freContext.getActivity().getApplicationContext());

        return null;
    }
}
