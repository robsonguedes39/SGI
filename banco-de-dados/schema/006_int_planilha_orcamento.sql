-- =====================================================================
-- SGI - Planilha de Orcamento (cabecalho da tabela PlanilhaOrcamento do
-- SIM-AM Obras, p. 811-813). Base: adtovb. Prefixo int_.
-- Idempotente: CREATE TABLE IF NOT EXISTS + semeadura condicional.
--
-- Guarda so o cabecalho - o leiaute nao coleta os itens da planilha.
-- Chave 1561: (Cod_intervencao, Cod_pessoa, Cod_leiato) - idPessoa e a
-- entidade, tpDocumento e sempre 2 (CPF, regra 1562), nrDocumento vem de
-- Cod_pessoa, cdControleLeiAto vem de Cod_leiato.
-- =====================================================================

CREATE TABLE IF NOT EXISTS int_tipo_planilha_orcamento (
  idTipoPlanilhaOrcamento TINYINT UNSIGNED PRIMARY KEY,
  dsTipoPlanilhaOrcamento VARCHAR(90) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO int_tipo_planilha_orcamento (idTipoPlanilhaOrcamento, dsTipoPlanilhaOrcamento) SELECT 1,'Base (Orçamento de Execução Direta ou Orçamento da Licitação)'               WHERE NOT EXISTS (SELECT 1 FROM int_tipo_planilha_orcamento WHERE idTipoPlanilhaOrcamento=1);
INSERT INTO int_tipo_planilha_orcamento (idTipoPlanilhaOrcamento, dsTipoPlanilhaOrcamento) SELECT 2,'Contrato (Planilha da Proposta Contratada)'                                  WHERE NOT EXISTS (SELECT 1 FROM int_tipo_planilha_orcamento WHERE idTipoPlanilhaOrcamento=2);
INSERT INTO int_tipo_planilha_orcamento (idTipoPlanilhaOrcamento, dsTipoPlanilhaOrcamento) SELECT 3,'Aditivo (Planilha da Proposta Contratada Alterada ou Planilha do Aditivo)'    WHERE NOT EXISTS (SELECT 1 FROM int_tipo_planilha_orcamento WHERE idTipoPlanilhaOrcamento=3);

CREATE TABLE IF NOT EXISTS int_planilha_orcamento (
  Cod                     INT AUTO_INCREMENT PRIMARY KEY,
  Cod_intervencao         INT              NOT NULL,
  Cod_pessoa              INT              NOT NULL,
  Cod_leiato              INT              NOT NULL,
  idTipoPlanilhaOrcamento TINYINT UNSIGNED NOT NULL,
  vlTotal                 DECIMAL(16,2)    NOT NULL,
  dtBase                  DATE             NOT NULL,
  UNIQUE KEY uk_int_planilha_orcamento (Cod_intervencao, Cod_pessoa, Cod_leiato),
  KEY idx_int_planilha_orcamento (Cod_intervencao),
  CONSTRAINT fk_plorc_intervencao FOREIGN KEY (Cod_intervencao)         REFERENCES int_intervencao(Cod),
  CONSTRAINT fk_plorc_pessoa      FOREIGN KEY (Cod_pessoa)              REFERENCES int_pessoa(Cod),
  CONSTRAINT fk_plorc_leiato      FOREIGN KEY (Cod_leiato)              REFERENCES int_leiato(Cod),
  CONSTRAINT fk_plorc_tipo        FOREIGN KEY (idTipoPlanilhaOrcamento) REFERENCES int_tipo_planilha_orcamento(idTipoPlanilhaOrcamento)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
