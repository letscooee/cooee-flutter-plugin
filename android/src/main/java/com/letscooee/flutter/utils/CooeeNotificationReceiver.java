package com.letscooee.flutter.utils;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.util.Log;
import com.google.firebase.messaging.RemoteMessage;
import com.letscooee.services.CooeeFirebaseMessagingService;
import com.letscooee.utils.Constants;

/**
 * Handle received push notification from firebase and set flag in {@link CooeeFirebaseMessagingService}
 * to prevent displaying same notification twice.
 *
 * @author Ashish Gaikwad 31/08/22
 * @since 1.4.0
 */
public class CooeeNotificationReceiver extends BroadcastReceiver {

    public CooeeNotificationReceiver() {
        CooeeFirebaseMessagingService.setMessageDelivered();
    }

    @Override
    public void onReceive(Context context, Intent intent) {
        RemoteMessage remoteMessage = new RemoteMessage(intent.getExtras());
        Log.d(Constants.TAG, "Notification received");
        new CooeeFirebaseMessagingService(context).handleRemoteMessage(remoteMessage);
    }
}
