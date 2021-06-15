package com.letscooee.flutter;

import android.app.Activity;
import android.app.Application;
import android.os.Bundle;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.letscooee.models.TriggerData;
import com.letscooee.models.TriggerBehindBackground;
import com.letscooee.trigger.CooeeEmptyActivity;
import com.letscooee.trigger.inapp.InAppTriggerActivity;
import com.letscooee.utils.Constants;


/**
 * Register {@link Application.ActivityLifecycleCallbacks} to
 * observe activity lifecycle
 *
 * @author Ashish Gaikwad on 11/06/21
 * @since 0.0.24
 */
public class ActivityLifecycle implements Application.ActivityLifecycleCallbacks {

    private static CooeeFlutterPlugin cooeeFlutterPlugin;

    public ActivityLifecycle() {
    }

    @Override
    public void onActivityCreated(@NonNull Activity activity, @Nullable Bundle savedInstanceState) {

    }

    @Override
    public void onActivityStarted(@NonNull Activity activity) {

    }

    @Override
    public void onActivityResumed(@NonNull Activity activity) {
        if (cooeeFlutterPlugin == null) {
            return;
        }
        if (activity instanceof CooeeEmptyActivity) {
            return;
        }

        if (activity instanceof InAppTriggerActivity) {
            TriggerData triggerData = ((InAppTriggerActivity) activity).getTriggerData();

            if (triggerData.getTriggerBackground().getType() == TriggerBehindBackground.Type.BLURRED) {
                int blur = triggerData.getTriggerBackground().getBlurRadius();
                String color = triggerData.getTriggerBackground().getColor();
                cooeeFlutterPlugin.renderGlassmorphismWidget(blur, color);
            }
        } else {
            if (TriggerHelper.lastTriggerData != null) {
                // Alternative of using ProcessLifeCycleOwner
                synchronized (TriggerHelper.lastTriggerData) {
                    TriggerHelper.renderInAppTrigger(activity);
                    TriggerHelper.lastTriggerData = null;
                }
            }
        }

    }

    @Override
    public void onActivityPaused(@NonNull Activity activity) {
        if (cooeeFlutterPlugin == null) {
            return;
        }
        if (activity instanceof InAppTriggerActivity) {
            InAppTriggerActivity inappActivity = (InAppTriggerActivity) activity;
            if (inappActivity.isManualClose()) {
                return;
            }
            TriggerData triggerData = inappActivity.getTriggerData();
            if (triggerData.getTriggerBackground().getType() == TriggerBehindBackground.Type.BLURRED) {
                TriggerHelper.lastTriggerData = inappActivity.getTriggerData();
            }
        }
    }

    @Override
    public void onActivityStopped(@NonNull Activity activity) {
        if (cooeeFlutterPlugin == null) {
            return;
        }

        if (activity instanceof InAppTriggerActivity) {
            cooeeFlutterPlugin.closeGlassmorphismWidget();
        }
    }

    @Override
    public void onActivitySaveInstanceState(@NonNull Activity activity, @NonNull Bundle outState) {

    }

    @Override
    public void onActivityDestroyed(@NonNull Activity activity) {

    }

    /**
     * Set instance of {@link CooeeFlutterPlugin} to manage Glassmorphism effect
     */
    public static void setCooeeFlutterPlugin(CooeeFlutterPlugin cooeeFlutterPlugin) {

        ActivityLifecycle.cooeeFlutterPlugin = cooeeFlutterPlugin;
    }


}
