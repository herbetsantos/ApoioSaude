import { json } from '../../_utils.js';

function validServiceSecret(request, env) {
  const expected = String(env.EMULTI_HANDOFF_SECRET || '');
  const supplied = String(request.headers.get('X-Handoff-Secret') || '');
  if (!expected || !supplied || expected.length !== supplied.length) return false;
  let diff = 0;
  for (let i = 0; i < expected.length; i++) diff |= expected.charCodeAt(i) ^ supplied.charCodeAt(i);
  return diff === 0;
}

export async function onRequestGet({ request, env }) {
  if (!validServiceSecret(request, env)) return json({ error: 'Integração não autorizada.' }, 401);
  const { results } = await env.DB.prepare(
    `SELECT id, username, name, role, active, unidade, must_change_password, theme
     FROM users ORDER BY name COLLATE NOCASE, username COLLATE NOCASE`
  ).all();
  return json({ users: (results || []).map((u) => ({ ...u, active: !!u.active, must_change_password: !!u.must_change_password })) });
}
