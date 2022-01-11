create database dados;
use dados;
/*----------------------------------------------------------------------------------*/
				/*TABELA DAS OPERADORAS*/
create table cadastrosop(
registroANS varchar(10) not null,
cnpj varchar(11) not null,
razaoSocial varchar(200) not null,
nomeFantasia varchar(100),
modalidade varchar(50) not null,
logradouro varchar(50),
numero varchar(20) not null,
complemento varchar(60),
bairro varchar(50) not null,
cidade varchar(30) not null,
uf varchar(5) not null,
cep varchar(10),
ddd varchar(5),
tel varchar(15),
fax varchar(15),
email varchar(50),
representante varchar(100) not null,
cargoRepresentante varchar(50) not null,
data_registro_ANS date not null,
primary key(registroANS)
)default charset = 'utf8mb4';


				/*CAPTURA DAS OPERADORAS NO ARQUIVI .CSV PARA IMPORTAÇÃO NA TABELA ACIMA*/
load data infile 'Teste_Nivelamento_I.C/files/desafio3_arquivos'
into table cadastrosop fields terminated by ';' 
lines terminated by '\n' 
ignore 3 rows
set data_registro_ANS = date_format(str_to_date(data_registro_ANS,"%d/%m/%Y"),"%Y/%m/%d");

/*----------------------------------------------------------------------------------*/

				/*TABELA PRIMEIRO TRIMESTRE DO ULTIMO ANO*/
create table primeirotri(
dataPri date not null,
reg_ANS varchar(10) not null,
cd_conta_contabil varchar(15) not null,
descricao mediumtext not null,
vl_saldo_final bigint
)default charset = 'utf8mb4';
				/*CAPTURA DOS DADOS DO PRIMEIRO TRIMESTRE PARA IMPORTAÇÃO NA TABELA*/
load data infile '/desafio3_arquivos/2021/1T2021.csv' 
into table primeirotri fields terminated by ';' 
lines terminated by '\n' 
ignore 1 lines 
set dataPri = date_format(str_to_date(dataPri,"%d/%m/%Y"),"%Y/%m/%d");


/*----------------------------------------------------------------------------------*/           
                
				/*TABELA SEGUNDO TRIMESTRE DO ULTIMO ANO*/
create table segundotri(
dataSeg date not null,
reg_ANS varchar(10) not null,
cd_conta_contabil varchar(15) not null,
descricao mediumtext not null,
vl_saldo_final bigint
)default charset = 'utf8mb4';
				/*CAPTURA DOS DADOS DO SEGUNDO TRIMESTRE PARA IMPORTAÇÃO NA TABELA*/
load data infile '/desafio3_arquivos/2021/2T2021.csv'
into table segundotri fields terminated by ';' 
lines terminated by '\n' 
ignore 1 lines 
set dataSeg = date_format(str_to_date(dataSeg,"%d/%m/%Y"),"%Y/%m/%d");
/*----------------------------------------------------------------------------------*/

				/*TABELA DO TERCEIRO TRIMESTRE ULTIMO ATÉ O MOMENTO*/
create table terceirotri(
dataTri date not null,
reg_ANS varchar(10) not null,
cd_conta_contabil varchar(15) not null,
descricao mediumtext not null,
vl_saldo_final bigint
)default charset = 'utf8mb4';

				/*CAPTURA DOS DADOS DO ULTIMO TRIMESTRE PARA IMPORTAÇÃO NA TABELA*/
load data infile '/desafio3_arquivos/2021/3T2021.csv'
into table terceirotri fields terminated by ';' 
lines terminated by '\n' 
ignore 1 lines 
set dataTri = date_format(str_to_date(dataTri,"%d/%m/%Y"),"%Y/%m/%d");
/*----------------------------------------------------------------------------------*/
				/*Quais as 10 operadoras que mais tiveram despesas com 
                "EVENTOS/ SINISTROS CONHECIDOS OU AVISADOS  DE ASSISTÊNCIA 
                A SAÚDE MEDICO HOSPITALAR" no último trimestre?*/
                
select c.nomeFantasia, c.razaoSocial, t.reg_ANS, t.vl_saldo_final
	from terceirotri as t, cadastrosop as c
	where t.descricao = 'EVENTOS/ SINISTROS CONHECIDOS OU AVISADOS  DE ASSISTÊNCIA A SAÚDE MEDICO HOSPITALAR '
    and c.registroANS = t.reg_ANS
    order by t.vl_saldo_final asc
    limit 10;
/*----------------------------------------------------------------------------------*/
				/*Quais as 10 operadoras que mais tiveram despesas com
                "EVENTOS/ SINISTROS CONHECIDOS OU AVISADOS  DE ASSISTÊNCIA
                A SAÚDE MEDICO HOSPITALAR" no último ano?*/

select c.razaoSocial, c.registroANS, c.nomeFantasia, c.representante, p.descricao, p.vl_saldo_final
	from primeirotri as p, cadastrosop as c
    where p.descricao = 'EVENTOS/ SINISTROS CONHECIDOS OU AVISADOS  DE ASSISTÊNCIA A SAÚDE MEDICO HOSPITALAR '
	and p.reg_ANS = c.registroANS
UNION
select c.razaoSocial, c.registroANS, c.nomeFantasia, c.representante, s.descricao, s.vl_saldo_final
	from segundotri as s, cadastrosop as c
    where s.descricao = 'EVENTOS/ SINISTROS CONHECIDOS OU AVISADOS  DE ASSISTÊNCIA A SAÚDE MEDICO HOSPITALAR '
	and s.reg_ANS = c.registroANS
UNION 
select c.razaoSocial, c.registroANS, c.nomeFantasia, c.representante, t.descricao, t.vl_saldo_final
	from terceirotri as t, cadastrosop as c
    where t.descricao = 'EVENTOS/ SINISTROS CONHECIDOS OU AVISADOS  DE ASSISTÊNCIA A SAÚDE MEDICO HOSPITALAR '
	and t.reg_ANS = c.registroANS
group by c.registroANS
order by vl_saldo_final asc
limit 10;

