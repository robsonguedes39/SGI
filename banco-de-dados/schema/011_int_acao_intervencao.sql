-- =====================================================================
-- SGI - Acao x Intervencao (vinculo da obra com as acoes do PPA)
-- Base: adtovb. Prefixo int_.
-- Idempotente: CREATE TABLE IF NOT EXISTS + ADD COLUMN IF NOT EXISTS.
-- Rodar duas vezes seguidas nao pode falhar. Sem semeadura.
-- Rodar depois da 002 (int_intervencao, int_entidade).
--
-- SIM-AM Obras, tabela AcaoXIntervencao (TCE OBRAS.pdf, p. 835-836).
-- Liga uma Intervencao a uma acao do Plano Plurianual (PPA). O cdAcao
-- (4 digitos) e o cdControleLeiAtoAcao (controle da lei do PPA na
-- Atoteca) sao DIGITADOS - vem da relacao de acoes do PPA da
-- contabilidade, o SGI nao tem essas tabelas. As regras 1641/1642/1768
-- (o vinculo existe em Acao/MovimentoAcao) sao conferidas na importacao
-- pelo TCE, nao aqui. Exclusao livre.
--
-- idPessoa (Camara) e idOrigemAcao (Prefeitura) nao viram coluna nesta
-- tabela: sao unicos por instalacao. idOrigemAcao mora em int_entidade;
-- o gerador SIM-AM injeta os dois.
-- =====================================================================

ALTER TABLE int_entidade ADD COLUMN IF NOT EXISTS idOrigemAcao INT UNSIGNED NULL;

CREATE TABLE IF NOT EXISTS int_acao_intervencao (
  Cod                   INT AUTO_INCREMENT PRIMARY KEY,
  Cod_intervencao       INT          NOT NULL,
  cdAcao                CHAR(4)      NOT NULL,
  cdControleLeiAtoAcao  INT UNSIGNED NOT NULL,
  UNIQUE KEY uk_int_acao_intervencao (Cod_intervencao, cdAcao, cdControleLeiAtoAcao),
  KEY idx_int_acao_intervencao (Cod_intervencao),
  CONSTRAINT fk_int_acao_intervencao FOREIGN KEY (Cod_intervencao)
    REFERENCES int_intervencao(Cod)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
