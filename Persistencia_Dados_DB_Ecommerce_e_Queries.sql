-- PERSISTENCIA DOS DADOS E QUERIES NAS TABELAS DO DB ECOMMERCE
USE ecommerce;

SHOW TABLES;

-- idClient, Fname, Minit, Lname, CPF, Address, birth
INSERT INTO Clients (Fname, Minit, Lname, CPF, Address, birth)
	VALUES('Maria', 'M', 'Silva', '123456789', 'Rua Silva de Prata 29, Carangola - Cidade das Flores', '1968-12-01'),
		  ('Mathues', 'O', 'Pimentel', '987654321', 'Rua Alemeda 289, Centro - Cidade das Flores', '1963-05-19'),
          ('Ricardo', 'F', 'Silva', '45678913', 'Avenida Alemeda Vinha 1009, Centro - Cidade das Flores', '1962-10-23'),
          ('Julia', 'S', 'França', '789123456', 'Rua Laranjeiras 861, Centro - Cidade das Flores', '1993-10-24'),
          ('Roberta', 'G', 'Assis', '98745631', 'Avenida Loller 19, Centro - Cidade das Flores', '1994-05-05'),
          ('Isabela', 'M', 'Cruz', '654789123', 'Rua Alemeda das Flores 28, Centro - Cidade das Flores', '1992-08-05');
          
SELECT * FROM clients;
          
-- idProduct, Pname, Pvalue, classification_kids boolean, category('Eletrônico', 'Vestimenta', 'Brinquedos', 'Alimentos', 'Móveis'), review, size, Pdescription
INSERT INTO product(Pname, classification_kids, category, review, size, Pdescription )
	VALUES('Fone de Ouvido', FALSE, 'Eletrônico', '4', NULL, NULL),
		  ('Barbie Elsa', TRUE, 'Brinquedos', '3', NULL, NULL),
          ('Body Carters', TRUE, 'Vestimenta', '5', NULL, NULL),
          ('Microfone Vedo - Youtuber', FALSE, 'Eletrônico', '4', NULL, NULL),
          ('Sofá Retrátil', FALSE, 'Móveis', '3', '3x57x80', NULL),
          ('Farinha de Arroz', FALSE, 'Alimentos', '2', NULL, NULL),
          ('Fire Stick Amazon', FALSE, 'Eletrônico', '4', NULL, NULL);
          
SELECT * FROM product;

INSERT INTO orders(idOrderClient, orderStatus,orderDescription, sendValue) 
	VALUES (1, DEFAULT, 'compra via aplicativo', DEFAULT),
		   (2, DEFAULT, 'compra via aplicativo', 50),
           (3, 'confirmado', NULL, DEFAULT),
           (4, DEFAULT, 'compra via web site', 150);

           
SELECT * FROM orders;
           
-- idPOproduct, idPOorder, poQuantity, poStatus
INSERT INTO productOrder (idPOproduct, idPOorder, poQuantity, poStatus) 
	VALUES(1,1,2,DEFAULT),
		  (2,1,1,DEFAULT),
          (3,3,1,DEFAULT);
          
SELECT * FROM PRODUCTORDER;
          
-- strageLocation, quantity
INSERT INTO productStorage(storageLocation, quantity)
	VALUES ('Rio de Janeiro', 1000),
		   ('Rio de Janeiro', 500),
           ('São Paulo', 10),
           ('São Paulo', 100),
           ('São Paulo', 10),
           ('Brasília', 60);
           
INSERT INTO storageLocation (idLproduct, idLstorage, location)
	VALUES (1,2,'RJ'),
           (2,6,'GO');
           
INSERT INTO supplier (SocialName, CNPJ, contact)
	VALUES ('Almeida e filhos', '123456789123456', '21985474'),
		   ('Eletrônicos Silva', '854519649143457', '21955474'),
           ('Eletrônicos Valma', '934567893934695', '21925474');

SELECT * FROM supplier;

INSERT INTO productSupplier (idPsSupplier, idPsProduct, quantity)
	VALUES (1,1,500),
		   (1,2,400),
           (2,4,633),
           (3,3,5),
           (2,5,10);
           
INSERT INTO seller (socialName, AbstName, CNPJ, location, contact)
	VALUES ('Tech eletronics', NULL, 123456789456321, 'Rio de Janeiro', 219946287),
		   ('Botique Durgas', NULL, 123456783, 'Rio de Janeiro', 219567895),
           ('kIDS World', NULL, 456789123654485, 'São Paulo', 1198657484);
           
SELECT * FROM seller;

INSERT INTO productSeller (idPseller, idPproduct, prodQuantity)
	VALUES (1,6,80),
		   (2,7,10);
           
SELECT * FROM productSeller;

-- QUERIES
-- recuperando número de clientes
SELECT count(*) from clients;

-- listar os pedidos feitos pelos clientes
SELECT * FROM clients c, orders o where c.idclient = idOrderClient;

-- especificando os atributos
SELECT Fname, Lname, idOrder, orderStatus FROM clients c, orders o where c.idclient = idOrderClient;
-- concatenando o nome
SELECT concat(Fname, ' ', Lname) as Client, idOrder as Request, orderStatus as Status FROM clients c, orders o where c.idclient = idOrderClient;

-- AGRUPANDO COM order by
INSERT INTO orders(idOrderClient, orderStatus,orderDescription, sendValue) 
	VALUES (2, DEFAULT, 'compra via web site', NULL);
    
SELECT count(*) FROM clients c, orders o
			where c.idclient = idOrderClient;
            
-- recupero tb clientes que não fizeram nenhum tipo de pedido, que não solicitaram nada
SELECT * FROM clients LEFT OUTER JOIN orders ON idClient = idOrderClient;

SELECT * FROM productOrder;

-- recuperação de pedido com produto associado
SELECT * FROM clients c 
			INNER JOIN orders o ON c.idClient = o.idOrderClient
			INNER JOIN productOrder p ON p.idPOorder = o.idOrder
	GROUP BY idClient;

-- Recuperar quantos pedidos foram realizados pelos clientes
SELECT c.idClient, Fname, count(*) as Number_of_orders FROM clients c 
			INNER JOIN orders o ON c.idClient = o.idOrderClient
	GROUP BY idClient;

-- malhis quotaos
show tables;
select * from clients;
select * from product;
select * from orders;
select * from payment;
select * from productseller;
select * from productstorage;
select * from productsupplier;
select * from seller;
select * from storagelocation;
select * from supplier;
select * from type_payment;

-- Selecionando Nome e CPF dos Clientes
SELECT concat(Fname, ' ', Lname) Nome, CPF from clients;

-- Relação de nomes dos fornecedores e nomes dos produtos;
SELECT  socialName Fornecedores, Pname as Produtos FROM supplier RIGHT JOIN product ON idsupplier=idProduct;

-- Algum vendedor também é fornecedor?
SELECT v.socialName Empresa FROM seller v, supplier f WHERE v.CNPJ=f.CNPJ;

-- Relação Produto Fornecedor trazendo a quantidade e o tipo do produto   
SELECT Pname as Produto, category as Categoria, ps.quantity as Qtd_Solicitada FROM product
	inner join productSupplier ps on ps.idPsProduct=idProduct;
    
-- ordenando os produtos por categoria    
SELECT category Categoria, Pname as Produtos FROM product ORDER BY category;

-- Selecionando cliente que tem mais de 1 pedido
SELECT concat(Fname, ' ', Lname) Nome, CPF from clients
	inner join orders on idorderclient=idclient
    group by idorderclient
    having count(*)>1;

           

    