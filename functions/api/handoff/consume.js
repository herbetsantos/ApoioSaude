import { json } from '../_utils.js';

function validServiceSecret(request, env) {
  const expected = String(env.EMULTI_HANDOFF_SECRET || '');
  const supplied = String(request.headers.get('X-Handoff-Secret') || '');
  if (!expected || !supplied || expected.length !== supplied.length) return false;
  let diff = 0;
  for (let i = 0; i < expected.length; i++) diff |= expected.charCodeAt(i) ^ supplied.charCodeAt(i);
  return diff === 0;
}

export async function onRequestPost({ request, env }) {
  if (!validServiceSecret(request, env)) return json({ error: 'Integração não autorizada.' }, 401);
  let body;
  try { body = await request.json(); } catch { return json({ error: 'JSON inválido.' }, 400); }
  const token = String(body?.token || '').trim();
  if (!token) return json({ error: 'Token ausente.' }, 400);

  const updated = await env.DB.prepare(
    `UPDATE handoff_tokens
     SET used = 1
     WHERE token = ? AND used = 0 AND datetime(expires_at) > datetime('now')`
  ).bind(token).run();
  if (!updated?.meta?.changes) return json({ error: 'Token inválido, expirado ou já utilizado.' }, 401);

  const row = await env.DB.prepare(
    `SELECT u.id, u.username, u.name, u.role, u.active, u.unidade, u.must_change_password, u.theme
     FROM handoff_tokens h
     JOIN users u ON u.id = h.user_id
     WHERE h.token = ?`
  ).bind(token).first();
  if (!row || !row.active) return json({ error: 'Usuário inativo ou inexistente.' }, 403);

  return json({
    valid: true,
    user: {
      id: row.id,
      username: row.username,
      name: row.name,
      role: row.role,
      active: !!row.active,
      unidade: row.unidade || null,
      must_change_password: !!row.must_change_password,
      theme: row.theme || 'light',
    },
  });
}
