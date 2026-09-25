-- =====================================================================
-- SGI - Planilha de Execucao Indireta Aditivo ganha a DATA DO TERMO
-- ADITIVO (a data em que o aditivo foi firmado/assinado).
-- Base: adtovb. Idempotente: ADD COLUMN IF NOT EXISTS. Rodar 2x sem erro.
-- Rodar depois da 008.
--
-- Por que: no SIM-AM Obras, o PlanilhaExecucaoIndiretaAditivo.txt - e o
-- PlanilhaOrcamento.txt do tipo Aditivo (3) - entram na competencia pela
-- data em que o TERMO ADITIVO foi assinado, nao pelo dtBase (data-base do
-- valor) da planilha. A base/contrato continua entrando junto com o
-- cadastro da intervencao (int_intervencao.dtInicio). Essa data de
-- assinatura nao existia no schema.
--
-- Fechamento: linhas ja existentes recebem dtAditivoContrato = dtBase da
-- planilha de orcamento tipo 3 que a PEIA orca (melhor aproximacao
-- disponivel).
-- =====================================================================

ALTER TABLE int_planilha_exec_indireta_aditivo
  ADD COLUMN IF NOT EXISTS dtAditivoContrato DATE NULL;

UPDATE int_planilha_exec_indireta_aditivo peia
  JOIN int_planilha_orcamento po ON po.Cod = peia.Cod_planilha_orcamento
  SET peia.dtAditivoContrato = po.dtBase
  WHERE peia.dtAditivoContrato IS NULL;

ALTER TABLE int_planilha_exec_indireta_aditivo
  MODIFY COLUMN dtAditivoContrato DATE NOT NULL;
