-- Só para quem JÁ executou migration_agenda.sql antes das etiquetas. Rode uma única vez.
ALTER TABLE agenda_contatos ADD COLUMN etiquetas TEXT;
