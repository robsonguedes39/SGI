-- =====================================================================
-- SGI - Sub-projeto 6: registro das remessas SIM-AM Obras geradas.
-- Base: adtovb. Prefixo int_. Idempotente. Sem semeadura.
-- Rodar depois da 002 (int_entidade) - na pratica depois de tudo, e a
-- ultima do modulo de obras.
--
-- So REGISTRO: competencia, quando/quem gerou, resumo, nome do zip. O
-- conteudo NAO e guardado - a competencia e regeravel do estado atual
-- do banco. Sem UNIQUE na competencia: regerar o mesmo mes grava outra
-- linha (historico).
-- =====================================================================

CREATE TABLE IF NOT EXISTS int_remessa (
  Cod               INT AUTO_INCREMENT PRIMARY KEY,
  nrAnoCompetencia  SMALLINT UNSIGNED NOT NULL,
  nrMesCompetencia  TINYINT  UNSIGNED NOT NULL,
  dtGeracao         DATETIME     NOT NULL,
  cpfGerou          VARCHAR(14)  NOT NULL,
  dsResumo          VARCHAR(2000) NOT NULL,
  nmArquivoZip      VARCHAR(120) NOT NULL,
  KEY idx_int_remessa_comp (nrAnoCompetencia, nrMesCompetencia)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
