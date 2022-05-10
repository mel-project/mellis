package org.themelio.Wallet

import android.Manifest
import android.annotation.TargetApi
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import android.util.Log
import android.webkit.*
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.ActivityCompat.requestPermissions
import androidx.core.content.ContextCompat
import androidx.webkit.WebViewAssetLoader
import java.io.BufferedReader
import java.io.IOException
import java.io.InputStreamReader
import kotlin.concurrent.thread


class MainActivity : AppCompatActivity() {

    var mwdProcess: Process? = null;

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // If the process is not running, start it.
        // The executable is a "fake library" in the native library directory
        val daemonBinaryPath = applicationInfo.nativeLibraryDir + "/libmelwalletd.so";
        val pb = ProcessBuilder(daemonBinaryPath, "--wallet-dir", applicationInfo.dataDir + "/wallets");
        try {
            val proc = pb.start();
            thread {
                val reader = BufferedReader(InputStreamReader(proc.errorStream));
                while (true) {
                    val line = reader.readLine() ?: break;
                    Log.d("MELWALLETD", line);
                }
            }
            mwdProcess = proc;
        } catch (e: IOException) {
            Log.e("START", e.toString());
            Toast.makeText(applicationContext, e.toString(), Toast.LENGTH_LONG).show();
            return;
        }



        setContentView(R.layout.activity_main)
        val mWebView: WebView = findViewById(R.id.main_webview)
        mWebView.settings.javaScriptEnabled = true;
        mWebView.settings.cacheMode = WebSettings.LOAD_NO_CACHE;
        mWebView.settings.domStorageEnabled = true;
        mWebView.settings.allowFileAccessFromFileURLs = true;
        mWebView.settings.setSupportMultipleWindows(false);
        mWebView.settings.mixedContentMode = WebSettings.MIXED_CONTENT_ALWAYS_ALLOW;
        val assetLoader: WebViewAssetLoader = WebViewAssetLoader.Builder()
            .setDomain("a.com")
            .setHttpAllowed(true)
            .addPathHandler("/", WebViewAssetLoader.AssetsPathHandler(this))
            .build()

        mWebView.setWebViewClient(object : WebViewClient() {
            override fun shouldInterceptRequest(
                view: WebView,
                request: WebResourceRequest
            ): WebResourceResponse? {
                return assetLoader.shouldInterceptRequest(request.url)
            }
        })
        mWebView.setWebChromeClient(object : WebChromeClient() {
            override fun onPermissionRequest(request: PermissionRequest) {
                if (ContextCompat.checkSelfPermission(applicationContext, Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED) {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                        requestPermissions(arrayOf(Manifest.permission.CAMERA), 100)
                    };
                }
                request.grant(request.resources)
            }
        })

        WebView.setWebContentsDebuggingEnabled(true);
        mWebView.loadUrl("https://a.com/index.html")
    }
}
