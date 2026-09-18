PRAGMA foreign_keys = ON;

INSERT INTO unidades (code, nome, cnes, endereco, tel, ativo, sort_order, created_at, tipo) VALUES
('upa','UPA 24h Vereador Luiz dos Santos Faria','7068824','Rua Alfredo Del''Vigna, 253 - Jordanésia, Cajamar/SP','(11) 4447-4058',1,1,'2026-07-27 20:01:59','outra'),
('policlinica','Policlínica Municipal de Cajamar','4982037','Av. Dr. Antonio João Abdalla, 1500 - Cristais, Cajamar/SP','(11) 4446-0100',1,2,'2026-07-27 20:01:59','outra'),
('cer2','Centro Especializado em Reabilitação CER II','5204887','Av. Dr. Antonio João Abdalla, 1500 - Cristais, Cajamar/SP','(11) 4446-0100',1,3,'2026-07-27 20:01:59','outra'),
('portal','ESF Carlos dos Santos','968358','Rua das Cravinas, 198 - Portal Ipês III, Cajamar/SP','(11) 4446-0124',1,4,'2026-07-27 20:01:59','aps'),
('km43','Posto de Saúde Nadília de Oliveira Santos','5270006','Rua Bela Vista, 1200 - São Benedito, Cajamar/SP','(11) 4446-0115',1,5,'2026-07-27 20:01:59','aps'),
('beloplanalto','PSF Belo Planalto','3672891','Rua Nercílio José dos Santos, 58 - Polvilho, Cajamar/SP','(11) 4446-0112',1,6,'2026-07-27 20:01:59','aps'),
('marialuiza','PSF Dra. Maria de Lourdes Mendonça Bravo','2096269','Av. Arujá, 208 - Colina Maria Luíza, Cajamar/SP','(11) 4446-0116',1,7,'2026-07-27 20:01:59','aps'),
('guaturinho','PSF Edivaldo Soares Massagardi','7068840','Rua Barueri, 198 - Guaturinho, Cajamar/SP','(11) 4446-0111',1,8,'2026-07-27 20:01:59','aps'),
('parquesaoroberto','UBS Enf. Leontina Martins França','2096242','Av. Dr. José Luíz Leme Maciel, 179 - Jordanésia, Cajamar/SP','(11) 4446-0109',1,9,'2026-07-27 20:01:59','aps'),
('ponunduva','USF Maria Aparecida Missé','2096226','Rua Joaquim Rodrigues Pontes, 203 - Ponunduva, Cajamar/SP','(11) 4446-0114',1,10,'2026-07-27 20:01:59','aps'),
('cajamarcento','USF Vereador Joaquim Alves de Castro','2096161','Av. Prof. Walter Ribas de Andrade, 544 - Água Fria, Cajamar/SP','(11) 4446-0110',1,11,'2026-07-27 20:01:59','aps'),
('jordanesia','UBS Enfermeiro Carlos Moreira da Silva','2096234','Av. Antônio Cândido Machado, 1769 - Jordanésia, Cajamar/SP','(11) 4446-0107',1,12,'2026-07-27 20:01:59','aps'),
('polvilho','UBS Dra. Izabel Gratieri','2096188','Rua Timburi, 121 - Panorama I - Polvilho, Cajamar/SP','(11) 4446-0108',1,13,'2026-07-27 20:01:59','aps'),
('manoelinacio','USF Manoel Inácio da Silva','3437280','Av. das Juritis, 385 - Pq. Maria Aparecida, Cajamar/SP','(11) 4446-0117',1,14,'2026-07-27 20:01:59','aps'),
('ceo','Centro de Especialidades Odontológicas','4075773','Av. Dr. Antonio João Abdalla, 1500 - 2º andar - Cristais, Cajamar/SP','(11) 4446-0117',1,15,'2026-07-27 20:01:59','outra'),
('caps','CAPS Cajamar','9077618','Rua Rita Maria de Jesus, 20 - Polvilho, Cajamar/SP','(11) 4446-0121',1,16,'2026-07-27 20:01:59','outra'),
('capsij','CAPS Infanto/Juvenil','499889','Rua das Moréias, 55 - Portal 3 - Polvilho, Cajamar/SP','(11) 4446-0122',1,17,'2026-07-27 20:01:59','outra')
ON CONFLICT(code) DO UPDATE SET nome=excluded.nome,cnes=excluded.cnes,endereco=excluded.endereco,tel=excluded.tel,ativo=excluded.ativo,sort_order=excluded.sort_order,tipo=excluded.tipo;

INSERT INTO users (id, username, name, password_hash, salt, role, active, must_change_password, unidade, created_at, theme) VALUES
(1,'admin','Administrador do Portal','6a6903b4f1902717a02fbcb8a771b96e8a0083bf41c01fc0e1ac23fa31b08850','58528e6c84c7a12e23c4b0263fd8ed1f','super_admin',1,0,NULL,'2026-07-08 19:14:32','light'),
(5,'arianekono','Ariane Renata Kono','2ebedec9cdb42c0f393e37e176124be84f04309e7cfeb04fe63513e5db83df50','f89d1cd84a1d4a14cc5be536d19e822c','admin_unidade',1,0,'Centro de Especialidades Odontológicas','2026-07-23 15:00:37','light'),
(7,'herbet.santos','Herbet David Gomes dos Santos','84931b9a59ae8af067f9f1a2548a86f1fd72d7367b4c5488452fb3f432528eaa','b571a6a04b17fb07689910cdf92bc348','super_admin',1,0,'Secretaria de Saúde','2026-07-24 23:35:33','light'),
(9,'g-macedo._','Gyselle Dias de Macedo','d83be4bf981cc5507ab2ab4769e70c8bea37234f204ee76be4d695fdd4835b3d','85c22216dd287591a4ab59c3a4dd9f14','user',1,0,'UBS Enfermeiro Carlos Moreira da Silva','2026-07-30 14:44:52','light'),
(10,'juliana.oliveira_santos-2026','Juliana de Oliveira Santos','9bff4e5d190e758cdb6d85abf574b37084663bc2f14f9a5aa2cb71dadb85c312','6f03774334a7990dbd2f7d3fa2bd38f9','user',1,0,'Posto de Saúde Nadília de Oliveira Santos','2026-07-30 17:46:12','light'),
(11,'rita_misse','Rita de Cassia Misse Macedo','cf3114058f69467563cb1d28046696043a0b4910cf8af48b52f363c9e5dd7e6b','98922d566c3e4a16f8870d71b93fcf38','user',1,1,'UBS Enf. Leontina Martins França','2026-07-30 17:46:13','light'),
(12,'francinymartins','Franciny Oliveira Martins','8301242103720688e22901e2c6b136b217fb310253d938b8bca5a1a7070343c8','785a1aeb489c2be785e3522a09672de0','user',1,0,'ESF Carlos dos Santos','2026-07-30 17:46:14','light'),
(13,'veonicabandoli','Veronica Bandoli Morais','2046f14c836f5a7cbb4c02722945ac37df9e3ef76d4147c53b0547bd4c5d4a0b','525be5bc3542cda44d3818c6c512e209','user',1,0,'UBS Enf. Leontina Martins França','2026-07-30 17:46:16','light'),
(14,'zurc','Bruna Cruz','08de2de36618b1cdbcd805a86df8c12eef8ed6779e2d2f35d59fc3c2d784680f','7dee75c31b08a4b0dd6dcb1ca101ec03','user',1,0,'APS','2026-07-31 14:33:06','light'),
(17,'juliany','Juliany Vieira Sant Ana','a48a48edde9258bbb270ce9c7b96aa82ecd4055b2891250fc97afe99ffc2f92f','7b7b0c438436fe9c6e412fb4fbbd8d40','user',1,0,'ESF Carlos dos Santos','2026-08-19 11:57:09','light'),
(18,'daniel.freitas','Daniel de Freitas','30c64312531d8e80c91d739321d738084318d92d5038778e21f9016b3be1fccb','88e6fbf26e4840e934531a0e406ab5ec','admin',1,1,NULL,'2026-08-20 20:24:01','light'),
(19,'tester','User Tester','97acc75b3df63b0dfbfd8e2aca171b8a2463ec4b0cff1d471cfac2d387e6abd2','a40051ab2816d571a201491078592745','user',1,0,'Posto de Saúde Nadília de Oliveira Santos','2026-08-31 19:08:20','light'),
(20,'jaqueline.gomes','Jaqueline Gomes','158e092abed748e7f7d12f7636ba7f7b8790b7afcee57c5917f05be16015082a','297661d6c813de696dd867965c501bbd','admin',1,0,NULL,'2026-09-04 19:14:48','light'),
(21,'grace.paula','Grace Paula','fb45eec21b732b920b2b184db12fb1ddd042b547e9979181494434e233f019cd','d305eae078d01087e0ca2852fb382746','admin',1,0,NULL,'2026-09-09 19:07:14','light'),
(22,'luiz.junior','Luiz Candido','56626c91e709f3ac87e80f1c9cb4c63eaa368d1abcc35eb79f4fb2da947fcac6','38159e1334a4e8933820163a652417ce','admin',1,0,NULL,'2026-09-09 19:08:49','light')
ON CONFLICT(id) DO UPDATE SET username=excluded.username,name=excluded.name,password_hash=excluded.password_hash,salt=excluded.salt,role=excluded.role,active=excluded.active,must_change_password=excluded.must_change_password,unidade=excluded.unidade,theme=excluded.theme;

INSERT INTO user_unidades (user_id, unidade_code) VALUES
(5,'ceo'),
(9,'jordanesia'),
(10,'km43'),
(11,'parquesaoroberto'),
(12,'portal'),
(13,'parquesaoroberto'),
(17,'portal'),
(19,'km43')
ON CONFLICT(user_id, unidade_code) DO NOTHING;

DELETE FROM admin_unidades WHERE admin_user_id = 5;
INSERT INTO admin_unidades (admin_user_id, unidade) VALUES (5,'Centro de Especialidades Odontológicas');

INSERT INTO role_permissions (role, feature_key, enabled) VALUES
('admin','administracao',1),('admin','documentos',1),('admin','facilitawhats',1),('admin','malotes',1),('admin','manuais',1),('admin','mensageiro_esus',1),('admin','receituario',1),('admin','relatorios',1),
('admin_unidade','administracao',1),('admin_unidade','documentos',1),('admin_unidade','facilitawhats',1),('admin_unidade','malotes',1),('admin_unidade','manuais',1),('admin_unidade','mensageiro_esus',1),('admin_unidade','receituario',1),('admin_unidade','relatorios',1),
('user','administracao',0),('user','documentos',1),('user','facilitawhats',1),('user','malotes',1),('user','manuais',1),('user','mensageiro_esus',1),('user','receituario',1),('user','relatorios',1)
ON CONFLICT(role, feature_key) DO UPDATE SET enabled=excluded.enabled;

DELETE FROM role_permissions WHERE feature_key IN ('regulacao_vagas','apoio_clinico','producao');
DELETE FROM user_permissions WHERE feature_key IN ('apoio_clinico','producao');

INSERT INTO user_permissions (user_id, feature_key, enabled) VALUES
(1,'regulacao_vagas',1),
(5,'regulacao_vagas',0),
(7,'regulacao_vagas',1),
(9,'documentos',1),
(9,'facilitawhats',1),
(9,'malotes',1),
(9,'manuais',1),
(9,'mensageiro_esus',1),
(9,'receituario',1),
(9,'regulacao_vagas',0),
(9,'relatorios',0),
(10,'regulacao_vagas',0),
(11,'regulacao_vagas',0),
(12,'regulacao_vagas',0),
(13,'regulacao_vagas',0),
(14,'regulacao_vagas',0),
(17,'regulacao_vagas',0),
(18,'regulacao_vagas',1),
(19,'regulacao_vagas',0)
ON CONFLICT(user_id, feature_key) DO UPDATE SET enabled=excluded.enabled;

INSERT INTO links (id, category, title, url, description, sort_order, created_at, open_mode, feature_key) VALUES
(1,'ferramenta','Malotes e Remessas','/guiasmalotes','Documente suas remessas com facilidade e economia de papel.',1,'2026-07-08 19:14:48','_blank','malotes'),
(2,'ferramenta','Prescrições','/receituario',NULL,2,'2026-07-08 19:14:48','_blank','receituario'),
(3,'ferramenta','FacilitaWhats','/facilitawhats','Com o PDF da agenda do dia, ou com uma planilha com informações básicas, tornará mais simples sua comunicação através do WhatsApp.',3,'2026-07-08 19:14:48','_blank','facilitawhats'),
(4,'ferramenta','Mensageiro eSUS','https://docs.google.com/uc?export=download&id=1-64Dwm1POwiH39EZMkP8kz1qWVZ29ngm','Facilita a comunicação com os pacientes do Prontuário Eletrônico do Cidadão (eSUS PEC APS), integrando-o com o WhatsApp Web.',4,'2026-07-17 18:51:19','_blank','mensageiro_esus'),
(5,'manual','Manual de uso - Mensagens eSUS','https://drive.google.com/file/d/1Bug7E-XKzxSBwCsbs586gml1YhXoQ3Jh/view?usp=sharing','Como utilizar a extensão facilitadora de mensageria Mensagens eSUS.',1,'2026-07-21 16:36:12','_blank',NULL),
(6,'ferramenta','PEC eSUS','https://esus.cajamar.sp.gov.br',NULL,5,'2026-08-27 14:24:35','_blank',NULL),
(7,'ferramenta','Ouvidor IA','https://docs.google.com/uc?export=download&id=1AEbViyxOLmA9mISaEU-TdkgpycwvZp_A','Software para auxílio com respostas para a ouvidoria.',6,'2026-08-28 19:45:17','_self',NULL),
(8,'ferramenta','Regulação de Vagas','https://emulti.pages.dev/',NULL,4,'2026-08-28 19:55:29','_blank','regulacao_vagas')
ON CONFLICT(id) DO UPDATE SET category=excluded.category,title=excluded.title,url=excluded.url,description=excluded.description,sort_order=excluded.sort_order,open_mode=excluded.open_mode,feature_key=excluded.feature_key;

INSERT INTO updates (id, title, body, tag, link_url, link_label, published_at, created_at, image_url, image_alt) VALUES
(1,'Bem-vindo(a) ao novo Portal da Atenção Primária à Saúde!','Acompanhe aqui ferramentas desenvolvidas para simplificar o seu dia de trabalho e novidades do departamento!','Sistema',NULL,NULL,'2026-07-22','2026-07-22 11:25:27',NULL,NULL),
(2,'Nova versão da Mensageria e-SUS!','Para facilitar a comunicação com os pacientes, comunicar sobre agendamentos, evoluímos uma extensão para automatizar o disparo de mensagens pré-definidas. Aproveite!','Ferramentas',NULL,'https://docs.google.com/uc?export=download&id=15Ist5JEuI2qAUMU0s5FwkFSutHfYArR4','2026-08-25','2026-08-25 15:34:42',NULL,NULL)
ON CONFLICT(id) DO UPDATE SET title=excluded.title,body=excluded.body,tag=excluded.tag,link_url=excluded.link_url,link_label=excluded.link_label,published_at=excluded.published_at,image_url=excluded.image_url,image_alt=excluded.image_alt;

DELETE FROM report_group_reports WHERE report_id = 2 OR group_id = 3;
DELETE FROM user_report_groups WHERE group_id = 3;
DELETE FROM reports WHERE id = 2 AND title = 'Absenteísmo e Distância de Agenda';
DELETE FROM report_groups WHERE id = 3 AND name = 'Geral';

INSERT INTO report_groups (id, name, description, created_at) VALUES
(2,'Odontologia',NULL,'2026-07-23 14:52:49')
ON CONFLICT(id) DO UPDATE SET name=excluded.name,description=excluded.description;

INSERT INTO reports (id, title, description, embed_url, display_mode, sort_order, created_at) VALUES
(1,'Notas Metodológicas - Odontologia','Acompanhe os resultados de suas unidades, equipes e profissionais.','https://datastudio.google.com/embed/reporting/8aca21ad-9863-4dfd-9430-b33401b0c171/page/p_xw1g5qn44d','new_tab',2,'2026-07-23 14:52:43')
ON CONFLICT(id) DO UPDATE SET title=excluded.title,description=excluded.description,embed_url=excluded.embed_url,display_mode=excluded.display_mode,sort_order=excluded.sort_order;

INSERT INTO report_group_reports (group_id, report_id) VALUES (2,1)
ON CONFLICT(group_id, report_id) DO NOTHING;

DELETE FROM sessions;
DELETE FROM handoff_tokens;

INSERT INTO app_db_meta (app_key, schema_version, updated_at)
VALUES ('apoio','2.11.4',datetime('now'))
ON CONFLICT(app_key) DO UPDATE SET schema_version=excluded.schema_version,updated_at=excluded.updated_at;

PRAGMA foreign_key_check;
