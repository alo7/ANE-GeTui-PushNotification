package com.alo7.ane.getuiPushNotification;

import android.util.Log;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;

/**
 * Created by li on 2014/12/1.
 */
public class GetuiExtension implements FREExtension {
    public static String TAG = "getuiPushNotification";

    private static GetuiContext _context;
    public static boolean isInForeground = false;

    @Override
    public void initialize() {

    }

    @Override
    public FREContext createContext(String s) {
        _context = new GetuiContext();
        return _context;
    }

    @Override
    public void dispose() {
        if (_context != null) {
            _context.dispose();
            _context = null;
        }
    }

    public static void dispatchEventForAs(String type, String message)
    {
        Log.d(TAG, message);

        if (_context != null)
        {
            _context.dispatchStatusEventAsync(type, message);
        }
    }

    public static void doAsLog(String log){
        dispatchEventForAs(EventConst.LOG_EVENT,log);
    }

}
