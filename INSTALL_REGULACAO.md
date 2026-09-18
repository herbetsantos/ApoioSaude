# Apoio APS ↔ eMulti | Regulação

O Apoio APS e o eMulti são aplicações separadas e usam bancos separados.

- Apoio APS: `portal-saude-db`
- eMulti | Regulação: `regulacao-vagas-db`

O Apoio mantém a identidade dos usuários. O eMulti mantém equipes, responsabilidades e dados assistenciais/regulatórios.

## Ingresso compartilhado

O ingresso entre os ambientes usa token de uso único com validade de 60 segundos.

1. O usuário autentica no Apoio APS.
2. O Apoio verifica a permissão individual `regulacao_vagas`.
3. `POST /api/handoff` cria um token em `handoff_tokens`.
4. O navegador abre `https://emulti.pages.dev/?handoff=TOKEN`.
5. O eMulti troca o token em `POST /api/handoff/consume` usando `X-Handoff-Secret`.
6. O eMulti cria sua própria sessão no `regulacao-vagas-db`.

Tokens antigos não devem ser migrados entre bancos.

## Segredo

Configure o mesmo valor de `EMULTI_HANDOFF_SECRET` no Apoio e no eMulti.

## Link

O registro do eMulti no Apoio deve usar:

```sql
UPDATE links
SET url = 'https://emulti.pages.dev/', feature_key = 'regulacao_vagas'
WHERE title = 'Regulação de Vagas';
```

## Permissões

`regulacao_vagas` é individual. Ela apenas permite iniciar o ingresso no eMulti.

Cadastrante, Regulador, Executor e Administrador são responsabilidades definidas no próprio eMulti e não dependem do papel do usuário no Apoio APS.

Superadministradores do Apoio recebem acesso de ingresso automaticamente. Para os demais usuários, configure `regulacao_vagas` individualmente no painel administrativo.

## Aplicações futuras

Outras aplicações com login compartilhado devem ter uma permissão própria e tokens vinculados ao destino. Não reutilize a autorização do eMulti como autorização genérica para outras aplicações.
