package com.letscooee.flutter;

import com.letscooee.enums.WrapperType;
import com.letscooee.flutter.utils.Constants;
import com.letscooee.init.AppController;
import com.letscooee.user.NewSessionExecutor;

/**
 * Manage and bind {@link ActivityLifecycleCallbacks} and
 * by extending {@link AppController} gives control to
 * Native Android SDK.
 *
 * @author Ashish Gaikwad on 11/06/21
 * @version 0.0.24
 */
public class FlutterPluginController extends AppController {

    @Override
    public void onCreate() {
        NewSessionExecutor.updateWrapperInformation(WrapperType.FLUTTER, Constants.VERSION_CODE, Constants.VERSION_NAME);
        super.onCreate();
        registerActivityLifecycleCallbacks(new ActivityLifecycle());
    }
}
