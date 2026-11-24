import 'package:observatorio_geo_hist/app/core/utils/browser/page_meta_data.dart';
import 'package:web/web.dart' as web;

/// Outside production the canonical is the environment's own address and the page is `noindex`,
/// so the dev site never competes with the real one.
void applyPageMeta(PageMeta meta, {required bool isProd}) {
  final origin = isProd ? siteOrigin : web.window.location.origin;
  final url = meta.canonicalUrl(origin);

  web.document.title = meta.title;
  _setMeta('meta[name="description"]', 'name', 'description', meta.description);
  _setMeta('meta[property="og:title"]', 'property', 'og:title', meta.title);
  _setMeta('meta[property="og:description"]', 'property', 'og:description', meta.description);
  _setMeta('meta[property="og:url"]', 'property', 'og:url', url);
  _setMeta('meta[name="twitter:title"]', 'name', 'twitter:title', meta.title);
  _setMeta('meta[name="twitter:description"]', 'name', 'twitter:description', meta.description);
  _setCanonical(url);

  if (isProd && !meta.noIndex) {
    web.document.querySelector('meta[name="robots"]')?.remove();
  } else {
    _setMeta('meta[name="robots"]', 'name', 'robots', 'noindex, nofollow');
  }
}

void _setMeta(String selector, String attribute, String key, String content) {
  var element = web.document.querySelector(selector);
  if (element == null) {
    element = web.document.createElement('meta')..setAttribute(attribute, key);
    web.document.head!.append(element);
  }
  element.setAttribute('content', content);
}

void _setCanonical(String href) {
  var element = web.document.querySelector('link[rel="canonical"]');
  if (element == null) {
    element = web.document.createElement('link')..setAttribute('rel', 'canonical');
    web.document.head!.append(element);
  }
  element.setAttribute('href', href);
}
