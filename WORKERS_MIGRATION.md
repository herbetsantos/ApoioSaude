# Apoio — migração para Cloudflare Workers

Versão: 2.11.0

O projeto usa Cloudflare Workers + Static Assets. As antigas Pages Functions permanecem em `functions/` e são compiladas no build para um único Worker em `.worker/index.js`.

## Cloudflare Workers Builds

- Repositório: o mesmo repositório do Apoio.
- Build command: `npm run build`
- Deploy command: `npx wrangler deploy`
- Root directory: raiz do repositório.
- D1 binding: `DB` -> `portal-saude-db`.

O `wrangler.toml` já contém o database_id atual do banco.

## Migração segura

1. Publique este projeto como Worker novo, sem excluir o Pages antigo.
2. Confirme login, Administração, Comunicação, Suporte, Chamados e acesso ao eMulti.
3. Atualize o eMulti para usar a URL definitiva do Worker.
4. Só então desative o Pages antigo.

Não execute `database/schema.sql` no banco existente. Esta migração de hospedagem não exige recriação do D1.

## Desenvolvimento local

`npm install`
`npm run dev`

## Observação

A pasta `.worker/` é artefato de build e não deve ser publicada como asset estático. `.assetsignore` também impede a exposição de `functions/`, scripts SQL e arquivos internos.
