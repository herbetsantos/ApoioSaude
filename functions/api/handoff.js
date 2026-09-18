// POST /api/handoff -> gera um código de uso único (60s de validade) para autenticação entre aplicações apartadas. O eMulti NÃO lê este D1.
// O token é trocado por identidade no endpoint servidor-a-servidor
// /api/handoff/consume e o eMulti cria sua própria sessão no próprio banco.
// Ver migration_regulacao_setup.sql (tabela handoff_tokens) e o
// functions/_middleware.js do projeto regulacao-vagas-cajamar, que consome
// este código.

import { json, getAuthUser } from './_utils.js';

function randomToken() {
  const bytes = new Uint8Array(32);
  crypto.getRandomValues(bytes);
  return Array.from(bytes, (b) => b.toString(16).padStart(2, '0')).join('');
}

export async function onRequestPost({ request, env }) {
  const user = await getAuthUser(request, env);
  if (!user) return json({ error: 'Não autenticado.' }, 401);

  const token = randomToken();
  const expiresAt = new Date(Date.now() + 60 * 1000).toISOString();

  await env.DB.prepare(
    'INSERT INTO handoff_tokens (token, user_id, expires_at) VALUES (?, ?, ?)'
  ).bind(token, user.id, expiresAt).run();

  // Limpeza best-effort de códigos velhos, pra tabela não crescer para sempre.
  try {
    await env.DB.prepare("DELETE FROM handoff_tokens WHERE expires_at < datetime('now', '-1 hour')").run();
  } catch { /* não crítico */ }

  return json({ token });
}
