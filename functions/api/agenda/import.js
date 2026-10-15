import { json, requireAdmin, logAudit } from '../_utils.js';
import { parseContato } from './index.js';

const MAX_POR_ENVIO = 200;
const key = (s) => String(s || '').trim().toLowerCase();

// Importação em massa (a planilha é lida no navegador e enviada em lotes).
// Ignora duplicados: mesmo e-mail ou, quando não há e-mail, mesmo nome + ramal.
export async function onRequestPost({ request, env }) {
  const { user, error } = await requireAdmin(request, env);
  if (error) return error;

  let body;
  try { body = await request.json(); } catch { return json({ error: 'Requisição inválida.' }, 400); }
  const lista = Array.isArray(body.contatos) ? body.contatos : null;
  if (!lista || !lista.length) return json({ error: 'Nenhum contato enviado.' }, 400);
  if (lista.length > MAX_POR_ENVIO) return json({ error: `Envie no máximo ${MAX_POR_ENVIO} contatos por vez.` }, 400);

  const { results } = await env.DB.prepare('SELECT nome, ramal, email FROM agenda_contatos').all();
  const emails = new Set(results.filter((r) => r.email).map((r) => key(r.email)));
  const nomeRamal = new Set(results.map((r) => `${key(r.nome)}|${key(r.ramal)}`));

  const stmts = [], invalidos = [];
  let duplicados = 0;
  lista.forEach((item, indice) => {
    const { c, error: motivo } = parseContato(item || {});
    if (motivo) { invalidos.push({ indice, motivo }); return; }
    const ke = c.email ? key(c.email) : null;
    const kn = `${key(c.nome)}|${key(c.ramal)}`;
    if (ke ? emails.has(ke) : nomeRamal.has(kn)) { duplicados += 1; return; }
    if (ke) emails.add(ke);
    nomeRamal.add(kn);
    stmts.push(env.DB.prepare(
      'INSERT INTO agenda_contatos (nome, ramal, email, divisao, departamento, secretaria, etiquetas, cargo, celular, ativo) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)'
    ).bind(c.nome, c.ramal, c.email, c.divisao, c.departamento, c.secretaria, c.etiquetas, c.cargo, c.celular, c.ativo));
  });

  if (stmts.length) await env.DB.batch(stmts);
  await logAudit(env, user, 'import', 'agenda', '', { inseridos: stmts.length, duplicados, invalidos: invalidos.length });
  return json({ ok: true, inseridos: stmts.length, duplicados, invalidos });
}
