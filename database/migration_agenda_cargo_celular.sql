-- Só para quem JÁ executou migration_agenda.sql antes de cargo/celular. Rode uma única vez.
ALTER TABLE agenda_contatos ADD COLUMN cargo TEXT;
ALTER TABLE agenda_contatos ADD COLUMN celular TEXT;
