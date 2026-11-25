import 'package:observatorio_geo_hist/app/core/utils/browser/page_meta_data.dart';

import 'site_pages.dart';

/// The JSON-LD of [page]: the main entity plus its breadcrumb trail.
Map<String, dynamic> structuredData(SitePage page, {required String origin}) {
  final url = page.meta.canonicalUrl(origin);
  final publisher = {'@type': 'EducationalOrganization', 'name': siteName, 'url': '$origin/'};

  final entities = <Map<String, dynamic>>[
    if (page.kind == PageKind.home) ...[
      {'@type': 'WebSite', 'name': siteName, 'url': url, 'inLanguage': 'pt-BR'},
      publisher,
    ] else
      {
        '@type': page.kind == PageKind.collection ? 'CollectionPage' : 'WebPage',
        'name': page.heading,
        'description': page.meta.description,
        'url': url,
        'inLanguage': 'pt-BR',
        'isPartOf': {'@type': 'WebSite', 'name': siteName, 'url': '$origin/'},
        if (page.kind == PageKind.post || page.kind == PageKind.document) 'publisher': publisher,
        ...page.schema,
        if (page.schema.containsKey('@type')) 'mainEntityOfPage': url,
      },
    if (page.breadcrumbs.length > 1)
      {
        '@type': 'BreadcrumbList',
        'itemListElement': [
          for (var i = 0; i < page.breadcrumbs.length; i++)
            {
              '@type': 'ListItem',
              'position': i + 1,
              'name': page.breadcrumbs[i].title,
              'item': PageMetaUrl.of(origin, page.breadcrumbs[i].route),
            },
        ],
      },
  ];

  return {'@context': 'https://schema.org', '@graph': entities};
}

abstract class PageMetaUrl {
  static String of(String origin, String route) =>
      PageMeta(title: '', description: '', path: route).canonicalUrl(origin);
}
