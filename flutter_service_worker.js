'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"apple-touch-icon.png": "3dc89a24a046276ae122b40d2d1deadc",
"assets/AssetManifest.bin": "269707fded68223ca1b03d97f6812a82",
"assets/AssetManifest.bin.json": "bf4653538a919db7e01f3bf42ab5975b",
"assets/AssetManifest.json": "601c0f7a72c3829023e14945e6efc6dd",
"assets/assets/icons/achievment.png": "d39111f5f36158c450b301ab7ddb1627",
"assets/assets/icons/back.png": "a6094e7873a2d79cdcee0e3c809f5679",
"assets/assets/icons/card.svg": "554ae831c9dd190c9e924409e7f61b27",
"assets/assets/icons/explore.png": "844f9786232ad4233295e631c75910aa",
"assets/assets/icons/eye-slash.svg": "bab8f69cf051cb5faff36e02b475ead0",
"assets/assets/icons/eye.svg": "00c92db7a4025800249f159c0fc9d26e",
"assets/assets/icons/fantasy.png": "e71b35bf54c902af07c45079c3f89915",
"assets/assets/icons/flash.svg": "16fcd581cd62d516e7cf32ce7f034b17",
"assets/assets/icons/gallery.svg": "7c1643b92ac7b20649793dc5ee8bfd51",
"assets/assets/icons/generate.png": "faa0f90e45ddcbe990610f612a4d0504",
"assets/assets/icons/google.svg": "bec4ddbb7b1f7ff11dad829ecf7999b3",
"assets/assets/icons/home.png": "fc455f4e24bbafa90ea4bb2f58ca8049",
"assets/assets/icons/honesty.png": "44940929920b261d3827cbc4d1bdc1b4",
"assets/assets/icons/kanca.png": "791e7d2fa6d81e22fad61ff0376789e3",
"assets/assets/icons/kanca_text.png": "8673907d7950877f0dbdd27f0cc86368",
"assets/assets/icons/mic.svg": "d5134c2aea28d20daee5a982934d0d21",
"assets/assets/icons/play.svg": "85d4434091dd111432c15b414c2900ab",
"assets/assets/icons/profile.png": "60e9f4853a401f44a08cb73d0d9060e2",
"assets/assets/icons/progress.png": "6ba2f87ca31fc55b8f42916f0abd2e23",
"assets/assets/icons/saving.png": "9a9677d53fcc533908445943d4aec69f",
"assets/assets/icons/school.png": "c336864f396800b8eafe49df642f7c8a",
"assets/assets/icons/send.svg": "2d3824053111a215affe495b8c1dd77b",
"assets/assets/icons/share.svg": "54d1fa7de580eaa4d5458e8408ba23df",
"assets/assets/icons/sharing.png": "78da7cc92a7e8d4e1937dc3265025504",
"assets/assets/icons/shopping.png": "423481b7971dac91efb2bc79206afa7f",
"assets/assets/icons/wise.png": "a55d48e6549f7cf924bec610c45dacfd",
"assets/assets/images/artboard_1.webp": "fd47952df45889f6fca22abf3e661e35",
"assets/assets/images/artboard_2.webp": "df6cc9b3df4c44b69f376110a5a4cafe",
"assets/assets/images/artboard_3.webp": "fd7f8eea443d62aa23944572254328b3",
"assets/assets/images/kimo_1.webp": "d2218d933c1490ce5e86b702068667c1",
"assets/assets/images/kimo_2.webp": "78736e097cd1b905f4f419a09819af96",
"assets/assets/lottie/loading.json": "7c1c82d743de6c5442a28da8d005ed93",
"assets/assets/mascots/auth.webp": "32108f5a019eb5c0b427e3984c52953f",
"assets/assets/mascots/help_center.webp": "37383766faeddae10449510648bd0838",
"assets/assets/mascots/hooray.webp": "142c58c89475705a3198bd0a4c432668",
"assets/assets/mascots/onboarding_loading.webp": "3026cc864cb88bf3d784d347fedf2b45",
"assets/assets/mascots/thinking.webp": "c1b31cbcf3d2a587e5921adf85884f5e",
"assets/assets/mascots/thinking_money.webp": "59ecb9423851bad1c8d318acd12cc6d5",
"assets/FontManifest.json": "7b2a36307916a9721811788013e65289",
"assets/fonts/MaterialIcons-Regular.otf": "5935348c6f0728d9bf9cd4a28339adf6",
"assets/NOTICES": "0b356b31d124fb5a62f810bcde36589e",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/canvaskit.js.symbols": "bdcd3835edf8586b6d6edfce8749fb77",
"canvaskit/canvaskit.wasm": "7a3f4ae7d65fc1de6a6e7ddd3224bc93",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.js.symbols": "b61b5f4673c9698029fa0a746a9ad581",
"canvaskit/chromium/canvaskit.wasm": "f504de372e31c8031018a9ec0a9ef5f0",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/skwasm.js.symbols": "e72c79950c8a8483d826a7f0560573a1",
"canvaskit/skwasm.wasm": "39dd80367a4e71582d234948adc521c0",
"favicon.ico": "fe5786316d656e6c9a6618907ea835d4",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"flutter_bootstrap.js": "651abbecc56fa7fa12221c0db934a6b1",
"icon-192-maskable.png": "fe46c2a281911a84f40b966111004b34",
"icon-192.png": "33fd9786e0f38af4a5926bdc93aca1aa",
"icon-512-maskable.png": "6355754012b8adf0e58077ae6fa6bccf",
"icon-512.png": "b286cbe90188f71780bd33a8374af789",
"index.html": "e3b4d1263de00ed82f57b60065e65984",
"/": "e3b4d1263de00ed82f57b60065e65984",
"main.dart.js": "89f50eb62571055b02cb771391e1fc0a",
"manifest.json": "76052ecde0aa1fc2cdc1b8cb129d90b9",
"splash/img/dark-1x.png": "16e65dac65091e01f02229772cd62f22",
"splash/img/dark-2x.png": "1d76913e4e08762fcf88079288ffd53e",
"splash/img/dark-3x.png": "e25f7865517ff79d7e31f11695908dc0",
"splash/img/dark-4x.png": "bc3aebd4dea3158fcb69033185a1e93c",
"splash/img/light-1x.png": "16e65dac65091e01f02229772cd62f22",
"splash/img/light-2x.png": "1d76913e4e08762fcf88079288ffd53e",
"splash/img/light-3x.png": "e25f7865517ff79d7e31f11695908dc0",
"splash/img/light-4x.png": "bc3aebd4dea3158fcb69033185a1e93c",
"version.json": "cd25c79ffc3bb32210ffe031b104bd2b"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
