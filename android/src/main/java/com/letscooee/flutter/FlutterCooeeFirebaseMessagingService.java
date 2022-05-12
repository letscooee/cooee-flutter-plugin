package com.letscooee.flutter;

import com.google.firebase.messaging.RemoteMessage;
import com.letscooee.services.CooeeFirebaseMessagingService;
import androidx.annotation.NonNull;

/**
 * FlutterCooeeFirebaseMessagingService is a class that extends the {@link CooeeFirebaseMessagingService}
 * which helps to run engagements in the background/foreground.
 *
 * @author Ashish Gaikwad 12/05/22
 * @since 1.3.5
 */
public class FlutterCooeeFirebaseMessagingService extends CooeeFirebaseMessagingService {
    @Override
    public void onNewToken(@NonNull String token) {
        super.onNewToken(token);
    }

    @Override
    public void onMessageReceived(@NonNull RemoteMessage remoteMessage) {
        super.onMessageReceived(remoteMessage);
    }
}