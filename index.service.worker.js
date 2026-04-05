// This service worker is required to expose an exported Godot project as a
// Progressive Web App. It provides an offline fallback page telling the user
// that they need an Internet connection to run the project if desired.
// Incrementing CACHE_VERSION will kick off the install event and force
// previously cached resources to be updated from the network.
/** @type {string} */
const CACHE_VERSION = '20260405-mobile-character-fix-2';
/** @type {string} */
const CACHE_PREFIX = 'openclaw-web-sw-cache-';
const CACHE_NAME = CACHE_PREFIX + CACHE_VERSION;
/** @type {string[]} */
const LEGACY_CACHE_PREFIXES = [
	CACHE_PREFIX,
	'钢翼秘术旅团-sw-cache-',
	'閽㈢考绉樻湳鏃呭洟-sw-cache-',
];
/** @type {string} */
const OFFLINE_URL = 'index.offline.html';
/** @type {boolean} */
const ENSURE_CROSSORIGIN_ISOLATION_HEADERS = true;
/** @type {string[]} */
const CACHED_FILES = ["index.html", "index.js", "index.offline.html", "index.icon.png", "index.apple-touch-icon.png", "index.audio.worklet.js", "index.audio.position.worklet.js"];
/** @type {string[]} */
const CACHEABLE_FILES = ["index.wasm", "index.pck"];
const FULL_CACHE = CACHED_FILES.concat(CACHEABLE_FILES);

self.addEventListener('install', (event) => {
	event.waitUntil(
		caches.open(CACHE_NAME).then((cache) => cache.addAll(CACHED_FILES)).then(() => self.skipWaiting())
	);
});

self.addEventListener('activate', (event) => {
	event.waitUntil(caches.keys().then(
		function (keys) {
			return Promise.all(
				keys.filter((key) => LEGACY_CACHE_PREFIXES.some((prefix) => key.startsWith(prefix)) && key !== CACHE_NAME).map((key) => caches.delete(key))
			);
		}
	).then(function () {
		return ('navigationPreload' in self.registration) ? self.registration.navigationPreload.enable() : Promise.resolve();
	}).then(() => self.clients.claim()));
});

function ensureCrossOriginIsolationHeaders(response) {
	if (response.headers.get('Cross-Origin-Embedder-Policy') === 'require-corp'
		&& response.headers.get('Cross-Origin-Opener-Policy') === 'same-origin') {
		return response;
	}

	const crossOriginIsolatedHeaders = new Headers(response.headers);
	crossOriginIsolatedHeaders.set('Cross-Origin-Embedder-Policy', 'require-corp');
	crossOriginIsolatedHeaders.set('Cross-Origin-Opener-Policy', 'same-origin');
	return new Response(response.body, {
		status: response.status,
		statusText: response.statusText,
		headers: crossOriginIsolatedHeaders,
	});
}

async function fetchAndCache(event, cache, isCacheable) {
	let response = await event.preloadResponse;
	if (response == null) {
		response = await self.fetch(event.request);
	}

	if (ENSURE_CROSSORIGIN_ISOLATION_HEADERS) {
		response = ensureCrossOriginIsolationHeaders(response);
	}

	if (isCacheable) {
		cache.put(event.request, response.clone());
	}

	return response;
}

self.addEventListener('fetch', (event) => {
	const isNavigate = event.request.mode === 'navigate';
	const url = event.request.url || '';
	const referrer = event.request.referrer || '';
	const base = referrer.slice(0, referrer.lastIndexOf('/') + 1);
	const local = url.startsWith(base) ? url.replace(base, '') : '';
	const isCacheable = FULL_CACHE.some((v) => v === local) || (base === referrer && base.endsWith(CACHED_FILES[0]));

	if (isNavigate || isCacheable) {
		event.respondWith((async () => {
			const cache = await caches.open(CACHE_NAME);
			if (isNavigate) {
				const fullCache = await Promise.all(FULL_CACHE.map((name) => cache.match(name)));
				const missing = fullCache.some((v) => v === undefined);
				if (missing) {
					try {
						return await fetchAndCache(event, cache, isCacheable);
					} catch (e) {
						console.error('Network error: ', e);
						return caches.match(OFFLINE_URL);
					}
				}
			}

			let cached = await cache.match(event.request);
			if (cached != null) {
				if (ENSURE_CROSSORIGIN_ISOLATION_HEADERS) {
					cached = ensureCrossOriginIsolationHeaders(cached);
				}
				return cached;
			}
			return await fetchAndCache(event, cache, isCacheable);
		})());
	} else if (ENSURE_CROSSORIGIN_ISOLATION_HEADERS) {
		event.respondWith((async () => {
			let response = await fetch(event.request);
			response = ensureCrossOriginIsolationHeaders(response);
			return response;
		})());
	}
});

self.addEventListener('message', (event) => {
	if (event.origin !== self.origin) {
		return;
	}
	const id = event.source.id || '';
	const msg = event.data || '';
	self.clients.get(id).then(function (client) {
		if (!client) {
			return;
		}
		if (msg === 'claim') {
			self.skipWaiting().then(() => self.clients.claim());
		} else if (msg === 'clear') {
			caches.delete(CACHE_NAME);
		} else if (msg === 'update') {
			self.skipWaiting().then(() => self.clients.claim()).then(() => self.clients.matchAll()).then((all) => all.forEach((c) => c.navigate(c.url)));
		}
	});
});
