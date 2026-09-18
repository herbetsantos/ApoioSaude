SELECT
  (SELECT COUNT(*) FROM users) AS users,
  (SELECT COUNT(*) FROM unidades) AS unidades,
  (SELECT COUNT(*) FROM user_unidades) AS user_unidades,
  (SELECT COUNT(*) FROM admin_unidades) AS admin_unidades,
  (SELECT COUNT(*) FROM role_permissions) AS role_permissions,
  (SELECT COUNT(*) FROM user_permissions) AS user_permissions,
  (SELECT COUNT(*) FROM reports) AS reports,
  (SELECT COUNT(*) FROM report_groups) AS report_groups,
  (SELECT COUNT(*) FROM report_group_reports) AS report_group_reports,
  (SELECT COUNT(*) FROM user_report_groups) AS user_report_groups,
  (SELECT COUNT(*) FROM links) AS links,
  (SELECT COUNT(*) FROM updates) AS updates;

SELECT id, username, role, active, unidade FROM users ORDER BY id;
SELECT user_id, feature_key, enabled FROM user_permissions WHERE feature_key IN ('regulacao_vagas','relatorios') ORDER BY user_id, feature_key;
SELECT id, title, url, feature_key FROM links ORDER BY id;
SELECT id, title FROM reports ORDER BY id;
SELECT id, name FROM report_groups ORDER BY id;
SELECT * FROM report_group_reports ORDER BY group_id, report_id;
SELECT app_key, schema_version FROM app_db_meta;
PRAGMA foreign_key_check;
