package com.alo7.ane.getuiPushNotification.function;

import com.adobe.fre.*;
import com.alo7.ane.getuiPushNotification.EventConst;
import com.alo7.ane.getuiPushNotification.GetuiExtension;
import com.igexin.sdk.PushConsts;
import com.igexin.sdk.PushManager;
import com.igexin.sdk.Tag;

/**
 * Created by jiongli on 14/12/26.
 */
public class SetTagFunction implements FREFunction {
    @Override
    public FREObject call(FREContext freContext, FREObject[] freObjects) {
        String tagString = null;
        boolean result = false;
        try{
            tagString = freObjects[0].getAsString();
        }catch (Exception e){
            GetuiExtension.doAsLog(e.getMessage());
        }
        if(tagString!=null){
            String[] tags = tagString.split(",");
            Tag[] tagParam = new Tag[tags.length];
            for (int i = 0; i < tags.length; i++) {
                Tag t = new Tag();
                t.setName(tags[i]);
                tagParam[i] = t;
            }
            GetuiExtension.doAsLog("设置标签："+tagString);
            int i = PushManager.getInstance().setTag(freContext.getActivity().getApplicationContext(), tagParam);
            String text = "ERROR";
            switch (i) {
                case PushConsts.SETTAG_SUCCESS:
                    text = "设置标签成功:";
                    result = true;
                    break;
                case PushConsts.SETTAG_ERROR_COUNT:
                    text = "设置标签失败，tag数量过大:";
                    break;
                default:
                    text = "设置标签失败，setTag异常:";
                    break;
            }
            GetuiExtension.doAsLog(text);
        }
        try{
            return FREObject.newObject(result);
        }catch (FREWrongThreadException e){
            return null;
        }
    }
}
