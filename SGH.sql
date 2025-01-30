/* EP_BD1(25_11_24)L: */

DROP SCHEMA IF EXISTS public CASCADE;

CREATE SCHEMA public
CREATE TABLE Unidade_de_hotel (
    status_atividade BOOLEAN,
    registro_imobiliario INT,
    caixa_entrada DECIMAL(12,2),
    caixa_saida DECIMAL(12,2),
    num_vagas INT,
    id_hotel INT PRIMARY KEY,
    local_hot VARCHAR(50),
    categoria_hot VARCHAR(50),
    nome_fantasia_hot VARCHAR(50),
    tamanho_hot VARCHAR(50)
);
-- Função para bloquear a exclusão de registros na tabela Unidade_de_hotel
CREATE OR REPLACE FUNCTION bloquear_delete_unidade_de_hotel()
RETURNS TRIGGER AS $$
BEGIN
    RAISE EXCEPTION 'Não é permitido excluir registros da tabela Unidade_de_hotel.';
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Gatilho que chama a função antes de deletar um registro na tabela Unidade_de_hotel
CREATE TRIGGER bloquear_delete_unidade_de_hotel
BEFORE DELETE ON Unidade_de_hotel
FOR EACH ROW
EXECUTE FUNCTION bloquear_delete_unidade_de_hotel();



CREATE TABLE Lobby (
    preco_por_m2 DECIMAL(7,2),
    numero_cond_disponiveis INT,
    id_lobby INT PRIMARY KEY,
    fk_Unidade_de_hotel INT,
    CONSTRAINT fk_uniH_lobby
        FOREIGN KEY (fk_Unidade_de_hotel)      
        REFERENCES Unidade_de_hotel(id_hotel)
        ON UPDATE CASCADE  

);

CREATE TABLE Cliente (
    cpf INT PRIMARY KEY,
    nome_cli VARCHAR(20),
    sobrenome VARCHAR(70),
    telefone INT,
    email VARCHAR(50),
    pontos INT
);
-- Função para bloquear a exclusão de registros na tabela Cliente
CREATE OR REPLACE FUNCTION bloquear_delete_cliente()
RETURNS TRIGGER AS $$
BEGIN
    RAISE EXCEPTION 'Não é permitido excluir registros da tabela Cliente.';
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Gatilho que chama a função antes de deletar um registro na tabela Cliente
CREATE TRIGGER bloquear_delete_cliente
BEFORE DELETE ON Cliente
FOR EACH ROW
EXECUTE FUNCTION bloquear_delete_cliente();



CREATE TABLE Acomodacao (
    registro_acomodacao INT PRIMARY KEY,
    tipo_acomodacao VARCHAR(50),
    politica_de_uso BYTEA,
    capacidade_maxima_acomodacao INT,
    status_acomodacao VARCHAR(50),
    ponto_atribuido INT,
    fk_id_hotel INT, 
    CONSTRAINT fk_uniH_acomodacao
        FOREIGN KEY (fk_id_hotel) 
        REFERENCES Unidade_de_hotel (id_hotel)
        ON UPDATE CASCADE

);


CREATE TABLE Reservas (
    registro_reserva INT PRIMARY KEY,
    status_res BOOLEAN,
    preco_reserva DECIMAL(7,2),
    data_e_hora_checkin TIMESTAMP,
    data_e_hora_checkout TIMESTAMP,
    custos_adicionais_reserva DECIMAL(7,2),
    preco_total_reserva DECIMAL(7,2),
    fk_cpf_cliente INT,
    fk_id_hotel INT,
    fk_registro_acomodacao INT,
    no_pessoas INT,

    CONSTRAINT fk_cliente_reserva
        FOREIGN KEY (fk_cpf_cliente) 
        REFERENCES Cliente (cpf)
        ON UPDATE CASCADE,

    CONSTRAINT fk_uniH_reserva
        FOREIGN KEY (fk_id_hotel) 
        REFERENCES Unidade_de_hotel (id_hotel)
        ON UPDATE CASCADE,
    
    CONSTRAINT fk_acomodacao_reserva
        FOREIGN KEY (fk_registro_acomodacao) 
        REFERENCES Acomodacao (registro_acomodacao)
);

-- Criando o gatilho para bloquear exclusão de reservas com status_res = 1 (sendo ocupada)
CREATE OR REPLACE FUNCTION bloquear_delete_reserva()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.status_res = TRUE THEN
        RAISE EXCEPTION 'Não é permitido excluir reservas ativas';
        RETURN NULL;  -- Impede a exclusão
    END IF;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_bloquear_delete_reserva
BEFORE DELETE ON Reservas
FOR EACH ROW
EXECUTE FUNCTION bloquear_delete_reserva();




CREATE TABLE Consumo (
    id_consumo INT,
    preco_total_con DECIMAL(7,2),
    fk_registro_reserva INT,
    PRIMARY KEY (id_consumo, fk_registro_reserva),
    CONSTRAINT fk_reserva_consumo 
        FOREIGN KEY (fk_registro_reserva) 
        REFERENCES Reservas (registro_reserva)
        ON UPDATE CASCADE
);


CREATE TABLE Produto_Delivery (
    id_produto INT PRIMARY KEY,
    nome_produto VARCHAR(50),
    preco_unitario DECIMAL(7,2)
);


CREATE TABLE Delivery (
    id_entrega INT PRIMARY KEY,
    data_del TIMESTAMP,
    quantidade_del INT,
    empresa_associada VARCHAR(50),
    valor_total DECIMAL(7,2),
    fk_registro_acomodacao INT,
    fk_id_produto INT,
    CONSTRAINT fk_acomodacao_delivery 
        FOREIGN KEY (fk_registro_acomodacao) 
        REFERENCES Acomodacao (registro_acomodacao),
    
    CONSTRAINT fk_produto_delivery
        FOREIGN KEY (fk_id_produto) 
        REFERENCES Produto_Delivery (id_produto)
);








CREATE TABLE Vagas_Estacionamento (
    numero_da_vaga INT PRIMARY KEY,
    status_disponibilidade BOOLEAN,
    custo_por_dia DECIMAL(7,2),
    tipo_vaga VARCHAR(50),
    fk_registro_reserva INT,
    CONSTRAINT fk_reserva_estac
        FOREIGN KEY (fk_registro_reserva) 
        REFERENCES Reservas (registro_reserva)
        ON UPDATE CASCADE
);


CREATE TABLE Area_Comum (
    id_area_comum INT PRIMARY KEY,
    tipo_a_c VARCHAR(50),
    nome_a_c VARCHAR(50),
    horario_abertura TIME,
    capacidade_max_a_c INT,
    local_a_c VARCHAR(50),
    status_a_c VARCHAR(50),
    fk_id_hotel INT, /*tirei o cpf do cliente*/
    horario_fechamento TIME,
    CONSTRAINT fk_uniH_areaCo 
        FOREIGN KEY (fk_id_hotel) 
        REFERENCES Unidade_de_hotel (id_hotel)
        ON UPDATE CASCADE
);

-- Criando a função para bloquear a exclusão
CREATE OR REPLACE FUNCTION bloquear_delete_area_comum()
RETURNS TRIGGER AS $$
BEGIN
    RAISE EXCEPTION 'Não é permitido excluir registros de Áreas Comuns.';
    RETURN NULL;  -- Impede a exclusão
END;
$$ LANGUAGE plpgsql;

-- Criando o trigger para a tabela Area_Comum
CREATE TRIGGER trigger_bloquear_delete_area_comum
BEFORE DELETE ON Area_Comum
FOR EACH ROW
EXECUTE FUNCTION bloquear_delete_area_comum();



CREATE TABLE Espaco_Eventos (

    fk_id_area_comum INT,
    fk_id_hotel INT,

    PRIMARY KEY (fk_id_area_comum, fk_id_hotel),

    CONSTRAINT fk_areaCo_espEv 
        FOREIGN KEY (fk_id_area_comum) 
        REFERENCES Area_Comum (id_area_comum)
        ON UPDATE CASCADE,
    CONSTRAINT fk_uniH_espEv 
        FOREIGN KEY (fk_id_hotel) 
        REFERENCES Unidade_de_hotel (id_hotel)
        ON UPDATE CASCADE
);


CREATE TABLE Requisicao_Chatbot (
    id_requisicao INT PRIMARY KEY,
    status_req VARCHAR(50),
    atendedor_req VARCHAR(20),
    data_abertura_req TIMESTAMP,
    data_fechamento_req TIMESTAMP,
    tipo_req VARCHAR(50),
    descricao_req VARCHAR(300),
    fk_cpf_client INT,
    fk_id_hotel INT,
    CONSTRAINT fk_cliente_reqChat 
        FOREIGN KEY (fk_cpf_client) 
        REFERENCES Cliente (cpf)
        ON UPDATE CASCADE,
    CONSTRAINT fk_uniH_reqChat 
        FOREIGN KEY (fk_id_hotel) 
        REFERENCES Unidade_de_hotel (id_hotel)
        ON UPDATE CASCADE
);


CREATE TABLE Descartaveis (
    quantidade_gasta INT,
    tipo_amen VARCHAR(50) PRIMARY KEY,
    nome_amen VARCHAR(50),
    quantidade_disponivel INT,
    fk_registro_acomodacao INT,
    CONSTRAINT fk_acomodacao_descart 
        FOREIGN KEY (fk_registro_acomodacao) 
        REFERENCES Acomodacao (registro_acomodacao)
);



CREATE TABLE Nao_Descartaveis (
    quantidade_usada INT,
    quantidade_em_uso INT,
    tipo_amen VARCHAR(50) PRIMARY KEY,
    nome_amen VARCHAR(50),
    quantidade_disponivel INT,
    fk_registro_acomodacao INT,
    CONSTRAINT fk_acomodacao_nDescart 
        FOREIGN KEY (fk_registro_acomodacao) 
        REFERENCES Acomodacao (registro_acomodacao)
);


CREATE TABLE Piscina (
    classificacao_indicativa INT,
    profundidade DECIMAL(7,2),
    categoria_piscina VARCHAR(50),
    fk_id_area_comum INT PRIMARY KEY,
    CONSTRAINT fk_areaCo_piscina 
        FOREIGN KEY (fk_id_area_comum) 
        REFERENCES Area_Comum (id_area_comum)
        ON UPDATE CASCADE
);


CREATE TABLE Academia (
    fk_id_area_comum INT PRIMARY KEY,
    modalidade VARCHAR(50),
    horario_abertura TIME,
    horario_fechamento TIME,
    CONSTRAINT fk_areaCo_academia 
        FOREIGN KEY (fk_id_area_comum) 
        REFERENCES Area_Comum (id_area_comum)
        ON UPDATE CASCADE
);



CREATE TABLE Academia_Amen_Desc (
    fk_tipo_amenidade VARCHAR(50),
    fk_id_area_comum INT,
    quantidade_oferecida INT,

    CONSTRAINT fk_descart_AcadAmenDesc
        FOREIGN KEY (fk_tipo_amenidade)
        REFERENCES Descartaveis (tipo_amen),

    CONSTRAINT fk_academia_AcadAmenDesc
        FOREIGN KEY (fk_id_area_comum) 
        REFERENCES Academia (fk_id_area_comum)
);



CREATE TABLE Academia_Amen_Nao (
    fk_tipo_amenidade VARCHAR(50),
    fk_id_area_comum INT,
    quantidade_oferecida INT,

    CONSTRAINT fk_nDescart_AcadAmenNao
        FOREIGN KEY (fk_tipo_amenidade)
        REFERENCES Nao_Descartaveis (tipo_amen),

    CONSTRAINT fk_academia_AcadAmenNao
        FOREIGN KEY (fk_id_area_comum) 
        REFERENCES Academia (fk_id_area_comum)
);

CREATE TABLE Piscina_Amen_Desc (
    fk_tipo_amenidade VARCHAR(50),
    fk_id_area_comum INT,
    quantidade_oferecida INT,

    CONSTRAINT fk_descart_PiscAmenDesc
        FOREIGN KEY (fk_tipo_amenidade)
        REFERENCES Descartaveis (tipo_amen),

    CONSTRAINT fk_piscina_PiscAmenDesc
        FOREIGN KEY (fk_id_area_comum) 
        REFERENCES Piscina (fk_id_area_comum)
    );

CREATE TABLE Piscina_Amen_Nao (
    fk_tipo_amenidade VARCHAR(50),
    fk_id_area_comum INT,
    quantidade_oferecida INT,

    CONSTRAINT fk_nDescart_PiscAmenNao
        FOREIGN KEY (fk_tipo_amenidade)
        REFERENCES Nao_Descartaveis (tipo_amen),

    CONSTRAINT fk_piscina_PiscAmenNao
        FOREIGN KEY (fk_id_area_comum) 
        REFERENCES Piscina (fk_id_area_comum)
);

CREATE TABLE Acomodacao_Amen_Desc(
    fk_tipo_amenidade VARCHAR(50),
    fk_registro_acomodacao INT,
    quantidade_oferecida INT,

    CONSTRAINT fk_descart_AcomAmenDesc
        FOREIGN KEY (fk_tipo_amenidade)
        REFERENCES Descartaveis (tipo_amen),

    CONSTRAINT fk_acomodacao_AcomAmenDesc
        FOREIGN KEY (fk_registro_acomodacao) 
        REFERENCES Acomodacao (registro_acomodacao)
);

CREATE TABLE Acomodacao_Amen_Nao(
    fk_tipo_amenidade VARCHAR(50),
    fk_registro_acomodacao INT,
    quantidade_oferecida INT,

    CONSTRAINT fk_nDescart_AcomAmenNao
        FOREIGN KEY (fk_tipo_amenidade)
        REFERENCES Nao_Descartaveis (tipo_amen),

    CONSTRAINT fk_acomodacao_AcomAmenNao
        FOREIGN KEY (fk_registro_acomodacao) 
        REFERENCES Acomodacao (registro_acomodacao)
);



CREATE TABLE Controle_Amenidades(
    fk_tipo_amenidades VARCHAR(50),
    fk_id_area_comum INT,
    fk_cpf_cliente INT,
    quantidade_em_uso INT,
    
    CONSTRAINT fk_nDescart_ContAmen
        FOREIGN KEY (fk_tipo_amenidades)
        REFERENCES Nao_Descartaveis (tipo_amen),

    CONSTRAINT fk_AreaCo_ContAmen
        FOREIGN KEY (fk_id_area_comum) 
        REFERENCES Area_Comum (id_area_comum)
        ON UPDATE CASCADE,

    CONSTRAINT fk_cliente_ContAmen
        FOREIGN KEY (fk_cpf_cliente) 
        REFERENCES Cliente (cpf)
        ON UPDATE CASCADE
);



CREATE TABLE Restaurante (
    fk_id_area_comum INT PRIMARY KEY,
    CONSTRAINT fk_areaCo_restaurante 
        FOREIGN KEY (fk_id_area_comum) 
        REFERENCES Area_Comum (id_area_comum)
        ON UPDATE CASCADE
);


CREATE TABLE Sala_de_Eventos (
    fk_id_area_comum INT PRIMARY KEY,
    CONSTRAINT fk_areaCo_salaEv 
        FOREIGN KEY (fk_id_area_comum) 
        REFERENCES Area_Comum (id_area_comum)
        ON UPDATE CASCADE
);


CREATE TABLE Equipamentos (
    id_equipamento INT,
    nome_equipamento VARCHAR(50),
    status_equipamento VARCHAR(20),
    fk_id_area_comum INT,
    PRIMARY KEY (id_equipamento, fk_id_area_comum),
    CONSTRAINT fk_areaCo_AcadEqui 
        FOREIGN KEY (fk_id_area_comum) 
        REFERENCES Area_Comum (id_area_comum)
        ON UPDATE CASCADE
);


CREATE TABLE Estoque (
    ingrediente VARCHAR(30),
    quantidade_ing INT,
    tipo_ing VARCHAR(30),
    validade_ing DATE,
    fk_id_area_comum INT,
    fk_id_hotel INT,
    PRIMARY KEY (ingrediente, fk_id_area_comum, fk_id_hotel),
    CONSTRAINT fk_areaCo_RestEstq 
        FOREIGN KEY (fk_id_area_comum) 
        REFERENCES Area_Comum (id_area_comum)
        ON UPDATE CASCADE,
    CONSTRAINT fk_uniH_RestEstq 
        FOREIGN KEY (fk_id_hotel) 
        REFERENCES Unidade_de_hotel (id_hotel)
        ON UPDATE CASCADE
);


CREATE TABLE Robo_Social (
    fk_id_hotel INT,
    id_robo_social INT PRIMARY KEY,
    CONSTRAINT fk_uniH_RoboS 
        FOREIGN KEY (fk_id_hotel) 
        REFERENCES Unidade_de_hotel (id_hotel)
        ON UPDATE CASCADE
);



CREATE TABLE Locker (
    numero_locker INT PRIMARY KEY,
    capacidade_locker DECIMAL(7,2),
    disponibilidade_locker VARCHAR(30), 
    preço_hora_locker DECIMAL(7,2),
    fk_id_hotel INT,
    CONSTRAINT fk_uniH_Locker 
        FOREIGN KEY (fk_id_hotel) 
        REFERENCES Unidade_de_hotel (id_hotel)
        ON UPDATE CASCADE
);

-- Função para verificar se a exclusão deve ser permitida
CREATE OR REPLACE FUNCTION bloquear_delete_locker()
RETURNS TRIGGER AS $$
BEGIN
    -- Verifica se o status de disponibilidade é "OCUPADO"
    IF OLD.disponibilidade_locker = 'OCUPADO' THEN
        RAISE EXCEPTION 'Não é permitido excluir o registro de um locker com status "OCUPADO".';
        RETURN NULL;  -- Impede a exclusão
    END IF;
    -- Permite a deleção se o status não for "OCUPADO"
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- Gatilho que chama a função antes de deletar um registro na tabela Locker
CREATE TRIGGER bloquear_delete_locker
BEFORE DELETE ON Locker
FOR EACH ROW
EXECUTE FUNCTION bloquear_delete_locker();






CREATE TABLE Manutencao_Locker (
    id_manutencao_loc INT UNIQUE,
    responsavel_man_loc VARCHAR(20),
    data_man_loc DATE,
    descricao_man_loc VARCHAR(300),
    fk_numero_locker INT,
    PRIMARY KEY (id_manutencao_loc, fk_numero_locker),
    CONSTRAINT fk_Locker_Manut 
        FOREIGN KEY (fk_numero_locker) 
        REFERENCES Locker (numero_locker)
        ON UPDATE CASCADE
);


CREATE TABLE Reserva_Vaga_Est (
    data_entrada_vaga TIMESTAMP,
    data_saida_vaga TIMESTAMP,
    id_reserva_vaga INT PRIMARY KEY,
    fk_cpf_cliente INT,
    fk_numero_da_vaga INT,
    fk_registro_reserva INT,
    CONSTRAINT fk_cliente_ResVagEst 
        FOREIGN KEY (fk_cpf_cliente) 
        REFERENCES Cliente (cpf)
        ON UPDATE CASCADE,
    CONSTRAINT fk_nVagaEst_ResVagEst 
        FOREIGN KEY (fk_numero_da_vaga) 
        REFERENCES Vagas_Estacionamento (numero_da_vaga),
    CONSTRAINT fk_reserva_ResVagEst 
        FOREIGN KEY (fk_registro_reserva) 
        REFERENCES Reservas (registro_reserva)
        ON UPDATE CASCADE
);


CREATE TABLE Condomino (
    registro_cond INT PRIMARY KEY,
    nome_fantasia_cond VARCHAR(50),
    tipo_cond VARCHAR(20),
    fk_id_lobby INT,
    CONSTRAINT fk_lobby_Cond
        FOREIGN KEY (fk_id_lobby) 
        REFERENCES Lobby (id_lobby)
);




CREATE TABLE Limpeza_Manutencao (
    local_man VARCHAR(30),
    data_man TIMESTAMP,
    tipo_man VARCHAR(30),
    fk_registro_ac INT,
    fk_id_area_comum INT,
    PRIMARY KEY (local_man, data_man),
    CONSTRAINT fk_acomodacao_LimpMan
        FOREIGN KEY (fk_registro_ac) 
        REFERENCES Acomodacao (registro_acomodacao),
    CONSTRAINT fk_areaCo_LimpMan
        FOREIGN KEY (fk_id_area_comum) 
        REFERENCES Area_Comum (id_area_comum)
        ON UPDATE CASCADE

);


CREATE TABLE Item_Consumo (
    id_item INT,
    data_item DATE,
    preco_unitario DECIMAL(7,2),
    nome_item VARCHAR(30),
    fk_id_consumo INT,
    fk_cpf_client INT,
    fk_registro_reserva INT,
    fk_registro_acomodacao  INT, /*adicionamos como chave estrangeira e chave primária */
    PRIMARY KEY (fk_id_consumo, fk_cpf_client, fk_registro_reserva, fk_registro_acomodacao, id_item),
    CONSTRAINT fk_consumo_Item
        FOREIGN KEY (fk_id_consumo, fk_registro_reserva)  -- Referencia a chave composta
        REFERENCES Consumo (id_consumo, fk_registro_reserva)  -- Usa a chave composta da tabela Consumo
        ON UPDATE CASCADE,
    CONSTRAINT fk_cliente_Item
        FOREIGN KEY (fk_cpf_client) 
        REFERENCES Cliente (cpf)
        ON UPDATE CASCADE,
    CONSTRAINT fk_reserva_Item
        FOREIGN KEY (fk_registro_reserva) 
        REFERENCES Reservas (registro_reserva)
        ON UPDATE CASCADE,
    CONSTRAINT fk_acomodacao_Item
        FOREIGN KEY (fk_registro_acomodacao) 
        REFERENCES Acomodacao (registro_acomodacao)

);


CREATE TABLE Funcionario (
    no_registro INT PRIMARY KEY,
    nome VARCHAR(30),
    sobrenome VARCHAR(70),
    salario DECIMAL(7,2),
    carga_horaria TIME,
    cpf_func INT UNIQUE,
    funcao_func VARCHAR(30),
    tipo_contrato VARCHAR(50),
    fk_id_hotel INT,
    CONSTRAINT fk_uniH_Func
        FOREIGN KEY (fk_id_hotel) 
        REFERENCES Unidade_de_hotel (id_hotel)
        ON UPDATE CASCADE
);


CREATE TABLE Beneficio (
    empresa_beneficiaria VARCHAR(30),
    valor_ben DECIMAL(7,2),
    tipo_ben VARCHAR(30),
    PRIMARY KEY (valor_ben, tipo_ben)
);


CREATE TABLE Transacao (
    id_transacao INT PRIMARY KEY,
    tipo_tra VARCHAR(30),
    direcao_fluxo VARCHAR(30),
    data_tra TIME,
    descricao_tra VARCHAR(100),
    valor_tra DECIMAL(7,2),
    fk_id_hotel INT,
    CONSTRAINT fk_uniH_Transacao
        FOREIGN KEY (fk_id_hotel) 
        REFERENCES Unidade_de_hotel (id_hotel)
        ON UPDATE CASCADE
);



CREATE TABLE documentos (
    id_documento INT PRIMARY KEY,
    fk_id_hotel INT,
    documento BYTEA,
    CONSTRAINT fk_uniH_documentos
        FOREIGN KEY (fk_id_hotel) 
        REFERENCES Unidade_de_hotel (id_hotel)
        ON UPDATE CASCADE
);


CREATE TABLE Entrega_Delivery (
    fk_id_entrega INT,
    fk_id_robo_social INT,
    PRIMARY KEY (fk_id_robo_social, fk_id_entrega),
    CONSTRAINT fk_delivery_entDeliv
        FOREIGN KEY (fk_id_entrega) 
        REFERENCES Delivery (id_entrega)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_roboS_entDeliv
        FOREIGN KEY (fk_id_robo_social) 
        REFERENCES Robo_Social (id_robo_social)
);



CREATE TABLE Beneficios_Funcionarios (
    fk_cpf_func INT,
    fk_valor_bens DECIMAL(7,2),
    fk_tipo_bens VARCHAR(30),
    PRIMARY KEY (fk_valor_bens, fk_tipo_bens, fk_cpf_func),
    CONSTRAINT fk_func_BenFunc
        FOREIGN KEY (fk_cpf_func) 
        REFERENCES Funcionario (cpf_func)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT fk_beneficio_BenFunc
        FOREIGN KEY (fk_valor_bens, fk_tipo_bens) 
        REFERENCES Beneficio (valor_ben, tipo_ben)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);


CREATE TABLE Ocupante_locker (
    id_ocupante INT PRIMARY KEY,
    nome VARCHAR(20),
    sobrenome VARCHAR(70),
    telefone INT,
    fk_cpf_cliente INT,
    cpf_nao_cli INT UNIQUE,
    CONSTRAINT fk_cliente_OcupLocker
        FOREIGN KEY (fk_cpf_cliente) 
        REFERENCES Cliente (cpf)
        ON UPDATE CASCADE

);


CREATE TABLE Reservas_Locker (
    id_reserva INT PRIMARY KEY,
    data_inicio_res TIMESTAMP,
    data_fim_res TIMESTAMP,
    valor_total_res DECIMAL(7,2),
    fk_numero_locker INT,
    fk_id_ocupante INT,
    CONSTRAINT fk_Locker_ResLocker
        FOREIGN KEY (fk_numero_locker) 
        REFERENCES Locker (numero_locker)
        ON UPDATE CASCADE,
    CONSTRAINT fk_ocupLocker_ResLocker
        FOREIGN KEY (fk_id_ocupante) 
        REFERENCES Ocupante_locker (id_ocupante)
);



CREATE TABLE Pagamento_Locker (
    id_pagamento INT PRIMARY KEY,
    valor_pag_loc DECIMAL(7,2),
    data_pag_loc TIMESTAMP,
    modalidade_pag_loc VARCHAR(30),
    fk_id_reserva INT,
    CONSTRAINT fk_reservaLocker_PagLocker
        FOREIGN KEY (fk_id_reserva) 
        REFERENCES Reservas_Locker (id_reserva)
);


CREATE TABLE Reserva_Restaurante (
    data_reserva_restaurante TIMESTAMP,
    num_pessoas INT,
    fk_id_area_comum INT,
    fk_cpf_cliente INT, 
    id_reserva_restaurante INT, /*tiramos di cosnumo e registro reserva pq mudamos a lógica do custo adicionado ao*/
    PRIMARY KEY (fk_id_area_comum, id_reserva_restaurante, fk_cpf_cliente),
    CONSTRAINT fk_areaCo_ResRest
        FOREIGN KEY (fk_id_area_comum) 
        REFERENCES Restaurante (fk_id_area_comum)
        ON UPDATE CASCADE,
    CONSTRAINT fk_cliente_ResRest
        FOREIGN KEY (fk_cpf_cliente) 
        REFERENCES Cliente (cpf)
        ON UPDATE CASCADE
);



CREATE TABLE Cliente_Restaurante (
    fk_cpf_client INT,
    fk_id_area_comum INT, 
    fk_registro_reserva INT, 
    fk_id_consumo INT,
    preço_adicionado DECIMAL(7,2),
    data_consumo TIMESTAMP,
    PRIMARY KEY (fk_cpf_client, fk_id_area_comum, fk_registro_reserva, fk_id_consumo, data_consumo),
    CONSTRAINT fk_cliente_CustRest
        FOREIGN KEY (fk_cpf_client) 
        REFERENCES Cliente (cpf)
        ON UPDATE CASCADE,
    CONSTRAINT fk_areaCo_CustRest
        FOREIGN KEY (fk_id_area_comum) 
        REFERENCES Area_Comum (id_area_comum)
        ON UPDATE CASCADE,
    CONSTRAINT fk_reserva_CustRest
        FOREIGN KEY (fk_registro_reserva) 
        REFERENCES Reservas (registro_reserva)
        ON UPDATE CASCADE,
    CONSTRAINT fk_consumo_CustRest
        FOREIGN KEY (fk_id_consumo, fk_registro_reserva)  -- Referencia a chave composta
        REFERENCES Consumo (id_consumo, fk_registro_reserva)  -- Usa a chave composta da tabela Consumo
        ON UPDATE CASCADE
    
);



CREATE TABLE Tipos_Uso_Esp_Ev (
    fk_id_area_comum INT,
	fk_id_hotel INT,
    tipo VARCHAR(30),
    PRIMARY KEY (tipo, fk_id_area_comum, fk_id_hotel),
    CONSTRAINT fk_EspEv_TipEspEv
        FOREIGN KEY (fk_id_area_comum, fk_id_hotel) 
        REFERENCES Espaco_Eventos (fk_id_area_comum, fk_id_hotel)
);


CREATE TABLE Reserva_Sal_Ev (
    fk_id_area_comum INT,
    fk_cpf_client INT,
    data_reserva_sal_eventos TIMESTAMP,
    preco_res_sal_eventos DECIMAL(7,2),
    fk_registro_reserva INT,
    id_reserva_sal_eventos INT,
    PRIMARY KEY (id_reserva_sal_eventos, fk_id_area_comum, fk_cpf_client, fk_registro_reserva),
    CONSTRAINT fk_areaCo_ResSalEv
        FOREIGN KEY (fk_id_area_comum) 
        REFERENCES Area_Comum (id_area_comum)
        ON UPDATE CASCADE,
    CONSTRAINT fk_cliente_ResSalEv
        FOREIGN KEY (fk_cpf_client) 
        REFERENCES Cliente (cpf)
        ON UPDATE CASCADE,
    CONSTRAINT fk_reserva_ResSalEv
        FOREIGN KEY (fk_registro_reserva) 
        REFERENCES Reservas (registro_reserva)
        ON UPDATE CASCADE
);



CREATE TABLE Reserva_Esp_Ev (
    id_reserva_e_e INT,
    data_reserva_e_e TIME,
    preco_reserva_e_e DECIMAL(7,2),
    fk_registro_reserva INT,
    fk_cpf_client INT,
    fk_id_area_comum INT,
    fk_id_hotel INT,

    PRIMARY KEY (id_reserva_e_e, fk_cpf_client, fk_id_area_comum, fk_registro_reserva, fk_id_hotel),

    CONSTRAINT fk_uniH_ResEspEv
        FOREIGN KEY (fk_id_hotel) 
        REFERENCES Unidade_de_hotel (id_hotel)
        ON UPDATE CASCADE,

    CONSTRAINT fk_AreaCo_ResEspEv
        FOREIGN KEY (fk_id_area_comum) 
        REFERENCES Area_Comum (id_area_comum)
        ON UPDATE CASCADE,

    CONSTRAINT fk_cliente_ResEspEv
        FOREIGN KEY (fk_cpf_client) 
        REFERENCES Cliente (cpf)
        ON UPDATE CASCADE,

    CONSTRAINT fk_reserva_ResEspEv
        FOREIGN KEY (fk_registro_reserva) 
        REFERENCES Reservas (registro_reserva)
        ON UPDATE CASCADE
);



CREATE TABLE Setores (
    fk_id_hotel INT,
    setor VARCHAR(30),
    
    PRIMARY KEY (fk_id_hotel, setor),

    CONSTRAINT fk_uniH_Setores
        FOREIGN KEY (fk_id_hotel) 
        REFERENCES Unidade_de_hotel (id_hotel)
        ON UPDATE CASCADE
);

ALTER TABLE Acomodacao
ADD valor_ac DECIMAL(7,2);


ALTER TABLE Produto_Delivery
ADD fk_id_entrega INT,
ADD CONSTRAINT fk_delivery_produtoDel
    FOREIGN KEY (fk_id_entrega)
    REFERENCES Delivery (id_entrega)
	ON DELETE CASCADE
    ON UPDATE CASCADE;
ALTER TABLE Produto_Delivery
ADD COLUMN quantidade INT;

ALTER TABLE Delivery
DROP CONSTRAINT fk_produto_delivery;
ALTER TABLE Delivery
DROP COLUMN fk_id_produto;
ALTER TABLE Delivery
DROP COLUMN quantidade_del;


-- Alterar o tipo de dado de 'cpf' para BIGINT
ALTER TABLE Cliente
    ALTER COLUMN cpf TYPE BIGINT USING cpf::BIGINT;

-- Alterar o tipo de dado de 'telefone' para BIGINT
ALTER TABLE Cliente
    ALTER COLUMN telefone TYPE BIGINT USING telefone::BIGINT;

ALTER TABLE Reservas
    ALTER COLUMN fk_cpf_cliente TYPE BIGINT USING fk_cpf_cliente::BIGINT;



ALTER TABLE Transacao
ALTER COLUMN data_tra TYPE TIMESTAMP
USING CURRENT_DATE + data_tra::interval;


ALTER TABLE Funcionario
DROP CONSTRAINT Funcionario_pkey;
ALTER TABLE Funcionario
ADD PRIMARY KEY (cpf_func);


ALTER TABLE Funcionario
ALTER COLUMN cpf_func TYPE BIGINT;


ALTER TABLE Tipos_Uso_Esp_Ev
ADD CONSTRAINT fk_id_hotel
    FOREIGN KEY (fk_id_hotel)
    REFERENCES Unidade_de_Hotel (id_hotel)
    ON DELETE CASCADE; -- ou outro comportamento


ALTER TABLE Requisicao_Chatbot
    ALTER COLUMN fk_cpf_client TYPE BIGINT USING fk_cpf_client::BIGINT;



-- Remover a Foreign Key
ALTER TABLE Descartaveis
DROP CONSTRAINT fk_acomodacao_descart;

-- Remover a coluna
ALTER TABLE Descartaveis
DROP COLUMN fk_registro_acomodacao;


ALTER TABLE Academia_Amen_Desc
ADD CONSTRAINT pk_AcadAmenDesc PRIMARY KEY (fk_id_area_comum, fk_tipo_amenidade);


ALTER TABLE Academia_Amen_Nao
ADD CONSTRAINT pk_AcadAmenNao PRIMARY KEY (fk_id_area_comum, fk_tipo_amenidade);


ALTER TABLE Piscina_Amen_Desc
ADD CONSTRAINT pk_PiscinaAmenDesc PRIMARY KEY (fk_id_area_comum, fk_tipo_amenidade);

ALTER TABLE Piscina_Amen_Nao
ADD CONSTRAINT pk_PiscinaAmenNao PRIMARY KEY (fk_id_area_comum, fk_tipo_amenidade);

ALTER TABLE Acomodacao_Amen_Desc
ADD CONSTRAINT pk_AcomodacaoAmenDesc PRIMARY KEY (fk_registro_acomodacao, fk_tipo_amenidade);

ALTER TABLE Acomodacao_Amen_Nao
ADD CONSTRAINT pk_AcomodacaoAmenNao PRIMARY KEY (fk_registro_acomodacao, fk_tipo_amenidade);


ALTER TABLE Controle_Amenidades
ALTER COLUMN fk_cpf_cliente TYPE BIGINT;


ALTER TABLE Locker
RENAME COLUMN capacidade_locker TO capacidade_locker_litros;


ALTER TABLE Vagas_Estacionamento
DROP CONSTRAINT fk_reserva_estac;
ALTER TABLE Vagas_Estacionamento
DROP COLUMN fk_registro_reserva;


ALTER TABLE Beneficios_Funcionarios
    ALTER COLUMN fk_cpf_func TYPE BIGINT USING fk_cpf_func::BIGINT;


ALTER TABLE Item_Consumo
    ALTER COLUMN fk_cpf_client TYPE BIGINT USING fk_cpf_client::BIGINT;


ALTER TABLE Ocupante_locker
    ALTER COLUMN fk_cpf_cliente TYPE BIGINT USING fk_cpf_cliente::BIGINT;
ALTER TABLE Ocupante_locker
    ALTER COLUMN telefone TYPE BIGINT USING telefone::BIGINT;
ALTER TABLE Ocupante_locker
    ALTER COLUMN cpf_nao_cli TYPE BIGINT USING cpf_nao_cli::BIGINT;


ALTER TABLE Reserva_Restaurante
    ALTER COLUMN fk_cpf_cliente TYPE BIGINT USING fk_cpf_cliente::BIGINT;

ALTER TABLE Cliente_Restaurante
    ALTER COLUMN fk_cpf_client TYPE BIGINT USING fk_cpf_client::BIGINT;

ALTER TABLE Reserva_Sal_Ev
    ALTER COLUMN fk_cpf_client TYPE BIGINT USING fk_cpf_client::BIGINT;


ALTER TABLE Reserva_Esp_Ev
    ALTER COLUMN fk_cpf_client TYPE BIGINT USING fk_cpf_client::BIGINT;

ALTER TABLE Produto_Delivery
DROP CONSTRAINT produto_delivery_pkey;
ALTER TABLE Produto_Delivery
ADD PRIMARY KEY (id_produto, fk_id_entrega);

-- Remover a Foreign Key
ALTER TABLE Nao_Descartaveis
DROP CONSTRAINT fk_acomodacao_nDescart;

ALTER TABLE Reserva_Vaga_Est
    ALTER COLUMN fk_cpf_cliente TYPE BIGINT USING fk_cpf_cliente::BIGINT;

