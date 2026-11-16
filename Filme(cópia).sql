CREATE DATABASE Filme;
GO
USE Filme;
GO



CREATE TABLE Filme (
	ID int NOT NULL,
	titulo varchar(80) NOT NULL,
	ano int NULL,
	CONSTRAINT PK_Filme PRIMARY KEY (ID),
	CONSTRAINT CK_ano CHECK (ano <= 2021)
);
GO

CREATE TABLE Cliente (
	num_cadastro INT NOT NULL,
	nome VARCHAR(70) NOT NULL,
	logradouro VARCHAR(150) NOT NULL,
	num INT NOT NULL,
	cep CHAR(8) NULL,
	CONSTRAINT PK_Cliente PRIMARY KEY (num_cadastro),
	CONSTRAINT CK_num CHECK (num >= 0),
	CONSTRAINT CK_cep CHECK (LEN(cep) = 8)  
);
GO

CREATE TABLE Estrela (
	ID INT NOT NULL,
	nome varchar(50) NOT NULL,
	nome_real varchar(80) NULL, -- Correção: vírgula adicionada aqui
	CONSTRAINT PK_Estrela PRIMARY KEY (ID)
);
GO

CREATE TABLE Filme_Estrela (
	Filme_ID INT NOT NULL,
	Estrela_ID INT NOT NULL,
	FOREIGN KEY (Filme_ID) REFERENCES Filme(ID),
	FOREIGN KEY (Estrela_ID) REFERENCES Estrela(ID),
	CONSTRAINT PK_Filme_Estrela PRIMARY KEY (Filme_ID, Estrela_ID)
);
GO

CREATE TABLE DVD (
	NUM int NOT NULL,
	data_fabricacao DATE NOT NULL,
	Filme_ID INT NOT NULL, 
	CONSTRAINT PK_DVD PRIMARY KEY (NUM),
	FOREIGN KEY (Filme_ID) REFERENCES Filme(ID),
	CONSTRAINT CK_data_fabricacao CHECK (data_fabricacao < GETDATE())
);
GO


CREATE TABLE Locacao (
	data_locacao DATE NOT NULL,
	data_devolucao DATE NOT NULL,
	valor DECIMAL(7,2) NOT NULL,
	DVD_NUM INT NOT NULL,
	Cliente_num_cadastro INT NOT NULL,
	Filme_ID INT NOT NULL,
	Estrela_ID INT NOT NULL, 
	CONSTRAINT PK_Locacao PRIMARY KEY (DVD_NUM, Cliente_num_cadastro, data_locacao),
	FOREIGN KEY (DVD_NUM) REFERENCES DVD(NUM),
	FOREIGN KEY (Cliente_num_cadastro) REFERENCES Cliente(num_cadastro),
	FOREIGN KEY (Estrela_ID) REFERENCES Estrela(ID),
	CONSTRAINT DF_data_locacao DEFAULT (GETDATE()),
	CONSTRAINT CK_data_devolucao CHECK (data_devolucao > data_locacao),
	CONSTRAINT CK_valor CHECK (valor >= 0)
);
GO

-- 3. Inserção dos Dados Iniciais 

-- Filmes 
INSERT INTO Filme (ID, titulo, ano) VALUES 
(1001, 'Whiplash', 2015),
(1002, 'Birdman', 2015),
(1003, 'Interestelar', 2014),
(1004, 'A Culpa é das estrelas', 2014),
(1005, 'Alexandre e o Dia Terrível, Horrível, Espantoso e Horroroso', 2014),
(1006, 'Sing', 2016);
GO

-- Estrelas 
INSERT INTO Estrela (ID, Nome, Nome_real) VALUES 
(9901, 'Michael Keaton', 'Michael John Douglas'),
(9902, 'Emma Stone', 'Emily Jean Stone'),
(9903, 'Miles Teller', 'Miles Alexander Teller'), -- Atualizado
(9904, 'Steve Carell', 'Steven John Carell'),
(9905, 'Jennifer Garner', 'Jennifer Anne Garner');
GO

-- Relação Filme-Estrela
INSERT INTO Filme_Estrela (Filme_ID, Estrela_ID) VALUES 
(1002, 9901),
(1002, 9902),
(1001, 9902), 
(1005, 9904),
(1005, 9905);
GO

-- Clientes 
INSERT INTO Cliente (Num_cadastro, Nome, Logradouro, Num, CEP) VALUES
(5501, 'Matilde Luz', 'Rua Síria', 150, '03086040'),
(5502, 'Carlos Carreiro', 'Rua Bartolomeu Aires', 1250, '04419110'),
(5503, 'Daniel Ramalho', 'Rua Itajutiba', 169, '08411150'), 
(5504, 'Roberta Bento', 'Rua Jayme Von Rosenburg', 36, '02918190'), 
(5505, 'Rosa Cerqueira', 'Rua Arnaldo Simões Pinto', 235, '02917110');
GO

-- DVDs
INSERT INTO DVD (NUM, Data_fabricacao, Filme_ID) VALUES
(10001, '2020-12-02', 1001),
(10002, '2019-10-18', 1002),
(10003, '2020-04-03', 1003),
(10004, '2020-12-02', 1001),
(10005, '2019-07-14', 1004),
(10006, '2020-04-03', 1002),
(10007, '2020-12-02', 1005),
(10008, '2019-10-18', 1002),
(10009, '2020-04-03', 1003);
GO

-- Locações 
INSERT INTO Locacao (DVD_NUM, Cliente_num_cadastro, data_locacao, data_devolucao, valor, Estrela_ID) VALUES
-- Locação 2021-02-18 Cliente 5502 (Valor 3.25)
(10001, 5502, '2021-02-18', '2021-02-21', 3.25, 9902), 
(10009, 5502, '2021-02-18', '2021-02-21', 3.25, 9903),
-- Locação 2021-02-18 Cliente 5503
(10002, 5503, '2021-02-18', '2021-02-19', 3.50, 9901),
-- Locação 2021-02-20 Cliente 5505
(10002, 5505, '2021-02-20', '2021-02-23', 3.00, 9901),
(10004, 5505, '2021-02-20', '2021-02-23', 3.00, 9902),
(10005, 5505, '2021-02-20', '2021-02-23', 3.00, 9903),
-- Locação 2021-02-24 Cliente 5501 (Valor 3.10)
(10001, 5501, '2021-02-24', '2021-02-26', 3.10, 9902),
(10008, 5501, '2021-02-24', '2021-02-26', 3.10, 9901);
GO

-- 4. Operações com Dados (Atualizações e Exclusões)

-- Atualizar CEP dos clientes 5503 e 5504 (já foram inseridos corretamente acima, mas aqui está o UPDATE caso recicle o script)
UPDATE Cliente SET cep = '08411150' WHERE num_cadastro = 5503;
UPDATE Cliente SET cep = '02918190' WHERE num_cadastro = 5504;

-- Atualizar valores das locações
-- Cliente 5502, data 2021-02-18
UPDATE Locacao SET valor = 3.25 
WHERE Cliente_num_cadastro = 5502 AND data_locacao = '2021-02-18';

-- Cliente 5501, data 2021-02-24
UPDATE Locacao SET valor = 3.10 
WHERE Cliente_num_cadastro = 5501 AND data_locacao = '2021-02-24';

-- Atualizar data de fabricação do DVD 10005
UPDATE DVD SET data_fabricacao = '2019-07-14' WHERE NUM = 10005;

-- Atualizar nome real de Miles Teller (já foi inserido correto acima, mas aqui está o UPDATE)
UPDATE Estrela SET nome_real = 'Miles Alexander Teller' WHERE ID = 9903;

-- Excluir Filme 'Sing' (ID 1006) que não tem DVD cadastrado
-- Nota: É necessário remover a relação na tabela Filme_Estrela antes de excluir o filme
DELETE FROM Filme_Estrela WHERE Filme_ID = 1006;
DELETE FROM Filme WHERE ID = 1006;
GO

-- 5. Consultas Solicitadas

-- 1) Nomes dos filmes de 2014
SELECT titulo 
FROM Filme 
WHERE ano = 2014;
GO

-- 2) ID e ano do filme Birdman
SELECT ID, ano 
FROM Filme 
WHERE titulo = 'Birdman';
GO

-- 3) ID e ano do filme terminado por 'plash'
SELECT ID, ano 
FROM Filme 
WHERE titulo LIKE '%plash';
GO

-- 4) ID, nome e nome_real da estrela cujo nome começa com 'Steve'
SELECT ID, nome, nome_real 
FROM Estrela 
WHERE nome LIKE 'Steve%';
GO

-- 5) FilmeId e data_fabricação (DD/MM/YYYY) dos DVDs fabricados a partir de 01/01/2020
SELECT Filme_ID, 
       FORMAT(data_fabricacao, 'dd/MM/yyyy') AS fab
FROM DVD
WHERE data_fabricacao >= '2020-01-01';
GO

-- 6) DVDnum, data_locacao, data_devolucao, valor e valor com multa de 2.00 para o cliente 5505
SELECT DVD_NUM, 
       data_locacao, 
       data_devolucao, 
       valor, 
       valor + 2.00 AS valor_com_multa
FROM Locacao
WHERE Cliente_num_cadastro = 5505;
GO

-- 7) Logradouro, num e CEP de Matilde Luz
SELECT logradouro, num, cep
FROM Cliente
WHERE nome = 'Matilde Luz';
GO

-- 8) Nome real de Michael Keaton
SELECT nome_real
FROM Estrela
WHERE nome = 'Michael Keaton';
GO

-- 9) num_cadastro, nome e endereço completo (logradouro, numero e CEP) dos clientes ID >= 5503
SELECT num_cadastro, 
       nome, 
       logradouro + ', ' + CAST(num AS VARCHAR) + ' - ' + ISNULL(cep, 'Sem CEP') AS end_comp
FROM Cliente
WHERE num_cadastro >= 5503;
GO

-- SELECT MATILDE --
SELECT 
    c.num_cadastro,
    c.nome,
    FORMAT(l.data_locacao, 'dd/MM/yyyy') AS data_locacao,
    DATEDIFF(DAY, l.data_locacao, l.data_devolucao) AS Qtd_dias_alugado,
    f.titulo,
    f.ano
FROM Locacao l
JOIN Cliente c ON l.Cliente_num_cadastro = c.num_cadastro
JOIN Filme f ON l.Filme_ID = f.ID
WHERE c.nome LIKE 'Matilde%';

-- SELECT 2015 --
SELECT 
    e.nome,
    e.nome_real,
    f.titulo
FROM Estrela e
JOIN Filme_Estrela fe ON e.ID = fe.Estrela_ID
JOIN Filme f ON fe.Filme_ID = f.ID
WHERE f.ano = 2015;

-- SELECT diferença_anos --
SELECT 
    f.titulo,
    FORMAT(d.data_fabricacao, 'dd/MM/yyyy') AS data_fabricacao,
    CASE 
        WHEN (YEAR(GETDATE()) - f.ano) > 6 
        THEN CAST((YEAR(GETDATE()) - f.ano) AS VARCHAR) + ' anos'
        ELSE CAST((YEAR(GETDATE()) - f.ano) AS VARCHAR)
    END AS diferenca_anos
FROM Filme f
JOIN DVD d ON f.ID = d.Filme_ID;

-- SELECT MAIOR DATA --
SELECT 
    c.num_cadastro,
    c.nome,
    f.titulo,
    FORMAT(d.data_fabricacao, 'dd/MM/yyyy') AS data_fabricacao,
    l.valor
FROM Locacao l
JOIN DVD d ON l.DVD_NUM = d.NUM
JOIN Filme f ON d.Filme_ID = f.ID
JOIN Cliente c ON l.Cliente_num_cadastro = c.num_cadastro
WHERE d.data_fabricacao = (SELECT MAX(data_fabricacao) FROM DVD);

-- SELECT DVDs ALUGADOS --
SELECT 
    c.num_cadastro,
    c.nome,
    FORMAT(l.data_locacao, 'dd/MM/yyyy') AS data_locacao,
    COUNT(l.DVD_NUM) AS qtd
FROM Locacao l
JOIN Cliente c ON l.Cliente_num_cadastro = c.num_cadastro
GROUP BY c.num_cadastro, c.nome, l.data_locacao;

-- SELECT VALOR TOTAL POR CLIENTE --
SELECT 
    c.num_cadastro,
    c.nome,
    FORMAT(l.data_locacao, 'dd/MM/yyyy') AS data_locacao,
    SUM(l.valor) AS valor_total
FROM Locacao l
JOIN Cliente c ON l.Cliente_num_cadastro = c.num_cadastro
GROUP BY c.num_cadastro, c.nome, l.data_locacao;

-- SELECT ALUGUEL CLIENTES --
SELECT 
    c.num_cadastro,
    c.nome,
    c.logradouro + ', ' + CAST(c.num AS VARCHAR) AS Endereco,
    FORMAT(l.data_locacao, 'dd/MM/yyyy') AS data_locacao
FROM Locacao l
JOIN Cliente c ON l.Cliente_num_cadastro = c.num_cadastro
GROUP BY c.num_cadastro, c.nome, c.logradouro, c.num, l.data_locacao
HAVING COUNT(l.Filme_ID) > 2;