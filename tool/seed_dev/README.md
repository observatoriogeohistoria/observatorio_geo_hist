# Dados de teste no dev

Grava no Firestore do **dev** (`observatorio-geo-hist-dev`) categorias, posts, documentos da biblioteca e membros da equipe para conferir o site novo com dados parecidos com os reais. O script se recusa a rodar com chave de outro projeto.

O que entra:

- **Categorias:** uma de História, uma de Geografia e uma nas duas áreas, com título longo.
- **Posts:** todos os tipos e todas as categorias de cada tipo (produção acadêmica, livro, documento, filme, revista e evento), alternando as áreas. Inclui casos sem imagem, com imagem quebrada, sem link, com campos opcionais vazios, títulos longos, texto rico com todos os recursos do editor, datas de evento em vários formatos, alguns destaques e um rascunho que não deve aparecer.
- **Biblioteca:** um documento por categoria nas duas áreas, um com várias categorias, um sem arquivo, instituição e ano e um sem tipo e sem categoria.
- **Equipe:** 5 membros: com página e foto, com página sem foto, só com Lattes, sem link nenhum (e foto quebrada) e com nome e função longos.

Todo documento tem id começando com `seed-`. Rodar de novo sobrescreve os mesmos documentos, e `--clean` apaga só eles.

## Como rodar

1. No console do Firebase do projeto **dev**: _Configurações do projeto › Contas de serviço › Gerar nova chave privada_. Guarde o JSON **fora** do repositório.
2. Rode primeiro sem `--write` para ver o que será gravado:

```sh
cd tool/seed_dev
npm install
GOOGLE_APPLICATION_CREDENTIALS=/caminho/da/chave-dev.json node index.mjs
GOOGLE_APPLICATION_CREDENTIALS=/caminho/da/chave-dev.json node index.mjs --write
```

3. Para remover os dados de teste:

```sh
GOOGLE_APPLICATION_CREDENTIALS=/caminho/da/chave-dev.json node index.mjs --clean
GOOGLE_APPLICATION_CREDENTIALS=/caminho/da/chave-dev.json node index.mjs --clean --write
```

4. Apague a chave baixada (ou revogue-a no console) ao terminar.

O dev não tem Storage: imagens e PDFs apontam para endereços externos.
