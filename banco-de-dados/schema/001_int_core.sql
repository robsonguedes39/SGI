-- =====================================================================
-- SGI - Sistema de Gestao de Intervencoes
-- Esquema base. Idempotente: rodar duas vezes nao pode falhar nem
-- duplicar.
--
-- Base: adtovb (compartilhada com o ProtocoloADTO).
-- Prefixo int_ separa o que e deste sistema. As tabelas tb_* pertencem
-- ao ProtocoloADTO e NAO sao tocadas - a unica excecao e tb_uf, lida
-- em modo somente-leitura para UF e municipio.
--
-- FUSO: DataAcao e UltimoPing sao gravados em UTC pelo aplicativo
-- (UTC_TIMESTAMP()), nunca em hora local. Para ler no horario de
-- Brasilia: CONVERT_TZ(DataAcao, '+00:00', '-03:00').
-- =====================================================================

CREATE TABLE IF NOT EXISTS int_user (
  Cod         INT AUTO_INCREMENT PRIMARY KEY,
  CPF         VARCHAR(14)  NOT NULL,
  Nome        VARCHAR(100) NULL,
  Chave       VARCHAR(255) NULL COMMENT 'Hash BCrypt. Nunca a senha em claro.',
  Email       VARCHAR(120) NULL,
  NivelAcesso VARCHAR(50)  NULL,
  TokenSessao VARCHAR(50)  NULL,
  UltimoPing  DATETIME     NULL COMMENT 'UTC. Base da trava de sessao unica.',
  UNIQUE KEY uk_int_user_cpf (CPF)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS int_log (
  ID         INT AUTO_INCREMENT PRIMARY KEY,
  DataAcao   DATETIME    NOT NULL COMMENT 'UTC, sempre.',
  CPF_Logado VARCHAR(14) NULL,
  CPF_Alvo   VARCHAR(14) NULL,
  Acao       TEXT        NULL,
  KEY idx_int_log_data (DataAcao)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS int_config (
  id                        INT AUTO_INCREMENT PRIMARY KEY,
  Versao_Minima_Obrigatoria VARCHAR(20) NOT NULL,
  -- Sem DEFAULT CURRENT_TIMESTAMP: e sinonimo de NOW() e resolve no fuso
  -- do servidor, o que contradiz a regra de gravar sempre em UTC. Quem
  -- escreve nesta coluna grava UTC_TIMESTAMP() explicitamente.
  Data_Atualizacao          DATETIME NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Semente da versao minima. O INSERT ... SELECT com WHERE NOT EXISTS e
-- o que torna este script repetivel: um INSERT simples criaria uma
-- segunda linha a cada execucao, e o frmLogin le a primeira que vier.
INSERT INTO int_config (Versao_Minima_Obrigatoria, Data_Atualizacao)
SELECT '1.0.0.0', UTC_TIMESTAMP()
 WHERE NOT EXISTS (SELECT 1 FROM int_config);
