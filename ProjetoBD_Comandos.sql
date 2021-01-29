-- DROP TABLE Situacao;
-- DROP TABLE Manutencao;
-- DROP TABLE Empresa;
-- DROP TABLE Chefe_de_cabine;
-- DROP TABLE Piloto;
-- DROP TABLE Tripulante;
-- DROP TABLE Razao;
-- DROP TABLE Cancelamento;
-- DROP TABLE Voo;
-- DROP TABLE Aviao;
-- DROP TABLE Rota;
-- DROP TABLE Aeroporto;

CREATE TABLE Aviao (
    matricula VARCHAR(255) NOT NULL,
    autonomia_milhas INTEGER(10) NOT NULL CHECK (autonomia_milhas >= 0),
    autonomia_horas TIME NOT NULL,
    cap_executiva INTEGER(10) NOT NULL CHECK (cap_executiva >= 0),
    cap_turistica INTEGER(10) NOT NULL CHECK (cap_turistica >= 0),
    carga INTEGER(10) NOT NULL CHECK (carga >= 0),
    contagem_horas_voo INTEGER(20) NOT NULL DEFAULT 0 CHECK (contagem_horas_voo >= 0),
    milhas INTEGER(10) NOT NULL DEFAULT 0 CHECK (milhas >= 0),
    marca ENUM("Airbus", "Embraer", "ATR") NOT NULL,
    modelo ENUM("A330-900neo", "A330-200", "A321-200", "A320-200", "A319-100", "Embraer195", "Embraer190", "ATR72-600") NOT NULL,
    tipo ENUM("Comercial", 'Militar') NOT NULL,
    piloto_id INTEGER(10) NOT NULL DEFAULT 0,
    copiloto_id INTEGER(10) NOT NULL DEFAULT 0,
    chefe_de_cabine_id INTEGER(10) NOT NULL DEFAULT 0,
    CONSTRAINT Aviao_pk PRIMARY KEY(matricula)
    );


CREATE TABLE Empresa (
    nome VARCHAR(255) NOT NULL DEFAULT 'A própria',
    tipo ENUM('Insourcing','Outsourcing') NOT NULL DEFAULT 'Outsourcing',
    duracao DATETIME DEFAULT CURRENT_TIMESTAMP,
    preco DECIMAL(10,4),
    CONSTRAINT Empresa_pk PRIMARY KEY(nome)
    );


CREATE TABLE Manutencao (
    matricula_aviao VARCHAR(255) NOT NULL,
    nome_empresa VARCHAR(255) NOT NULL DEFAULT 'A própria',
    nr_aterragens INTEGER(10) NOT NULL DEFAULT 0 CHECK (nr_aterragens >= 0),
    data_inicio DATETIME DEFAULT '2021-01-21 00:00:00',
    data_fim DATETIME DEFAULT CURRENT_TIMESTAMP,
    horas_voo INTEGER(20) NOT NULL DEFAULT 0 CHECK (horas_voo >= 0),
    nr_milhas INTEGER(20) NOT NULL DEFAULT 0 CHECK (nr_milhas >= 0),
    CONSTRAINT Manutencao_pk PRIMARY KEY (matricula_aviao, nome_empresa)
);


CREATE TABLE Situacao (
    matricula_aviao VARCHAR(255) NOT NULL,
    nome_empresa VARCHAR(255) NOT NULL,
    observacao VARCHAR(255) NOT NULL,
    CONSTRAINT Situacao_pk PRIMARY KEY (matricula_aviao, nome_empresa)
);

CREATE TABLE Tripulante (
    id INTEGER(10),
    matricula_aviao VARCHAR(255) NOT NULL,
    nome VARCHAR(255) NOT NULL,
    genero ENUM('Feminino', 'Masculino', 'Outros') NOT NULL,
    morada VARCHAR(255) NOT NULL,
    categoria ENUM('Comandante','Oficial Piloto','Chefe de Cabine','Pessoal da Cabine') NOT NULL,
    escalao ENUM('Junior','Intermédio','Sénior') NOT NULL,
    CONSTRAINT Tripulante_pk PRIMARY KEY(id)
    );

CREATE TABLE Piloto (
    id INTEGER(10) CHECK (id >= 0),
    data_emissao_licenca DATETIME NOT NULL,
    nr_descolagens INTEGER(10) NOT NULL DEFAULT 0 CHECK (nr_descolagens >= 0),
    nr_aterragens INTEGER(10) NOT NULL DEFAULT 0 CHECK (nr_aterragens >= 0),
    horas_voo INTEGER(10) NOT NULL CHECK (horas_voo > 0),
    licenca VARCHAR(255) NOT NULL UNIQUE,
    CONSTRAINT Piloto_pk PRIMARY KEY(id)
    );


CREATE TABLE Chefe_de_cabine (
    id INTEGER(10) CHECK (id >= 0),
    CONSTRAINT Chefe_de_cabine_pk PRIMARY KEY(id)
);

CREATE TABLE Aeroporto (
    cod VARCHAR(255) NOT NULL,
    localizacao VARCHAR(255) NOT NULL,
    pais VARCHAR(255) NOT NULL,
    CONSTRAINT Aeroporto_pk PRIMARY KEY(cod)
);

CREATE TABLE Rota (
    id INTEGER(10) AUTO_INCREMENT,
    milhas INTEGER(10) NOT NULL CHECK (milhas > 0),
    cod_aeroporto_orig VARCHAR(255) NOT NULL,
    cod_aeroporto_dest VARCHAR(255) NOT NULL,
    CONSTRAINT Rota_pk PRIMARY KEY(id)
);

CREATE TABLE Voo (
    matricula_aviao VARCHAR(255) NOT NULL,
    id_rota INTEGER(10) NOT NULL CHECK (id_rota >= 0),
    partida_prevista DATETIME NOT NULL,
    partida_realizada DATETIME,
    chegada_prevista DATETIME NOT NULL,
    chegada_realizada DATETIME,
    estado ENUM('planeado', 'realizado', 'em curso', 'cancelado') DEFAULT 'planeado',
    CONSTRAINT Voo_pk PRIMARY KEY (matricula_aviao, id_rota)
);

CREATE TABLE Cancelamento (
    id INTEGER(10) AUTO_INCREMENT,
    matricula_aviao VARCHAR(255) NOT NULL,
    id_rota INTEGER(10) NOT NULL,
    responsavel VARCHAR(255) NOT NULL,
    CONSTRAINT Cancelamento_pk PRIMARY KEY (id)
);

CREATE TABLE Razao (
    numero INTEGER(10) NOT NULL CHECK (numero >= 0),
    id_cancelamento INTEGER(10) NOT NULL,
    observacao VARCHAR(255) NOT NULL,
    CONSTRAINT Razao_pk PRIMARY KEY (numero, id_cancelamento)
);

CREATE TABLE Escala (
    id_rota INTEGER(10),
    cod_aeroporto VARCHAR(255) NOT NULL,
    ordem INTEGER(10) NOT NULL,
    CONSTRAINT Escala_pk PRIMARY KEY(cod_aeroporto, id_rota)

);

CREATE TABLE Comandante (
    id INTEGER(10),
    data_promocao DATE NOT NULL,
    horas_comando INTEGER(10) NOT NULL,
    CONSTRAINT Comandante_pk PRIMARY KEY (id)
);


INSERT INTO Aviao (matricula, autonomia_milhas, autonomia_horas, cap_executiva, cap_turistica, carga, contagem_horas_voo, milhas, marca, modelo, tipo, piloto_id, copiloto_id, chefe_de_cabine_id)
    VALUES
        ('A', 7627, '13:30:51', 30, 250, 13582, 261, 104376, "Airbus", "A330-900neo", "Comercial", 11, 21, 31),
        ('B', 10843, '19:35:50', 18, 154, 2000, 185, 239138, 1, 2, 1, 12, 22, 32),
        ('C', 5362, '11:00:55', 0, 42, 6255, 34, 186398, 1, 3, 2, 13, 23, 33),
        ('D', 1441, '06:12:29', 47, 135, 16242, 206, 333603, 1, 4, 1, 14, 24, 34),
        ('E', 7322, '12:26:15', 1, 25, 12999, 101, 141416, 1, 2, 2, 15, 25, 35),
        ('F', 8536, '07:53:02', 61, 120, 18322, 73, 258965, "Embraer", "Embraer190", "Comercial", 16, 26, 36),
        ('G', 3853, '12:16:22', 3, 24, 1304, 303, 163375, 1, 5, 2, 17, 27, 37),
        ('H', 6816, '02:44:14', 0, 37, 15391, 78, 117597, 2, 6, 2, 18, 28, 38),
        ('I', 8223, '10:37:24', 70, 201, 20000, 108, 163375, 3, 8, 1, 19, 29, 39),
        ('J', 290, '04:27:41', 0, 66, 5910, 48, 84299, "ATR", "A330-200", "Militar", 20, 30, 40);


-- Propria
INSERT INTO Empresa (tipo, preco)
VALUES (1, 8324.6345);

INSERT INTO Empresa (nome, preco)
VALUES
    ('K', 16930.9562),
    ('L', 9635.9627),
    ('M', 6339.8540),
    ('N', 18606.6876),
    ('O', 14779.1868),
    ('P', 5869.5689),
    ('Q', 16985.4682),
    ('R', 12330.9812),
    ('S', 3980.4365);

INSERT INTO Manutencao (matricula_aviao, nome_empresa)
    VALUES 
        ('A', 'K'),
        ('B', 'L'),
        ('C', 'M'),
        ('D', 'N'),
        ('E', 'O'),
        ('F', 'P'),
        ('G', 'Q'),
        ('H', 'R'),
        ('I', 'S'),
        ('J', 'A própria');
        
INSERT INTO Tripulante (id, matricula_aviao, nome, genero, morada, categoria, escalao)
    VALUES 
        (11,'A', 'C1','Masculino' , 'morada nº1', 'Comandante', 'Sénior'),
        (12,'B', 'C2', 3, 'morada nº2', 1, 2),
        (13,'C', 'C3', 1, 'morada nº3', 1, 1),
        (14,'D', 'C4', 1, 'morada nº4', 1, 3),
        (15,'E', 'C5', 2, 'morada nº5', 1, 3),
        (16,'F', 'C6', 2, 'morada nº6', 1, 2),
        (17,'G', 'C7', 2, 'morada nº7', 1, 2),
        (18,'H', 'C8', 1, 'morada nº8', 1, 1),
        (19,'I', 'C9', 2, 'morada nº9', 1, 2),
        (20,'J', 'C10', 2, 'morada nº10', 1, 1),
        (21,'A', 'P1', 'Masculino', 'morada nº11', 'Oficial Piloto', 'Intermédio'),
        (22,'B', 'P2', 2, 'morada nº12', 2, 3),
        (23,'C', 'P3', 3, 'morada nº13', 2, 2),
        (24,'D', 'P4', 2, 'morada nº14', 2, 1),
        (25,'E', 'P5', 1, 'morada nº15', 2, 2),
        (26,'F', 'P6', 1, 'morada nº16', 2, 2),
        (27,'G', 'P7', 1, 'morada nº17', 2, 1),
        (28,'H', 'P8', 2, 'morada nº18', 2, 3),
        (29,'I', 'P9', 2, 'morada nº19', 2, 2),
        (30,'J', 'P10', 2, 'morada nº20', 2, 1),
        (31,'A', 'CC1', 'Feminino', 'morada nº21', 'Chefe de Cabine', 'Sénior'),
        (32,'B', 'CC2', 2, 'morada nº22', 3, 1),
        (33,'C', 'CC3', 1, 'morada nº23', 3, 3),
        (34,'D', 'CC4', 2, 'morada nº24', 3, 1),
        (35,'E', 'CC5', 1, 'morada nº25', 3, 1),
        (36,'F', 'CC6', 1, 'morada nº26', 3, 1),
        (37,'G', 'CC7', 2, 'morada nº27', 3, 2),
        (38,'H', 'CC8', 1, 'morada nº28', 3, 3),
        (39,'I', 'CC9', 2, 'morada nº29', 3, 2),
        (40,'J', 'CC10', 1, 'morada nº30', 3, 2),
        (1,'A', 'PC1', 'Outros', 'morada nº31', 'Pessoal da Cabine', 'Junior'),
        (2,'B', 'PC2', 2, 'morada nº32', 3, 2),
        (3,'C', 'PC3', 1, 'morada nº33', 3, 1),
        (4,'D', 'PC4', 2, 'morada nº34', 3, 3),
        (5,'E', 'PC5', 1, 'morada nº35', 3, 1),
        (6,'F', 'PC6', 3, 'morada nº36', 3, 2),
        (7,'G', 'PC7', 2, 'morada nº37', 3, 1),
        (8,'H', 'PC8', 2, 'morada nº38', 3, 2),
        (9,'I', 'PC9', 2, 'morada nº39', 3, 3),
        (10,'J', 'PC10', 2, 'morada nº40', 3, 1);

INSERT INTO Piloto (id, data_emissao_licenca, nr_descolagens, nr_aterragens, horas_voo, licenca)
    VALUES
        (11,'2006-03-31 11:54:42', 3778, 3738, 1392, 'LP59'),
        (12,'2018-11-08 17:27:05', 3353, 3323, 1726, 'LP16'),
        (13,'2008-06-16 17:10:21', 4366, 4316, 2420, 'LP17'),
        (14,'2015-02-07 06:40:08', 1032, 1031, 2664, 'LP22'),
        (15,'2008-02-14 08:49:45', 4213, 4213, 1200, 'LP18'),
        (16,'2011-05-11 10:48:45', 1461, 1467, 1919, 'LP73'),
        (17,'2005-10-20 15:10:48', 675,   666, 2534, 'LP82'),
        (18,'2011-05-16 09:20:05', 4087, 4120, 2857, 'LP76'),
        (19,'2019-03-21 14:16:46', 4286, 4533, 1182, 'LP66'),
        (20,'2018-12-07 08:35:54', 2846, 2846, 2313, 'LP81'),
        (21,'2009-03-11 12:55:48', 323, 310, 473, 'LP15'),
        (22,'2016-03-12 09:39:31', 342, 248, 768, 'LP84'),
        (23,'2006-02-21 11:09:23', 212, 376, 822, 'LP79'),
        (24,'2001-03-19 13:25:23', 349, 262, 992, 'LP14'),
        (25,'2011-02-28 13:03:18', 403, 371, 773, 'LP83'),
        (26,'2012-05-16 17:07:55', 435, 309, 488, 'LP46'),
        (27,'2005-02-07 14:00:36', 223, 576, 449, 'LP11'),
        (28,'2008-07-21 08:09:37', 404, 214, 665, 'LP49'),
        (29,'2003-05-25 10:17:03', 479, 482, 881, 'LP60'),
        (30,'2009-11-30 07:23:15', 428, 241, 846, 'LP40');

INSERT INTO Situacao (matricula_aviao, nome_empresa, observacao)
    VALUES 
        ('A', 'K', 'still to be invented'),
        ('B', 'L', 'Weird Painting'),
        ('C', 'M', 'Broken Wheel'),
        ('D', 'N', 'Broken Button'),
        ('E', 'O', 'Broken Window'),
        ('F', 'P', 'Broken Door'),
        ('G', 'Q', 'Broken Toilet'),
        ('H', 'R', 'Broken Seat'),
        ('I', 'S', 'Broken Engine'),
        ('J', 'A própria', 'Broken Chassis');

INSERT INTO Chefe_de_cabine(id)
    VALUES
        (31),
        (32),
        (33),
        (34),
        (35),
        (36),
        (37),
        (38),
        (39),
        (40);

INSERT INTO Comandante (id, data_promocao, horas_comando)
    VALUES
        (11, "2020-12-07 14:26:31", 823),
        (12, "2020-10-23 16:00:53", 682),
        (13, "2020-06-17 08:27:47", 981),
        (14, "2019-04-22 10:56:47", 839),
        (15, "2020-09-28 08:46:09", 730),
        (16, "2019-03-30 06:05:44", 613),
        (17, "2020-11-26 10:56:17", 847),
        (18, "2019-09-05 07:15:29", 739),
        (19, "2020-11-22 12:36:34", 914),
        (20, "2019-08-14 13:45:22", 859);

INSERT INTO Aeroporto (cod, localizacao, pais)
    VALUES 
        ("ARPT1", "Barcelona", "Espanha"),
        ("ARPT2", "Vienna", "Austria"),
        ("ARPT3", "Stuttgart", "Alemanha"),
        ("ARPT4", "Guadalajara", "México"),
        ("ARPT5", "Lisboa", "Portugal"),
        ("ARPT6", "Vancouver", "Canadá"),
        ("ARPT7", "San Francisco", "Estados Unidos da América"),
        ("ARPT8", "Seoul", "Coreia do Sol"),
        ("ARPT9", "Kyoto", "Japão"),
        ("ARPT10", "Malmo", "Suécia");

INSERT INTO Rota (milhas, cod_aeroporto_orig, cod_aeroporto_dest)
    VALUES
        (905, "ARPT1", "ARPT10"),
        (234, "ARPT2", "ARPT9"),
        (173, "ARPT3", "ARPT8"),
        (8458, "ARPT4", "ARPT7"),
        (734, "ARPT5", "ARPT6"),
        (347, "ARPT6", "ARPT3"),
        (3727, "ARPT7", "ARPT2"),
        (436, "ARPT8", "ARPT7"),
        (945, "ARPT9", "ARPT4"),
        (745, "ARPT10", "ARPT7");


INSERT INTO Voo (matricula_aviao, id_rota, partida_prevista, partida_realizada, chegada_prevista, chegada_realizada, estado)
    VALUES 
        ('A' , 1, "2019:01:09 09:20:00", "2019:01:09 09:40:00", "2019:01:09 11:20:00", "2019:01:09 11:40:00", 4),
        ('B' , 2, "2019:01:10 09:20:00", "2019:01:10 09:20:00", "2019:01:10 11:20:00", "2019:01:10 11:20:00", 4),
        ('C' , 3, "2019:01:11 09:20:00", "2019:01:11 09:40:00", "2019:01:11 11:20:00", "2019:01:11 11:40:00", 4),
        ('D' , 4, "2019:01:12 09:20:00", "2019:01:12 09:20:00", "2019:01:12 11:20:00", "2019:01:12 11:20:00", 4),
        ('E' , 5, "2019:01:13 09:20:00", "2019:01:13 09:40:00", "2019:01:13 11:20:00", "2019:01:13 11:40:00", 4),
        ('F' , 6, "2019:01:14 09:20:00", "2019:01:14 09:40:00", "2019:01:14 11:20:00", "2019:01:14 11:40:00", 4),
        ('G' , 7, "2019:01:15 09:20:00", "2019:01:15 09:40:00", "2019:01:15 11:20:00", "2019:01:15 11:40:00", 4),
        ('H' , 8, "2019:01:16 09:20:00", "2019:01:16 09:20:00", "2019:01:16 11:20:00", "2019:01:16 11:20:00", 4),
        ('I' , 9, "2019:01:17 09:20:00", "2019:01:17 09:20:00", "2019:01:17 11:20:00", "2019:01:17 11:20:00", 4),
        ('J' , 10, "2019:01:18 09:20:00", "2019:01:18 09:20:00", "2019:01:18 11:20:00", "2019:01:18 11:20:00", 4);


INSERT INTO Cancelamento (id, matricula_aviao, id_rota, responsavel)
    VALUES
        ("1", 'A', 1, "Diretor do Departamento de Meteorologia"),
        ("2", 'B', 2, "Diretor do Departamento de Meteorologia"),
        ("3", 'C', 3, "Diretor do Departamento de Meteorologia"),
        ("4", 'D', 4, "Diretor do Departamento de Meteorologia"),
        ("5", 'E', 5, "IPMA"),
        ("6", 'F', 6, "Diretor do Departamento de Meteorologia"),
        ("7", 'G', 7, "Diretor de mecânica da EasyJet"),
        ("8", 'H', 8, "Diretor do Departamento de Meteorologia"),
        ("9", 'I', 9, "Diretor do Departamento de Meteorologia"),
        ("10", 'J', 10,  "Diretor do Departamento de Meteorologia");

INSERT INTO Razao (numero, id_cancelamento, observacao)
    VALUES
        (1, "1", "Condições atmosféricas adversas" ),
        (2, "2", "Condições atmosféricas adversas" ),
        (3, "3", "Condições atmosféricas adversas" ),
        (4, "4", "Condições atmosféricas adversas" ),
        (5, "5", "Condições atmosféricas adversas" ),
        (6, "6", "Condições atmosféricas adversas" ),
        (7, "7", "Anomalia no único avião disponível" ),
        (8, "8", "Condições atmosféricas adversas" ),
        (9, "9", "Condições atmosféricas adversas" ),
        (10, "10", "Condições atmosféricas adversas" );


INSERT INTO Escala (id_rota, cod_aeroporto, ordem)
    VALUES
        (1, "ARPT1", 1),
        (2, "ARPT2", 0),
        (3, "ARPT3", 0),
        (4, "ARPT4", 1),
        (5, "ARPT5", 1),
        (6, "ARPT6", 0),
        (7, "ARPT7", 2),
        (8, "ARPT8", 0),
        (9, "ARPT9", 1),
        (10, "ARPT10", 0);


ALTER TABLE Aviao
ADD CONSTRAINT Aviao_fk1 FOREIGN KEY (piloto_id) REFERENCES Comandante(id),
ADD CONSTRAINT Aviao_fk2 FOREIGN KEY (copiloto_id) REFERENCES Piloto(id),
ADD CONSTRAINT Aviao_fk3 FOREIGN KEY (chefe_de_cabine_id) REFERENCES Chefe_de_cabine(id);

ALTER TABLE Manutencao
ADD CONSTRAINT Manutencao_fk1 FOREIGN KEY (matricula_aviao) REFERENCES Aviao(matricula),
ADD CONSTRAINT Manutencao_fk2 FOREIGN KEY (nome_empresa) REFERENCES Empresa(nome);

ALTER TABLE Situacao
ADD CONSTRAINT Situacao_fk1 FOREIGN KEY (matricula_aviao) REFERENCES Aviao(matricula),
ADD CONSTRAINT Situacao_fk2 FOREIGN KEY (nome_empresa) REFERENCES Empresa(nome);

ALTER TABLE Tripulante
ADD CONSTRAINT Tripulante_fk FOREIGN KEY (matricula_aviao) REFERENCES Aviao(matricula);

ALTER TABLE Piloto
add CONSTRAINT Piloto_fk FOREIGN KEY (id) REFERENCES Tripulante(id);

ALTER TABLE Chefe_de_cabine
ADD CONSTRAINT Chefe_de_cabine_fk FOREIGN KEY (id) REFERENCES Tripulante(id);

ALTER TABLE Comandante
ADD CONSTRAINT Comandante_fk1 FOREIGN KEY (id) REFERENCES Piloto(id);

ALTER TABLE Rota
ADD CONSTRAINT Rota_fk1 FOREIGN KEY (cod_aeroporto_orig) REFERENCES Aeroporto(cod),
ADD CONSTRAINT Rota_fk2 FOREIGN KEY (cod_aeroporto_dest) REFERENCES Aeroporto(cod);

ALTER TABLE Voo
ADD CONSTRAINT Voo_fk1 FOREIGN KEY (matricula_aviao) REFERENCES Aviao(matricula),
ADD CONSTRAINT Voo_fk2 FOREIGN KEY (id_rota) REFERENCES Rota(id);

ALTER TABLE Cancelamento
ADD CONSTRAINT Cancelamento_fk1 FOREIGN KEY (matricula_aviao) REFERENCES Voo(matricula_aviao),
ADD CONSTRAINT Cancelamento_fk2 FOREIGN KEY (id_rota) REFERENCES Voo(id_rota);

ALTER TABLE Escala
ADD CONSTRAINT Escala_fk1 FOREIGN KEY (cod_aeroporto) REFERENCES Aeroporto(cod),
ADD CONSTRAINT Escala_fk2 FOREIGN KEY (id_rota) REFERENCES Rota(id);
