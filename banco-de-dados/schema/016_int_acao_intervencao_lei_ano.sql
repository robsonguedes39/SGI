-- =====================================================================
-- SGI - Numero e ano da lei no vinculo de Acao x Intervencao
-- Base: adtovb. Idempotente: ADD COLUMN IF NOT EXISTS. Rodar 2x sem erro.
-- Rodar depois da 011 (int_acao_intervencao).
-- =====================================================================

ALTER TABLE int_acao_intervencao
  ADD COLUMN IF NOT EXISTS nrLeiAto INT UNSIGNED NULL,
  ADD COLUMN IF NOT EXISTS nrAnoLeiAto SMALLINT UNSIGNED NULL;
