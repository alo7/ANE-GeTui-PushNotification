package com.alo7.ane.getuiPushNotification.function;

import android.util.Log;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.alo7.ane.getuiPushNotification.GetuiExtension;
import com.igexin.sdk.PushManager;

/**
 * Created by jiongli on 16/6/20.
 */
public class GetVersionFunction implements FREFunction {


    @Override
    public FREObject call(FREContext freContext, FREObject[] freObjects) {
        String version = PushManager.getInstance().getVersion(freContext.getActivity().getApplicationContext());
        FREObject result = null;
        try{
            result = FREObject.newObject(version);
        }catch (Exception e){
            Log.e(GetuiExtension.TAG, e.getMessage());
        }
        return result;
    }
}
