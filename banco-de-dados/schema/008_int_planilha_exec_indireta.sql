-- =====================================================================
-- SGI - Planilhas de Execucao Indireta: o vinculo entre uma planilha de
-- orcamento tipo Contrato (2) / Aditivo (3) e o contrato que ela orca.
-- Nao carrega valor - o vlTotal mora na int_planilha_orcamento pai.
-- Base: adtovb. Idempotente. Rodar DEPOIS da migracao 006.
--
-- O aditivo NAO duplica os campos de contrato: guarda so um ponteiro
-- para a planilha-contrato (Cod_planilha_contrato) + nr/ano do termo.
-- Assim a regra 1574 (a planilha do contrato tem que existir) e uma FK
-- NOT NULL e nao pode ser violada.
-- =====================================================================

CREATE TABLE IF NOT EXISTS int_tipo_ato_contrato (
  idTipoAtoContrato TINYINT UNSIGNED PRIMARY KEY,
  dsTipoAtoContrato VARCHAR(60) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO int_tipo_ato_contrato (idTipoAtoContrato, dsTipoAtoContrato)
SELECT 1, 'Contrato'
 WHERE NOT EXISTS (SELECT 1 FROM int_tipo_ato_contrato WHERE idTipoAtoContrato = 1);
INSERT INTO int_tipo_ato_contrato (idTipoAtoContrato, dsTipoAtoContrato)
SELECT 2, 'Ata de Registro de Preços'
 WHERE NOT EXISTS (SELECT 1 FROM int_tipo_ato_contrato WHERE idTipoAtoContrato = 2);

CREATE TABLE IF NOT EXISTS int_tipo_origem_contrato (
  idTipoOrigemContrato TINYINT UNSIGNED PRIMARY KEY,
  dsTipoOrigemContrato VARCHAR(60) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO int_tipo_origem_contrato (idTipoOrigemContrato, dsTipoOrigemContrato)
SELECT 1, 'Própria Entidade'
 WHERE NOT EXISTS (SELECT 1 FROM int_tipo_origem_contrato WHERE idTipoOrigemContrato = 1);
INSERT INTO int_tipo_origem_contrato (idTipoOrigemContrato, dsTipoOrigemContrato)
SELECT 2, 'Contratado/Entidade Pública de Outro Estado'
 WHERE NOT EXISTS (SELECT 1 FROM int_tipo_origem_contrato WHERE idTipoOrigemContrato = 2);
INSERT INTO int_tipo_origem_contrato (idTipoOrigemContrato, dsTipoOrigemContrato)
SELECT 3, 'Outra Entidade Pública'
 WHERE NOT EXISTS (SELECT 1 FROM int_tipo_origem_contrato WHERE idTipoOrigemContrato = 3);

CREATE TABLE IF NOT EXISTS int_planilha_exec_indireta_contrato (
  Cod                    INT AUTO_INCREMENT PRIMARY KEY,
  Cod_planilha_orcamento INT              NOT NULL,
  idTipoAtoContrato      TINYINT UNSIGNED NOT NULL,
  idTipoOrigemContrato   TINYINT UNSIGNED NOT NULL,
  nrContrato             INT UNSIGNED     NOT NULL,
  nrAnoContrato          SMALLINT UNSIGNED NOT NULL,
  nrCNPJOrigem           CHAR(14)         NOT NULL,
  UNIQUE KEY uk_int_peic_planilha (Cod_planilha_orcamento),
  CONSTRAINT fk_peic_planilha FOREIGN KEY (Cod_planilha_orcamento) REFERENCES int_planilha_orcamento(Cod),
  CONSTRAINT fk_peic_ato      FOREIGN KEY (idTipoAtoContrato)      REFERENCES int_tipo_ato_contrato(idTipoAtoContrato),
  CONSTRAINT fk_peic_origem   FOREIGN KEY (idTipoOrigemContrato)   REFERENCES int_tipo_origem_contrato(idTipoOrigemContrato)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS int_planilha_exec_indireta_aditivo (
  Cod                    INT AUTO_INCREMENT PRIMARY KEY,
  Cod_planilha_orcamento INT              NOT NULL,
  Cod_planilha_contrato  INT              NOT NULL,
  nrAditivoContrato      INT UNSIGNED     NOT NULL,
  nrAnoAditivoContrato   SMALLINT UNSIGNED NOT NULL,
  UNIQUE KEY uk_int_peia_planilha (Cod_planilha_orcamento),
  CONSTRAINT fk_peia_planilha FOREIGN KEY (Cod_planilha_orcamento) REFERENCES int_planilha_orcamento(Cod),
  CONSTRAINT fk_peia_contrato FOREIGN KEY (Cod_planilha_contrato)  REFERENCES int_planilha_exec_indireta_contrato(Cod)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
