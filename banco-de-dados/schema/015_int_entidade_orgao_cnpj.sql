-- =====================================================================
-- SGI - Nome e CNPJ do ente declarante (para outro ente usar o sistema).
-- Base: adtovb. Idempotente: ADD COLUMN IF NOT EXISTS. Rodar 2x sem erro.
-- Rodar depois da 002 (int_entidade).
--
-- Por que: o nome da instituicao e o CNPJ estavam so como constante
-- compilada em Marca.vb. Para outro ente rodar o mesmo binario, viram
-- cadastro em int_entidade (tela Dados da Entidade). A MARCA do software
-- (SGI, titulo da janela, tela Sobre, tela inicial) NAO muda - o sistema
-- continua da Camara Municipal de Assis Chateaubriand.
--
-- cdControleLeiAtoBase ja mora em int_config desde a migracao 005 - a
-- tela Dados da Entidade so passa a deixar edita-lo.
--
-- Fechamento: se ja existe a linha da entidade (idEntidade=1), preenche
-- com os valores atuais do Marca. Se nao existe, Entidade.Orgao()/Cnpj()
-- caem no padrao do Marca ate a tela ser salva.
-- =====================================================================

ALTER TABLE int_entidade ADD COLUMN IF NOT EXISTS nmOrgao VARCHAR(150) NULL;
ALTER TABLE int_entidade ADD COLUMN IF NOT EXISTS nrCnpj  VARCHAR(20)  NULL;
-- Larga o nrCnpj se uma versao anterior desta migracao criou VARCHAR(18)
-- (a mascara 00.000.000/0000-00 tem 18 chars exatos - sem folga). MODIFY
-- para o mesmo tipo ou mais largo e no-op/seguro no rerun.
ALTER TABLE int_entidade MODIFY COLUMN nrCnpj VARCHAR(20) NULL;

UPDATE int_entidade
   SET nmOrgao = 'Câmara Municipal de Assis Chateaubriand'
 WHERE idEntidade = 1 AND (nmOrgao IS NULL OR nmOrgao = '');

UPDATE int_entidade
   SET nrCnpj = '77.878.320/0001-73'
 WHERE idEntidade = 1 AND (nrCnpj IS NULL OR nrCnpj = '');
