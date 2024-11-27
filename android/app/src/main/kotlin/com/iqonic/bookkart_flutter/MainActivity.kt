package co.za.voelgoed.media

import io.flutter.embedding.android.FlutterActivity
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import javax.crypto.Cipher
import co.za.voelgoed.media.FileEncryptionUtils

class MainActivity : FlutterActivity() {


    companion object Test {
        const val ENCRYPT = "ENCRYPT";
        const val DECRYPT = "DECRYPT";
        const val CHANNEL = "CHANNEL"
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)


        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->

            when (call.method) {

                ENCRYPT -> {
                    result.success((FileEncryptionUtils.doCryptoInAES(applicationContext, cipherMode = Cipher.ENCRYPT_MODE, "bookkart", File(call.argument<String>("File")), File(call.argument<String>("File")))))
//                    result.success(FileEncryptionUtils.encrypt(applicationContext, call.argument<String>("File")))
                }
                DECRYPT -> {
                    result.success((FileEncryptionUtils.doCryptoInAES(applicationContext, cipherMode = Cipher.DECRYPT_MODE, "bookkart", File(call.argument<String>("File")), File(call.argument<String>("File")))))
//                    result.success(FileEncryptionUtils.decrypt(applicationContext, call.argument<String>("File")))
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}
