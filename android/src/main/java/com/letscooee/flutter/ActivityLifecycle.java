package com.letscooee.flutter;

import android.app.Activity;
import android.app.Application;
import android.graphics.Bitmap;
import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.letscooee.trigger.inapp.InAppTriggerActivity;


/**
 * Register {@link Application.ActivityLifecycleCallbacks} to
 * observe activity lifecycle
 *
 * @author Ashish Gaikwad on 11/06/21
 * @since 0.0.24
 */
public class ActivityLifecycle implements Application.ActivityLifecycleCallbacks {

    public ActivityLifecycle() {
    }

    @Override
    public void onActivityCreated(@NonNull Activity activity, @Nullable Bundle savedInstanceState) {
        if (activity instanceof InAppTriggerActivity) {
            Bitmap bitmap = CooeeFlutterPlugin.getInstance().getFlutterRenderer().getBitmap();
            ((InAppTriggerActivity) activity).setBitmapForBlurry(bitmap);
        }
    }

    @Override
    public void onActivityStarted(@NonNull Activity activity) {}

    @Override
    public void onActivityResumed(@NonNull Activity activity) {}

    @Override
    public void onActivityPaused(@NonNull Activity activity) {}

    @Override
    public void onActivityStopped(@NonNull Activity activity) {}

    @Override
    public void onActivitySaveInstanceState(@NonNull Activity activity, @NonNull Bundle outState) {}

    @Override
    public void onActivityDestroyed(@NonNull Activity activity) {}
}
