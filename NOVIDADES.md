# Apoio v2.11.0

- Migração de Cloudflare Pages para **Cloudflare Workers + Static Assets**.
- Pages Functions compiladas para um único Worker durante o build.
- Mantido o binding `DB` para o `portal-saude-db`.
- Adicionado `.assetsignore` para impedir publicação de código de backend, SQL e arquivos internos como assets.
- Habilitadas URLs de preview do Worker.
- Nenhuma recriação do banco é necessária para a migração.

# Apoio v2.10.1 — migração de identidade e domínio

- Projeto Pages renomeado para **apoio**.
- URL de referência alterada para **https://apoio.pages.dev**.
- Removidas referências públicas residuais a `apoioapscajamar` e `portal-saude-cajamar`.
- `robots.txt` e `sitemap.xml` atualizados para a nova origem.
- Integração com eMulti preparada para usar a nova origem do Apoio.

# Novidades do Apoio

## 2.10.1 — Nova identidade
- Nome simplificado para **Apoio**.
- Novo imagotipo próprio aplicado ao login, cabeçalho e favicon.
- Remoção das referências visuais à Prefeitura/Secretaria na autenticação para evitar aparência de página institucional oficial.



## 2.9.2 — Administração escalável

- Usuários agora são carregados por página no backend.
- Quantidade por página: 10, 20, 50 ou 100 registros.
- Busca por nome ou login.
- Filtros combináveis por unidade, função e status.
- Paginação preserva as regras de escopo do Administrador de Unidade.
- A melhoria evita carregar listas administrativas cada vez maiores de uma só vez.

## 2.9.1 — Chat e suporte aprimorados

- Presença online compartilhada entre Apoio e eMulti.
- Identificação visual dos participantes no chat.
- Contadores de mensagens não lidas no menu da conta.
- Lista de atendimentos de suporte com presença e não lidas.
- Encerramento e reabertura de atendimentos pelo Super Administrador.
- Atualização quase em tempo real por consulta periódica segura.
- Retenção permanece configurável pelo Super Administrador, com 30 dias como padrão.


## 2.9.1 — Comunicação, suporte e gestão integrada
- Cards de Atualizações reorganizados para melhor aproveitamento da tela.
- Atualizações agora aceitam imagem por URL/caminho ou arquivo de imagem convertido no navegador.
- Comunicação interna compartilhada entre Apoio e eMulti.
- Chat de suporte compartilhado entre as duas plataformas.
- Retenção padrão de 30 dias para os dois chats; somente super_admin pode alterar os prazos.
- Chamados podem ser abertos a partir do suporte e acompanhados pelo super_admin.
- Estrutura inicial do futuro Assistente de Rotinas, priorizando POP municipal e, quando necessário, documento federal oficial.
- Banco do Portal consolidado em database/schema.sql e database/update.sql.

## Histórico anterior
As alterações técnicas antigas foram consolidadas nesta versão. O histórico operacional passa a ser mantido neste documento único e nas páginas de novidades do sistema.