SELECT
  (SELECT COUNT(*) FROM users) AS users,
  (SELECT COUNT(*) FROM unidades) AS unidades,
  (SELECT COUNT(*) FROM user_unidades) AS user_unidades,
  (SELECT COUNT(*) FROM admin_unidades) AS admin_unidades,
  (SELECT COUNT(*) FROM role_permissions) AS role_permissions,
  (SELECT COUNT(*) FROM user_permissions) AS user_permissions,
  (SELECT COUNT(*) FROM reports) AS reports,
  (SELECT COUNT(*) FROM report_groups) AS report_groups,
  (SELECT COUNT(*) FROM links) AS links,
  (SELECT COUNT(*) FROM updates) AS updates;

SELECT app_key, schema_version, updated_at FROM app_db_meta;

PRAGMA foreign_key_check;
