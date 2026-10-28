/* Service worker : garde l'application sur l'appareil pour l'ouvrir sans Internet.
   Changer VERSION à chaque mise à jour de l'application. */
const VERSION = "totrans-flotte-v2";
const SHELL = ["./", "index.html", "config.js", "manifest.webmanifest", "supabase.js", "591.supabase.js",
  "xlsx.full.min.js", "icon.svg", "icon-192.png", "icon-512.png"];

self.addEventListener("install", e => {
  e.waitUntil(caches.open(VERSION).then(c => c.addAll(SHELL)).then(() => self.skipWaiting()));
});
self.addEventListener("activate", e => {
  e.waitUntil(caches.keys().then(ks => Promise.all(ks.filter(k => k !== VERSION).map(k => caches.delete(k))))
    .then(() => self.clients.claim()));
});
self.addEventListener("fetch", e => {
  const req = e.request;
  if (req.method !== "GET") return;
  const url = new URL(req.url);
  if (/supabase\.co$/.test(url.hostname)) return;           // données : jamais en cache ici
  const isFont = /fonts\.(googleapis|gstatic)\.com$/.test(url.hostname);
  if (url.origin !== location.origin && !isFont) return;
  // réseau d'abord (pour recevoir les mises à jour), cache si hors connexion
  e.respondWith(
    fetch(req).then(res => {
      if (res && (res.ok || res.type === "opaque")) { const copy = res.clone(); caches.open(VERSION).then(c => c.put(req, copy)); }
      return res;
    }).catch(() => caches.match(req, { ignoreSearch: true }).then(r => r || (req.mode === "navigate" ? caches.match("index.html") : undefined)))
  );
});
