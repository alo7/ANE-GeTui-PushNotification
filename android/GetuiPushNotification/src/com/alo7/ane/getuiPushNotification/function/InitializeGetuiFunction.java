package com.alo7.ane.getuiPushNotification.function;

import android.Manifest;
import android.content.pm.PackageManager;
import android.os.Build;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.alo7.ane.getuiPushNotification.EventConst;
import com.alo7.ane.getuiPushNotification.GetuiExtension;
import com.alo7.ane.getuiPushNotification.GetuiIntentService;
import com.alo7.ane.getuiPushNotification.GetuiPushService;
import com.igexin.sdk.PushManager;

/**
 * Created by jiongli on 14/12/3.
 */
public class InitializeGetuiFunction implements FREFunction {

    @Override
    public FREObject call(FREContext freContext, FREObject[] freObjects) {

        PackageManager pkgManager = freContext.getActivity().getPackageManager();

        // 读写 sd card 权限非常重要, android6.0默认禁止的, 建议初始化之前就弹窗让用户赋予该权限
        boolean sdCardWritePermission =
                pkgManager.checkPermission(Manifest.permission.WRITE_EXTERNAL_STORAGE, freContext.getActivity().getPackageName()) == PackageManager.PERMISSION_GRANTED;

        // read phone state用于获取 imei 设备信息
        boolean phoneSatePermission =
                pkgManager.checkPermission(Manifest.permission.READ_PHONE_STATE, freContext.getActivity().getPackageName()) == PackageManager.PERMISSION_GRANTED;

        if (Build.VERSION.SDK_INT >= 23 && !sdCardWritePermission || !phoneSatePermission) {
            GetuiExtension.dispatchEventForAs(EventConst.GETUI_NEED_PERMISSION,
                    "WRITE_EXTERNAL_STORAGE: " + sdCardWritePermission + ", READ_PHONE_STATE: " + phoneSatePermission);
        } else {
            PushManager.getInstance().initialize(freContext.getActivity().getApplicationContext(), GetuiPushService.class);
        }

        PushManager.getInstance().registerPushIntentService(freContext.getActivity().getApplicationContext(), GetuiIntentService.class);

        return null;
    }

}
