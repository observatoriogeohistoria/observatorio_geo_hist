import 'dart:js_interop';

import 'package:web/web.dart' as web;

/// Os links com `linkUrl` viram `<a href>` na árvore de semântica, que o
/// navegador seguiria sozinho ao ser ativado pelo leitor de tela (recarregando
/// a página ou trocando a aba). Cancela essa navegação: quem navega é a ação
/// `onTap` do próprio link, que o Flutter recebe pelo mesmo clique.
void preventSemanticLinkNavigation() {
  web.document.addEventListener(
    'click',
    (web.Event event) {
      final target = event.target;
      if (target == null || !target.isA<web.Element>()) return;
      if ((target as web.Element).closest('flt-semantics-host a[href]') != null) {
        event.preventDefault();
      }
    }.toJS,
    true.toJS,
  );
}
