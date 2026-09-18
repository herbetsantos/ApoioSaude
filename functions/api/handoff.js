// POST /api/handoff -> gera um código de uso único (60s) para o eMulti.
// O código só é emitido a usuários autenticados com regulacao_vagas liberada.

import { json, getAuthUser } from './_utils.js';
import { getUserPermissions } from './_permissions.js';

function randomToken() {
  const bytes = new Uint8Array(32);
  crypto.getRandomValues(bytes);
  return Array.from(bytes, (b) => b.toString(16).padStart(2, '0')).join('');
}

export async function onRequestPost({ request, env }) {
  const user = await getAuthUser(request, env);
  if (!user) return json({ error: 'Não autenticado.' }, 401);

  let featureKey = 'regulacao_vagas';
  try {
    const body = await request.json();
    if (body?.feature_key) featureKey = String(body.feature_key).trim();
  } catch { /* corpo é opcional para compatibilidade */ }

  if (featureKey !== 'regulacao_vagas') return json({ error: 'Destino de ingresso inválido.' }, 400);
  const permissions = await getUserPermissions(env, user);
  if (!permissions.regulacao_vagas) return json({ error: 'Acesso ao eMulti não autorizado.' }, 403);

  const token = randomToken();
  const expiresAt = new Date(Date.now() + 60 * 1000).toISOString();

  await env.DB.prepare(
    'INSERT INTO handoff_tokens (token, user_id, expires_at) VALUES (?, ?, ?)'
  ).bind(token, user.id, expiresAt).run();

  try {
    await env.DB.prepare("DELETE FROM handoff_tokens WHERE expires_at < datetime('now', '-1 hour')").run();
  } catch { /* não crítico */ }

  return json({ token });
}
