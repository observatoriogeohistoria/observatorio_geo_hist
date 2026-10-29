# Histórico do redesign

Redesenho do site público, do login e do painel, executado de 2026-09-26 a 2026-10-20 em 33 specs (001 a 033). O planejamento, as specs e as verificações saíram do repositório depois do merge e estão na tag `redesign-specs`:

```sh
git show redesign-specs:docs/redesign/planejamento.md
git ls-tree -r --name-only redesign-specs docs/specs
```

- **Protótipo navegável:** https://claude.ai/artifact/PimRbbQyUDbqrapiv8HseH. Continua sendo a referência visual.
- **Fora do escopo:** Geoensine, modo escuro e mudanças de dados, permissões ou regras do painel.

## Decisões de design

| Tema | Decisão |
|---|---|
| Público | Professores, pesquisadores e estudantes, em desktop e celular |
| Fontes | Bricolage Grotesque nos títulos e Figtree no texto, embutidas nos assets (no lugar da Dosis) |
| Cor | Laranja `#C94400` como acento, neutros quentes, rodapé escuro em colunas |
| Logo | Círculos concêntricos em laranja, em `assets/images/logo.svg` |
| Imagens | Vêm dos autores sem proporção garantida: proporção fixa 16:10 com `cover`, degradê só sob o título, placeholder sem imagem |
| Categorias | Ficam como estão no menu de posts e nas 16 da biblioteca, sem agrupar. Na biblioteca, seleção livre de várias |
| Biblioteca | Entrada por área (Geografia e História), com contagem. Tipos só Tese e Dissertação |
| Fale com a gente | Continua abrindo o programa de e-mail (`mailto:`), com validação e "Copiar mensagem" na confirmação |
| Colabore | Fora do rodapé. Só no cabeçalho da categoria, conforme `hasCollaborateOption` |
| Parceiros | A mesma lista de 9 na Home e no post |
| Post | Sem tempo de leitura. Um layout-base com blocos por tipo (10 tipos). Compartilhar por link, WhatsApp, Facebook, X, LinkedIn, Telegram e e-mail, além do nativo no celular |
| Painel | Todo botão só de ícone tem dica dizendo o que acontece. Botão indisponível explica o motivo |
| Editor | Página própria em `/admin/painel/publicacoes/:categoria/:id/editar`, no lugar do diálogo em duas etapas |

## Fases

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
| 8. Login, painel e editor redesenhados | 2026-10-08 a 10-20 | 029 a 033 | specs em #35, código em #37, ajustes em #38 |

## Ressalvas em aberto
- Leitor de tela real (VoiceOver/NVDA) não foi usado; só a árvore de semântica.
- Painel e login: o que exige login (entrar, criar, editar, excluir, publicar, salvar no Firestore, enviar ao Storage) não foi conferido com o Firebase real (023 a 033). Na Fase 8 as telas foram conferidas num app de teste com dados falsos.
- Com a semântica ligada, os links Imagem e Categoria do resumo do editor não levam o foco ao campo, por causa do `excludeSemantics` nos componentes compartilhados (033).
- O nome dos botões da barra do Quill fica num nó em volta do botão, limitação do pacote (033).
- `/admin/painel/:tab` sem sessão abre a moldura vazia, como antes (030, regra de acesso).
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
- Digitar no Quill pelo Chrome headless só funciona com a semântica desligada.
- Sem credenciais de teste, telas do painel são conferidas num app à parte no scratchpad que monta os widgets com dados falsos.
