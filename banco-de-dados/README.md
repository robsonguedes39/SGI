# Banco de dados do SGI

Base MariaDB (10.6+) com qualquer nome — os exemplos abaixo usam
`sgi_obras`. Todas as tabelas do sistema usam o prefixo `int_`, para não
colidir com outras aplicações que eventualmente dividam o mesmo banco.

## 1. Criar a base (se ainda não existir)

    CREATE DATABASE IF NOT EXISTS sgi_obras
      CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

## 2. Rodar o esquema

**Opção rápida — um arquivo só.** [`instalacao-completa.sql`](instalacao-completa.sql)
já traz tudo (tabela `tb_UF` de municípios + as 17 migrações do SGI) na
ordem certa. Testado do zero, duas vezes seguidas, sem erro nem
duplicação:

    mysql -u usuario -p -h SEU_HOST sgi_obras < instalacao-completa.sql

**Opção granular — arquivo por arquivo.** Os arquivos em [`schema/`](schema/)
são **numerados e idempotentes** — rodar um deles duas vezes não falha nem
duplica dado. Use esta opção se for atualizar um banco que já tem
versões antigas do SGI, ou se seu banco **já tem o ProtocoloADTO
instalado** (nesse caso pule o `000_tb_uf_ibge.sql` — a tabela `tb_UF` já
existe lá):

    for f in schema/*.sql; do
      mysql -u usuario -p -h SEU_HOST sgi_obras < "$f"
    done

(ou, um a um, no Windows: `mysql -u usuario -p -h SEU_HOST sgi_obras < schema\000_tb_uf_ibge.sql`,
depois `001_int_core.sql`, `002_...`, e assim por diante até `017_int_empenho.sql`.)

`000_tb_uf_ibge.sql` cria a tabela `tb_UF` (catálogo de municípios do
IBGE — dado público, sem informação pessoal) que o SGI usa, somente
leitura, para mostrar nome de município nas telas de Pessoa. Ela
pertence originalmente ao **ProtocoloADTO** (sistema irmão da Câmara);
está reproduzida aqui só para permitir instalar o SGI num banco que
ainda não tem o ProtocoloADTO. **Se o seu banco já tem essa tabela, não
rode este script** — o `INSERT` usa `IGNORE` e não duplica dado, mas é
trabalho à toa (297 KB, 5.571 linhas).

Os demais scripts criam as tabelas de cadastro do SGI (intervenções,
pessoas e responsáveis técnicos, planilhas orçamentárias, acompanhamento
mensal, matrícula no INSS, empenhos, leis/atos de obra) e semeiam os
lookups padronizados pelo TCE-PR.

## 3. Informar os dados da entidade

Depois do primeiro login, abra a tela **Dados da Entidade** no sistema e
preencha o `idPessoa` da Câmara/Prefeitura no SIM-AM — sem isso a remessa
mensal não é gerada corretamente.

## 4. Criar o primeiro usuário administrador

A senha nunca é gravada em texto puro — a coluna `Chave` guarda um hash
**BCrypt**. Gere o hash antes de inserir o usuário.

**Opção A — PowerShell**, usando a própria biblioteca que acompanha o
instalador:

    Add-Type -Path "..\instalador\BCrypt-Net-Next.dll"
    [BCrypt.Net.BCrypt]::HashPassword("SUA_SENHA_AQUI")

**Opção B — .NET**, se a Opção A não carregar a DLL nessa estação:

    dotnet run --project - <<'EOF'
    Console.WriteLine(BCrypt.Net.BCrypt.HashPassword("SUA_SENHA_AQUI"));
    EOF

(equivalente a criar um projeto de console mínimo com o pacote NuGet
`BCrypt.Net-Next`.)

Copie o hash impresso e use no `INSERT` abaixo (troque CPF, nome e
e-mail pelos do administrador real; `NivelAcesso = 'Admin'` é o que dá
acesso total no sistema):

    INSERT INTO int_user (CPF, Nome, Chave, Email, NivelAcesso)
    VALUES ('00000000000', 'Nome do Administrador', '<hash gerado acima>',
            'admin@exemplo.gov.br', 'Admin');

No primeiro login, use o CPF cadastrado e a senha em texto puro que você
escolheu (não o hash).

## Fuso horário

As colunas `int_log.DataAcao` e `int_user.UltimoPing` são gravadas pelo
próprio sistema em **UTC**. Para ler no horário de Brasília:

    SELECT CONVERT_TZ(DataAcao, '+00:00', '-03:00') AS hora_brasilia,
           CPF_Logado, Acao
      FROM int_log ORDER BY DataAcao DESC;
