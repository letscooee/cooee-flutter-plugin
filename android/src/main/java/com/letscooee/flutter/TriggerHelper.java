package com.letscooee.flutter;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;

import com.google.gson.Gson;
import com.letscooee.models.TriggerData;
import com.letscooee.trigger.inapp.InAppTriggerActivity;
import com.letscooee.utils.Constants;

import io.sentry.Sentry;

/**
 * Load {@link InAppTriggerActivity} with the help of data
 *
 * @author Ashish Gaikwad on 11/06/21
 * @version 0.0.24
 */
public class TriggerHelper {

    public static TriggerData lastTriggerData;

    /**
     * Renders {@link InAppTriggerActivity}
     */
    public static void renderInAppTrigger(Context context) {
        try {
            Intent intent = new Intent(context, InAppTriggerActivity.class);
            Bundle sendBundle = new Bundle();
            sendBundle.putParcelable("triggerData", lastTriggerData);
            intent.putExtra("bundle", sendBundle);
            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            context.startActivity(intent);

        } catch (Exception ex) {
            Log.d(Constants.LOG_PREFIX, "Couldn't show Engagement Trigger " + ex.toString());
            Sentry.captureException(ex);
        }
    }
}
