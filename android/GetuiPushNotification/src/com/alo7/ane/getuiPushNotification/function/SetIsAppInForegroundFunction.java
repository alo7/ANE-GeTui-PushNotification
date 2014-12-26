package com.alo7.ane.getuiPushNotification.function;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.alo7.ane.getuiPushNotification.GetuiExtension;

/**
 * Created by jiongli on 14/12/26.
 */
public class SetIsAppInForegroundFunction implements FREFunction {
    @Override
    public FREObject call(FREContext freContext, FREObject[] freObjects) {
        try {
            boolean isInForeground = freObjects[0].getAsBool();
            GetuiExtension.isInForeground = isInForeground;
        } catch (Exception e) {
            GetuiExtension.doAsLog(e.getMessage());
        }
        return null;
    }
}
