import { json, requireAdmin, logAudit } from '../_utils.js';
import { parseContato } from './index.js';

export async function onRequestPut({ request, env, params }) {
  const { user, error } = await requireAdmin(request, env);
  if (error) return error;
  const id = Number(params.id);
  const existing = await env.DB.prepare('SELECT id FROM agenda_contatos WHERE id = ?').bind(id).first();
  if (!existing) return json({ error: 'Contato não encontrado.' }, 404);

  let body;
  try { body = await request.json(); } catch { return json({ error: 'Requisição inválida.' }, 400); }
  const { c, error: msg } = parseContato(body);
  if (msg) return json({ error: msg }, 400);

  await env.DB.prepare(
    `UPDATE agenda_contatos SET nome=?, ramal=?, email=?, divisao=?, departamento=?, secretaria=?, etiquetas=?, cargo=?, celular=?, ativo=?, updated_at=datetime('now') WHERE id=?`
  ).bind(c.nome, c.ramal, c.email, c.divisao, c.departamento, c.secretaria, c.etiquetas, c.cargo, c.celular, c.ativo, id).run();
  await logAudit(env, user, 'update', 'agenda', id, { nome: c.nome });
  return json({ ok: true });
}

export async function onRequestDelete({ request, env, params }) {
  const { user, error } = await requireAdmin(request, env);
  if (error) return error;
  const id = Number(params.id);
  const existing = await env.DB.prepare('SELECT nome FROM agenda_contatos WHERE id = ?').bind(id).first();
  if (!existing) return json({ error: 'Contato não encontrado.' }, 404);
  await env.DB.prepare('DELETE FROM agenda_contatos WHERE id = ?').bind(id).run();
  await logAudit(env, user, 'delete', 'agenda', id, { nome: existing.nome });
  return json({ ok: true });
}
