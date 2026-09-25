# SGI — Sistema de Gestão de Intervenções

Câmara Municipal de Assis Chateaubriand — CNPJ 77.878.320/0001-73

Sistema de cadastro de intervenções (obras públicas) e geração da remessa
mensal **SIM-AM Obras** enviada ao TCE-PR (Tribunal de Contas do Estado do
Paraná). Este repositório traz apenas o **instalador pronto** e as
instruções de instalação/configuração — o código-fonte não está aqui.

## O que o sistema faz

O SGI acompanha uma obra pública do início ao fim e produz, todo mês, o
arquivo de prestação de contas que a Câmara envia ao TCE-PR. Na prática,
cobre:

- **Login com segundo fator (2FA)** e trava de sessão única por usuário.
- **Cadastro da obra (intervenção)**: dados básicos, classificação e
  tipo, conforme o leiaute do TCE-PR.
- **Pessoas e Responsáveis Técnicos**: quem assina a obra (ART/RRT),
  com os documentos de conselho de classe.
- **Leis e atos autorizativos** (Atoteca): os atos que amparam legalmente
  a obra.
- **Planilhas de orçamento e contratos**: valor base, aditivos, execução
  direta ou indireta.
- **Matrícula no INSS** (CNO/CEI) e as CNDs associadas.
- **Acompanhamento mensal**: medições, paralisações e conclusão da obra.
- **Geração da remessa SIM-AM Obras**: monta os arquivos exigidos pelo
  TCE-PR, com uma conferência prévia que aponta inconsistência antes de
  gerar o `.zip` final.

O [manual do usuário completo](manual/manual-do-sistema.html) — o mesmo
que roda dentro do sistema, aba "Manual do Sistema" — está neste
repositório; baixe o arquivo e abra no navegador.

## Requisitos

- Windows 10 ou 11 (64 bits).
- Acesso de rede a um servidor **MariaDB** (10.6 ou superior) com a base
  de dados já criada.
- **Runtime do .NET Desktop 10** instalado na estação — [baixe aqui](https://dotnet.microsoft.com/download/dotnet/10.0)
  (escolha "Desktop Runtime", x64) caso o Windows Update ainda não o
  tenha instalado.

## Como instalar

Este é um pacote **standalone** (pasta zipada, sem instalador nem
ClickOnce) — não faz nenhum contato com servidor da Câmara, nem para
instalar nem para atualizar.

1. Baixe a pasta [`instalador/`](instalador/) (ou o `.zip` da seção
   [Releases](../../releases) deste repositório, se houver um).
2. Extraia-a em qualquer lugar da estação (ex.: `C:\SGI\`).
3. Execute `instalador\SGI.exe`. Não há instalador nem atalho automático
   — crie um atalho para `SGI.exe` se quiser.
4. Na primeira execução, o sistema pede os **dados de conexão com o
   banco de dados** (host, porta, nome da base, usuário e senha). Esses
   dados ficam guardados **somente naquela estação**, criptografados.

Para atualizar, baixe a versão nova e substitua a pasta inteira — não há
atualização automática.

## Como preparar o banco de dados

Veja [`banco-de-dados/README.md`](banco-de-dados/README.md): a ordem de
execução dos scripts de esquema e como criar o primeiro usuário
administrador.

## Licença

[PolyForm Noncommercial 1.0.0](LICENSE) — Câmara Municipal de Assis
Chateaubriand. Uso, cópia e adaptação livres para qualquer finalidade
**não comercial**; venda ou uso comercial por terceiros não é permitido.

## Suporte

Câmara Municipal de Assis Chateaubriand — https://camarassis.pr.gov.br
