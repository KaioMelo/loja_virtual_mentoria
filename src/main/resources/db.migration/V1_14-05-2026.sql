SELECT CONSTRAINT_NAME FROM INFORMATION_SCHEMA.constraint_column_usage 
WHERE TABLE_NAME = 'usuario_acesso' AND COLUMN_NAME = 'acesso_id'
AND CONSTRAINT_NAME <> 'unique_acesso_user';

ALTER TABLE usuario_acesso DROP CONSTRAINT "uk_fhwpg5wu1u5p306q8gycxn9ky";