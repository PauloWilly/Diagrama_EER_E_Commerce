-- criação do banco de dados para o cenário de E-ccomerce
-- drop database ecommerce;
CREATE DATABASE ecommerce;
USE ecommerce;

-- criar tabela cliente

CREATE TABLE clients(
	idClient INT AUTO_INCREMENT PRIMARY KEY,
    Fname VARCHAR(15),
    Minit CHAR(3), 
    Lname VARCHAR(20),
    CPF CHAR(11) NOT NULL,
    Address VARCHAR(100),
    birth DATE, 
    CONSTRAINT unique_cpf_client UNIQUE (CPF)   
);

-- para não dar erro na inserção dos dados, incrementar a partir de uma sequencia como um todo usando alter table abaixo, sem isso o SGDB vai entender
-- que estou incrementando uma mesma variável para todas as tabelas
ALTER TABLE clients AUTO_INCREMENT=1;

desc clients;
-- criar tabela produto
-- size é a dimensão do produto
-- drop table product;
CREATE TABLE product(
	idProduct INT AUTO_INCREMENT PRIMARY KEY,
    Pname VARCHAR(45) NOT NULL,
    Pvalue varchar(45),
    classification_kids BOOL DEFAULT FALSE,
    category ENUM('Eletrônico', 'Vestimenta', 'Brinquedos', 'Alimentos', 'Móveis') NOT NULL,
    review FLOAT DEFAULT 0,
    size VARCHAR(10),
	Pdescription VARCHAR(45)
);
desc product;

-- tabela pagamento
-- para ser continuado no desafio: terminar de implementar a tablea e criar a conexão com as tabelas necessárias
-- refletir essa modificação no diagrama de esquema relacional
-- criar constraints relacionadas ao pagamento
-- parte 5 6:00 min fala sobre executar essa tabela depois

-- drop table type_payment;
CREATE TABLE type_payment(
	idtypepayment INT AUTO_INCREMENT PRIMARY KEY,
    type_payment VARCHAR(45) NOT NULL
);
desc type_payment;

-- criar tabela pedido
-- "idPayment" será uma foreign key
-- DROP TABLE orders;
CREATE TABLE orders(
	idOrder INT AUTO_INCREMENT PRIMARY KEY,
    IdOrderClient INT,
    orderStatus ENUM('Cancelado', 'Confirmado', 'Em processamento') DEFAULT 'Em processamento',
    orderDescription VARCHAR(255),
    sendValue FLOAT DEFAULT 10,
    CONSTRAINT fk_order_client FOREIGN KEY (idOrderClient) REFERENCES clients(idClient)
		ON UPDATE CASCADE
);

desc orders;

-- DROP TABLE productStorage;
-- criar tabela estoque
CREATE TABLE productStorage(
	idProdStorage INT AUTO_INCREMENT PRIMARY KEY,
    storageLocation VARCHAR(255),
    quantity INT DEFAULT 0
);

desc productStorage;

-- criar tabela fornecedor
CREATE TABLE supplier(
	idSupplier INT AUTO_INCREMENT PRIMARY KEY,
    socialName VARCHAR(255) NOT NULL,
    CNPJ CHAR(15) NOT NULL,
	contact CHAR(11) NOT NULL,
    CONSTRAINT unique_supplier UNIQUE (CNPJ)
);

desc supplier;

-- criar tabela vendedor
-- separar "terceiro - vendedor" em PF e PJ
CREATE TABLE seller(
	idSeller INT AUTO_INCREMENT PRIMARY KEY,
    socialName VARCHAR(255) NOT NULL,
    AbstName VARCHAR(255),
    CNPJ CHAR(15),
    location VARCHAR(255),
	contact CHAR(11) NOT NULL,
    CONSTRAINT unique_cnpj_seller UNIQUE (CNPJ)
);

desc seller;

-- tabelas com foreign keys
CREATE TABLE productSeller(
	idPseller INT,
    idPproduct INT,
    prodQuantity INT DEFAULT 1,
    PRIMARY KEY (idPseller, idPproduct),
    CONSTRAINT fk_product_seller FOREIGN KEY (idPseller) REFERENCES seller(idSeller),
    CONSTRAINT fk_product_product FOREIGN KEY (idPproduct) REFERENCES product(idProduct)
);

desc productSeller;

-- VERIFICAR O NOME DAS DUAS CONSTRAINTS (VERIFICADO)
CREATE TABLE productOrder(
	idPOproduct INT,
    idPOorder INT,
    poQuantity INT DEFAULT 1,
    poStatus ENUM('Disponível', 'Sem estoque') DEFAULT 'Disponível',
    PRIMARY KEY (idPOproduct, idPOorder),
    CONSTRAINT fk_productorder_product FOREIGN KEY (idPOproduct) REFERENCES product(idProduct),
    CONSTRAINT fk_productorder_orders FOREIGN KEY (idPOorder) REFERENCES orders(idOrder)
);

desc productOrder;
SELECT * FROM productOrder;

-- VERIFICAR O NOME DAS DUAS CONSTRAINTS
CREATE TABLE storageLocation(
	idLproduct INT,
    idLstorage INT,
    location VARCHAR(255) NOT NULL,
    PRIMARY KEY ENUM(idLproduct, idLstorage),
    CONSTRAINT fk_storage_location_product FOREIGN KEY (idLproduct) REFERENCES product(idProduct),
    CONSTRAINT fk_storage_location_storage FOREIGN KEY (idLstorage) REFERENCES productStorage(idProdStorage)
);

desc storageLocation;

-- CRIANDO MINHAS CONSTRAINTS SOZINHO
-- tabela PJ
-- DROP TABLE Pessoa_Juridica;
CREATE TABLE Pessoa_Juridica(
	idPJ INT AUTO_INCREMENT PRIMARY KEY,
    idPJclient INT,
    CNPJ CHAR(15) NOT NULL,
    AbstName VARCHAR(255),
    CONSTRAINT unique_PJ_CNPJ UNIQUE (CNPJ),
    CONSTRAINT fk_Pessoa_juridica_client FOREIGN KEY (idPJclient) REFERENCES clients(idClient)    
);
desc Pessoa_juridica;

-- tabela PF
CREATE TABLE Pessoa_Fisica(
	idPF INT AUTO_INCREMENT PRIMARY KEY,
    idPFclient INT,
    CPF CHAR(11) NOT NULL,
    RG VARCHAR(20) NOT NULL,
    sexo CHAR(1),
    CONSTRAINT unique_PF_CNPJ UNIQUE (CPF),
    CONSTRAINT unique_PF_RG UNIQUE (RG),
    CONSTRAINT fk_Pessoa_fisica_client FOREIGN KEY (idPFclient) REFERENCES clients(idClient)    
);
desc pessoa_fisica;

CREATE TABLE payment(
	idPayment INT AUTO_INCREMENT PRIMARY KEY,
    idPayTypePay INT,
    idPayOrders INT,
    idPayClient INT,
    Pvalue FLOAT(9,2) NOT NULL,
    CONSTRAINT fk_payment_typePay FOREIGN KEY (idPayTypePay) REFERENCES type_payment(idtypepayment),
    CONSTRAINT fk_payment_orders FOREIGN KEY (idPayOrders) REFERENCES orders(idOrder),
    CONSTRAINT fk_payment_client FOREIGN KEY (idPayClient) REFERENCES clients(idClient)
);
desc payment;

CREATE TABLE delivery(
	idDelivery INT AUTO_INCREMENT PRIMARY KEY,
    idDOrder INT,
    idDClient INT,
    Dstatus VARCHAR(45) NOT NULL,
    trackingCode VARCHAR(45) NOT NULL,
    address VARCHAR(45) NOT NULL,
    Dnumber VARCHAR(45) NOT NULL,
    neighborhood VARCHAR(45) NOT NULL,
    city VARCHAR(45) NOT NULL,
    state CHAR(2) NOT NULL,
    zipcode VARCHAR(10) NOT NULL,
    country VARCHAR(45),
    CONSTRAINT fk_delivery_orders FOREIGN KEY (idDOrder) REFERENCES orders(idOrder),
    CONSTRAINT fk_delivery_client FOREIGN KEY (idDClient) REFERENCES clients(idClient)
);
desc delivery;

CREATE TABLE productSupplier(
	idPsSupplier INT,
    idPsProduct INT,
    quantity INT NOT NULL,
    PRIMARY KEY (idPsSupplier, idPsProduct),
	CONSTRAINT fk_product_supplier_supplier FOREIGN KEY (idPsSupplier) REFERENCES supplier(idSupplier),
    CONSTRAINT fk_product_supplier_product FOREIGN KEY (idPsProduct) REFERENCES product(idProduct)
);
desc productsupplier;
SELECT * FROM productSupplier;
show tables;

-- use information_schema;
-- show tables;
-- desc referential_constraints;
-- vizualizando as fks de ecommerce
-- select * from referential_constraints where constraint_schema = 'ecommerce';





