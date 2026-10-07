# Histórico do redesign

Resumo das Fases 0 a 7, executadas de 2026-09-26 a 2026-10-07. Decisões e conferências de cada entrega estão no `spec.md` e no `verificacao.md` da spec; o registro detalhado de cada execução (`execucao-fase-N.md`) ficou no git até o commit que criou este arquivo.

| Fase | Período | Specs | PR |
|---|---|---|---|
| 0. Fundação e casco | 2026-09-26 | 001 a 003 | #19 |
| 1. Home | 2026-09-26 a 09-29 | 004 a 009 | #21, ajustes em #23 |
| 2. Leitura e post | 2026-10-01 | 010 a 013 | #24 |
| 3. Listagens de publicações | 2026-10-02 | 014, 015 | #25 |
| 4. Biblioteca | 2026-10-02 | 016, 017 | #26 |
| 5. Formulários, estados e tipos de post | 2026-10-05 a 10-06 | 018 a 022 | #27 |
| 6. Painel e login nos tokens novos | 2026-10-06 | 023 a 026 | specs em #29, código em #31 |
| 7. Limpeza de código, assets e pacotes | 2026-10-07 | 027, 028 | #32 |

## Ressalvas em aberto
- Leitor de tela real (VoiceOver/NVDA) não foi usado; só a árvore de semântica.
- Painel e login: o que exige login (entrar, criar, editar, excluir, publicar) não foi conferido na tela (023 a 028).
- No editor Quill do painel, o Tab faz recuo e prende a navegação por teclado (025, comportamento antigo, a decidir).
- Links dentro do texto do post não recebem foco por teclado, por limite do Quill só leitura (012).
- A seta do `PrimaryButton` não cresce com o texto a 200% (010).
- Não conferidos no app, por falta de dados no ambiente: área da biblioteca sem documentos, "Nenhum documento encontrado", categoria sem "Colabore" e o erro dos Destaques (corrigido no código).
- Sugestão de autopreenchimento do navegador nos formulários de contato e Colabore (018, 019).

## Lições da execução
- `dart format` numa pasta com "ó" no caminho não lê o `analysis_options.yaml` e formata com largura 80. Formatar numa cópia com caminho ASCII e copiar de volta.
- O navegador embutido, com o painel escondido, não pinta, perde cliques e não repassa digitação aos campos do Flutter. As conferências foram feitas num Chrome headless por CDP.
- A leitura do Firestore de prod por REST é negada pelo classificador de permissões. Para ver dados reais, usar um build `APP_ENV=prod` só leitura.
- Offline, o Firestore responde com o cache vazio em vez de erro. Os datasources tratam consulta vazia vinda do cache como falha.
- Depois da 028, builds locais antigos precisam de `fvm flutter clean` (registro de plugins com o `file_saver` removido).
- O `build_runner` regera `library_document_store.g.dart` com quebras de linha diferentes das versionadas; o arquivo fica como está.
