USE [DATACLASSIC]
GO

/****** Object:  View [dbo].[BM_CXFLW]    Script Date: 05/03/2024 08:42:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[BM_CXFLW] AS

SELECT TB04014_CODIGO Titulo,
	   TB04014_CODEMP Codemp,
	   TB01007_NOME Empresa,
	   TB04014_DATA [Data],
       TB04014_NOME [Name],
	   CASE WHEN TB04014_OPERACAO IN (1, 2) THEN TB01001_NOME
		    WHEN TB04014_OPERACAO = 3 THEN TB01017_NOME
			WHEN TB04014_OPERACAO = 4 THEN TB01009_NOME END Favorecido,
	   TB04014_VLRBRUTO ValorBruto,
	   TB04014_DTVENC Vencimento,
	   TB04014_DTVENC [Date],
	   TB04014_VLRDESCONTO [DiscountAmount],
	   TB04014_VLRACRES [IncreasedValue],
	   TB04014_VLRTITULO [Value],
	   TB04014_VLRTITULO Payment,
	   0 Receipt,
	   TB04004_NOME Centro,
	   TB04005_NOME Subcentro,
	   100 [Bank Balance],

	   CASE WHEN TB04014_PROVISAO = 'S' THEN TB04014_VLRTITULO ELSE 0 END ValorPrevisao,
	   CASE WHEN TB04014_PROVISAO = 'N' THEN TB04014_VLRTITULO ELSE 0 END ValorSemPrevisao,
	   0 ValorPedCompra,
	   'Pagar' Tipo
  FROM TB04014
LEFT JOIN TB01001 ON TB01001_CODIGO = TB04014_CODFOR
LEFT JOIN TB01017 ON TB01017_CODIGO = TB04014_PREST
LEFT JOIN TB01009 ON TB01009_CODIGO = TB04014_TRANSP
LEFT JOIN TB01007 ON TB01007_CODIGO = TB04014_CODEMP
LEFT JOIN TB04004 ON TB04004_CODIGO = TB04014_CODCEN
LEFT JOIN TB04005 ON TB04005_CODIGO = TB04014_CODSUB
 WHERE CAST(TB04014_DTVENC as date) >= CAST(getdate() as date)
   AND TB04014_VLRTITULO > 0
   AND TB04014_VLRPAGO = 0
   -- AND TB04014_CODEMP = '80'

UNION

SELECT TB04010_CODIGO Titulo,
	   TB04010_CODEMP Codemp,
	   TB01007_NOME Empresa,
	   TB04010_DATA [Data],
       TB04010_NOME [Name],
	   TB01008_NOME Favorecido,
	   TB04010_VLRBRUTO ValorBruto,
	   TB04010_DTVENC Vencimento,
	   CASE WHEN DATEPART(w, CAST(TB04010_DTVENC + TB04003_A.TB04003_NUMERO_DIAS AS date)) = 1 THEN CAST(TB04010_DTVENC + TB04003_A.TB04003_NUMERO_DIAS + 1 AS date) WHEN DATEPART(w, CAST(TB04010_DTVENC + TB04003_A.TB04003_NUMERO_DIAS AS date)) = 7 THEN CAST(TB04010_DTVENC + TB04003_A.TB04003_NUMERO_DIAS + 2 AS date) ELSE CAST(TB04010_DTVENC + TB04003_A.TB04003_NUMERO_DIAS AS date) END [Date],
	   TB04010_VLRDESCONTO [DiscountAmount],
	   TB04010_VLRACRES [IncreasedValue],
	   TB04010_VLRTITULO [Value],
	   0 Payment,
	   TB04010_VLRTITULO Receipt,
	   TB04004_NOME Centro,
	   TB04005_NOME Subcentro,
	  100 [Bank Balance],

	   0 ValorPrevisao,
	   0 ValorSemPrevisao,
	   0 ValorPedCompra,
	   'Receber' Tipo
  FROM TB04010
LEFT JOIN TB01008 ON TB01008_CODIGO = TB04010_CODCLI
LEFT JOIN TB01007 ON TB01007_CODIGO = TB04010_CODEMP
LEFT JOIN TB04004 ON TB04004_CODIGO = TB04010_CODCEN
LEFT JOIN TB04005 ON TB04005_CODIGO = TB04010_CODSUB
LEFT JOIN TB04003 AS TB04003_A ON TB04003_A.TB04003_CODIGO = TB04010_TIPDOC
 WHERE CAST(TB04010_DTVENC as date) >= CAST(getdate() as date)
   AND TB04010_VLRTITULO > 0
   AND TB04010_VLRPAGO = 0

UNION

SELECT Pedido Titulo,
	   Codemp,
	   Empresa,
	   [Data],
	   Fornecedor [Name],
	   Fornecedor Favorecido,
	   ValorPedido ValorBruto,
	   Vencimento,
	   Vencimento [Date],
	   0 [DiscountAmount],
	   0 [IncreasedValue],
	   ValorPedido [Value],
	   ValorPedido Payment,
	   0 Receipt,
	   Centro,
	   Subcentro,
	   100 [Bank Balance],
	   0 ValorPrevisao,
	   0 ValorSemPrevisao,
	   ValorPedido ValorPedCompra,
	   'Ped. Compra' Tipo
  FROM BM_PEDCOMPRASATU
 WHERE CAST(Vencimento as date) >= CAST(getdate() as date)



GO

