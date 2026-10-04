# Campos de busca da biblioteca

A busca da biblioteca compara com `title_lower`, `author_lower` e `institution_lower`. O painel grava esses campos ao salvar um documento; este script preenche os documentos que já existiam.

1. No console do Firebase do projeto: *Configurações do projeto › Contas de serviço › Gerar nova chave privada*. Guarde o JSON **fora** do repositório.
2. Rode, primeiro sem `--write` para ver quantos documentos mudam:

```sh
cd tool/library_search_fields
npm install
GOOGLE_APPLICATION_CREDENTIALS=/caminho/da/chave.json node index.mjs --project observatorio-geo-hist-dev
GOOGLE_APPLICATION_CREDENTIALS=/caminho/da/chave.json node index.mjs --project observatorio-geo-hist-dev --write
```

3. Repita com `--project observatorio-geo-hist` (e a chave de produção) **antes** de publicar o site na `main`: sem os campos, a busca não acha os documentos antigos.
4. Apague a chave baixada (ou revogue-a no console) ao terminar.

Rodar de novo é seguro: só atualiza o que estiver diferente.
