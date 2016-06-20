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
            int i = PushManager.getInstance().setTag(freContext.getActivity().getApplicationContext(), tagParam,
                    System.currentTimeMillis() + "");
            String text = "设置标签失败,未知异常";
            switch (i) {
                case PushConsts.SETTAG_SUCCESS:
                    text = "设置标签成功";
                    break;
                case PushConsts.SETTAG_ERROR_COUNT:
                    text = "设置标签失败, tag数量过大, 最大不能超过200个";
                    break;
                case PushConsts.SETTAG_ERROR_FREQUENCY:
                    text = "设置标签失败, 频率过快, 两次间隔应大于1s";
                    break;
                case PushConsts.SETTAG_ERROR_REPEAT:
                    text = "设置标签失败, 标签重复";
                    break;
                case PushConsts.SETTAG_ERROR_UNBIND:
                    text = "设置标签失败, 服务未初始化成功";
                    break;
                case PushConsts.SETTAG_ERROR_EXCEPTION:
                    text = "设置标签失败, 未知异常";
                    break;
                case PushConsts.SETTAG_ERROR_NULL:
                    text = "设置标签失败, tag 为空";
                    break;
                case PushConsts.SETTAG_NOTONLINE:
                    text = "还未登陆成功";
                    break;
                case PushConsts.SETTAG_IN_BLACKLIST:
                    text = "该应用已经在黑名单中,请联系售后支持!";
                    break;
                case PushConsts.SETTAG_NUM_EXCEED:
                    text = "已存 tag 超过限制";
                    break;
                default:
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
