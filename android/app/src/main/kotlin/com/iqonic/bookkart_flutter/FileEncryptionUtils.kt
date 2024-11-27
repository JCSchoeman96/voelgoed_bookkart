<<<<<<< HEAD
package co.za.voelgoed.media
=======
package com.iqonic.bookkart_flutter
>>>>>>> ae21abeaa0319c719eda54e7b11e7019d33c88ee

import android.content.Context
import android.media.MediaCodec
import android.widget.Toast
import java.io.File
import java.io.FileInputStream
import java.io.FileOutputStream
import java.io.IOException
import java.nio.charset.StandardCharsets
import java.security.*
import javax.crypto.*
import javax.crypto.spec.SecretKeySpec


object FileEncryptionUtils {

    @Throws(NoSuchPaddingException::class, NoSuchAlgorithmException::class, InvalidAlgorithmParameterException::class, InvalidKeyException::class, Exception::class)
    fun createKey(): SecretKey {
        val keyString = "bookkart_official_123456789"
        val messageDigest: MessageDigest = MessageDigest.getInstance("SHA-256")
        val keyBytes: ByteArray = messageDigest.digest(keyString.toByteArray(StandardCharsets.UTF_8))

        return SecretKeySpec(keyBytes, "AES")

    }

    @Throws(MediaCodec.CryptoException::class)
    fun doCryptoInAES(
        applicationContext: Context,
        cipherMode: Int, key: String, inputFile: File,
        outputFile: File,
    ): Boolean {
        try {
            
            val cipher: Cipher = Cipher.getInstance("AES")
            cipher.init(cipherMode, createKey())
            val inputStream = FileInputStream(inputFile)
            val inputBytes = ByteArray(inputFile.length().toInt())
            inputStream.read(inputBytes)
            val outputBytes: ByteArray = cipher.doFinal(inputBytes)
            val outputStream = FileOutputStream(outputFile)
            outputStream.write(outputBytes)
            inputStream.close()
            outputStream.close()
            return true


        } catch (ex: NoSuchPaddingException) {
            throw MediaCodec.CryptoException(0, "Something went wrong NoSuchPaddingException")
        } catch (ex: NoSuchAlgorithmException) {
            throw MediaCodec.CryptoException(0, "Something went wrong NoSuchAlgorithmException")
        } catch (ex: InvalidKeyException) {
            throw MediaCodec.CryptoException(0, "Something went wrong InvalidKeyException")
        } catch (ex: BadPaddingException) {
            throw MediaCodec.CryptoException(0, "Something went wrong BadPaddingException")
        } catch (ex: IllegalBlockSizeException) {
            throw MediaCodec.CryptoException(0, "Something went wrong IllegalBlockSizeException")
        } catch (ex: IOException) {
            throw MediaCodec.CryptoException(0, "Something went wrong IOException")
        }
    }


}
