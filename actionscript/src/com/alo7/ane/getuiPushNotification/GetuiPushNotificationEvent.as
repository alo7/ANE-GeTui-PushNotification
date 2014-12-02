/**
 * Created by jiongli on 14/12/2.
 */
package com.alo7.ane.getuiPushNotification {
    import flash.events.Event;

    public class GetuiPushNotificationEvent extends Event{

        public static const TOKEN_SUCCESS:String = "TOKEN_SUCCESS";  //注册APN成功
        public static const TOKEN_FAIL:String = "TOKEN_FAIL";  //注册APN失败
        public static const RECEIVE_REMOTE_NOTIFICATION:String = "RECEIVE_REMOTE_NOTIFICATION"; // 接受远程通知
        public static const GETUI_DID_REGISTER_CLIENT:String = "GETUI_DID_REGISTER_CLIENT"; //个推注册clinetId成功
        public static const GETUI_DID_RECEIVE_PAYLOAD:String = "GETUI_DID_RECEIVE_PAYLOAD"; //个推接受个推消息
        public static const GETUI_DID_OCCUR_ERROR:String = "GETUI_DID_OCCUR_ERROR";//通知发送错误

        public var data:Object;

        public function GetuiPushNotificationEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
            super (type,bubbles,cancelable);
        }


    }
}
