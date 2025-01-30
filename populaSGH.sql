INSERT INTO Unidade_de_hotel (status_atividade, registro_imobiliario, caixa_entrada, caixa_saida, num_vagas, id_hotel, local_hot, categoria_hot, nome_fantasia_hot, tamanho_hot)
VALUES
(true, 123456, 10000000.00, 50000.00, 20, 1, 'Rio de Janeiro', 'Luxo', 'Hotel Maravilha', 'Grande'),
(true, 789012, 80000000.00, 30500.00, 30, 2, 'São Paulo', 'Médio', 'Hotel Paulista', 'Médio'),
(true, 345678, 60000000.00, 1000000.00, 10, 3, 'Brasília', 'Econômico', 'Hotel Brasília', 'Pequeno'),
(true, 901234, 15000000.00, 8000000.00, 15, 4, 'Salvador', 'Luxo', 'Hotel Bahia', 'Grande'),
(true, 567890, 12000000.00, 6000000.00, 25, 5, 'Fortaleza', 'Médio', 'Hotel Fortaleza', 'Médio');


INSERT INTO Lobby (preco_por_m2, numero_cond_disponiveis, id_lobby, fk_Unidade_de_hotel)
VALUES
(5000.00, 5, 11, 1),
(4000.00, 10, 22, 2),
(6000.00, 2, 33, 3),
(4500.00, 7, 44, 4),
(5500.00, 4, 55, 5);


INSERT INTO Cliente (cpf, nome_cli, sobrenome, telefone, email, pontos)
VALUES
(12345678901, 'Ana', 'Souza', 1123456789, 'ana.souza@email.com', 80),
(23456789012, 'João', 'Silva', 1198765432, 'joao.silva@email.com', 0),
(34567890123, 'Maria', 'Oliveira', 1134567890, 'maria.oliveira@email.com', 90),
(45678901234, 'Carlos', 'Pereira', 1145678901, 'carlos.pereira@email.com', 0),
(56789012345, 'Paula', 'Costa', 1156789012, 'paula.costa@email.com', 80);



INSERT INTO Acomodacao (registro_acomodacao, tipo_acomodacao, politica_de_uso, capacidade_maxima_acomodacao, status_acomodacao, ponto_atribuido, fk_id_hotel, valor_ac)
VALUES
(101, 'Suíte', '\\x54686973206973206120707269766174652061636f6d6d6f646174696f6e2e', 4, 'Disponível', 100, 1, 1200.00),
(102, 'Quarto', '\\x54686973206973206120636f6d666f727461626c6520', 2, 'OCUPADO', 80, 2, 700.00),
(103, 'Suíte', '\\x536c656570206f7665726e6967687420616e642074686520616c69676e6d656e742e', 3, 'Disponível', 90, 3, 800.00),
(104, 'Quarto', '\\x54686973206973206120646573636f727269626564206361736520616e6420636f6d666f727461626c652e', 2, 'Disponível', 110, 4, 900.00),
(105, 'Suíte', '\\x54686973206973206120736d616c6c20706572736f6e616c697a656420616e64206578636c757365206663206c6976652e', 5, 'OCUPADO', 120, 5, 1500.00);


INSERT INTO Reservas (registro_reserva, status_res, preco_reserva, data_e_hora_checkin, data_e_hora_checkout, custos_adicionais_reserva, preco_total_reserva, fk_cpf_cliente, fk_id_hotel, fk_registro_acomodacao, no_pessoas)
VALUES
(201, false, 1200.00, '2024-12-28 14:00:00', '2024-12-29 14:00:00', 0.00, 1200.00, 12345678901, 1, 101, 2),
(202, true, 700.00, '2024-11-29 16:00:00', '2024-11-30 16:00:00', 500.00, 1200.00, 23456789012, 2, 102, 1),
(203, false, 800.00, '2024-12-01 18:00:00', '2024-12-02 18:00:00', 0.00, 800.00, 34567890123, 3, 103, 1),
(204, false, 900.00, '2024-12-02 12:00:00', '2024-12-03 12:00:00', 0.00, 900.00, 45678901234, 4, 104, 4),
(205, true, 1500.00, '2024-11-29 14:00:00', '2024-11-30 14:00:00', 805.00, 2305.00, 56789012345, 5, 105, 2);

INSERT INTO Reservas (registro_reserva, status_res, preco_reserva, data_e_hora_checkin, data_e_hora_checkout, custos_adicionais_reserva, preco_total_reserva, fk_cpf_cliente, fk_id_hotel, fk_registro_acomodacao, no_pessoas)
VALUES
(206, false, 700.00, '2024-12-05 10:00:00', '2024-12-06 10:00:00', 0.00, 700.00, 23456789012, 2, 102, 1);

--update dos valores dos custos adicionais para cada reserva clevando em consideração a reserva das vagas de estacionamento
UPDATE Reservas
SET custos_adicionais_reserva = 
    CASE 
        WHEN fk_cpf_cliente = 23456789012 THEN custos_adicionais_reserva + 200
        WHEN fk_cpf_cliente = 56789012345 THEN custos_adicionais_reserva + 100
        ELSE custos_adicionais_reserva
    END
WHERE fk_cpf_cliente IN (23456789012, 56789012345);

UPDATE Reservas
SET preco_total_reserva = 
    CASE 
        WHEN fk_cpf_cliente = 23456789012 THEN preco_total_reserva + 200
        WHEN fk_cpf_cliente = 56789012345 THEN preco_total_reserva + 100
        ELSE preco_total_reserva
    END
WHERE fk_cpf_cliente IN (23456789012, 56789012345);



--update dos valores dos custos adicionais para cada reserva clevando em consideração a reserva dos espaços de evento
UPDATE Reservas
SET custos_adicionais_reserva = 
    CASE 
        WHEN fk_cpf_cliente = 23456789012 THEN custos_adicionais_reserva + 200
        WHEN fk_cpf_cliente = 56789012345 THEN custos_adicionais_reserva + 300
        ELSE custos_adicionais_reserva
    END
WHERE fk_cpf_cliente IN (23456789012, 56789012345);

UPDATE Reservas
SET preco_total_reserva = 
    CASE 
        WHEN fk_cpf_cliente = 23456789012 THEN preco_total_reserva + 200
        WHEN fk_cpf_cliente = 56789012345 THEN preco_total_reserva + 300
        ELSE preco_total_reserva
    END
WHERE fk_cpf_cliente IN (23456789012, 56789012345);




-- Inserir dados na tabela 'Consumo'
INSERT INTO Consumo (id_consumo, preco_total_con, fk_registro_reserva) 
VALUES
    (10, 0.00, 201),
    (20, 350.00, 202),
    (30, 0.00, 203),
    (40, 0.00, 204),
    (50, 555.00, 205);


-- Inserir dados na tabela 'Delivery'
INSERT INTO Delivery (id_entrega, data_del, empresa_associada, valor_total, fk_registro_acomodacao) 
VALUES
    (005, '2024-11-29 17:00:00', 'FoodExpress', 65.00, 105),
    (055, '2024-11-29 18:30:00', 'FoodExpress', 50.00, 105),
    (555, '2024-11-29 14:15:00', 'QuickFood', 10.00, 105),
    (500, '2024-11-29 15:00:00', 'FoodExpress', 50.00, 105),
    (550, '2024-11-29 16:45:00', 'QuickFood', 30.00, 105);


-- Inserir dados na tabela 'Produto_Delivery'
INSERT INTO Produto_Delivery (id_produto, nome_produto, preco_unitario, fk_id_entrega, quantidade) 
VALUES
    (1, 'Pizza', 65.00, 005, 1),
    (2, 'Hambúrguer', 50.00, 055, 1),
    (3, 'Refrigerante', 10.00, 555, 1),
    (4, 'Salada', 50.00, 500, 1),
    (5, 'Torta', 30.00, 550, 1);


-- Inserir dados na tabela 'Vagas_Estacionamento'
INSERT INTO Vagas_Estacionamento (numero_da_vaga, status_disponibilidade, custo_por_dia, tipo_vaga)
VALUES
    (1, true, 50.00, 'Não Coberta'),
    (2, false, 50.00, 'Não Coberta'),
    (3, true, 100.00, 'Coberta'),
    (4, true, 50.00, 'Não Coberta'),
    (5, false, 50.00, 'Não Coberta');


    -- Inserir dados na tabela 'Area_Comum'
INSERT INTO Area_Comum (id_area_comum, tipo_a_c, nome_a_c, horario_abertura, capacidade_max_a_c, local_a_c, status_a_c, fk_id_hotel, horario_fechamento)
VALUES
    (1, 'Piscina', 'Piscina Pequena', '08:30:00', 50, 'Área externa', 'Disponível', 1, '20:30:00'),
    (2, 'Piscina', 'Piscina Média', '09:00:00', 100, 'Área externa', 'Disponível', 2, '21:00:00'),
    (3, 'Piscina', 'Piscina Grande', '07:45:00', 150, 'Área externa', 'Disponível', 3, '19:45:00'),
    (4, 'Piscina', 'Piscina Infantil', '10:00:00', 30, 'Área externa', 'Disponível', 4, '20:30:00'),
    (5, 'Piscina', 'Piscina Aquecida', '09:30:00', 100, 'Área externa', 'Disponível', 5, '21:00:00'),
    (6, 'Academia', 'Academia Compacta', '06:00:00', 20, 'Área interna', 'Disponível', 1, '22:00:00'),
    (7, 'Academia', 'Academia Avançada', '05:30:00', 40, 'Área interna', 'Disponível', 2, '23:00:00'),
    (8, 'Academia', 'Academia Luxo', '06:15:00', 25, 'Área interna', 'Disponível', 3, '21:45:00'),
    (9, 'Academia', 'Academia Premium', '07:00:00', 30, 'Área interna', 'Disponível', 4, '22:30:00'),
    (10, 'Academia', 'Academia Simples', '05:00:00', 15, 'Área interna', 'Disponível', 5, '20:00:00'),
    (11, 'Sala de Eventos', 'Sala Grande', '08:00:00', 200, 'Área interna', 'Disponível', 1, '22:00:00'),
    (12, 'Sala de Eventos', 'Sala Média', '09:00:00', 150, 'Área interna', 'Disponível', 2, '21:30:00'),
    (13, 'Sala de Eventos', 'Sala Compacta', '07:30:00', 100, 'Área interna', 'Disponível', 3, '20:30:00'),
    (14, 'Sala de Eventos', 'Sala Luxo', '10:00:00', 250, 'Área interna', 'Disponível', 4, '23:00:00'),
    (15, 'Sala de Eventos', 'Sala VIP', '06:45:00', 80, 'Área interna', 'Disponível', 5, '22:45:00'),
    (16, 'Espaço de Eventos', 'Auditório Grande', '08:00:00', 500, 'Área interna', 'Disponível', 1, '23:00:00'),
    (17, 'Espaço de Eventos', 'Auditório Médio', '09:00:00', 300, 'Área interna', 'Disponível', 2, '22:00:00'),
    (18, 'Espaço de Eventos', 'Sala de Convenções', '07:30:00', 350, 'Área interna', 'Disponível', 3, '21:30:00'),
    (19, 'Espaço de Eventos', 'Anfiteatro', '10:00:00', 400, 'Área externa', 'Disponível', 4, '22:45:00'),
    (20, 'Espaço de Eventos', 'Centro de Convenções', '07:00:00', 600, 'Área externa', 'Disponível', 5, '00:00:00'),
    (21, 'Restaurante', 'Restaurante Gourmet', '12:00:00', 80, 'Área interna', 'Disponível', 1, '22:30:00'),
    (22, 'Restaurante', 'Restaurante Buffet', '07:00:00', 150, 'Área interna', 'Disponível', 2, '23:00:00'),
    (23, 'Restaurante', 'Restaurante à la Carte', '11:30:00', 100, 'Área interna', 'Disponível', 3, '21:45:00'),
    (24, 'Restaurante', 'Restaurante Familiar', '06:45:00', 120, 'Área interna', 'Disponível', 4, '22:00:00'),
    (25, 'Restaurante', 'Restaurante Exclusivo', '10:30:00', 60, 'Área interna', 'Disponível', 5, '20:30:00');


-- Inserir dados na tabela 'Espaço_Eventos'
INSERT INTO Espaco_Eventos (fk_id_area_comum, fk_id_hotel)
VALUES
    (16, 1), 
    (17, 2), 
    (18, 3), 
    (19, 4), 
    (20, 5); 


-- Inserir dados na tabela 'Requisicao_Chatbot'
INSERT INTO Requisicao_Chatbot (id_requisicao, status_req, atendedor_req, data_abertura_req, data_fechamento_req, tipo_req, descricao_req, fk_cpf_client, fk_id_hotel)
VALUES
    (1, 'Resolvido', 'Carlos Assistente', '2024-11-29 18:05:00', '2024-11-29 18:30:00', 'Informação', 'Consulta sobre horário do café da manhã.', 23456789012, 2),
    (2, 'Resolvido', 'Carlos Assistente', '2024-11-29 22:10:00', '2024-11-29 23:30:00', 'Manutenção', 'Relato de problema na televisão.', 23456789012, 2),
    (3, 'Resolvido', 'João Assistente', '2024-11-29 16:15:00', '2024-11-29 16:50:00', 'Manutenção', 'Relato de problema no ar-condicionado.', 56789012345, 5),
    (4, 'Resolvido', 'João Assistente', '2024-11-30 16:45:00', '2024-11-30 16:50:00', 'Serviço Extra', 'Pedido de informações sobre os detalhes da reserva.', 56789012345, 5),
    (5, 'Resolvido', 'João Assistente', '2024-11-30 06:20:00', '2024-11-30 07:05:00', 'Informação', 'Consulta sobre horário do café da manhã', 56789012345, 5);


-- Inserir dados na tabela 'Descartaveis'
INSERT INTO Descartaveis (quantidade_gasta, tipo_amen, nome_amen, quantidade_disponivel)
VALUES
    (2, 'Sabonete', 'Sabonete Grande 150g', 120),
    (3, 'Shampoo', 'Shampoo Grande 300ml', 100),
    (1, 'Condicionador', 'Condicionador 250ml', 100),
    (5, 'Papel Higiênico', 'Papel Higiênico 12 rolos', 200),
    (1, 'Pasta de Dentes', 'Pasta de Dentes 100ml', 50);


    --atualizando as tuplas com os valores gastos pelas áreas comuns e pelas acomodações!:
    UPDATE Descartaveis
    SET quantidade_gasta = 100
    WHERE tipo_amen = 'Sabonete';

    UPDATE Descartaveis
    SET quantidade_gasta = 10
    WHERE tipo_amen = 'Shampoo';

    UPDATE Descartaveis
    SET quantidade_gasta = 10
    WHERE tipo_amen = 'Condicionador';

    UPDATE Descartaveis
    SET quantidade_gasta = 110
    WHERE tipo_amen = 'Papel Higiênico';

    UPDATE Descartaveis
    SET quantidade_gasta = 10
    WHERE tipo_amen = 'Pasta de Dentes';


    -- Inserir dados na tabela 'Nao_Descartaveis'
INSERT INTO Nao_Descartaveis (quantidade_usada, quantidade_em_uso, tipo_amen, nome_amen, quantidade_disponivel)
VALUES
    (2, 8, 'Toalha de Rosto', 'Toalha de Rosto Pequena', 200),
    (3, 7, 'Roupão', 'Roupão tamanho M', 150),
    (1, 5, 'Toalha de Banho', 'Toalha de Banho Grande', 150),
    (4, 6, 'Edredon', 'Edredon Cama Queen Size', 100),
    (2, 9, 'Cobre leito', 'Cobre leito Cama Queen Size', 200);
    --atualizando as tuplas com os valores gastos pelas áreas comuns e pelas acomodações!:
    UPDATE Nao_Descartaveis
    SET quantidade_em_uso = 105
    WHERE tipo_amen = 'Toalha de Rosto';

    UPDATE Nao_Descartaveis
    SET quantidade_em_uso = 15
    WHERE tipo_amen = 'Roupão';

    UPDATE Nao_Descartaveis
    SET quantidade_em_uso = 115
    WHERE tipo_amen = 'Toalha de Banho';

    UPDATE Nao_Descartaveis
    SET quantidade_em_uso = 15
    WHERE tipo_amen = 'Edredon';

    UPDATE Nao_Descartaveis
    SET quantidade_em_uso = 15
    WHERE tipo_amen = 'Cobre leito';



-- Inserir dados na tabela 'Piscina'
INSERT INTO Piscina (classificacao_indicativa, profundidade, categoria_piscina, fk_id_area_comum)
VALUES
    (10, 0.90, 'Pequena', 1), -- Classificação 1 = Infantil
    (16, 1.20, 'Média', 2), -- Classificação 2 = Junevil
    (18, 1.50, 'Grande', 3), -- Classificação 3 = Adulto
    (5, 0.50, 'Infantil', 4), -- Classificação 4 = 
    (16, 1.30, 'Aquecida', 5);
-- Inserir dados na tabela 'Academia'

INSERT INTO Academia (fk_id_area_comum, modalidade, horario_abertura, horario_fechamento)
VALUES
    (6, 'Musculação', '06:00:00', '23:00:00'),
    (7, 'Aeróbico', '06:00:00', '23:00:00'),
    (8, 'Yoga', '07:00:00', '22:45:00'),
    (9, 'Pilates', '07:00:00', '22:45:00'),
    (10, 'Cardio', '06:00:00', '23:00:00');


-- Inserir dados na tabela 'Academia_Amen_Desc'
INSERT INTO Academia_Amen_Desc (fk_tipo_amenidade, fk_id_area_comum, quantidade_oferecida)
VALUES
    ('Sabonete', 6, 30),
    ('Sabonete', 7, 15),
    ('Sabonete', 8, 15),
    ('Sabonete', 9, 15),
    ('Sabonete', 10, 15);


INSERT INTO Academia_Amen_Desc (fk_tipo_amenidade, fk_id_area_comum, quantidade_oferecida)
VALUES
    ('Papel Higiênico', 6, 10),
    ('Papel Higiênico', 7, 10),
    ('Papel Higiênico', 8, 10),
    ('Papel Higiênico', 9, 10),
    ('Papel Higiênico', 10, 10);


-- Inserir dados na tabela 'Academia_Amen_Nao'
INSERT INTO Academia_Amen_Nao (fk_tipo_amenidade, fk_id_area_comum, quantidade_oferecida)
VALUES
    ('Toalha de Rosto', 6, 30),
    ('Toalha de Rosto', 7, 15),
    ('Toalha de Rosto', 8, 15),
    ('Toalha de Rosto', 9, 15),
    ('Toalha de Rosto', 10, 15);


-- Inserir dados na tabela 'Piscina_Amen_Desc'
INSERT INTO Piscina_Amen_Desc (fk_tipo_amenidade, fk_id_area_comum, quantidade_oferecida)
VALUES
    ('Papel Higiênico', 1, 10),  
    ('Papel Higiênico', 2, 10), 
    ('Papel Higiênico', 3, 10),  
    ('Papel Higiênico', 4, 10), 
    ('Papel Higiênico', 5, 10);  

-- Inserir dados na tabela 'Piscina_Amen_Nao'
INSERT INTO Piscina_Amen_Nao (fk_tipo_amenidade, fk_id_area_comum, quantidade_oferecida)
VALUES
    ('Toalha de Banho', 1, 20),
    ('Toalha de Banho', 2, 20),
    ('Toalha de Banho', 3, 20),
    ('Toalha de Banho', 4, 20),
    ('Toalha de Banho', 5, 20);

-- Inserir dados na tabela 'Acomodacao_Amen_Desc'
INSERT INTO Acomodacao_Amen_Desc (fk_tipo_amenidade, fk_registro_acomodacao, quantidade_oferecida)
VALUES
    ('Sabonete', 101, 2),
    ('Sabonete', 102, 2),
    ('Sabonete', 103, 2),
    ('Sabonete', 104, 2),
    ('Sabonete', 105, 2),

    ('Shampoo', 101, 2),
    ('Shampoo', 102, 2),
    ('Shampoo', 103, 2),
    ('Shampoo', 104, 2),
    ('Shampoo', 105, 2),

    ('Condicionador', 101, 2),
    ('Condicionador', 102, 2),
    ('Condicionador', 103, 2),
    ('Condicionador', 104, 2),
    ('Condicionador', 105, 2),

    ('Papel Higiênico', 101, 2),
    ('Papel Higiênico', 102, 2),
    ('Papel Higiênico', 103, 2),
    ('Papel Higiênico', 104, 2),
    ('Papel Higiênico', 105, 2),

    ('Pasta de Dentes', 101, 2),
    ('Pasta de Dentes', 102, 2),
    ('Pasta de Dentes', 103, 2),
    ('Pasta de Dentes', 104, 2),
    ('Pasta de Dentes', 105, 2);


-- Inserir dados na tabela 'Acomodacao_Amen_Nao'
INSERT INTO Acomodacao_Amen_Nao (fk_tipo_amenidade, fk_registro_acomodacao, quantidade_oferecida)
VALUES
    ('Toalha de Banho', 101, 3),
    ('Toalha de Banho', 102, 3),
    ('Toalha de Banho', 103, 3),
    ('Toalha de Banho', 104, 3),
    ('Toalha de Banho', 105, 3);


-- Inserir dados na tabela 'Acomodacao_Amen_Nao'
INSERT INTO Acomodacao_Amen_Nao (fk_tipo_amenidade, fk_registro_acomodacao, quantidade_oferecida)
VALUES
    ('Toalha de Rosto', 101, 3),
    ('Toalha de Rosto', 102, 3),
    ('Toalha de Rosto', 103, 3),
    ('Toalha de Rosto', 104, 3),
    ('Toalha de Rosto', 105, 3),

    ('Roupão', 101, 3),
    ('Roupão', 102, 3),
    ('Roupão', 103, 3),
    ('Roupão', 104, 3),
    ('Roupão', 105, 3),

    ('Edredon', 101, 3),
    ('Edredon', 102, 3),
    ('Edredon', 103, 3),
    ('Edredon', 104, 3),
    ('Edredon', 105, 3),

    ('Cobre leito', 101, 3),
    ('Cobre leito', 102, 3),
    ('Cobre leito', 103, 3),
    ('Cobre leito', 104, 3),
    ('Cobre leito', 105, 3);




-- Inserir dados na tabela 'Controle_Amenidades'
INSERT INTO Controle_Amenidades (fk_tipo_amenidades, fk_id_area_comum, fk_cpf_cliente, quantidade_em_uso)
VALUES
    ('Toalha de Rosto', 8, 23456789012, 1),  
    ('Toalha de Rosto', 7, 23456789012, 1),  
    ('Toalha de Banho', 1, 56789012345, 1),  
    ('Toalha de Banho', 2, 56789012345, 1),  
    ('Toalha de Banho', 3, 56789012345, 1);  



    -- Inserir dados na tabela 'Restaurante'
INSERT INTO Restaurante (fk_id_area_comum)
VALUES
    (21), -- 'Restaurante Gourmet'
    (22), -- 'Restaurante Buffet'
    (23), -- 'Restaurante à la Carte'
    (24), -- 'Restaurante Familiar'
    (25); -- 'Restaurante Exclusivo'



-- Inserir dados na tabela 'Sala_de_Eventos'
INSERT INTO Sala_de_Eventos (fk_id_area_comum)
VALUES
    (11),  -- Sala Grande
    (12),  -- Sala Média
    (13),  -- Sala Compacta
    (14),  -- Sala Luxo
    (15);  -- Sala VIP



-- Inserir dados na tabela 'Equipamentos'
INSERT INTO Equipamentos (id_equipamento, nome_equipamento, status_equipamento, fk_id_area_comum)
VALUES
    (1, 'Esteira', 'Disponível', 6),
    (2, 'Bicicleta Ergométrica', 'Disponível', 6),
    (3, 'Halteres', 'Disponível', 7),
    (4, 'Leg Press', 'Em manutenção', 8),
    (5, 'Supino', 'Disponível', 9);


-- Inserir dados na tabela 'Estoque'
INSERT INTO Estoque (ingrediente, quantidade_ing, tipo_ing, validade_ing, fk_id_area_comum, fk_id_hotel)
VALUES
    ('Tomate', 50, 'Legume', '2024-12-15', 21, 1),
    ('Alface', 30, 'Verdura', '2024-12-10', 22, 2),
    ('Arroz', 100, 'Grão', '2025-02-20', 23, 3),
    ('Frango', 20, 'Proteína', '2024-11-30', 24, 4),
    ('Peixe', 40, 'Proteína', '2024-12-25', 25, 5);



-- Inserir dados na tabela 'Robo_Social'
INSERT INTO Robo_Social (fk_id_hotel, id_robo_social)
VALUES
    (1, 10),
    (2, 11),
    (3, 12),
    (4, 13),
    (5, 14);


-- Inserir dados na tabela 'Locker'
INSERT INTO Locker (numero_locker, capacidade_locker_litros, disponibilidade_locker, preço_hora_locker, fk_id_hotel)
VALUES
    (1, 40.00, 'DISPONÍVEL', 25.00, 1), -- capacidade em litros
    (2, 30.00, 'OCUPADO', 20.00, 2),
    (3, 30.00, 'DISPONÍVEL', 20.00, 3),
    (4, 40.00, 'DISPONÍVEL', 25.00, 4),
    (5, 20.00, 'OCUPADO', 15.00, 5);



    -- Inserir dados na tabela 'Manutencao_Locker'
INSERT INTO Manutencao_Locker (id_manutencao_loc, responsavel_man_loc, data_man_loc, descricao_man_loc, fk_numero_locker)
VALUES
    (1, 'Carlos Silva', '2024-11-25', 'Troca de fechadura devido a defeito', 1),
    (2, 'Fernanda Costa', '2024-11-26', 'Limpeza interna', 2),
    (3, 'João Oliveira', '2024-11-27', 'Troca de tampa danificada', 3),
    (4, 'Patrícia Souza', '2024-11-28', 'Reparo na porta, não fecha corretamente', 4),
    (5, 'Marcelo Lima', '2024-11-29', 'Manutenção no sistema de bloqueio eletrônico', 5);


    -- Inserir dados na tabela 'Reserva_Vaga_Est'
INSERT INTO Reserva_Vaga_Est (data_entrada_vaga, data_saida_vaga, id_reserva_vaga, fk_cpf_cliente, fk_numero_da_vaga, fk_registro_reserva)
VALUES
    ('2024-11-29 16:00:00', '2024-11-30 16:00:00', 1, 23456789012, 2, 202),
    ('2024-11-29 16:00:00', '2024-11-30 16:00:00', 2, 23456789012, 3, 202),
    ('2024-11-29 14:20:00', '2024-11-30 14:00:00', 3, 56789012345, 4, 205),
    ('2024-11-29 14:00:00', '2024-11-30 14:00:00', 4, 56789012345, 5, 205),
    ('2024-11-29 16:00:00', '2024-11-30 16:00:00', 5, 23456789012, 1, 202);


-- Inserir dados na tabela 'Condomino'
INSERT INTO Condomino (registro_cond, nome_fantasia_cond, tipo_cond, fk_id_lobby)
VALUES
    (1, 'Azul é a Cor Mais Quente', 'Teatro', 11),
    (2, 'Verde Tiffany', 'Loja', 22),
    (3, 'Sol', 'Loja', 33),
    (4, 'Farm Jardim', 'Loja', 44),
    (5, 'Marrom Lagoa', 'Loja', 55);


    -- Inserir dados na tabela 'Limpeza_Manutencao'
INSERT INTO Limpeza_Manutencao (local_man, data_man, tipo_man, fk_registro_ac, fk_id_area_comum)
VALUES
    ('Quarto 102', '2024-11-25 08:30:00', 'Limpeza Diária', 102, NULL),
    ('Academia Compacta', '2024-11-25 10:00:00', 'Manutenção de Equipamentos', NULL, 6),
    ('Restaurante Gourmet', '2024-11-25 15:00:00', 'Limpeza Pós-Almoço', NULL, 21),
    ('Auditório Grande', '2024-11-26 11:00:00', 'Revisão de Áudio e Iluminação', NULL, 16),
    ('Piscina Aquecida', '2024-11-26 14:30:00', 'Tratamento de Água', NULL, 5);


-- Inserir dados na tabela 'Funcionario'
INSERT INTO Funcionario (no_registro, nome, sobrenome, salario, carga_horaria, cpf_func, funcao_func, tipo_contrato, fk_id_hotel)
VALUES
    (1, 'Flávio', 'Silva', 3000.00, '08:00:00', 67890123456, 'Recepcionista', 'CLT', 1),
    (2, 'Joana', 'Costa', 5000.00, '08:00:00', 78901234567, 'Gerente', 'CLT', 2),
    (3, 'Rodrigo', 'Pereira', 3000.00, '06:00:00', 89012345678, 'Camareiro', 'Temporário', 3),
    (4, 'Cecília', 'Oliveira', 3800.00, '08:00:00', 90123456789, 'Cozinheira', 'CLT', 4),
    (5, 'Johnatan', 'Almeida', 4200.00, '08:00:00', 22398745600, 'Segurança', 'CLT', 5);


-- Inserir dados na tabela 'Beneficio'
INSERT INTO Beneficio (empresa_beneficiaria, valor_ben, tipo_ben)
VALUES
    ('Empresa Alpha', 500.00, 'Vale Alimentação'),
    ('Empresa Beta', 300.50, 'Vale Refeição'),
    ('Empresa Gamma', 1000.00, 'Assistência Médica'),
    ('Empresa Delta', 750.75, 'Auxílio Transporte'),
    ('Empresa Epsilon', 1200.00, 'Seguro de Vida');


-- Inserir dados na tabela 'Transacao'
INSERT INTO Transacao (id_transacao, tipo_tra, data_tra, descricao_tra, valor_tra, fk_id_hotel)
VALUES
    (1, 'Pix', 'entrada', '2024-11-29 16:02:00', 'Pagamento de reserva', 150.00, 2),
    (2, 'Cartão de Crédito', 'entrada', '2024-11-30 16:36:00', 'Pagamento de reserva', 75.00, 2),
    (3, 'Pix', 'saida', '2024-11-30 11:37:00', 'Pagamento de despesas', 125.00, 5),
    (4, 'Pix', 'entrada', '2024-11-30 08:42:00', 'Pagamento de reserva', 95.00, 4),
    (5, 'Deposito', 'saida', '2024-11-30 14:36:00', 'Pagamento de Salario', 12000.00, 5);



-- Inserir dados tabela 'Documentos'
INSERT INTO documentos (id_documento, fk_id_hotel, documento)
VALUES
    (1, 1, '\\x504b03040a00000000008f7a7c4f0000000000000000000000000005001c646f632e747874'),
    (2, 2, '\\x504b03040a00000000008f7a7c4f0000000000000000000000000005001c646f632e706466'), 
    (3, 3, '\\x504b03040a00000000008f7a7c4f0000000000000000000000000005001c646f632e646f63'), 
    (4, 4, '\\x504b03040a00000000008f7a7c4f0000000000000000000000000005001c646f632e786d6c'), 
    (5, 5, '\\x504b03040a00000000008f7a7c4f0000000000000000000000000005001c646f632e637376');

-- Inserir dados na tabela 'Beneficios_Funcionarios'
INSERT INTO Beneficios_Funcionarios (fk_cpf_func, fk_valor_bens, fk_tipo_bens)
VALUES
    (67890123456, 500.00, 'Vale Alimentação'),
    (78901234567, 300.50, 'Vale Refeição'),
    (89012345678, 1000.00, 'Assistência Médica'),
    (90123456789, 750.75, 'Auxílio Transporte'),
    (22398745600, 1200.00, 'Seguro de Vida');


    -- Inserir dados na tabela 'Entrega_Delivery'
INSERT INTO Entrega_Delivery (fk_id_entrega, fk_id_robo_social)
VALUES
    (005, 10),
    (055, 11),
    (555, 12),
    (500, 13),
    (550, 14);


-- Inserir dados na tabela 'Item_Consumo'
INSERT INTO Item_Consumo (id_item, data_item, preco_unitario, nome_item, fk_id_consumo, fk_cpf_client, fk_registro_reserva, fk_registro_acomodacao)
VALUES
    (1, '2024-11-29', 10.00, 'Água Mineral', 20, 23456789012, 202, 102),
    (2, '2024-11-29', 25.00, 'Sanduíche', 20, 23456789012, 202, 102),
    (3, '2024-11-29', 12.00, 'Água com Gás', 50, 56789012345, 205, 105),
    (4, '2024-11-30', 15.00, 'Cerveja Artesanal', 50, 56789012345, 205, 105),
    (5, '2024-11-30', 13.00, 'Refrigerante', 50, 56789012345, 205, 105);



-- Inserir dados na tabela 'Ocupante_locker'
INSERT INTO Ocupante_locker (id_ocupante, nome, sobrenome, telefone, fk_cpf_cliente, cpf_nao_cli)
VALUES
    (1, 'Maria', 'Souza', 1123456789, NULL, 11223344556),  -- Não cliente
    (2, 'João', 'Silva', 1198765432, 23456789012, NULL),  -- Cliente
    (3, 'Maria', 'Oliveira', 1134567890, NULL, 15926348978),  -- Não Cliente
    (4, 'Samuel', 'Santos', 1145678901, NULL, 98765432100),  -- Não cliente
    (5, 'Paula', 'Costa', 1156789012, 56789012345, NULL);  -- Cliente

    
-- Inserir dados na tabela 'Reservas_Locker'
INSERT INTO Reservas_Locker (id_reserva, data_inicio_res, data_fim_res, valor_total_res, fk_numero_locker, fk_id_ocupante)
VALUES
    (1, '2024-11-29 17:00:00', '2024-11-29 17:50:00', 40.00, 1, 1),  
    (2, '2024-11-29 19:15:00', '2024-11-29 20:15:00', 30.00, 3, 2),  
    (3, '2024-11-30 08:30:00', '2024-11-30 9:30:00', 40.00, 4, 3),  
    (4, '2024-11-30 14:16:00', '2024-11-30 15:00:00', 30.00, 2, 4),  
    (5, '2024-11-30 11:00:00', '2024-11-30 12:00:00', 20.00, 5, 5);  


-- Inserir dados na tabela 'Pagamento_Locker'
INSERT INTO Pagamento_Locker (id_pagamento, valor_pag_loc, data_pag_loc, modalidade_pag_loc, fk_id_reserva)
VALUES
    (1, 40.00, '2024-11-29 17:50:00', 'Cartão de Crédito', 1),
    (2, 30.00, '2024-11-29 20:15:00', 'Dinheiro', 2),
    (3, 40.00, '2024-11-30 9:30:00', 'Cartão de Débito', 3),
    (4, 30.00, '2024-11-30 15:00:00', 'Dinheiro', 4),
    (5, 20.00, '2024-11-30 12:00:00', 'Pix', 5);


-- Inserir dados na tabela 'Reserva_Restaurante'
INSERT INTO Reserva_Restaurante (data_reserva_restaurante, num_pessoas, fk_id_area_comum, fk_cpf_cliente, id_reserva_restaurante)
VALUES
    ('2024-11-29 17:45:00', 1, 22, 23456789012, 1), 
    ('2024-11-29 20:30:00', 1, 22, 23456789012, 2), 
    ('2024-11-29 18:00:00', 1, 25, 56789012345, 3), 
    ('2024-11-30 07:45:00', 2, 25, 56789012345, 4), 
    ('2024-11-29 14:36:00', 2, 25, 56789012345, 5); 


-- Inserir dados na tabela 'Cliente_Restaurante'
INSERT INTO Cliente_Restaurante (fk_cpf_client, fk_id_area_comum, fk_registro_reserva, fk_id_consumo, preço_adicionado, data_consumo)
VALUES
    (23456789012, 22, 202, 20, 157.50, '2024-11-29 18:45:00'),
    (23456789012, 22, 202, 20, 157.50, '2024-11-29 21:30:00'),
    (56789012345, 25, 205, 50, 104.00, '2024-11-29 19:00:00'),
    (56789012345, 25, 205, 50, 102.60, '2024-11-30 08:45:00'),
    (56789012345, 25, 205, 50, 104.00, '2024-11-29 15:36:00');

   
-- Inserir dados na tabela 'Tipos_Uso_Esp_Ev'
INSERT INTO Tipos_Uso_Esp_Ev (fk_id_area_comum, fk_id_hotel, tipo)
VALUES
    (16, 1, 'Congresso'),
    (17, 2, 'Workshop'),
    (18, 3, 'Seminário'),
    (19, 4, 'Festa Corporativa'),
    (20, 5, 'Exposição');


-- Inserir dados na tabela na 'Reserva_Sal_Ev'
INSERT INTO Reserva_Sal_Ev (fk_id_area_comum, fk_cpf_client, data_reserva_sal_eventos, preco_res_sal_eventos, fk_registro_reserva, id_reserva_sal_eventos)
VALUES
    (12, 23456789012, '2024-11-30 10:00:00', 75.00, 202, 1),
    (12, 23456789012, '2024-11-30 14:00:00', 75.00, 202, 2),
    (15, 56789012345, '2024-11-30 09:00:00', 84.00, 205, 3),
    (15, 56789012345, '2024-11-30 10:00:00', 82.00, 205, 4),
    (15, 56789012345, '2024-11-30 11:00:00', 84.00, 205, 5);



-- Inserir dados na tabela 'Setores'
INSERT INTO Setores (fk_id_hotel, setor)
VALUES
    (1, 'Trabalho'),
    (2, 'Família'),
    (3, 'Infantil'),
    (4, 'Adultos'),
    (5, 'Pets');