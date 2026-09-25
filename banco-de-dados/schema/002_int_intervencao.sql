-- =====================================================================
-- SGI - Sub-projeto 1: cadastro de intervencoes (obras)
-- Base: adtovb. Prefixo int_.
-- Idempotente: CREATE TABLE IF NOT EXISTS + semeadura condicional.
-- Rodar duas vezes seguidas nao pode falhar nem duplicar.
--
-- Nomes de coluna sao os do leiaute SIM-AM/TCE-PR (idTipoIntervencao,
-- dsTipoIntervencao, ...) para o gerador do arquivo (Sub-projeto 6) nao
-- precisar de um mapa de-para.
-- =====================================================================

CREATE TABLE IF NOT EXISTS int_tipo_intervencao (
  idTipoIntervencao TINYINT UNSIGNED PRIMARY KEY,
  dsTipoIntervencao VARCHAR(60) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS int_classificacao_intervencao (
  idClassificacaoIntervencao TINYINT UNSIGNED PRIMARY KEY,
  dsClassificacaoIntervencao VARCHAR(60) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS int_tipo_obra (
  idTipoObra TINYINT UNSIGNED PRIMARY KEY,
  dsTipoObra VARCHAR(60) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS int_classificacao_obra (
  idClassificacaoObra TINYINT UNSIGNED PRIMARY KEY,
  dsClassificacaoObra VARCHAR(60) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS int_tipo_x_classificacao_obra (
  idTipoObra          TINYINT UNSIGNED NOT NULL,
  idClassificacaoObra TINYINT UNSIGNED NOT NULL,
  PRIMARY KEY (idTipoObra, idClassificacaoObra),
  CONSTRAINT fk_txc_tipo    FOREIGN KEY (idTipoObra)          REFERENCES int_tipo_obra(idTipoObra),
  CONSTRAINT fk_txc_classif FOREIGN KEY (idClassificacaoObra) REFERENCES int_classificacao_obra(idClassificacaoObra)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS int_tipo_regime_intervencao (
  idTipoRegimeIntervencao TINYINT UNSIGNED PRIMARY KEY,
  dsTipoRegimeIntervencao VARCHAR(60) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS int_unidade_medida_intervencao (
  idUnidadeMedidaIntervencao TINYINT UNSIGNED PRIMARY KEY,
  dsUnidadeMedidaIntervencao VARCHAR(60) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Linha unica: idPessoa da Camara no cadastro interno do TCE-PR.
-- Nasce vazia; a tela de Dados da Entidade faz upsert em idEntidade = 1.
CREATE TABLE IF NOT EXISTS int_entidade (
  idEntidade       TINYINT UNSIGNED PRIMARY KEY,
  idPessoa         INT UNSIGNED NOT NULL,
  Data_Atualizacao DATETIME NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS int_intervencao (
  Cod                        INT AUTO_INCREMENT PRIMARY KEY,
  idPessoa                   INT UNSIGNED      NOT NULL,
  cdIntervencao              INT UNSIGNED      NOT NULL,
  nrAnoIntervencao           SMALLINT UNSIGNED NOT NULL,
  idTipoIntervencao          TINYINT UNSIGNED  NOT NULL,
  idClassificacaoIntervencao TINYINT UNSIGNED  NOT NULL,
  nmIntervencao              VARCHAR(100)      NOT NULL,
  idTipoObra                 TINYINT UNSIGNED  NOT NULL,
  idClassificacaoObra        TINYINT UNSIGNED  NOT NULL,
  dsObjeto                   VARCHAR(800)      NOT NULL,
  nrMedida                   DECIMAL(8,2)      NOT NULL,
  idUnidadeMedidaIntervencao TINYINT UNSIGNED  NOT NULL,
  vlIntervencao              DECIMAL(16,2)     NOT NULL,
  dtBaseValorIntervencao     DATE              NOT NULL,
  nrPrazoExecucao            SMALLINT UNSIGNED NOT NULL,
  dtInicio                   DATE              NOT NULL,
  idTipoRegimeIntervencao    TINYINT UNSIGNED  NOT NULL,
  UNIQUE KEY uk_int_intervencao_chave (idPessoa, nrAnoIntervencao, cdIntervencao),
  KEY idx_int_intervencao_ano (nrAnoIntervencao),
  CONSTRAINT fk_int_tipo    FOREIGN KEY (idTipoIntervencao)          REFERENCES int_tipo_intervencao(idTipoIntervencao),
  CONSTRAINT fk_int_classif FOREIGN KEY (idClassificacaoIntervencao) REFERENCES int_classificacao_intervencao(idClassificacaoIntervencao),
  CONSTRAINT fk_int_tobra   FOREIGN KEY (idTipoObra)                 REFERENCES int_tipo_obra(idTipoObra),
  CONSTRAINT fk_int_cobra   FOREIGN KEY (idClassificacaoObra)        REFERENCES int_classificacao_obra(idClassificacaoObra),
  CONSTRAINT fk_int_txc     FOREIGN KEY (idTipoObra, idClassificacaoObra)
                            REFERENCES int_tipo_x_classificacao_obra(idTipoObra, idClassificacaoObra),
  CONSTRAINT fk_int_unidade FOREIGN KEY (idUnidadeMedidaIntervencao) REFERENCES int_unidade_medida_intervencao(idUnidadeMedidaIntervencao),
  CONSTRAINT fk_int_regime  FOREIGN KEY (idTipoRegimeIntervencao)    REFERENCES int_tipo_regime_intervencao(idTipoRegimeIntervencao)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- Semeadura. Uma instrucao por valor: INSERT ... SELECT <v> WHERE NOT
-- EXISTS (... WHERE <pk> = <v>). Repetivel, nao duplica, e a guarda e
-- por valor - acrescentar uma linha nova depois insere so a que falta,
-- em vez de nao inserir nada porque a tabela ja tem conteudo.
-- ---------------------------------------------------------------------

INSERT INTO int_tipo_intervencao (idTipoIntervencao, dsTipoIntervencao) SELECT 1, 'Execução de Obra' WHERE NOT EXISTS (SELECT 1 FROM int_tipo_intervencao WHERE idTipoIntervencao = 1);
INSERT INTO int_tipo_intervencao (idTipoIntervencao, dsTipoIntervencao) SELECT 2, 'Projeto' WHERE NOT EXISTS (SELECT 1 FROM int_tipo_intervencao WHERE idTipoIntervencao = 2);
INSERT INTO int_tipo_intervencao (idTipoIntervencao, dsTipoIntervencao) SELECT 3, 'Outras Atividades Técnicas' WHERE NOT EXISTS (SELECT 1 FROM int_tipo_intervencao WHERE idTipoIntervencao = 3);

INSERT INTO int_classificacao_intervencao (idClassificacaoIntervencao, dsClassificacaoIntervencao) SELECT 1, 'Construção' WHERE NOT EXISTS (SELECT 1 FROM int_classificacao_intervencao WHERE idClassificacaoIntervencao = 1);
INSERT INTO int_classificacao_intervencao (idClassificacaoIntervencao, dsClassificacaoIntervencao) SELECT 2, 'Ampliação' WHERE NOT EXISTS (SELECT 1 FROM int_classificacao_intervencao WHERE idClassificacaoIntervencao = 2);
INSERT INTO int_classificacao_intervencao (idClassificacaoIntervencao, dsClassificacaoIntervencao) SELECT 3, 'Reforma' WHERE NOT EXISTS (SELECT 1 FROM int_classificacao_intervencao WHERE idClassificacaoIntervencao = 3);
INSERT INTO int_classificacao_intervencao (idClassificacaoIntervencao, dsClassificacaoIntervencao) SELECT 4, 'Outro' WHERE NOT EXISTS (SELECT 1 FROM int_classificacao_intervencao WHERE idClassificacaoIntervencao = 4);

INSERT INTO int_tipo_obra (idTipoObra, dsTipoObra) SELECT 1, 'Edificação' WHERE NOT EXISTS (SELECT 1 FROM int_tipo_obra WHERE idTipoObra = 1);
INSERT INTO int_tipo_obra (idTipoObra, dsTipoObra) SELECT 2, 'Pavimentação' WHERE NOT EXISTS (SELECT 1 FROM int_tipo_obra WHERE idTipoObra = 2);
INSERT INTO int_tipo_obra (idTipoObra, dsTipoObra) SELECT 3, 'Saneamento' WHERE NOT EXISTS (SELECT 1 FROM int_tipo_obra WHERE idTipoObra = 3);
INSERT INTO int_tipo_obra (idTipoObra, dsTipoObra) SELECT 4, 'Parque ou praça' WHERE NOT EXISTS (SELECT 1 FROM int_tipo_obra WHERE idTipoObra = 4);
INSERT INTO int_tipo_obra (idTipoObra, dsTipoObra) SELECT 5, 'Equipamento Urbano' WHERE NOT EXISTS (SELECT 1 FROM int_tipo_obra WHERE idTipoObra = 5);
INSERT INTO int_tipo_obra (idTipoObra, dsTipoObra) SELECT 6, 'Iluminação Pública' WHERE NOT EXISTS (SELECT 1 FROM int_tipo_obra WHERE idTipoObra = 6);

INSERT INTO int_classificacao_obra (idClassificacaoObra, dsClassificacaoObra) SELECT 1, 'Abatedouro' WHERE NOT EXISTS (SELECT 1 FROM int_classificacao_obra WHERE idClassificacaoObra = 1);
INSERT INTO int_classificacao_obra (idClassificacaoObra, dsClassificacaoObra) SELECT 2, 'Barracão' WHERE NOT EXISTS (SELECT 1 FROM int_classificacao_obra WHERE idClassificacaoObra = 2);
INSERT INTO int_classificacao_obra (idClassificacaoObra, dsClassificacaoObra) SELECT 3, 'Creche' WHERE NOT EXISTS (SELECT 1 FROM int_classificacao_obra WHERE idClassificacaoObra = 3);
INSERT INTO int_classificacao_obra (idClassificacaoObra, dsClassificacaoObra) SELECT 4, 'Edifício Administrativo' WHERE NOT EXISTS (SELECT 1 FROM int_classificacao_obra WHERE idClassificacaoObra = 4);
INSERT INTO int_classificacao_obra (idClassificacaoObra, dsClassificacaoObra) SELECT 5, 'Escola/Colégio' WHERE NOT EXISTS (SELECT 1 FROM int_classificacao_obra WHERE idClassificacaoObra = 5);
INSERT INTO int_classificacao_obra (idClassificacaoObra, dsClassificacaoObra) SELECT 6, 'Hospital' WHERE NOT EXISTS (SELECT 1 FROM int_classificacao_obra WHERE idClassificacaoObra = 6);
INSERT INTO int_classificacao_obra (idClassificacaoObra, dsClassificacaoObra) SELECT 7, 'Posto de Saúde' WHERE NOT EXISTS (SELECT 1 FROM int_classificacao_obra WHERE idClassificacaoObra = 7);
INSERT INTO int_classificacao_obra (idClassificacaoObra, dsClassificacaoObra) SELECT 8, 'Unidade Habitacional' WHERE NOT EXISTS (SELECT 1 FROM int_classificacao_obra WHERE idClassificacaoObra = 8);
INSERT INTO int_classificacao_obra (idClassificacaoObra, dsClassificacaoObra) SELECT 9, 'Outros Edifícios' WHERE NOT EXISTS (SELECT 1 FROM int_classificacao_obra WHERE idClassificacaoObra = 9);
INSERT INTO int_classificacao_obra (idClassificacaoObra, dsClassificacaoObra) SELECT 10, 'Malha Viária Urbana' WHERE NOT EXISTS (SELECT 1 FROM int_classificacao_obra WHERE idClassificacaoObra = 10);
INSERT INTO int_classificacao_obra (idClassificacaoObra, dsClassificacaoObra) SELECT 11, 'Estrada Municipal' WHERE NOT EXISTS (SELECT 1 FROM int_classificacao_obra WHERE idClassificacaoObra = 11);
INSERT INTO int_classificacao_obra (idClassificacaoObra, dsClassificacaoObra) SELECT 12, 'Estrada Rural' WHERE NOT EXISTS (SELECT 1 FROM int_classificacao_obra WHERE idClassificacaoObra = 12);
INSERT INTO int_classificacao_obra (idClassificacaoObra, dsClassificacaoObra) SELECT 13, 'Obra de Arte Especial' WHERE NOT EXISTS (SELECT 1 FROM int_classificacao_obra WHERE idClassificacaoObra = 13);
INSERT INTO int_classificacao_obra (idClassificacaoObra, dsClassificacaoObra) SELECT 14, 'Abastecimento de Água' WHERE NOT EXISTS (SELECT 1 FROM int_classificacao_obra WHERE idClassificacaoObra = 14);
INSERT INTO int_classificacao_obra (idClassificacaoObra, dsClassificacaoObra) SELECT 15, 'Aterro Sanitário' WHERE NOT EXISTS (SELECT 1 FROM int_classificacao_obra WHERE idClassificacaoObra = 15);
INSERT INTO int_classificacao_obra (idClassificacaoObra, dsClassificacaoObra) SELECT 16, 'Canalização de Rio' WHERE NOT EXISTS (SELECT 1 FROM int_classificacao_obra WHERE idClassificacaoObra = 16);
INSERT INTO int_classificacao_obra (idClassificacaoObra, dsClassificacaoObra) SELECT 17, 'Cemitério' WHERE NOT EXISTS (SELECT 1 FROM int_classificacao_obra WHERE idClassificacaoObra = 17);
INSERT INTO int_classificacao_obra (idClassificacaoObra, dsClassificacaoObra) SELECT 18, 'Dragagem' WHERE NOT EXISTS (SELECT 1 FROM int_classificacao_obra WHERE idClassificacaoObra = 18);
INSERT INTO int_classificacao_obra (idClassificacaoObra, dsClassificacaoObra) SELECT 19, 'Esgoto' WHERE NOT EXISTS (SELECT 1 FROM int_classificacao_obra WHERE idClassificacaoObra = 19);
INSERT INTO int_classificacao_obra (idClassificacaoObra, dsClassificacaoObra) SELECT 20, 'Fundo de Vale' WHERE NOT EXISTS (SELECT 1 FROM int_classificacao_obra WHERE idClassificacaoObra = 20);
INSERT INTO int_classificacao_obra (idClassificacaoObra, dsClassificacaoObra) SELECT 21, 'Galeria Pluvial' WHERE NOT EXISTS (SELECT 1 FROM int_classificacao_obra WHERE idClassificacaoObra = 21);
INSERT INTO int_classificacao_obra (idClassificacaoObra, dsClassificacaoObra) SELECT 22, 'Outras Obras de Saneamento' WHERE NOT EXISTS (SELECT 1 FROM int_classificacao_obra WHERE idClassificacaoObra = 22);
INSERT INTO int_classificacao_obra (idClassificacaoObra, dsClassificacaoObra) SELECT 23, 'Parque ou Praça' WHERE NOT EXISTS (SELECT 1 FROM int_classificacao_obra WHERE idClassificacaoObra = 23);
INSERT INTO int_classificacao_obra (idClassificacaoObra, dsClassificacaoObra) SELECT 24, 'Abrigo de ônibus' WHERE NOT EXISTS (SELECT 1 FROM int_classificacao_obra WHERE idClassificacaoObra = 24);
INSERT INTO int_classificacao_obra (idClassificacaoObra, dsClassificacaoObra) SELECT 25, 'Outros Equipamentos Urbanos' WHERE NOT EXISTS (SELECT 1 FROM int_classificacao_obra WHERE idClassificacaoObra = 25);
INSERT INTO int_classificacao_obra (idClassificacaoObra, dsClassificacaoObra) SELECT 26, 'Iluminação Pública' WHERE NOT EXISTS (SELECT 1 FROM int_classificacao_obra WHERE idClassificacaoObra = 26);

INSERT INTO int_tipo_x_classificacao_obra (idTipoObra, idClassificacaoObra) SELECT 1, 1 WHERE NOT EXISTS (SELECT 1 FROM int_tipo_x_classificacao_obra WHERE idTipoObra = 1 AND idClassificacaoObra = 1);
INSERT INTO int_tipo_x_classificacao_obra (idTipoObra, idClassificacaoObra) SELECT 1, 2 WHERE NOT EXISTS (SELECT 1 FROM int_tipo_x_classificacao_obra WHERE idTipoObra = 1 AND idClassificacaoObra = 2);
INSERT INTO int_tipo_x_classificacao_obra (idTipoObra, idClassificacaoObra) SELECT 1, 3 WHERE NOT EXISTS (SELECT 1 FROM int_tipo_x_classificacao_obra WHERE idTipoObra = 1 AND idClassificacaoObra = 3);
INSERT INTO int_tipo_x_classificacao_obra (idTipoObra, idClassificacaoObra) SELECT 1, 4 WHERE NOT EXISTS (SELECT 1 FROM int_tipo_x_classificacao_obra WHERE idTipoObra = 1 AND idClassificacaoObra = 4);
INSERT INTO int_tipo_x_classificacao_obra (idTipoObra, idClassificacaoObra) SELECT 1, 5 WHERE NOT EXISTS (SELECT 1 FROM int_tipo_x_classificacao_obra WHERE idTipoObra = 1 AND idClassificacaoObra = 5);
INSERT INTO int_tipo_x_classificacao_obra (idTipoObra, idClassificacaoObra) SELECT 1, 6 WHERE NOT EXISTS (SELECT 1 FROM int_tipo_x_classificacao_obra WHERE idTipoObra = 1 AND idClassificacaoObra = 6);
INSERT INTO int_tipo_x_classificacao_obra (idTipoObra, idClassificacaoObra) SELECT 1, 7 WHERE NOT EXISTS (SELECT 1 FROM int_tipo_x_classificacao_obra WHERE idTipoObra = 1 AND idClassificacaoObra = 7);
INSERT INTO int_tipo_x_classificacao_obra (idTipoObra, idClassificacaoObra) SELECT 1, 8 WHERE NOT EXISTS (SELECT 1 FROM int_tipo_x_classificacao_obra WHERE idTipoObra = 1 AND idClassificacaoObra = 8);
INSERT INTO int_tipo_x_classificacao_obra (idTipoObra, idClassificacaoObra) SELECT 1, 9 WHERE NOT EXISTS (SELECT 1 FROM int_tipo_x_classificacao_obra WHERE idTipoObra = 1 AND idClassificacaoObra = 9);
INSERT INTO int_tipo_x_classificacao_obra (idTipoObra, idClassificacaoObra) SELECT 2, 10 WHERE NOT EXISTS (SELECT 1 FROM int_tipo_x_classificacao_obra WHERE idTipoObra = 2 AND idClassificacaoObra = 10);
INSERT INTO int_tipo_x_classificacao_obra (idTipoObra, idClassificacaoObra) SELECT 2, 11 WHERE NOT EXISTS (SELECT 1 FROM int_tipo_x_classificacao_obra WHERE idTipoObra = 2 AND idClassificacaoObra = 11);
INSERT INTO int_tipo_x_classificacao_obra (idTipoObra, idClassificacaoObra) SELECT 2, 12 WHERE NOT EXISTS (SELECT 1 FROM int_tipo_x_classificacao_obra WHERE idTipoObra = 2 AND idClassificacaoObra = 12);
INSERT INTO int_tipo_x_classificacao_obra (idTipoObra, idClassificacaoObra) SELECT 2, 13 WHERE NOT EXISTS (SELECT 1 FROM int_tipo_x_classificacao_obra WHERE idTipoObra = 2 AND idClassificacaoObra = 13);
INSERT INTO int_tipo_x_classificacao_obra (idTipoObra, idClassificacaoObra) SELECT 3, 14 WHERE NOT EXISTS (SELECT 1 FROM int_tipo_x_classificacao_obra WHERE idTipoObra = 3 AND idClassificacaoObra = 14);
INSERT INTO int_tipo_x_classificacao_obra (idTipoObra, idClassificacaoObra) SELECT 3, 15 WHERE NOT EXISTS (SELECT 1 FROM int_tipo_x_classificacao_obra WHERE idTipoObra = 3 AND idClassificacaoObra = 15);
INSERT INTO int_tipo_x_classificacao_obra (idTipoObra, idClassificacaoObra) SELECT 3, 16 WHERE NOT EXISTS (SELECT 1 FROM int_tipo_x_classificacao_obra WHERE idTipoObra = 3 AND idClassificacaoObra = 16);
INSERT INTO int_tipo_x_classificacao_obra (idTipoObra, idClassificacaoObra) SELECT 3, 17 WHERE NOT EXISTS (SELECT 1 FROM int_tipo_x_classificacao_obra WHERE idTipoObra = 3 AND idClassificacaoObra = 17);
INSERT INTO int_tipo_x_classificacao_obra (idTipoObra, idClassificacaoObra) SELECT 3, 18 WHERE NOT EXISTS (SELECT 1 FROM int_tipo_x_classificacao_obra WHERE idTipoObra = 3 AND idClassificacaoObra = 18);
INSERT INTO int_tipo_x_classificacao_obra (idTipoObra, idClassificacaoObra) SELECT 3, 19 WHERE NOT EXISTS (SELECT 1 FROM int_tipo_x_classificacao_obra WHERE idTipoObra = 3 AND idClassificacaoObra = 19);
INSERT INTO int_tipo_x_classificacao_obra (idTipoObra, idClassificacaoObra) SELECT 3, 20 WHERE NOT EXISTS (SELECT 1 FROM int_tipo_x_classificacao_obra WHERE idTipoObra = 3 AND idClassificacaoObra = 20);
INSERT INTO int_tipo_x_classificacao_obra (idTipoObra, idClassificacaoObra) SELECT 3, 21 WHERE NOT EXISTS (SELECT 1 FROM int_tipo_x_classificacao_obra WHERE idTipoObra = 3 AND idClassificacaoObra = 21);
INSERT INTO int_tipo_x_classificacao_obra (idTipoObra, idClassificacaoObra) SELECT 3, 22 WHERE NOT EXISTS (SELECT 1 FROM int_tipo_x_classificacao_obra WHERE idTipoObra = 3 AND idClassificacaoObra = 22);
INSERT INTO int_tipo_x_classificacao_obra (idTipoObra, idClassificacaoObra) SELECT 4, 23 WHERE NOT EXISTS (SELECT 1 FROM int_tipo_x_classificacao_obra WHERE idTipoObra = 4 AND idClassificacaoObra = 23);
INSERT INTO int_tipo_x_classificacao_obra (idTipoObra, idClassificacaoObra) SELECT 5, 24 WHERE NOT EXISTS (SELECT 1 FROM int_tipo_x_classificacao_obra WHERE idTipoObra = 5 AND idClassificacaoObra = 24);
INSERT INTO int_tipo_x_classificacao_obra (idTipoObra, idClassificacaoObra) SELECT 5, 25 WHERE NOT EXISTS (SELECT 1 FROM int_tipo_x_classificacao_obra WHERE idTipoObra = 5 AND idClassificacaoObra = 25);
INSERT INTO int_tipo_x_classificacao_obra (idTipoObra, idClassificacaoObra) SELECT 6, 26 WHERE NOT EXISTS (SELECT 1 FROM int_tipo_x_classificacao_obra WHERE idTipoObra = 6 AND idClassificacaoObra = 26);

INSERT INTO int_tipo_regime_intervencao (idTipoRegimeIntervencao, dsTipoRegimeIntervencao) SELECT 1, 'Direto' WHERE NOT EXISTS (SELECT 1 FROM int_tipo_regime_intervencao WHERE idTipoRegimeIntervencao = 1);
INSERT INTO int_tipo_regime_intervencao (idTipoRegimeIntervencao, dsTipoRegimeIntervencao) SELECT 2, 'Indireto' WHERE NOT EXISTS (SELECT 1 FROM int_tipo_regime_intervencao WHERE idTipoRegimeIntervencao = 2);
INSERT INTO int_tipo_regime_intervencao (idTipoRegimeIntervencao, dsTipoRegimeIntervencao) SELECT 3, 'Misto (direto + indireto)' WHERE NOT EXISTS (SELECT 1 FROM int_tipo_regime_intervencao WHERE idTipoRegimeIntervencao = 3);

INSERT INTO int_unidade_medida_intervencao (idUnidadeMedidaIntervencao, dsUnidadeMedidaIntervencao) SELECT 1, 'Hora' WHERE NOT EXISTS (SELECT 1 FROM int_unidade_medida_intervencao WHERE idUnidadeMedidaIntervencao = 1);
INSERT INTO int_unidade_medida_intervencao (idUnidadeMedidaIntervencao, dsUnidadeMedidaIntervencao) SELECT 2, 'Hectare' WHERE NOT EXISTS (SELECT 1 FROM int_unidade_medida_intervencao WHERE idUnidadeMedidaIntervencao = 2);
INSERT INTO int_unidade_medida_intervencao (idUnidadeMedidaIntervencao, dsUnidadeMedidaIntervencao) SELECT 3, 'Quilograma' WHERE NOT EXISTS (SELECT 1 FROM int_unidade_medida_intervencao WHERE idUnidadeMedidaIntervencao = 3);
INSERT INTO int_unidade_medida_intervencao (idUnidadeMedidaIntervencao, dsUnidadeMedidaIntervencao) SELECT 4, 'Quilômetro' WHERE NOT EXISTS (SELECT 1 FROM int_unidade_medida_intervencao WHERE idUnidadeMedidaIntervencao = 4);
INSERT INTO int_unidade_medida_intervencao (idUnidadeMedidaIntervencao, dsUnidadeMedidaIntervencao) SELECT 5, 'Metro' WHERE NOT EXISTS (SELECT 1 FROM int_unidade_medida_intervencao WHERE idUnidadeMedidaIntervencao = 5);
INSERT INTO int_unidade_medida_intervencao (idUnidadeMedidaIntervencao, dsUnidadeMedidaIntervencao) SELECT 6, 'Metro quadrado' WHERE NOT EXISTS (SELECT 1 FROM int_unidade_medida_intervencao WHERE idUnidadeMedidaIntervencao = 6);
INSERT INTO int_unidade_medida_intervencao (idUnidadeMedidaIntervencao, dsUnidadeMedidaIntervencao) SELECT 7, 'Metro cúbico' WHERE NOT EXISTS (SELECT 1 FROM int_unidade_medida_intervencao WHERE idUnidadeMedidaIntervencao = 7);
INSERT INTO int_unidade_medida_intervencao (idUnidadeMedidaIntervencao, dsUnidadeMedidaIntervencao) SELECT 8, 'Tonelada' WHERE NOT EXISTS (SELECT 1 FROM int_unidade_medida_intervencao WHERE idUnidadeMedidaIntervencao = 8);
