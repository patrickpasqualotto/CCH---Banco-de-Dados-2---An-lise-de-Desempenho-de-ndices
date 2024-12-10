from faker import Faker
import random
from datetime import datetime, timedelta

# Inicializa o Faker
fake = Faker('pt_BR')

# Número de registros a serem gerados
num_taxis = 100  # Número de Taxis
num_clientes = 100  # Número de Clientes
num_motoristas = 100  # Número de Motoristas
num_filas = 100  # Número de registros na Fila
num_corridas = 100  # Número de Corridas
num_zona = 100 # Numero de zonas

marcas_modelos = [
    ("Fiat", ["Uno", "Palio", "Strada","Toro","Siena", "Mobi"]),
    ("Volkswagen", ["Gol", "Fox", "Voyage","Polo","Virtus", "Nivus","Amarok", "T-Cross", "Golf","Up", "Saveiro"]),
    ("Chevrolet", ["Onix", "Celta", "Cruze","Prisma", "Corsa", "S10", "Tracker", "Cobalt", "Vectra","Agile","Spin","TrailBlazer"]),
    ("Ford", ["Fiesta", "Ka", "Ecosport","Focus","Ranger","Fusion",]),
    ("Toyota", ["Corolla", "Etios", "Hilux","Corolla Cross","Sw4","RAV4"]),
    ("Honda",["City","Civic","CRV", "Fit","HR-V"]),
    ("Renault",["Sandero","Kwid","Clio","Duster","Logan","Megane"]),
    ("Hyundai",["Hb20","Creta","Elantra","i30","Azera","Tucson","IX35"]),
    ("BYD",["Dolphin","HAN","Seal","Song Plus","Tan","Dolphin Mini"]),
    ("Tesla",["Model 3","Model S","Model X","Model Y","Cybertruck"]),
    ("Jeep",["Commander","Compass","Renegade"])
]


# Listas para armazenar os dados
taxis = []
clientes = []
motoristas = []
corridas = []
filas = []
zona = []
clienteempresa =[]

# Gerar dados para a tabela Taxi
placas=set();
for _ in range(num_taxis):
    while True:
        placa = fake.license_plate()[:8]  # Placa com 7 caracteres
        if placa not in placas:
            placas.add(placa)
            break
    marca, modelos = random.choice(marcas_modelos)
    modelo = random.choice(modelos)
    ano_fab = random.randint(2009, 2023)  # Ano de fabricação entre 2000 e 2023
    licenca = fake.random_int(min=000000000, max=999999999)  # Licença com 9 dígitos
    taxis.append(f"('{placa}', '{marca}', '{modelo}', {ano_fab}, '{licenca}')")

# Gerar dados para a tabela Cliente
for i in range(num_clientes):
    cli_id = f"{i:05d}"
    nome = fake.name()
    cpf = fake.cpf()  # Gera um CPF fictício
    clientes.append(f"('{cli_id}','{nome}', '{cpf}')")



# Gerar dados para a Motorista
motorista_to_taxi = {}  # Dicionário para garantir que a placa seja a mesma
for i in range(num_motoristas):
    cnh = f"{random.randint(100000000, 999999999)}"  # CNH com 9 dígitos
    nome = fake.name()
    cnh_valid = random.randint(0, 1)  # Ano de validade da CNH
    placa = random.choice([tax.split(',')[0].strip("()'") for tax in taxis])  # Escolhe um taxi aleatório
    motorista_to_taxi[cnh] = placa  # Associa a CNH à placa do táxi
    motoristas.append(f"('{cnh}', '{nome}', {cnh_valid}, '{placa}')")

# Gerar dados para a tabela Zona
for i in range(num_zona):
    nomeZona = fake.unique.city()
    zona.append(f"('{nomeZona}')")

# Gerar dados para a tabela Corrida
for _ in range(num_corridas):
    cli_id = random.choice([cli_id.split(',')[0].strip("()'") for cli_id in clientes])  # Escolhe um cliente aleatório
    placa = random.choice(list(placas))  # Escolhe um taxi aleatório
    data_pedido = fake.date_time_this_year()  # Data entre um ano atrás e hoje
    corridas.append(f"('{cli_id}', '{placa}', '{data_pedido}')")

# Gerar dados para a tabela Fila
for _ in range(num_filas):
    zonaAleatoria = random.choice([nomeZona.split(',')[0].strip("()'") for nomeZona in zona])  # Escolhe uma zona aleatória
    cnh = random.choice(list(motorista_to_taxi.keys()))  # Escolhe um motorista pela CNH
    placa = motorista_to_taxi[cnh]  # A placa do táxi será a mesma do motorista
    data_hora_in = fake.date_time_this_year()  # Data e hora de entrada
    data_hora_out = data_hora_in + timedelta(hours=random.randint(1, 5))  # Data e hora de saída
    km_in = random.randint(1, 500)  # Quilometragem de entrada
    filas.append(f"('{zonaAleatoria}', '{cnh}', '{data_hora_in}', '{data_hora_out}', {km_in})")

start_cli_id = num_clientes + 1  # Próximo ID após o último cliente pessoa física

for i in range(num_clientes):  # Número de clientes pessoa jurídica
    cli_id = f"{start_cli_id + i:05d}"  # Continua a sequência de IDs
    nome = fake.company()
    cnpj = fake.unique.bothify(text='##############')  # Gera um CNPJ fictício
    filas.append(f"('{cli_id}', '{nome}', '{cnpj}')")


# Criar o arquivo SQL
with open('dados_ficticios2.sql', 'w') as file:
    # Inserir dados na tabela Taxi
    file.write("INSERT INTO Taxi (Placa, Marca, Modelo, AnoFab, Licenca) VALUES\n")
    file.write(",\n".join(taxis) + ";\n\n")

    # Inserir dados na tabela Cliente
    file.write("INSERT INTO Cliente (Cliid, Nome, CPF) VALUES\n")
    file.write(",\n".join(clientes) + ";\n\n")

    # Inserir dados na tabela Motorista
    file.write("INSERT INTO Motorista (CNH, Nome, CNHValid, Placa) VALUES\n")
    file.write(",\n".join(motoristas) + ";\n\n")

    # Inserir dados na tabela Zona
    file.write("INSERT INTO Zona (Zona) VALUES\n")
    file.write(",\n".join(zona) + ";\n\n")

    # Inserir dados na tabela Corrida
    file.write("INSERT INTO Corrida (CliId, Placa, DataPedido) VALUES\n")
    file.write(",\n".join(corridas) + ";\n\n")

    # Inserir dados na tabela Fila
    file.write("INSERT INTO Fila (Zona, CNH, DataHoraIn, DataHoraOut, KmIn) VALUES\n")
    file.write(",\n".join(filas) + ";\n")

    ## Inserir dados na tabela clientes cnpj
    file.write("INSERT INTO ClienteEmpresa (CliId, Nome, CNPJ) VALUES ({cli_id}, '{nome}', '{cnpj}') VALUES\n")
    file.write(",\n".join(clienteempresa) + ";\n")

print("Arquivo 'dados_ficticios2.sql' criado com sucesso!")