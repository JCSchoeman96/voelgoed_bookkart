import System
import UIKit
import Flutter
import Foundation
import CommonCrypto
import CryptoKit
import AppleArchive

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let deviceChannel = FlutterMethodChannel(name: "CHANNEL", binaryMessenger: controller.binaryMessenger)
        
         prepareMethodHandler(deviceChannel: deviceChannel)
        
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }


    private func prepareMethodHandler(deviceChannel: FlutterMethodChannel) {
        deviceChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
            do {
                switch call.method {
                case "ENCRYPT":
                    guard let arguments = call.arguments as? [String: Any],
                          let inputURL = arguments["File"] as? String
                    else {
                        result(FlutterError(code: "InvalidArguments", message: "Invalid arguments", details: nil))
                        return
                    }

                    if #available(iOS 14.0, *) {
                        let encryptedFilePath = FilePath(inputURL)
                        let decryptedFilePath = FilePath(inputURL)
                        let sourceFilePath = FilePath(inputURL)
                        let key = SymmetricKey(size: SymmetricKeySize.bits256)
                        if #available(iOS 15.0, *) {
                            let context = ArchiveEncryptionContext(profile: .hkdf_sha256_aesctr_hmac__symmetric__none, compressionAlgorithm: .lzfse)
                            try context.setSymmetricKey(key)

                            if let sourceFileStream = ArchiveByteStream.fileStream(path: sourceFilePath, mode: .readOnly, options: [], permissions: FilePermissions(rawValue: 0o644)) {
                                if let destinationFileStream = ArchiveByteStream.fileStream(path: encryptedFilePath, mode: .writeOnly, options: [.create, .truncate], permissions: FilePermissions(rawValue: 0o644)) {
                                    if let encryptionStream = ArchiveByteStream.encryptionStream(writingTo: destinationFileStream, encryptionContext: context) {
                                        try ArchiveByteStream.process(readingFrom: sourceFileStream, writingTo: encryptionStream)
                                    }
                                }
                            }
                        } else {
                            self.showToast(message: "Not supported")
                        }
                        
                    } else {
                        self.showToast(message: "Not supported")
                    }
                   

                case "DECRYPT":
                    guard let arguments = call.arguments as? [String: Any],
                          let inputURL = arguments["File"] as? String
                    else {
                        result(FlutterError(code: "InvalidArguments", message: "Invalid arguments", details: nil))
                        return
                    }

                    if #available(iOS 14.0, *) {
                        let encryptedFilePath = FilePath(inputURL)
                        let decryptedFilePath = FilePath(inputURL)
                        let sourceFilePath = FilePath(inputURL)
                        let key = SymmetricKey(size: SymmetricKeySize.bits256)
                        if #available(iOS 15.0, *) {
                            let context = ArchiveEncryptionContext(profile: .hkdf_sha256_aesctr_hmac__symmetric__none, compressionAlgorithm: .lzfse)
                            if let sourceFileStream = ArchiveByteStream.fileStream(path: sourceFilePath, mode: .readOnly, options: [], permissions: FilePermissions(rawValue: 0o644)) {
                                let decryptionContext = ArchiveEncryptionContext(from: sourceFileStream)
                                try decryptionContext?.setSymmetricKey(key)

                                if let decryptionStream = ArchiveByteStream.decryptionStream(readingFrom: sourceFileStream, encryptionContext: decryptionContext!) {
                                    if let decryptedFileStream = ArchiveByteStream.fileStream(path: decryptedFilePath, mode: .writeOnly, options: [.create, .truncate], permissions: FilePermissions(rawValue: 0o644)) {
                                        try ArchiveByteStream.process(readingFrom: decryptionStream, writingTo: decryptedFileStream)
                                    }
                                }
                            }
                        } else {
                            self.showToast(message: "Not supported")
                        }
                        
                    } else {
                        self.showToast(message: "Not supported")
                    }
                   

                default:
                    result(FlutterMethodNotImplemented)
                }
            } catch {
                result(FlutterError(code: "Exception", message: error.localizedDescription, details: nil))
            }
        }
    }

    


func showToast(message: String) {
    let toastViewController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
    let duration: Double = 2
    UIApplication.shared.keyWindow?.rootViewController?.present(toastViewController, animated: true, completion: nil)
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
        toastViewController.dismiss(animated: true, completion: nil)
    }
   }

}
