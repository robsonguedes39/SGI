-- =====================================================================
-- SGI - Sub-projeto 2: Pessoas e Responsabilidade Tecnica
-- Base: adtovb. Prefixo int_.
-- Idempotente: CREATE TABLE IF NOT EXISTS + semeadura condicional
-- (INSERT ... SELECT ... WHERE NOT EXISTS). Rodar duas vezes seguidas
-- nao pode falhar nem duplicar.
--
-- Nomes de coluna dos lookups seguem o leiaute SIM-AM/TCE-PR
-- (idTipoDocumentoPessoa, flExigeUF, ...) para o gerador do arquivo
-- (Sub-projeto 6) nao precisar de mapa de-para.
-- =====================================================================

-- ---------------------------------------------------------------------
-- int_uf: codigo IBGE da UF (2 dig) -> sigla. tb_UF (do ProtocoloADTO)
-- tem so o codigo numerico e o nome; a sigla que o TCE quer vem daqui.
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS int_uf (
  cdUF CHAR(2)     NOT NULL,
  sgUF CHAR(2)     NOT NULL,
  nmUF VARCHAR(40) NOT NULL,
  PRIMARY KEY (cdUF),
  UNIQUE KEY uk_int_uf_sg (sgUF)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO int_uf (cdUF, sgUF, nmUF) SELECT '11','RO','Rondônia'                 WHERE NOT EXISTS (SELECT 1 FROM int_uf WHERE cdUF='11');
INSERT INTO int_uf (cdUF, sgUF, nmUF) SELECT '12','AC','Acre'                     WHERE NOT EXISTS (SELECT 1 FROM int_uf WHERE cdUF='12');
INSERT INTO int_uf (cdUF, sgUF, nmUF) SELECT '13','AM','Amazonas'                 WHERE NOT EXISTS (SELECT 1 FROM int_uf WHERE cdUF='13');
INSERT INTO int_uf (cdUF, sgUF, nmUF) SELECT '14','RR','Roraima'                  WHERE NOT EXISTS (SELECT 1 FROM int_uf WHERE cdUF='14');
INSERT INTO int_uf (cdUF, sgUF, nmUF) SELECT '15','PA','Pará'                     WHERE NOT EXISTS (SELECT 1 FROM int_uf WHERE cdUF='15');
INSERT INTO int_uf (cdUF, sgUF, nmUF) SELECT '16','AP','Amapá'                    WHERE NOT EXISTS (SELECT 1 FROM int_uf WHERE cdUF='16');
INSERT INTO int_uf (cdUF, sgUF, nmUF) SELECT '17','TO','Tocantins'               WHERE NOT EXISTS (SELECT 1 FROM int_uf WHERE cdUF='17');
INSERT INTO int_uf (cdUF, sgUF, nmUF) SELECT '21','MA','Maranhão'                 WHERE NOT EXISTS (SELECT 1 FROM int_uf WHERE cdUF='21');
INSERT INTO int_uf (cdUF, sgUF, nmUF) SELECT '22','PI','Piauí'                    WHERE NOT EXISTS (SELECT 1 FROM int_uf WHERE cdUF='22');
INSERT INTO int_uf (cdUF, sgUF, nmUF) SELECT '23','CE','Ceará'                    WHERE NOT EXISTS (SELECT 1 FROM int_uf WHERE cdUF='23');
INSERT INTO int_uf (cdUF, sgUF, nmUF) SELECT '24','RN','Rio Grande do Norte'      WHERE NOT EXISTS (SELECT 1 FROM int_uf WHERE cdUF='24');
INSERT INTO int_uf (cdUF, sgUF, nmUF) SELECT '25','PB','Paraíba'                  WHERE NOT EXISTS (SELECT 1 FROM int_uf WHERE cdUF='25');
INSERT INTO int_uf (cdUF, sgUF, nmUF) SELECT '26','PE','Pernambuco'               WHERE NOT EXISTS (SELECT 1 FROM int_uf WHERE cdUF='26');
INSERT INTO int_uf (cdUF, sgUF, nmUF) SELECT '27','AL','Alagoas'                  WHERE NOT EXISTS (SELECT 1 FROM int_uf WHERE cdUF='27');
INSERT INTO int_uf (cdUF, sgUF, nmUF) SELECT '28','SE','Sergipe'                  WHERE NOT EXISTS (SELECT 1 FROM int_uf WHERE cdUF='28');
INSERT INTO int_uf (cdUF, sgUF, nmUF) SELECT '29','BA','Bahia'                    WHERE NOT EXISTS (SELECT 1 FROM int_uf WHERE cdUF='29');
INSERT INTO int_uf (cdUF, sgUF, nmUF) SELECT '31','MG','Minas Gerais'             WHERE NOT EXISTS (SELECT 1 FROM int_uf WHERE cdUF='31');
INSERT INTO int_uf (cdUF, sgUF, nmUF) SELECT '32','ES','Espírito Santo'           WHERE NOT EXISTS (SELECT 1 FROM int_uf WHERE cdUF='32');
INSERT INTO int_uf (cdUF, sgUF, nmUF) SELECT '33','RJ','Rio de Janeiro'           WHERE NOT EXISTS (SELECT 1 FROM int_uf WHERE cdUF='33');
INSERT INTO int_uf (cdUF, sgUF, nmUF) SELECT '35','SP','São Paulo'                WHERE NOT EXISTS (SELECT 1 FROM int_uf WHERE cdUF='35');
INSERT INTO int_uf (cdUF, sgUF, nmUF) SELECT '41','PR','Paraná'                   WHERE NOT EXISTS (SELECT 1 FROM int_uf WHERE cdUF='41');
INSERT INTO int_uf (cdUF, sgUF, nmUF) SELECT '42','SC','Santa Catarina'           WHERE NOT EXISTS (SELECT 1 FROM int_uf WHERE cdUF='42');
INSERT INTO int_uf (cdUF, sgUF, nmUF) SELECT '43','RS','Rio Grande do Sul'        WHERE NOT EXISTS (SELECT 1 FROM int_uf WHERE cdUF='43');
INSERT INTO int_uf (cdUF, sgUF, nmUF) SELECT '50','MS','Mato Grosso do Sul'       WHERE NOT EXISTS (SELECT 1 FROM int_uf WHERE cdUF='50');
INSERT INTO int_uf (cdUF, sgUF, nmUF) SELECT '51','MT','Mato Grosso'              WHERE NOT EXISTS (SELECT 1 FROM int_uf WHERE cdUF='51');
INSERT INTO int_uf (cdUF, sgUF, nmUF) SELECT '52','GO','Goiás'                    WHERE NOT EXISTS (SELECT 1 FROM int_uf WHERE cdUF='52');
INSERT INTO int_uf (cdUF, sgUF, nmUF) SELECT '53','DF','Distrito Federal'         WHERE NOT EXISTS (SELECT 1 FROM int_uf WHERE cdUF='53');

-- ---------------------------------------------------------------------
-- Lookups do TCE. Descricoes 5-8 corrigidas em relacao ao PDF (spec 2.3);
-- o id, que e o que vai no arquivo, e o do leiaute.
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS int_tipo_documento_pessoa (
  idTipoDocumentoPessoa TINYINT UNSIGNED NOT NULL,
  sgTipoDocumento       VARCHAR(12) NOT NULL,
  dsTipoDocumento       VARCHAR(80) NOT NULL,
  flExigeUF             CHAR(1) NOT NULL,
  flExigeValidade       CHAR(1) NOT NULL,
  PRIMARY KEY (idTipoDocumentoPessoa)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO int_tipo_documento_pessoa (idTipoDocumentoPessoa, sgTipoDocumento, dsTipoDocumento, flExigeUF, flExigeValidade) SELECT  1,'RG','Número de Identidade','S','N'                                        WHERE NOT EXISTS (SELECT 1 FROM int_tipo_documento_pessoa WHERE idTipoDocumentoPessoa=1);
INSERT INTO int_tipo_documento_pessoa (idTipoDocumentoPessoa, sgTipoDocumento, dsTipoDocumento, flExigeUF, flExigeValidade) SELECT  2,'CPF','Cadastro de Pessoas Físicas','N','N'                                 WHERE NOT EXISTS (SELECT 1 FROM int_tipo_documento_pessoa WHERE idTipoDocumentoPessoa=2);
INSERT INTO int_tipo_documento_pessoa (idTipoDocumentoPessoa, sgTipoDocumento, dsTipoDocumento, flExigeUF, flExigeValidade) SELECT  3,'CNPJ','Cadastro Nacional de Pessoas Jurídicas','N','S'                     WHERE NOT EXISTS (SELECT 1 FROM int_tipo_documento_pessoa WHERE idTipoDocumentoPessoa=3);
INSERT INTO int_tipo_documento_pessoa (idTipoDocumentoPessoa, sgTipoDocumento, dsTipoDocumento, flExigeUF, flExigeValidade) SELECT  4,'OAB','Ordem dos Advogados do Brasil','S','N'                               WHERE NOT EXISTS (SELECT 1 FROM int_tipo_documento_pessoa WHERE idTipoDocumentoPessoa=4);
INSERT INTO int_tipo_documento_pessoa (idTipoDocumentoPessoa, sgTipoDocumento, dsTipoDocumento, flExigeUF, flExigeValidade) SELECT  5,'CREA','Conselho Regional de Engenharia e Agronomia','S','N'               WHERE NOT EXISTS (SELECT 1 FROM int_tipo_documento_pessoa WHERE idTipoDocumentoPessoa=5);
INSERT INTO int_tipo_documento_pessoa (idTipoDocumentoPessoa, sgTipoDocumento, dsTipoDocumento, flExigeUF, flExigeValidade) SELECT  6,'CAU','Conselho de Arquitetura e Urbanismo','S','N'                       WHERE NOT EXISTS (SELECT 1 FROM int_tipo_documento_pessoa WHERE idTipoDocumentoPessoa=6);
INSERT INTO int_tipo_documento_pessoa (idTipoDocumentoPessoa, sgTipoDocumento, dsTipoDocumento, flExigeUF, flExigeValidade) SELECT  7,'CTF','Conselho Federal dos Técnicos Industriais','S','N'                 WHERE NOT EXISTS (SELECT 1 FROM int_tipo_documento_pessoa WHERE idTipoDocumentoPessoa=7);
INSERT INTO int_tipo_documento_pessoa (idTipoDocumentoPessoa, sgTipoDocumento, dsTipoDocumento, flExigeUF, flExigeValidade) SELECT  8,'CFTA','Conselho Federal dos Técnicos Agrícolas','S','N'                  WHERE NOT EXISTS (SELECT 1 FROM int_tipo_documento_pessoa WHERE idTipoDocumentoPessoa=8);
INSERT INTO int_tipo_documento_pessoa (idTipoDocumentoPessoa, sgTipoDocumento, dsTipoDocumento, flExigeUF, flExigeValidade) SELECT 96,'CONSEMPR','Consórcio de Empresas - Art. 15 Lei 14133/21','N','N'            WHERE NOT EXISTS (SELECT 1 FROM int_tipo_documento_pessoa WHERE idTipoDocumentoPessoa=96);
INSERT INTO int_tipo_documento_pessoa (idTipoDocumentoPessoa, sgTipoDocumento, dsTipoDocumento, flExigeUF, flExigeValidade) SELECT 97,'CONTR','Contribuintes sem registro de CPF','N','N'                       WHERE NOT EXISTS (SELECT 1 FROM int_tipo_documento_pessoa WHERE idTipoDocumentoPessoa=97);
INSERT INTO int_tipo_documento_pessoa (idTipoDocumentoPessoa, sgTipoDocumento, dsTipoDocumento, flExigeUF, flExigeValidade) SELECT 98,'EST','Estrangeiros','N','N'                                              WHERE NOT EXISTS (SELECT 1 FROM int_tipo_documento_pessoa WHERE idTipoDocumentoPessoa=98);

CREATE TABLE IF NOT EXISTS int_tipo_documento_orgao_classe (
  idTipoDocumentoOrgaoClasse TINYINT UNSIGNED NOT NULL,
  dsTipoDocumentoOrgaoClasse VARCHAR(60) NOT NULL,
  PRIMARY KEY (idTipoDocumentoOrgaoClasse)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO int_tipo_documento_orgao_classe (idTipoDocumentoOrgaoClasse, dsTipoDocumentoOrgaoClasse) SELECT 1,'ART (CREA)'                    WHERE NOT EXISTS (SELECT 1 FROM int_tipo_documento_orgao_classe WHERE idTipoDocumentoOrgaoClasse=1);
INSERT INTO int_tipo_documento_orgao_classe (idTipoDocumentoOrgaoClasse, dsTipoDocumentoOrgaoClasse) SELECT 2,'RRT (CAU) e TRT (CFT e CFTA)'  WHERE NOT EXISTS (SELECT 1 FROM int_tipo_documento_orgao_classe WHERE idTipoDocumentoOrgaoClasse=2);

CREATE TABLE IF NOT EXISTS int_tipo_responsabilidade_tecnica (
  idTipoResponsabilidadeTecnica TINYINT UNSIGNED NOT NULL,
  dsTipoResponsabilidadeTecnica VARCHAR(40) NOT NULL,
  PRIMARY KEY (idTipoResponsabilidadeTecnica)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO int_tipo_responsabilidade_tecnica (idTipoResponsabilidadeTecnica, dsTipoResponsabilidadeTecnica) SELECT 1,'Execução de Obra'        WHERE NOT EXISTS (SELECT 1 FROM int_tipo_responsabilidade_tecnica WHERE idTipoResponsabilidadeTecnica=1);
INSERT INTO int_tipo_responsabilidade_tecnica (idTipoResponsabilidadeTecnica, dsTipoResponsabilidadeTecnica) SELECT 2,'Projeto Arquitetônico'   WHERE NOT EXISTS (SELECT 1 FROM int_tipo_responsabilidade_tecnica WHERE idTipoResponsabilidadeTecnica=2);
INSERT INTO int_tipo_responsabilidade_tecnica (idTipoResponsabilidadeTecnica, dsTipoResponsabilidadeTecnica) SELECT 3,'Projeto Estrutural'      WHERE NOT EXISTS (SELECT 1 FROM int_tipo_responsabilidade_tecnica WHERE idTipoResponsabilidadeTecnica=3);
INSERT INTO int_tipo_responsabilidade_tecnica (idTipoResponsabilidadeTecnica, dsTipoResponsabilidadeTecnica) SELECT 4,'Projeto Complementar'    WHERE NOT EXISTS (SELECT 1 FROM int_tipo_responsabilidade_tecnica WHERE idTipoResponsabilidadeTecnica=4);
INSERT INTO int_tipo_responsabilidade_tecnica (idTipoResponsabilidadeTecnica, dsTipoResponsabilidadeTecnica) SELECT 5,'Orçamento'               WHERE NOT EXISTS (SELECT 1 FROM int_tipo_responsabilidade_tecnica WHERE idTipoResponsabilidadeTecnica=5);
INSERT INTO int_tipo_responsabilidade_tecnica (idTipoResponsabilidadeTecnica, dsTipoResponsabilidadeTecnica) SELECT 6,'Fiscalização'            WHERE NOT EXISTS (SELECT 1 FROM int_tipo_responsabilidade_tecnica WHERE idTipoResponsabilidadeTecnica=6);
INSERT INTO int_tipo_responsabilidade_tecnica (idTipoResponsabilidadeTecnica, dsTipoResponsabilidadeTecnica) SELECT 7,'Consultoria'             WHERE NOT EXISTS (SELECT 1 FROM int_tipo_responsabilidade_tecnica WHERE idTipoResponsabilidadeTecnica=7);
INSERT INTO int_tipo_responsabilidade_tecnica (idTipoResponsabilidadeTecnica, dsTipoResponsabilidadeTecnica) SELECT 8,'Cargo e Função'          WHERE NOT EXISTS (SELECT 1 FROM int_tipo_responsabilidade_tecnica WHERE idTipoResponsabilidadeTecnica=8);
INSERT INTO int_tipo_responsabilidade_tecnica (idTipoResponsabilidadeTecnica, dsTipoResponsabilidadeTecnica) SELECT 9,'Outra'                   WHERE NOT EXISTS (SELECT 1 FROM int_tipo_responsabilidade_tecnica WHERE idTipoResponsabilidadeTecnica=9);

-- De-para conselho -> orgao de classe. Mesma verdade da funcao
-- ResponsavelTecnicoRegras.OrgaoClassePorConselho; a tabela existe para
-- o gerador do arquivo (Sub-projeto 6).
CREATE TABLE IF NOT EXISTS int_map_tipodoc_orgaoclasse (
  idTipoDocumentoPessoa      TINYINT UNSIGNED NOT NULL,
  idTipoDocumentoOrgaoClasse TINYINT UNSIGNED NOT NULL,
  PRIMARY KEY (idTipoDocumentoPessoa, idTipoDocumentoOrgaoClasse),
  CONSTRAINT fk_map_tdp FOREIGN KEY (idTipoDocumentoPessoa)      REFERENCES int_tipo_documento_pessoa(idTipoDocumentoPessoa),
  CONSTRAINT fk_map_toc FOREIGN KEY (idTipoDocumentoOrgaoClasse) REFERENCES int_tipo_documento_orgao_classe(idTipoDocumentoOrgaoClasse)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO int_map_tipodoc_orgaoclasse (idTipoDocumentoPessoa, idTipoDocumentoOrgaoClasse) SELECT 5,1 WHERE NOT EXISTS (SELECT 1 FROM int_map_tipodoc_orgaoclasse WHERE idTipoDocumentoPessoa=5 AND idTipoDocumentoOrgaoClasse=1);
INSERT INTO int_map_tipodoc_orgaoclasse (idTipoDocumentoPessoa, idTipoDocumentoOrgaoClasse) SELECT 6,2 WHERE NOT EXISTS (SELECT 1 FROM int_map_tipodoc_orgaoclasse WHERE idTipoDocumentoPessoa=6 AND idTipoDocumentoOrgaoClasse=2);
INSERT INTO int_map_tipodoc_orgaoclasse (idTipoDocumentoPessoa, idTipoDocumentoOrgaoClasse) SELECT 7,2 WHERE NOT EXISTS (SELECT 1 FROM int_map_tipodoc_orgaoclasse WHERE idTipoDocumentoPessoa=7 AND idTipoDocumentoOrgaoClasse=2);
INSERT INTO int_map_tipodoc_orgaoclasse (idTipoDocumentoPessoa, idTipoDocumentoOrgaoClasse) SELECT 8,2 WHERE NOT EXISTS (SELECT 1 FROM int_map_tipodoc_orgaoclasse WHERE idTipoDocumentoPessoa=8 AND idTipoDocumentoOrgaoClasse=2);

-- ---------------------------------------------------------------------
-- int_pessoa: identidade CPF (2) ou CNPJ (3). nrDocumento guardado SO
-- com digitos (a mascara e da tela). CHECK como segunda guarda alem da
-- combo (MariaDB 11.8 aplica CHECK).
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS int_pessoa (
  Cod         INT AUTO_INCREMENT PRIMARY KEY,
  tpDocumento TINYINT UNSIGNED NOT NULL,
  nrDocumento VARCHAR(15)      NOT NULL,
  nmPessoa    VARCHAR(100)     NOT NULL,
  dsEndereco  VARCHAR(250)     NOT NULL,
  cdCEP       CHAR(8)          NOT NULL,
  cdIBGE      CHAR(5)          NOT NULL,
  sgUF        CHAR(2)          NOT NULL,
  UNIQUE KEY uk_int_pessoa_doc (tpDocumento, nrDocumento),
  KEY idx_int_pessoa_nome (nmPessoa),
  CONSTRAINT fk_pessoa_tpdoc FOREIGN KEY (tpDocumento) REFERENCES int_tipo_documento_pessoa(idTipoDocumentoPessoa),
  CONSTRAINT fk_pessoa_uf    FOREIGN KEY (sgUF)        REFERENCES int_uf(sgUF),
  CONSTRAINT ck_pessoa_tpdoc CHECK (tpDocumento IN (2,3))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- int_pessoa_documento: registros de conselho (CREA 5, CAU 6, CTF 7,
-- CFTA 8). So para pessoa CPF (regra 1690) - a tela nao abre a sub-grade
-- para CNPJ; o banco nao tem como amarrar isso a uma FK.
CREATE TABLE IF NOT EXISTS int_pessoa_documento (
  Cod              INT AUTO_INCREMENT PRIMARY KEY,
  Cod_pessoa       INT              NOT NULL,
  tpOutroDocumento TINYINT UNSIGNED NOT NULL,
  nrOutroDocumento VARCHAR(15)      NOT NULL,
  sgUFConselho     CHAR(2)          NOT NULL,
  UNIQUE KEY uk_pessoa_doc (Cod_pessoa, tpOutroDocumento),
  CONSTRAINT fk_pdoc_pessoa FOREIGN KEY (Cod_pessoa)       REFERENCES int_pessoa(Cod),
  CONSTRAINT fk_pdoc_tipo   FOREIGN KEY (tpOutroDocumento) REFERENCES int_tipo_documento_pessoa(idTipoDocumentoPessoa),
  CONSTRAINT fk_pdoc_uf     FOREIGN KEY (sgUFConselho)     REFERENCES int_uf(sgUF),
  CONSTRAINT ck_pdoc_tipo   CHECK (tpOutroDocumento IN (5,6,7,8))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- int_responsabilidade_tecnica: filha da Intervencao. Exclusao livre
-- (sem sequencia tipo cdIntervencao). fk_rt_pessoa impede excluir uma
-- Pessoa que seja responsavel em alguma Intervencao.
CREATE TABLE IF NOT EXISTS int_responsabilidade_tecnica (
  Cod                           INT AUTO_INCREMENT PRIMARY KEY,
  Cod_intervencao               INT              NOT NULL,
  Cod_pessoa                    INT              NOT NULL,
  idTipoDocumentoOrgaoClasse    TINYINT UNSIGNED NOT NULL,
  nrRT                          VARCHAR(20)      NOT NULL,
  idTipoResponsabilidadeTecnica TINYINT UNSIGNED NOT NULL,
  UNIQUE KEY uk_rt (Cod_intervencao, Cod_pessoa, idTipoDocumentoOrgaoClasse, nrRT, idTipoResponsabilidadeTecnica),
  KEY idx_rt_intervencao (Cod_intervencao),
  CONSTRAINT fk_rt_intervencao FOREIGN KEY (Cod_intervencao)               REFERENCES int_intervencao(Cod),
  CONSTRAINT fk_rt_pessoa      FOREIGN KEY (Cod_pessoa)                    REFERENCES int_pessoa(Cod),
  CONSTRAINT fk_rt_orgaoclasse FOREIGN KEY (idTipoDocumentoOrgaoClasse)    REFERENCES int_tipo_documento_orgao_classe(idTipoDocumentoOrgaoClasse),
  CONSTRAINT fk_rt_tipo        FOREIGN KEY (idTipoResponsabilidadeTecnica) REFERENCES int_tipo_responsabilidade_tecnica(idTipoResponsabilidadeTecnica)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
