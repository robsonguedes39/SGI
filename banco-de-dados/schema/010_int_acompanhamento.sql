-- =====================================================================
-- SGI - Acompanhamento mensal de obras: a linha do tempo da obra
-- (int_acompanhamento, filha de intervencao) e os detalhes por tipo -
-- medicao (+ execucao indireta de contrato/aditivo), paralisacao,
-- documentos anexos. Base: adtovb. Idempotente. Rodar DEPOIS da 008.
--
-- nrAcompanhamento e sequencial gerado pelo SGI por (intervencao,
-- origem=1), regra 1611 - exclusao so do ultimo.
-- As execucoes indiretas guardam so o ponteiro p/ a planilha de
-- execucao indireta (PEIC/PEIA); os campos do contrato vem por JOIN.
-- A maquina de estados (regras 1601/1603/1605/1612/1613/1730) fica na
-- tela via AcompanhamentoRegras.
-- =====================================================================

CREATE TABLE IF NOT EXISTS int_origem_acompanhamento (
  idOrigemAcompanhamento TINYINT UNSIGNED PRIMARY KEY,
  dsOrigemAcompanhamento VARCHAR(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
-- 1 Jurisdicionado / 2 TCE-PR / 3 CREA-PR

CREATE TABLE IF NOT EXISTS int_tipo_acompanhamento (
  idTipoAcompanhamento TINYINT UNSIGNED PRIMARY KEY,
  dsTipoAcompanhamento VARCHAR(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
-- 1 Medicao / 2 Paralisacao / 3 Conclusao / 4 Cancelamento de Intervencao / 5 Cadastro indevido

CREATE TABLE IF NOT EXISTS int_tipo_medicao (
  idTipoMedicao TINYINT UNSIGNED PRIMARY KEY,
  dsTipoMedicao VARCHAR(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
-- 1 Execucao Indireta - Contrato / 2 Execucao Indireta - Aditivo / 3 Execucao Direta

CREATE TABLE IF NOT EXISTS int_motivo_paralisacao (
  idMotivoParalisacao TINYINT UNSIGNED PRIMARY KEY,
  dsMotivoParalisacao VARCHAR(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
-- 1..8 (ver §2.6)

CREATE TABLE IF NOT EXISTS int_acompanhamento (
  Cod                    INT AUTO_INCREMENT PRIMARY KEY,
  Cod_intervencao        INT              NOT NULL,
  idOrigemAcompanhamento TINYINT UNSIGNED NOT NULL DEFAULT 1,
  nrAcompanhamento       SMALLINT UNSIGNED NOT NULL,
  dtAcompanhamento       DATE             NOT NULL,
  idTipoAcompanhamento   TINYINT UNSIGNED NOT NULL,
  Cod_pessoa             INT              NOT NULL,
  dsObservacao           VARCHAR(800)     NULL,
  UNIQUE KEY uk_int_acompanhamento (Cod_intervencao, idOrigemAcompanhamento, nrAcompanhamento),
  KEY idx_int_acompanhamento (Cod_intervencao),
  CONSTRAINT fk_acomp_intervencao FOREIGN KEY (Cod_intervencao)        REFERENCES int_intervencao(Cod),
  CONSTRAINT fk_acomp_origem      FOREIGN KEY (idOrigemAcompanhamento) REFERENCES int_origem_acompanhamento(idOrigemAcompanhamento),
  CONSTRAINT fk_acomp_tipo        FOREIGN KEY (idTipoAcompanhamento)   REFERENCES int_tipo_acompanhamento(idTipoAcompanhamento),
  CONSTRAINT fk_acomp_pessoa      FOREIGN KEY (Cod_pessoa)             REFERENCES int_pessoa(Cod)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS int_medicao (
  Cod                INT AUTO_INCREMENT PRIMARY KEY,
  Cod_acompanhamento INT              NOT NULL,
  idTipoMedicao      TINYINT UNSIGNED NOT NULL,
  nrPercentualFisico DECIMAL(5,2)     NOT NULL CHECK (nrPercentualFisico BETWEEN 0 AND 100),
  UNIQUE KEY uk_int_medicao (Cod_acompanhamento),
  CONSTRAINT fk_medicao_acomp FOREIGN KEY (Cod_acompanhamento) REFERENCES int_acompanhamento(Cod),
  CONSTRAINT fk_medicao_tipo  FOREIGN KEY (idTipoMedicao)      REFERENCES int_tipo_medicao(idTipoMedicao)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS int_execucao_indireta_contrato (
  Cod                                 INT AUTO_INCREMENT PRIMARY KEY,
  Cod_medicao                         INT NOT NULL,
  Cod_planilha_exec_indireta_contrato INT NOT NULL,
  UNIQUE KEY uk_int_exec_ind_contrato (Cod_medicao),
  CONSTRAINT fk_execc_medicao  FOREIGN KEY (Cod_medicao)                         REFERENCES int_medicao(Cod),
  CONSTRAINT fk_execc_planilha FOREIGN KEY (Cod_planilha_exec_indireta_contrato) REFERENCES int_planilha_exec_indireta_contrato(Cod)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS int_execucao_indireta_aditivo (
  Cod                                INT AUTO_INCREMENT PRIMARY KEY,
  Cod_medicao                        INT NOT NULL,
  Cod_planilha_exec_indireta_aditivo INT NOT NULL,
  UNIQUE KEY uk_int_exec_ind_aditivo (Cod_medicao),
  CONSTRAINT fk_execa_medicao  FOREIGN KEY (Cod_medicao)                        REFERENCES int_medicao(Cod),
  CONSTRAINT fk_execa_planilha FOREIGN KEY (Cod_planilha_exec_indireta_aditivo) REFERENCES int_planilha_exec_indireta_aditivo(Cod)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS int_paralisacao (
  Cod                 INT AUTO_INCREMENT PRIMARY KEY,
  Cod_acompanhamento  INT              NOT NULL,
  idMotivoParalisacao TINYINT UNSIGNED NOT NULL,
  UNIQUE KEY uk_int_paralisacao (Cod_acompanhamento),
  CONSTRAINT fk_paralisacao_acomp  FOREIGN KEY (Cod_acompanhamento)  REFERENCES int_acompanhamento(Cod),
  CONSTRAINT fk_paralisacao_motivo FOREIGN KEY (idMotivoParalisacao) REFERENCES int_motivo_paralisacao(idMotivoParalisacao)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS int_documento_acompanhamento (
  Cod                INT AUTO_INCREMENT PRIMARY KEY,
  Cod_acompanhamento INT NOT NULL,
  Cod_leiato         INT NOT NULL,
  UNIQUE KEY uk_int_doc_acomp (Cod_acompanhamento, Cod_leiato),
  CONSTRAINT fk_docacomp_acomp  FOREIGN KEY (Cod_acompanhamento) REFERENCES int_acompanhamento(Cod),
  CONSTRAINT fk_docacomp_leiato FOREIGN KEY (Cod_leiato)         REFERENCES int_leiato(Cod)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --- Sementes dos lookups (idempotentes) ------------------------------

INSERT INTO int_origem_acompanhamento (idOrigemAcompanhamento, dsOrigemAcompanhamento)
SELECT 1, 'Jurisdicionado' WHERE NOT EXISTS (SELECT 1 FROM int_origem_acompanhamento WHERE idOrigemAcompanhamento = 1);
INSERT INTO int_origem_acompanhamento (idOrigemAcompanhamento, dsOrigemAcompanhamento)
SELECT 2, 'TCE-PR' WHERE NOT EXISTS (SELECT 1 FROM int_origem_acompanhamento WHERE idOrigemAcompanhamento = 2);
INSERT INTO int_origem_acompanhamento (idOrigemAcompanhamento, dsOrigemAcompanhamento)
SELECT 3, 'CREA-PR' WHERE NOT EXISTS (SELECT 1 FROM int_origem_acompanhamento WHERE idOrigemAcompanhamento = 3);

INSERT INTO int_tipo_acompanhamento (idTipoAcompanhamento, dsTipoAcompanhamento)
SELECT 1, 'Medição' WHERE NOT EXISTS (SELECT 1 FROM int_tipo_acompanhamento WHERE idTipoAcompanhamento = 1);
INSERT INTO int_tipo_acompanhamento (idTipoAcompanhamento, dsTipoAcompanhamento)
SELECT 2, 'Paralisação' WHERE NOT EXISTS (SELECT 1 FROM int_tipo_acompanhamento WHERE idTipoAcompanhamento = 2);
INSERT INTO int_tipo_acompanhamento (idTipoAcompanhamento, dsTipoAcompanhamento)
SELECT 3, 'Conclusão' WHERE NOT EXISTS (SELECT 1 FROM int_tipo_acompanhamento WHERE idTipoAcompanhamento = 3);
INSERT INTO int_tipo_acompanhamento (idTipoAcompanhamento, dsTipoAcompanhamento)
SELECT 4, 'Cancelamento de Intervenção' WHERE NOT EXISTS (SELECT 1 FROM int_tipo_acompanhamento WHERE idTipoAcompanhamento = 4);
INSERT INTO int_tipo_acompanhamento (idTipoAcompanhamento, dsTipoAcompanhamento)
SELECT 5, 'Cadastro indevido' WHERE NOT EXISTS (SELECT 1 FROM int_tipo_acompanhamento WHERE idTipoAcompanhamento = 5);

INSERT INTO int_tipo_medicao (idTipoMedicao, dsTipoMedicao)
SELECT 1, 'Execução Indireta - Contrato' WHERE NOT EXISTS (SELECT 1 FROM int_tipo_medicao WHERE idTipoMedicao = 1);
INSERT INTO int_tipo_medicao (idTipoMedicao, dsTipoMedicao)
SELECT 2, 'Execução Indireta - Aditivo' WHERE NOT EXISTS (SELECT 1 FROM int_tipo_medicao WHERE idTipoMedicao = 2);
INSERT INTO int_tipo_medicao (idTipoMedicao, dsTipoMedicao)
SELECT 3, 'Execução Direta' WHERE NOT EXISTS (SELECT 1 FROM int_tipo_medicao WHERE idTipoMedicao = 3);

INSERT INTO int_motivo_paralisacao (idMotivoParalisacao, dsMotivoParalisacao)
SELECT 1, 'Falta de recurso próprio' WHERE NOT EXISTS (SELECT 1 FROM int_motivo_paralisacao WHERE idMotivoParalisacao = 1);
INSERT INTO int_motivo_paralisacao (idMotivoParalisacao, dsMotivoParalisacao)
SELECT 2, 'Ausência/Atraso na liberação de recursos do convênio' WHERE NOT EXISTS (SELECT 1 FROM int_motivo_paralisacao WHERE idMotivoParalisacao = 2);
INSERT INTO int_motivo_paralisacao (idMotivoParalisacao, dsMotivoParalisacao)
SELECT 3, 'Valor orçado insuficiente para conclusão da obra' WHERE NOT EXISTS (SELECT 1 FROM int_motivo_paralisacao WHERE idMotivoParalisacao = 3);
INSERT INTO int_motivo_paralisacao (idMotivoParalisacao, dsMotivoParalisacao)
SELECT 4, 'Alteração de projeto/Serviços necessários à conclusão da obra não foram previstos' WHERE NOT EXISTS (SELECT 1 FROM int_motivo_paralisacao WHERE idMotivoParalisacao = 4);
INSERT INTO int_motivo_paralisacao (idMotivoParalisacao, dsMotivoParalisacao)
SELECT 5, 'Descumprimento de obrigações contratuais pela empresa contratada' WHERE NOT EXISTS (SELECT 1 FROM int_motivo_paralisacao WHERE idMotivoParalisacao = 5);
INSERT INTO int_motivo_paralisacao (idMotivoParalisacao, dsMotivoParalisacao)
SELECT 6, 'Ação judicial' WHERE NOT EXISTS (SELECT 1 FROM int_motivo_paralisacao WHERE idMotivoParalisacao = 6);
INSERT INTO int_motivo_paralisacao (idMotivoParalisacao, dsMotivoParalisacao)
SELECT 7, 'Não atendimento a exigências legais (Ex. ambientais, pendências em relação à regularidade do terreno, etc.)' WHERE NOT EXISTS (SELECT 1 FROM int_motivo_paralisacao WHERE idMotivoParalisacao = 7);
INSERT INTO int_motivo_paralisacao (idMotivoParalisacao, dsMotivoParalisacao)
SELECT 8, 'Obra incompatível com interesses do município' WHERE NOT EXISTS (SELECT 1 FROM int_motivo_paralisacao WHERE idMotivoParalisacao = 8);
