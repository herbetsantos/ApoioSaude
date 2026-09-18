PRAGMA foreign_keys = ON;

-- Apoio v2.11.4 — portal-saude-db
-- Banco EXCLUSIVO do Apoio: identidade/login e módulos próprios.
-- O eMulti Regulação não lê este D1 e mantém seu próprio regulacao-vagas-db.

CREATE TABLE IF NOT EXISTS users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  username TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  password_hash TEXT NOT NULL,
  salt TEXT NOT NULL,
  role TEXT NOT NULL DEFAULT 'user' CHECK (role IN ('user','admin','super_admin','admin_unidade')),
  active INTEGER NOT NULL DEFAULT 1,
  must_change_password INTEGER NOT NULL DEFAULT 0,
  unidade TEXT,
  created_at TEXT DEFAULT (datetime('now')),
  theme TEXT CHECK (theme IN ('auto','light','dark','contrast'))
);
CREATE INDEX IF NOT EXISTS idx_users_active_name ON users(active, name);

CREATE TABLE IF NOT EXISTS sessions (
  token TEXT PRIMARY KEY,
  user_id INTEGER NOT NULL,
  expires_at TEXT NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
CREATE INDEX IF NOT EXISTS idx_sessions_user ON sessions(user_id);
CREATE INDEX IF NOT EXISTS idx_sessions_expires ON sessions(expires_at);

CREATE TABLE IF NOT EXISTS handoff_tokens (
  token TEXT PRIMARY KEY,
  user_id INTEGER NOT NULL,
  created_at TEXT DEFAULT (datetime('now')),
  expires_at TEXT NOT NULL,
  used INTEGER NOT NULL DEFAULT 0,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
CREATE INDEX IF NOT EXISTS idx_handoff_expiry ON handoff_tokens(expires_at, used);

CREATE TABLE IF NOT EXISTS login_attempts (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  username TEXT NOT NULL,
  ip TEXT,
  success INTEGER NOT NULL,
  created_at TEXT DEFAULT (datetime('now'))
);
CREATE INDEX IF NOT EXISTS idx_login_attempts_user_time ON login_attempts(username, created_at);
CREATE INDEX IF NOT EXISTS idx_login_attempts_ip_time ON login_attempts(ip, created_at);

CREATE TABLE IF NOT EXISTS audit_log (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  actor_user_id INTEGER,
  actor_username TEXT,
  action TEXT NOT NULL,
  entity_type TEXT NOT NULL,
  entity_id TEXT,
  details TEXT,
  created_at TEXT DEFAULT (datetime('now')),
  FOREIGN KEY (actor_user_id) REFERENCES users(id) ON DELETE SET NULL
);
CREATE INDEX IF NOT EXISTS idx_audit_created ON audit_log(created_at DESC);

CREATE TABLE IF NOT EXISTS unidades (
  code TEXT PRIMARY KEY,
  nome TEXT NOT NULL,
  cnes TEXT,
  endereco TEXT,
  tel TEXT,
  ativo INTEGER NOT NULL DEFAULT 1,
  sort_order INTEGER NOT NULL DEFAULT 0,
  created_at TEXT DEFAULT (datetime('now')),
  tipo TEXT NOT NULL DEFAULT 'outra'
);

CREATE TABLE IF NOT EXISTS user_unidades (
  user_id INTEGER NOT NULL,
  unidade_code TEXT NOT NULL,
  PRIMARY KEY (user_id, unidade_code),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (unidade_code) REFERENCES unidades(code) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS admin_unidades (
  admin_user_id INTEGER NOT NULL,
  unidade TEXT NOT NULL,
  PRIMARY KEY (admin_user_id, unidade),
  FOREIGN KEY (admin_user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS role_permissions (
  role TEXT NOT NULL,
  feature_key TEXT NOT NULL,
  enabled INTEGER NOT NULL DEFAULT 1,
  PRIMARY KEY (role, feature_key)
);

CREATE TABLE IF NOT EXISTS user_permissions (
  user_id INTEGER NOT NULL,
  feature_key TEXT NOT NULL,
  enabled INTEGER NOT NULL DEFAULT 1,
  PRIMARY KEY (user_id, feature_key),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS signup_requests (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  username TEXT NOT NULL,
  password_hash TEXT NOT NULL,
  salt TEXT NOT NULL,
  unidade TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending','approved','rejected')),
  created_at TEXT DEFAULT (datetime('now')),
  resolved_at TEXT,
  resolved_by INTEGER,
  FOREIGN KEY (resolved_by) REFERENCES users(id)
);

CREATE TABLE IF NOT EXISTS links (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  category TEXT NOT NULL CHECK (category IN ('ferramenta','documento','manual')),
  title TEXT NOT NULL,
  url TEXT NOT NULL,
  description TEXT,
  sort_order INTEGER NOT NULL DEFAULT 0,
  created_at TEXT DEFAULT (datetime('now')),
  open_mode TEXT NOT NULL DEFAULT '_blank',
  feature_key TEXT
);

CREATE TABLE IF NOT EXISTS updates (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  tag TEXT,
  link_url TEXT,
  link_label TEXT,
  image_url TEXT,
  image_alt TEXT,
  published_at TEXT NOT NULL DEFAULT (date('now')),
  created_at TEXT DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS report_groups (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  description TEXT,
  created_at TEXT DEFAULT (datetime('now'))
);
CREATE TABLE IF NOT EXISTS reports (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  description TEXT,
  embed_url TEXT NOT NULL,
  display_mode TEXT NOT NULL DEFAULT 'embed' CHECK (display_mode IN ('embed','new_tab')),
  sort_order INTEGER NOT NULL DEFAULT 0,
  created_at TEXT DEFAULT (datetime('now'))
);
CREATE TABLE IF NOT EXISTS report_group_reports (
  group_id INTEGER NOT NULL,
  report_id INTEGER NOT NULL,
  PRIMARY KEY (group_id, report_id),
  FOREIGN KEY (group_id) REFERENCES report_groups(id) ON DELETE CASCADE,
  FOREIGN KEY (report_id) REFERENCES reports(id) ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS user_report_groups (
  user_id INTEGER NOT NULL,
  group_id INTEGER NOT NULL,
  PRIMARY KEY (user_id, group_id),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (group_id) REFERENCES report_groups(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS ouvidoria_profissionais (
  codigo TEXT PRIMARY KEY,
  nome TEXT NOT NULL,
  nome_ouvidorsus TEXT,
  email TEXT,
  ativo INTEGER NOT NULL DEFAULT 1 CHECK (ativo IN (0,1)),
  observacao TEXT,
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  updated_at TEXT NOT NULL DEFAULT (datetime('now'))
);
CREATE TABLE IF NOT EXISTS ouvidoria_config (
  id INTEGER PRIMARY KEY CHECK (id = 1),
  confidence_threshold REAL NOT NULL DEFAULT 0.80 CHECK (confidence_threshold >= 0 AND confidence_threshold <= 1),
  versao INTEGER NOT NULL DEFAULT 1,
  updated_at TEXT NOT NULL DEFAULT (datetime('now'))
);
INSERT OR IGNORE INTO ouvidoria_config (id) VALUES (1);
CREATE TABLE IF NOT EXISTS ouvidoria_regras (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  titulo TEXT NOT NULL,
  divisao TEXT NOT NULL,
  subtipo TEXT NOT NULL DEFAULT 'geral',
  descricao TEXT,
  prioridade INTEGER NOT NULL DEFAULT 100,
  profissional_codigo TEXT NOT NULL,
  ativo INTEGER NOT NULL DEFAULT 1 CHECK (ativo IN (0,1)),
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  updated_at TEXT NOT NULL DEFAULT (datetime('now')),
  FOREIGN KEY (profissional_codigo) REFERENCES ouvidoria_profissionais(codigo)
);
CREATE TABLE IF NOT EXISTS ouvidoria_fallbacks (
  ordem INTEGER PRIMARY KEY CHECK (ordem BETWEEN 1 AND 10),
  profissional_codigo TEXT NOT NULL,
  ativo INTEGER NOT NULL DEFAULT 1 CHECK (ativo IN (0,1)),
  updated_at TEXT NOT NULL DEFAULT (datetime('now')),
  FOREIGN KEY (profissional_codigo) REFERENCES ouvidoria_profissionais(codigo)
);

CREATE TABLE IF NOT EXISTS chat_config (
  id INTEGER PRIMARY KEY CHECK (id = 1),
  internal_retention_days INTEGER NOT NULL DEFAULT 30 CHECK (internal_retention_days BETWEEN 1 AND 3650),
  support_retention_days INTEGER NOT NULL DEFAULT 30 CHECK (support_retention_days BETWEEN 1 AND 3650),
  updated_by INTEGER,
  updated_at TEXT NOT NULL DEFAULT (datetime('now')),
  FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
);
INSERT OR IGNORE INTO chat_config (id, internal_retention_days, support_retention_days) VALUES (1, 30, 30);

CREATE TABLE IF NOT EXISTS chat_rooms (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  type TEXT NOT NULL CHECK (type IN ('internal','support')),
  title TEXT,
  created_by INTEGER NOT NULL,
  status TEXT NOT NULL DEFAULT 'open' CHECK (status IN ('open','closed')),
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  updated_at TEXT NOT NULL DEFAULT (datetime('now')),
  FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE CASCADE
);
CREATE UNIQUE INDEX IF NOT EXISTS idx_chat_internal_singleton ON chat_rooms(type) WHERE type='internal';
CREATE UNIQUE INDEX IF NOT EXISTS idx_chat_support_user_open ON chat_rooms(created_by) WHERE type='support' AND status='open';
CREATE INDEX IF NOT EXISTS idx_chat_rooms_type_updated ON chat_rooms(type, updated_at DESC);

CREATE TABLE IF NOT EXISTS chat_messages (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  room_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  body TEXT NOT NULL,
  platform TEXT NOT NULL DEFAULT 'portal' CHECK (platform IN ('portal','emulti')),
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  FOREIGN KEY (room_id) REFERENCES chat_rooms(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
CREATE INDEX IF NOT EXISTS idx_chat_messages_room_created ON chat_messages(room_id, created_at, id);

CREATE TABLE IF NOT EXISTS chat_presence (
  user_id INTEGER PRIMARY KEY,
  platform TEXT NOT NULL DEFAULT 'portal' CHECK (platform IN ('portal','emulti')),
  last_seen TEXT NOT NULL DEFAULT (datetime('now')),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
CREATE INDEX IF NOT EXISTS idx_chat_presence_last_seen ON chat_presence(last_seen DESC);

CREATE TABLE IF NOT EXISTS chat_read_state (
  room_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  last_read_message_id INTEGER NOT NULL DEFAULT 0,
  updated_at TEXT NOT NULL DEFAULT (datetime('now')),
  PRIMARY KEY (room_id, user_id),
  FOREIGN KEY (room_id) REFERENCES chat_rooms(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
CREATE INDEX IF NOT EXISTS idx_chat_read_state_user ON chat_read_state(user_id, updated_at DESC);

CREATE TABLE IF NOT EXISTS chamados (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  codigo TEXT UNIQUE,
  title TEXT NOT NULL,
  description TEXT,
  platform TEXT NOT NULL DEFAULT 'portal' CHECK (platform IN ('portal','emulti','ambos')),
  category TEXT,
  priority TEXT NOT NULL DEFAULT 'normal' CHECK (priority IN ('baixa','normal','alta','critica')),
  status TEXT NOT NULL DEFAULT 'aberto' CHECK (status IN ('aberto','em_analise','em_atendimento','aguardando_usuario','resolvido','encerrado')),
  requester_user_id INTEGER NOT NULL,
  assigned_user_id INTEGER,
  source_room_id INTEGER,
  resolution TEXT,
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  updated_at TEXT NOT NULL DEFAULT (datetime('now')),
  resolved_at TEXT,
  closed_at TEXT,
  FOREIGN KEY (requester_user_id) REFERENCES users(id) ON DELETE RESTRICT,
  FOREIGN KEY (assigned_user_id) REFERENCES users(id) ON DELETE SET NULL,
  FOREIGN KEY (source_room_id) REFERENCES chat_rooms(id) ON DELETE SET NULL
);
CREATE INDEX IF NOT EXISTS idx_chamados_status_updated ON chamados(status, updated_at DESC);
CREATE INDEX IF NOT EXISTS idx_chamados_requester ON chamados(requester_user_id, updated_at DESC);

CREATE TABLE IF NOT EXISTS chamado_eventos (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  chamado_id INTEGER NOT NULL,
  actor_user_id INTEGER,
  event_type TEXT NOT NULL,
  details TEXT,
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  FOREIGN KEY (chamado_id) REFERENCES chamados(id) ON DELETE CASCADE,
  FOREIGN KEY (actor_user_id) REFERENCES users(id) ON DELETE SET NULL
);
CREATE INDEX IF NOT EXISTS idx_chamado_eventos_chamado ON chamado_eventos(chamado_id, created_at, id);

CREATE TABLE IF NOT EXISTS assistente_documentos (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  source_scope TEXT NOT NULL CHECK (source_scope IN ('municipal','federal')),
  issuing_body TEXT,
  version_label TEXT,
  subject TEXT,
  source_url TEXT,
  active INTEGER NOT NULL DEFAULT 1 CHECK (active IN (0,1)),
  effective_date TEXT,
  supersedes_id INTEGER,
  created_by INTEGER,
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  updated_at TEXT NOT NULL DEFAULT (datetime('now')),
  FOREIGN KEY (supersedes_id) REFERENCES assistente_documentos(id) ON DELETE SET NULL,
  FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL
);
CREATE INDEX IF NOT EXISTS idx_assistente_docs_scope_active ON assistente_documentos(source_scope, active, subject);

CREATE TABLE IF NOT EXISTS app_db_meta (
  app_key TEXT PRIMARY KEY,
  schema_version TEXT NOT NULL,
  updated_at TEXT NOT NULL DEFAULT (datetime('now'))
);
INSERT INTO app_db_meta (app_key, schema_version, updated_at)
VALUES ('apoio', '2.11.4', datetime('now'))
ON CONFLICT(app_key) DO UPDATE SET schema_version=excluded.schema_version, updated_at=excluded.updated_at;
