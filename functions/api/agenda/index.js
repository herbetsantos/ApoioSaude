import { json, requireAuth, requireAdmin, logAudit } from '../_utils.js';
import { getUserPermissions } from '../_permissions.js';

const isAdmin = (u) => u.role === 'admin' || u.role === 'super_admin';

// Etiquetas: aceita array ou texto separado por vírgula/;. Remove duplicadas
// (sem diferenciar maiúsculas), limita a 15 etiquetas de até 40 caracteres.
function parseEtiquetas(v) {
  const list = Array.isArray(v) ? v : (typeof v === 'string' ? v.split(/[,;]/) : []);
  const seen = new Set(), out = [];
  for (const raw of list) {
    const t = String(raw).replace(/\s+/g, ' ').trim().slice(0, 40);
    const k = t.toLowerCase();
    if (t && !seen.has(k)) { seen.add(k); out.push(t); }
  }
  return out.slice(0, 15);
}

// Valida e normaliza o corpo enviado pelo cliente (usado também por [id].js).
export function parseContato(body) {
  const clean = (v, max) => (typeof v === 'string' ? v.trim().slice(0, max) : '') || null;
  const c = {
    nome: clean(body.nome, 120),
    cargo: clean(body.cargo, 120),
    ramal: clean(body.ramal, 20),
    celular: clean(body.celular, 30),
    email: clean(body.email, 160),
    divisao: clean(body.divisao, 120),
    departamento: clean(body.departamento, 120),
    secretaria: clean(body.secretaria, 120),
    etiquetas: parseEtiquetas(body.etiquetas).join(',') || null,
    ativo: body.ativo === false ? 0 : 1,
  };
  if (!c.nome) return { error: 'Informe o nome do profissional.' };
  if (c.email && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(c.email)) return { error: 'E-mail inválido.' };
  return { c };
}

export async function onRequestGet({ request, env }) {
  const { user, error } = await requireAuth(request, env);
  if (error) return error;
  const perms = await getUserPermissions(env, user);
  if (!perms.agenda) return json({ error: 'Sem acesso a Contatos.' }, 403);

  const where = isAdmin(user) ? '' : 'WHERE ativo = 1';
  const { results } = await env.DB.prepare(
    `SELECT id, nome, ramal, email, divisao, departamento, secretaria, etiquetas, cargo, celular, updated_at, ativo
     FROM agenda_contatos ${where} ORDER BY nome COLLATE NOCASE ASC`
  ).all();
  const contatos = results.map((r) => ({ ...r, etiquetas: r.etiquetas ? r.etiquetas.split(',') : [] }));
  return json({ contatos, canEdit: isAdmin(user) });
}

export async function onRequestPost({ request, env }) {
  const { user, error } = await requireAdmin(request, env);
  if (error) return error;
  let body;
  try { body = await request.json(); } catch { return json({ error: 'Requisição inválida.' }, 400); }
  const { c, error: msg } = parseContato(body);
  if (msg) return json({ error: msg }, 400);

  const r = await env.DB.prepare(
    'INSERT INTO agenda_contatos (nome, ramal, email, divisao, departamento, secretaria, etiquetas, cargo, celular, ativo) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)'
  ).bind(c.nome, c.ramal, c.email, c.divisao, c.departamento, c.secretaria, c.etiquetas, c.cargo, c.celular, c.ativo).run();
  await logAudit(env, user, 'create', 'agenda', r.meta.last_row_id, { nome: c.nome });
  return json({ ok: true, id: r.meta.last_row_id }, 201);
}
