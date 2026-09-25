-- =====================================================================
-- SGI - Responsavel Tecnico ganha data de inicio propria.
-- Base: adtovb. Idempotente: ADD COLUMN IF NOT EXISTS. Rodar 2x sem erro.
-- Rodar depois da 003.
--
-- Por que: no SIM-AM Obras, o RT pode ser vinculado a intervencao DEPOIS
-- do inicio da obra, e pode haver troca de RT ao longo da execucao. A
-- data-gatilho da competencia (arquivo responsabilidadetecnica.txt) e
-- esta dtInicio, nao o dtInicio da intervencao. O TCE nao tem coluna de
-- data em ResponsabilidadeTecnica - dtInicio e so do SGI.
--
-- Fechamento: linhas ja existentes recebem dtInicio = dtInicio da
-- intervencao-mae (comportamento equivalente ao que a Onda A assumia).
-- =====================================================================

ALTER TABLE int_responsabilidade_tecnica
  ADD COLUMN IF NOT EXISTS dtInicio DATE NULL;

UPDATE int_responsabilidade_tecnica rt
  JOIN int_intervencao i ON i.Cod = rt.Cod_intervencao
  SET rt.dtInicio = i.dtInicio
  WHERE rt.dtInicio IS NULL;

ALTER TABLE int_responsabilidade_tecnica
  MODIFY COLUMN dtInicio DATE NOT NULL;
