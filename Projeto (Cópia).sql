CREATE DATABASE Projeto;
GO
USE Projeto;
GO

-- 1. Tabela do projeto --
CREATE TABLE PROJETO(
	ID INT IDENTITY(10001,1) NOT NULL,
	Nome VARCHAR(45) NOT NULL,
	Descricao VARCHAR(45),
	Data_inicio DATE,
	CONSTRAINT CK_PROJETO_data_inicio CHECK (Data_inicio > '2014-09-01'),
	CONSTRAINT PK_PROJETO PRIMARY KEY (ID)
);
GO

-- 2. Tabela do Usuário --
CREATE TABLE USUARIO(
	ID INT IDENTITY(1,1) NOT NULL,
	Nome VARCHAR(45) NOT NULL,
	Username VARCHAR(10) NOT NULL, 
	Senha VARCHAR(45) NOT NULL,
	email VARCHAR(45) NOT NULL,
	CONSTRAINT PK_USUARIO PRIMARY KEY (ID),
	CONSTRAINT UQ_USUARIO_USERNAME UNIQUE (Username)
);
GO

-- 3. Tabela Associativa (M:M) --
CREATE TABLE USUARIOS_TEM_PROJETOS(
	USUARIO_ID INT ,
	PROJETO_ID INT ,
	CONSTRAINT PK_USUARIOS_TEM_PROJETOS PRIMARY KEY (USUARIO_ID, PROJETO_ID),
	CONSTRAINT FK_USUARIOS_TEM_PROJETOS_USUARIO FOREIGN KEY (USUARIO_ID) REFERENCES USUARIO(ID),
	CONSTRAINT FK_USUARIOS_TEM_PROJETOS_PROJETO FOREIGN KEY (PROJETO_ID) REFERENCES PROJETO(ID)
);
GO

-- Inserção da Tabela USUARIO --
INSERT INTO USUARIO (Nome, Username, Senha, email) VALUES
	('Maria', 'Rh_maria', '123mudar', 'maria@empresa.com'),       
	('Paulo', 'Ti_paulo', '123@456', 'paulo@empresa.com'),       
	('Ana', 'Rh_ana', '123mudar', 'ana@empresa.com'),             
	('Clara', 'Ti_Clara', '123mudar', 'clara@empresa.com'),       
	('Aparecido', 'Rh_cido', '55@!cido', 'aparecido@empresa.com'),
	('Joao', 'Ti_joao', '123mudar', 'joao@empresa.com');          
GO

-- Inserção da Tabela PROJETO --
INSERT INTO PROJETO(Nome, Descricao, Data_inicio) VALUES
	('Re-folha', 'Refatoração das folhas', '2014-09-05'),                  
	('Manutenção PC´s', 'Manutenção PC´s', '2014-09-06'),                  
	('Auditoria', NULL, '2014-09-07'),                                     
	('Atualização de Sistemas', 'Modificação de SO nos PCs', '2014-09-12');
GO

-- INSERT da tabela USUARIOS_TEM_PROJETOS -- 
INSERT INTO USUARIOS_TEM_PROJETOS (USUARIO_ID, PROJETO_ID) VALUES
(1, 10001),   
(2, 10001),   
(3, 10001),   
(4, 10002),   
(5, 10003),   
(6, 10001);   
GO   

-- Updates solicitados
UPDATE PROJETO SET Data_inicio = '2014-09-12' WHERE Nome LIKE 'Manutenção%';
UPDATE USUARIO SET Senha = '888@*' WHERE Username LIKE 'Rh_maria';

UPDATE PROJETO
SET Data_inicio = '12/09/2014'
WHERE Nome LIKE 'Manutenção%'
GO

UPDATE USUARIO 
SET Username = 'Rh_cido'
WHERE Nome LIKE 'Aparecido'
GO

UPDATE USUARIO
SET Senha = '888@*'
WHERE Username LIKE 'Rh_Maria'
GO

UPDATE USUARIOS_TEM_PROJETOS
SET PROJETO_ID = NULL, USUARIO_ID = NULL
WHERE USUARIO_ID = 2
GO

-- SELECT 1 --
SELECT us.ID, us.Nome, us.email,
       pr.ID, pr.Nome, pr.Descricao, pr.Data_inicio
FROM USUARIOS_TEM_PROJETOS utp
INNER JOIN USUARIO us ON us.ID = utp.USUARIO_ID
INNER JOIN PROJETO pr ON pr.ID = utp.PROJETO_ID
WHERE pr.Nome = 'Re-folha';   
SELECT *
FROM USUARIOS_TEM_PROJETOS

-- SELECT 2 --
SELECT pr.Nome
FROM PROJETO pr
LEFT JOIN USUARIOS_TEM_PROJETOS utp ON pr.ID = utp.PROJETO_ID
WHERE utp.PROJETO_ID IS NULL;   

-- SELECT 3 --
SELECT us.Nome
FROM USUARIO us
LEFT JOIN USUARIOS_TEM_PROJETOS utp ON us.ID = utp.USUARIO_ID
WHERE utp.USUARIO_ID IS NULL;   

-- SELECT USUARIOS COM MAIS PROJETOS --
SELECT 
    us.ID AS Usuario_ID,
    us.Nome,
    COUNT(utp.PROJETO_ID) AS Quantidade_Projetos
FROM USUARIO us
JOIN USUARIOS_TEM_PROJETOS utp ON us.ID = utp.USUARIO_ID
GROUP BY us.ID, us.Nome
ORDER BY Quantidade_Projetos DESC;

-- SELECT USUARIOS SEM PROJETO --
SELECT 
    us.ID,
    us.Nome
FROM USUARIO us
WHERE us.ID NOT IN (SELECT USUARIO_ID FROM USUARIOS_TEM_PROJETOS);

-- SELECT PROJETOS COM MAIS USUARIOS --
SELECT 
    pr.Nome AS Projeto_Nome,
    COUNT(utp.USUARIO_ID) AS Quantidade_Usuarios
FROM PROJETO pr
JOIN USUARIOS_TEM_PROJETOS utp ON pr.ID = utp.PROJETO_ID
GROUP BY pr.Nome
ORDER BY Quantidade_Usuarios DESC;