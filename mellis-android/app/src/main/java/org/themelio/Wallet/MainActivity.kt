package org.themelio.Wallet

import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.webkit.*
import androidx.annotation.RequiresApi
import androidx.appcompat.app.AppCompatActivity
import androidx.webkit.WebViewAssetLoader


class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        var mWebView: WebView = findViewById(R.id.main_webview);
        mWebView.settings.javaScriptEnabled = true;
        mWebView.settings.cacheMode = WebSettings.LOAD_NO_CACHE;
        mWebView.settings.domStorageEnabled = true;
        mWebView.settings.allowFileAccessFromFileURLs = true;
        mWebView.settings.setSupportMultipleWindows(false);
        val assetLoader: WebViewAssetLoader = WebViewAssetLoader.Builder()
            .addPathHandler("/", WebViewAssetLoader.AssetsPathHandler(this))
            .build()

        mWebView.setWebViewClient(object : WebViewClient() {
//            @RequiresApi(21)
//            override fun shouldInterceptRequest(
//                view: WebView,
//                request: WebResourceRequest
//            ): WebResourceResponse? {
//                return assetLoader.shouldInterceptRequest(request.url)
//            }

            // for API < 21
            @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
            override fun shouldInterceptRequest(
                view: WebView,
                request: WebResourceRequest
            ): WebResourceResponse? {
                return assetLoader.shouldInterceptRequest(request.url)
            }
        })


        mWebView.loadUrl("https://appassets.androidplatform.net/index.html")
    }
}
