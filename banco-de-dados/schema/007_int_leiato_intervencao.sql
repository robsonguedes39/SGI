-- =====================================================================
-- SGI - LeiAto ganha vinculo com a Intervencao e uma descricao interna.
-- Base: adtovb. Idempotente: ADD COLUMN IF NOT EXISTS, ADD CONSTRAINT
-- IF NOT EXISTS, ADD INDEX IF NOT EXISTS (MariaDB 10.5+).
--
-- Todo ato de obra (projeto, orcamento, medicao, recebimento,
-- paralisacao) e de UMA intervencao; uma intervencao tem varios atos.
-- Cod_intervencao fica NULL no banco (os atos cadastrados antes desta
-- migracao nao tinham valor); a obrigatoriedade para atos NOVOS e da
-- tela.
--
-- dsDescricao e so conveniencia interna do SGI - o leiaute do TCE nao
-- tem campo de descricao para o LeiAto.
-- =====================================================================

ALTER TABLE int_leiato ADD COLUMN IF NOT EXISTS Cod_intervencao INT NULL;
ALTER TABLE int_leiato ADD COLUMN IF NOT EXISTS dsDescricao VARCHAR(200) NULL;

-- No MariaDB o "IF NOT EXISTS" da FK vem depois de FOREIGN KEY.
ALTER TABLE int_leiato
  ADD CONSTRAINT fk_leiato_intervencao
  FOREIGN KEY IF NOT EXISTS (Cod_intervencao) REFERENCES int_intervencao(Cod);

-- Atos orfaos: se houver EXATAMENTE UMA intervencao cadastrada, todos os
-- atos sem intervencao pertencem a ela (nao ha ambiguidade). Com mais de
-- uma intervencao, o UPDATE nao roda - o operador associa cada ato pela
-- tela.
UPDATE int_leiato
   SET Cod_intervencao = (SELECT Cod FROM int_intervencao LIMIT 1)
 WHERE Cod_intervencao IS NULL
   AND (SELECT COUNT(*) FROM int_intervencao) = 1;
