// Initialize the API
const __PDA_platformReadyPromise = new Promise(resolve => {
    window.addEventListener("flutterInAppWebViewPlatformReady", resolve);
});

// Performs a GET request to the provided URL
// Returns a promise for a response object that has these properties:
//     responseHeaders - String, with CRLF line terminators.
//     responseText
//     status
//     statusText
async function PDA_httpGet(url) {
    await __PDA_platformReadyPromise;
    return window.flutter_inappwebview.callHandler("PDA_httpGet", url);
}

// Performs a POST request to the provided URL
// The expected arguments are:
//     url
//     headers - Object with key, value string pairs 
//     body - String or Object with key, value string pairs. If it's an object,
//            it will be encoded as form fields
// Returns a promise for a response object that has these properties:
//     responseHeaders: String, with CRLF line terminators.
//     responseText
//     status
//     statusText
async function PDA_httpPost(url, headers, body) {
    await __PDA_platformReadyPromise;
    return window.flutter_inappwebview.callHandler("PDA_httpPost", url, headers, body);
}

