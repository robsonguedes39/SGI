-- =====================================================================
-- SGI - Sub-projeto 3 (parcial): Intervencao X Bem
-- Base: adtovb. Prefixo int_.
-- Idempotente: CREATE TABLE IF NOT EXISTS. Rodar duas vezes seguidas nao
-- pode falhar. Sem semeadura - a tabela nasce vazia.
--
-- Liga uma Intervencao a codigos de bem patrimonial (SIM-AM Obras,
-- tabela IntervencaoXBem, p. 807-808). O cdBem e X(10) e vem de outro
-- modulo/sistema da Camara - o SGI so guarda o codigo digitado. A regra
-- 1523 (o par (idPessoa, cdBem) tem de existir na tabela Bem do TCE) e
-- conferida na importacao pelo TCE, nao aqui.
-- =====================================================================

CREATE TABLE IF NOT EXISTS int_intervencao_bem (
  Cod             INT AUTO_INCREMENT PRIMARY KEY,
  Cod_intervencao INT         NOT NULL,
  cdBem           VARCHAR(10) NOT NULL,
  UNIQUE KEY uk_int_intervencao_bem (Cod_intervencao, cdBem),
  KEY idx_int_intervencao_bem (Cod_intervencao),
  CONSTRAINT fk_int_intervencao_bem FOREIGN KEY (Cod_intervencao)
    REFERENCES int_intervencao(Cod)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
