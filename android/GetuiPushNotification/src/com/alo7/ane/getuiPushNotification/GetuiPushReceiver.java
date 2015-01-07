package com.alo7.ane.getuiPushNotification;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import com.igexin.sdk.PushConsts;
import com.igexin.sdk.PushManager;

public class GetuiPushReceiver extends BroadcastReceiver {

    @Override
    public void onReceive(Context context, Intent intent) {
        Bundle bundle = intent.getExtras();

        GetuiExtension.doAsLog("onReceive() action=" + bundle.getInt("action"));
        switch (bundle.getInt(PushConsts.CMD_ACTION)) {

            case PushConsts.GET_MSG_DATA:
                // 获取透传数据
                // String appid = bundle.getString("appid");
                GetuiExtension.doAsLog("get_msg_data:" + bundle.toString());

                byte[] payload = bundle.getByteArray("payload");

                String taskid = bundle.getString("taskid");
                String messageid = bundle.getString("messageid");

                // smartPush第三方回执调用接口，actionid范围为90000-90999，可根据业务场景执行
                boolean result = PushManager.getInstance().sendFeedbackMessage(context, taskid, messageid, 90001);
                GetuiExtension.doAsLog( "第三方回执接口调用" + (result ? "成功" : "失败"));

                String data = payload!=null?new String(payload):"null";
                GetuiExtension.dispatchEventForAs(EventConst.GETUI_DID_RECEIVE_PAYLOAD, data);

                break;
            case PushConsts.GET_CLIENTID:
                // 获取ClientID(CID)
                // 第三方应用需要将CID上传到第三方服务器，并且将当前用户帐号和CID进行关联，以便日后通过用户帐号查找CID进行消息推送
                String cid = bundle.getString("clientid");
//			Log.d("GetuiSdk","client id:" + cid);
                GetuiExtension.dispatchEventForAs(EventConst.GETUI_DID_REGISTER_CLIENT, cid);
                break;
            case PushConsts.THIRDPART_FEEDBACK:
            /*String appid = bundle.getString("appid");
			String taskid = bundle.getString("taskid");
			String actionid = bundle.getString("actionid");
			String result = bundle.getString("result");
			long timestamp = bundle.getLong("timestamp");

			Log.d("GetuiSdk", "appid = " + appid);
			Log.d("GetuiSdk", "taskid = " + taskid);
			Log.d("GetuiSdk", "actionid = " + actionid);
			Log.d("GetuiSdk", "result = " + result);
			Log.d("GetuiSdk", "timestamp = " + timestamp);*/
                break;
            default:
                GetuiExtension.dispatchEventForAs(EventConst.OTHER_EVENT,bundle.toString());
                break;
        }
    }
}
