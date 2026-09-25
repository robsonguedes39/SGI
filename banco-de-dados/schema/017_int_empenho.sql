-- =====================================================================
-- SGI - Empenho x Intervencao (vinculo da obra com os empenhos)
-- Base: adtovb. Prefixo int_. Idempotente: CREATE TABLE IF NOT EXISTS.
-- Rodar duas vezes seguidas nao pode falhar. Sem semeadura.
-- Rodar depois da 002 (int_intervencao).
--
-- SIM-AM Obras, tabela EmpenhoXIntervencao (TCE OBRAS.pdf, p. 836-838).
-- So o vinculo: numero/ano do empenho + intervencao. Sem valor.
-- O empenho NAO e obrigatorio no SGI - a vinculacao pode vir do sistema
-- de contabilidade. dtEmpenho define a competencia em que a linha entra
-- na remessa (periodicidade mensal do TCE); nrAnoEmpenho e derivado dela
-- por coluna gerada, para a UK bater com a chave da regra 661.
--
-- idOrigemEmpenho = 0 significa "a propria entidade": o gerador SIM-AM
-- troca 0 pelo idPessoa de int_intervencao. Valor != 0 so quando o
-- registro decorre de cisao, fusao, incorporacao ou extincao. NOT NULL
-- DEFAULT 0 (e nao NULL) para a UK nao deixar passar duplicata - o
-- MariaDB trata NULL como distinto em indice unico.
--
-- Regra 661 (unicidade do conjunto), 662 (o empenho existe na tabela
-- Empenho da contabilidade) e 664 (a intervencao existe) sao conferidas
-- pelo TCE na importacao, nao aqui. Exclusao livre.
-- =====================================================================

CREATE TABLE IF NOT EXISTS int_empenho (
  Cod              INT AUTO_INCREMENT PRIMARY KEY,
  Cod_intervencao  INT             NOT NULL,
  nrEmpenho        BIGINT UNSIGNED NOT NULL,
  dtEmpenho        DATE            NOT NULL,
  nrAnoEmpenho     SMALLINT UNSIGNED AS (YEAR(dtEmpenho)) STORED,
  idOrigemEmpenho  INT UNSIGNED    NOT NULL DEFAULT 0,
  UNIQUE KEY uk_int_empenho (Cod_intervencao, nrEmpenho, nrAnoEmpenho, idOrigemEmpenho),
  KEY idx_int_empenho (Cod_intervencao),
  CONSTRAINT fk_int_empenho FOREIGN KEY (Cod_intervencao)
    REFERENCES int_intervencao(Cod)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
