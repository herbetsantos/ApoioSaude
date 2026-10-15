-- Apoio — Agenda de contatos internos (aditiva, pode rodar mais de uma vez).
CREATE TABLE IF NOT EXISTS agenda_contatos (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  nome TEXT NOT NULL,
  ramal TEXT,
  email TEXT,
  divisao TEXT,
  departamento TEXT,
  secretaria TEXT,
  etiquetas TEXT,
  cargo TEXT,
  celular TEXT,
  ativo INTEGER NOT NULL DEFAULT 1 CHECK (ativo IN (0,1)),
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  updated_at TEXT NOT NULL DEFAULT (datetime('now'))
);
CREATE INDEX IF NOT EXISTS idx_agenda_nome ON agenda_contatos(nome);
CREATE INDEX IF NOT EXISTS idx_agenda_ativo ON agenda_contatos(ativo);

-- Libera a funcionalidade "agenda" para todos os papéis (sem isso o teto por papel fica desligado).
INSERT OR IGNORE INTO role_permissions (role, feature_key, enabled) VALUES
  ('user', 'agenda', 1),
  ('admin_unidade', 'agenda', 1),
  ('admin', 'agenda', 1);
