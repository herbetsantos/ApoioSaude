// Permissões próprias do Apoio.
// O eMulti Regulação é uma aplicação apartada e não participa do modelo
// de permissões deste portal. O Apoio responde apenas pela identidade/login.

export const FEATURES = [
  { key: 'receituario', label: 'Receituário' },
  { key: 'malotes', label: 'Malotes e Remessas' },
  { key: 'facilitawhats', label: 'FacilitaWhats' },
  { key: 'mensageiro_esus', label: 'Mensageiro eSUS' },
  { key: 'documentos', label: 'Documentos Úteis' },
  { key: 'manuais', label: 'Manuais de Uso' },
  { key: 'relatorios', label: 'Relatórios' },
  { key: 'administracao', label: 'Administração' },
];

export const FEATURE_KEYS = FEATURES.map((f) => f.key);
const FEATURE_KEY_SET = new Set(FEATURE_KEYS);
export function isFeatureKey(key) { return FEATURE_KEY_SET.has(key); }

function allTrue() { const m={}; FEATURE_KEYS.forEach((k)=>{m[k]=true;}); return m; }
function allFalse() { const m={}; FEATURE_KEYS.forEach((k)=>{m[k]=false;}); return m; }

export async function getRoleCeiling(env, role) {
  if (role === 'super_admin') return allTrue();
  try {
    const { results } = await env.DB.prepare(
      'SELECT feature_key, enabled FROM role_permissions WHERE role = ?'
    ).bind(role).all();
    const ceiling = allFalse();
    (results || []).forEach((r) => { if (isFeatureKey(r.feature_key)) ceiling[r.feature_key] = !!r.enabled; });
    return ceiling;
  } catch {
    return allTrue();
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
    FEATURE_KEYS.forEach((k) => {
      const wanted = Object.prototype.hasOwnProperty.call(overrides, k) ? overrides[k] : ceiling[k];
      effective[k] = !!ceiling[k] && !!wanted;
    });
    return effective;
  } catch {
    return ceiling;
  }
}
