-- =====================================================================
-- SGI - Matricula da obra no INSS: matricula CEI (filha de intervencao),
-- CNDs emitidas sobre ela e o eventual cancelamento (0..1). Sem lookup.
-- Base: adtovb. Idempotente.
--
-- nrMatriculaCEI (12 digitos) e nrCND (17 digitos) guardados como numero;
-- o gerador do SIM-AM zero-pada na emissao (Z(12) / 9(17)).
-- nrOperacao e sequencial gerado pelo SGI por (matricula, nrCND) - 3o
-- membro da chave da regra 1586.
-- Regra 1590 (nao cancelar com CND) fica na tela, nao no schema.
-- =====================================================================

CREATE TABLE IF NOT EXISTS int_matricula_inss (
  Cod             INT AUTO_INCREMENT PRIMARY KEY,
  Cod_intervencao INT             NOT NULL,
  nrMatriculaCEI  BIGINT UNSIGNED NOT NULL,
  UNIQUE KEY uk_int_matricula_inss (Cod_intervencao, nrMatriculaCEI),
  KEY idx_int_matricula_inss (Cod_intervencao),
  CONSTRAINT fk_matinss_intervencao FOREIGN KEY (Cod_intervencao) REFERENCES int_intervencao(Cod)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS int_cnd_obra (
  Cod                INT AUTO_INCREMENT PRIMARY KEY,
  Cod_matricula_inss INT              NOT NULL,
  nrCND              BIGINT UNSIGNED  NOT NULL,
  nrOperacao         SMALLINT UNSIGNED NOT NULL,
  dtEmissao          DATE             NOT NULL,
  dtValidade         DATE             NOT NULL,
  UNIQUE KEY uk_int_cnd_obra (Cod_matricula_inss, nrCND, nrOperacao),
  CONSTRAINT fk_cnd_matricula FOREIGN KEY (Cod_matricula_inss) REFERENCES int_matricula_inss(Cod)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS int_cancelamento_matricula_inss (
  Cod                INT AUTO_INCREMENT PRIMARY KEY,
  Cod_matricula_inss INT          NOT NULL,
  dtCancelamento     DATE         NOT NULL,
  dsMotivo           VARCHAR(250) NOT NULL,
  UNIQUE KEY uk_int_cancel_matricula (Cod_matricula_inss),
  CONSTRAINT fk_cancel_matricula FOREIGN KEY (Cod_matricula_inss) REFERENCES int_matricula_inss(Cod)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
