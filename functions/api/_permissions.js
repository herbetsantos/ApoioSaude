// Permissões próprias do Apoio e permissões individuais de ingresso em aplicações integradas.
// O eMulti mantém suas responsabilidades internas no próprio banco; aqui controlamos apenas se o usuário pode iniciar o ingresso compartilhado.

export const FEATURES = [
  { key: 'receituario', label: 'Receituário' },
  { key: 'malotes', label: 'Malotes e Remessas' },
  { key: 'facilitawhats', label: 'FacilitaWhats' },
  { key: 'mensageiro_esus', label: 'Mensageiro eSUS' },
  { key: 'documentos', label: 'Documentos Úteis' },
  { key: 'manuais', label: 'Manuais de Uso' },
  { key: 'relatorios', label: 'Relatórios' },
  { key: 'regulacao_vagas', label: 'eMulti | Regulação', individualOnly: true },
  { key: 'administracao', label: 'Administração' },
];

export const FEATURE_KEYS = FEATURES.map((f) => f.key);
const FEATURE_KEY_SET = new Set(FEATURE_KEYS);
const INDIVIDUAL_ONLY = new Set(FEATURES.filter((f) => f.individualOnly).map((f) => f.key));
export function isFeatureKey(key) { return FEATURE_KEY_SET.has(key); }
export function isIndividualOnlyFeature(key) { return INDIVIDUAL_ONLY.has(key); }

function allTrue() { const m={}; FEATURE_KEYS.forEach((k)=>{m[k]=true;}); return m; }
function allFalse() { const m={}; FEATURE_KEYS.forEach((k)=>{m[k]=false;}); return m; }

export async function getRoleCeiling(env, role) {
  if (role === 'super_admin') return allTrue();
  try {
    const { results } = await env.DB.prepare(
      'SELECT feature_key, enabled FROM role_permissions WHERE role = ?'
    ).bind(role).all();
    const ceiling = allFalse();
    // Features individualOnly não recebem padrão por papel; true aqui significa apenas que podem ser configuradas individualmente.
    INDIVIDUAL_ONLY.forEach((k) => { ceiling[k] = true; });
    (results || []).forEach((r) => {
      if (isFeatureKey(r.feature_key) && !isIndividualOnlyFeature(r.feature_key)) ceiling[r.feature_key] = !!r.enabled;
    });
    return ceiling;
  } catch {
    const fallback = allTrue();
    INDIVIDUAL_ONLY.forEach((k) => { fallback[k] = true; });
    return fallback;
  }
}

export async function getUserPermissions(env, user) {
  if (user.role === 'super_admin') return allTrue();
  const ceiling = await getRoleCeiling(env, user.role);
  try {
    const { results } = await env.DB.prepare(
      'SELECT feature_key, enabled FROM user_permissions WHERE user_id = ?'
    ).bind(user.id).all();
    const overrides = {};
    (results || []).forEach((r) => { if (isFeatureKey(r.feature_key)) overrides[r.feature_key] = !!r.enabled; });
    const effective = {};
    FEATURES.forEach((f) => {
      const k = f.key;
      if (f.individualOnly) {
        effective[k] = Object.prototype.hasOwnProperty.call(overrides, k) ? !!overrides[k] : false;
        return;
      }
      const wanted = Object.prototype.hasOwnProperty.call(overrides, k) ? overrides[k] : ceiling[k];
      effective[k] = !!ceiling[k] && !!wanted;
    });
    return effective;
  } catch {
    const fallback = { ...ceiling };
    INDIVIDUAL_ONLY.forEach((k) => { fallback[k] = false; });
    return fallback;
  }
}
