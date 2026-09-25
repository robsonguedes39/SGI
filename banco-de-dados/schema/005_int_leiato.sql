-- =====================================================================
-- SGI - Leis e Atos de obra (recorte de obras da tabela LeiAto do SIM-AM)
-- Base: adtovb. Prefixo int_.
-- Idempotente: CREATE TABLE IF NOT EXISTS, ADD COLUMN IF NOT EXISTS,
-- INSERT ... SELECT ... WHERE NOT EXISTS. Rodar duas vezes seguidas nao
-- pode falhar nem duplicar.
--
-- O de-para ConsolidacaoTipoDocumentoXEscopo tem, para obras, 8
-- combinacoes, e cada tipo de documento mapeia para exatamente um escopo
-- (ver spec 2026-09-01-leiato-obras-design.md, secao 1). Os 8 tipos tem
-- flExigeNumeroDocumento='N' e os 6 escopos flPlurianual='N' - nenhuma
-- das regras condicionais do leiaute alcanca esse subconjunto.
-- =====================================================================

CREATE TABLE IF NOT EXISTS int_tipo_documento_leiato (
  idTipoDocumento        SMALLINT UNSIGNED PRIMARY KEY,
  dsTipoDocumento        VARCHAR(120) NOT NULL,
  flExigeNumeroDocumento CHAR(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO int_tipo_documento_leiato (idTipoDocumento, dsTipoDocumento, flExigeNumeroDocumento) SELECT 100,'Projeto','N'                                                                              WHERE NOT EXISTS (SELECT 1 FROM int_tipo_documento_leiato WHERE idTipoDocumento=100);
INSERT INTO int_tipo_documento_leiato (idTipoDocumento, dsTipoDocumento, flExigeNumeroDocumento) SELECT 104,'Orçamento base (execução direta) ou do edital (execução indireta)','N'                 WHERE NOT EXISTS (SELECT 1 FROM int_tipo_documento_leiato WHERE idTipoDocumento=104);
INSERT INTO int_tipo_documento_leiato (idTipoDocumento, dsTipoDocumento, flExigeNumeroDocumento) SELECT 105,'Planilha Orçamentária Contratada','N'                                                   WHERE NOT EXISTS (SELECT 1 FROM int_tipo_documento_leiato WHERE idTipoDocumento=105);
INSERT INTO int_tipo_documento_leiato (idTipoDocumento, dsTipoDocumento, flExigeNumeroDocumento) SELECT 106,'Planilha Orçamentária Aditivo','N'                                                      WHERE NOT EXISTS (SELECT 1 FROM int_tipo_documento_leiato WHERE idTipoDocumento=106);
INSERT INTO int_tipo_documento_leiato (idTipoDocumento, dsTipoDocumento, flExigeNumeroDocumento) SELECT 107,'Termo de Paralisação','N'                                                              WHERE NOT EXISTS (SELECT 1 FROM int_tipo_documento_leiato WHERE idTipoDocumento=107);
INSERT INTO int_tipo_documento_leiato (idTipoDocumento, dsTipoDocumento, flExigeNumeroDocumento) SELECT 108,'Termo(s) de Recebimento Definitivo','N'                                                 WHERE NOT EXISTS (SELECT 1 FROM int_tipo_documento_leiato WHERE idTipoDocumento=108);
INSERT INTO int_tipo_documento_leiato (idTipoDocumento, dsTipoDocumento, flExigeNumeroDocumento) SELECT 109,'Medição','N'                                                                          WHERE NOT EXISTS (SELECT 1 FROM int_tipo_documento_leiato WHERE idTipoDocumento=109);
INSERT INTO int_tipo_documento_leiato (idTipoDocumento, dsTipoDocumento, flExigeNumeroDocumento) SELECT 110,'Justificativa para Cancelamento ou Cadastro Indevido de Intervenção','N'                WHERE NOT EXISTS (SELECT 1 FROM int_tipo_documento_leiato WHERE idTipoDocumento=110);

CREATE TABLE IF NOT EXISTS int_escopo_leiato (
  idEscopo     SMALLINT UNSIGNED PRIMARY KEY,
  dsEscopo     VARCHAR(120) NOT NULL,
  flPlurianual CHAR(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO int_escopo_leiato (idEscopo, dsEscopo, flPlurianual) SELECT 36,'Projeto de Obras Públicas','N'                                                       WHERE NOT EXISTS (SELECT 1 FROM int_escopo_leiato WHERE idEscopo=36);
INSERT INTO int_escopo_leiato (idEscopo, dsEscopo, flPlurianual) SELECT 38,'Orçamentos de Obras Públicas','N'                                                    WHERE NOT EXISTS (SELECT 1 FROM int_escopo_leiato WHERE idEscopo=38);
INSERT INTO int_escopo_leiato (idEscopo, dsEscopo, flPlurianual) SELECT 39,'Boletins de Medição de Obras Públicas','N'                                           WHERE NOT EXISTS (SELECT 1 FROM int_escopo_leiato WHERE idEscopo=39);
INSERT INTO int_escopo_leiato (idEscopo, dsEscopo, flPlurianual) SELECT 40,'Termos de Recebimento Definitivo de Obras Públicas','N'                              WHERE NOT EXISTS (SELECT 1 FROM int_escopo_leiato WHERE idEscopo=40);
INSERT INTO int_escopo_leiato (idEscopo, dsEscopo, flPlurianual) SELECT 65,'Termo de Paralisação de Obras Públicas','N'                                          WHERE NOT EXISTS (SELECT 1 FROM int_escopo_leiato WHERE idEscopo=65);
INSERT INTO int_escopo_leiato (idEscopo, dsEscopo, flPlurianual) SELECT 66,'Documentos com Justificativa para Cancelamento ou Cadastro Indevido de Intervenção','N' WHERE NOT EXISTS (SELECT 1 FROM int_escopo_leiato WHERE idEscopo=66);

CREATE TABLE IF NOT EXISTS int_map_tipodoc_escopo (
  idTipoDocumento SMALLINT UNSIGNED NOT NULL,
  idEscopo        SMALLINT UNSIGNED NOT NULL,
  PRIMARY KEY (idTipoDocumento, idEscopo),
  CONSTRAINT fk_mapde_tipo   FOREIGN KEY (idTipoDocumento) REFERENCES int_tipo_documento_leiato(idTipoDocumento),
  CONSTRAINT fk_mapde_escopo FOREIGN KEY (idEscopo)        REFERENCES int_escopo_leiato(idEscopo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO int_map_tipodoc_escopo (idTipoDocumento, idEscopo) SELECT 100,36 WHERE NOT EXISTS (SELECT 1 FROM int_map_tipodoc_escopo WHERE idTipoDocumento=100 AND idEscopo=36);
INSERT INTO int_map_tipodoc_escopo (idTipoDocumento, idEscopo) SELECT 104,38 WHERE NOT EXISTS (SELECT 1 FROM int_map_tipodoc_escopo WHERE idTipoDocumento=104 AND idEscopo=38);
INSERT INTO int_map_tipodoc_escopo (idTipoDocumento, idEscopo) SELECT 105,38 WHERE NOT EXISTS (SELECT 1 FROM int_map_tipodoc_escopo WHERE idTipoDocumento=105 AND idEscopo=38);
INSERT INTO int_map_tipodoc_escopo (idTipoDocumento, idEscopo) SELECT 106,38 WHERE NOT EXISTS (SELECT 1 FROM int_map_tipodoc_escopo WHERE idTipoDocumento=106 AND idEscopo=38);
INSERT INTO int_map_tipodoc_escopo (idTipoDocumento, idEscopo) SELECT 107,65 WHERE NOT EXISTS (SELECT 1 FROM int_map_tipodoc_escopo WHERE idTipoDocumento=107 AND idEscopo=65);
INSERT INTO int_map_tipodoc_escopo (idTipoDocumento, idEscopo) SELECT 108,40 WHERE NOT EXISTS (SELECT 1 FROM int_map_tipodoc_escopo WHERE idTipoDocumento=108 AND idEscopo=40);
INSERT INTO int_map_tipodoc_escopo (idTipoDocumento, idEscopo) SELECT 109,39 WHERE NOT EXISTS (SELECT 1 FROM int_map_tipodoc_escopo WHERE idTipoDocumento=109 AND idEscopo=39);
INSERT INTO int_map_tipodoc_escopo (idTipoDocumento, idEscopo) SELECT 110,66 WHERE NOT EXISTS (SELECT 1 FROM int_map_tipodoc_escopo WHERE idTipoDocumento=110 AND idEscopo=66);

-- ---------------------------------------------------------------------
-- Dados. cdControleLeiAto e gerado pelo SGL a partir de
-- int_config.cdControleLeiAtoBase. FK composta (idTipoDocumento,
-- idEscopo) garante a combinacao valida (regra 688).
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS int_leiato (
  Cod                   INT AUTO_INCREMENT PRIMARY KEY,
  cdControleLeiAto      INT UNSIGNED      NOT NULL,
  idTipoDocumento       SMALLINT UNSIGNED NOT NULL,
  idEscopo              SMALLINT UNSIGNED NOT NULL,
  nrLeiAto              INT UNSIGNED      NULL,
  nrAnoLeiAto           SMALLINT UNSIGNED NULL,
  dtLeiAto              DATE             NULL,
  cdControleDocumento   INT UNSIGNED      NOT NULL,
  nrAnoInicialAplicacao SMALLINT UNSIGNED NOT NULL,
  UNIQUE KEY uk_int_leiato_cd (cdControleLeiAto),
  KEY idx_int_leiato_tipo (idTipoDocumento),
  CONSTRAINT fk_leiato_map FOREIGN KEY (idTipoDocumento, idEscopo)
    REFERENCES int_map_tipodoc_escopo(idTipoDocumento, idEscopo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- Numero-base do cdControleLeiAto: inicio da lacuna livre na Atoteca da
-- Camara (450900, informado pelo declarante).
-- ---------------------------------------------------------------------
ALTER TABLE int_config ADD COLUMN IF NOT EXISTS cdControleLeiAtoBase INT UNSIGNED NULL;
UPDATE int_config SET cdControleLeiAtoBase = 450900 WHERE cdControleLeiAtoBase IS NULL;
