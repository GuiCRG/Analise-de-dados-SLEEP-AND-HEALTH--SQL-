-- Verifica��o dos Data Types para documenta��o
select * from INFORMATION_SCHEMA.COLUMNS
where table_name = 'Fato_people'

-----------------------------------------------------------

-- Cria��o da tabela Dim_people
Use [Health and sleep relation]
Create table Dim_People
(	Person_ID smallint,
	Gender varchar(6),
	Age smallint,
	Occupation varchar(20)
	)
----------------------------------------------------------

-- Inser��o dos person_id na dim_people

insert into Dim_People (Person_ID)  
select [Person ID]
From Fato_people
-----------------------------------------------------------

-- Visualiza��o eventual
select * from Dim_People
Select * from Fato_people
-----------------------------------------------------------


--Adi��o das tabelas que ir�o compor a dim_people
Alter table dim_people 
add  Age smallint , Gender varchar (6)

Alter table dim_people 
add  Occupation varchar(20)
-----------------------------------------------------------

-- Merge para consolidar dados da tabela sleep para dim_people
Merge into dim_people as dp 
using Fato_people as sp 
ON dp.[Person_id] = sp.[Person ID]
when matched then update set dp.Gender = sp.Gender, dp.Age = sp.Age, dp.Occupation = sp.Occupation;

-----------------------------------------------------------
--Drop das colunas na sleep por que estar�o na outra agora
alter table Fato_people
drop column [Gender],[Occupation]; 

-----------------------------------------------------------

Select * from Fato_people

--Altera��o de data type para n�o nulo e estabelecimento de primary key
alter table Dim_People
alter column Person_ID SMALLINT NOT NULL

alter table Dim_People
ADD CONSTRAINT PK_ID_PEOPLE PRIMARY KEY (Person_ID)

-----------------------------------------------------------
--Conex�o foreing key to primary key das tabelas

alter table Fato_people
add constraint FK_personID FOREIGN KEY ([PERSON ID]) REFERENCES Dim_people(Person_ID)

-----------------------------------------------------------

select Dim_People.Occupation, Fato_people.[Daily Steps] from Dim_People join Fato_people
on Dim_People.Person_ID = Fato_people.[Person ID]


EXEC sp_help Fato_people


-- Poss�veis an�lises --
-- M�dia de passos di�rios
use [Health and sleep relation]
select Dim_People.Occupation, avg(Fato_people.[Daily Steps]) as M�dia_de_passos_di�rios,
count(Dim_People.Occupation) as Count_of_People
from Dim_People join Fato_people
on Dim_People.Person_ID = Fato_people.[Person ID]
Group by  Dim_People.Occupation order by M�dia_de_passos_di�rios desc


use [Health and sleep relation]
Select * from Dim_People
select * from Fato_people

--  1) Pessoas que possuem menos que 5000 passos di�rios possuem dist�rbios de sono?  
use [Health and sleep relation]
select [Daily Steps] , [Sleep Disorder], [Stress Level] from fato_people
where [Daily Steps] < 5000 

------------------------------------------------------------------------------------------

--  2) Pessoas com >=8k de passos possuem uma boa qualidade do sono?
use [Health and sleep relation]
select * from Fato_people
where [Daily Steps]>=8000


----------------------------------------------------------------------------------------------
--  3) Pessoas com mais estresse possuem dist�rbios do sono e qual sua ocupa��o?  

use [Health and sleep relation]
select fato_people.[Daily Steps], fato_people.[Quality of Sleep], fato_people.[Stress Level], 
fato_people.[Sleep Disorder], dim_people.Occupation from Fato_people join Dim_People
on Fato_people.[Person ID] = Dim_People.Person_ID 
where [Stress Level]>=7 and [Sleep Disorder] <> 'none'


select AVG([Daily Steps]) as 'M�dia passos di�rios' from Fato_people
WHERE [Stress Level]>=7 


select Dim_People.Occupation, COUNT(Fato_people.[Heart Rate]) as 'Contagem_Sleep' 
from Dim_People join Fato_people
on Dim_People.Person_ID = Fato_people.[Person ID]
where Fato_people.[Stress Level]>=7
Group by Dim_People.Occupation


Select COUNT(Fato_people.[Heart Rate]) as Fato_Contagem from Fato_people
where Fato_people.[Stress Level]>=7


-----------------------------------------------------------------------------------------

-- 4) Quantas pessoas est�o com sobrepeso ou obesas?

Use [Health and sleep relation]
Select COUNT(Fato_people.[Blood Pressure]) as Contagem from Fato_people
where Fato_people.[BMI Category] <> 'Normal'



----------------------------------------------------------------------------------------
-- 5) Quantas pessoas dormem abaixo de 7h?
select COUNT([Sleep Duration]) as 'Contagem -7h' from Fato_people
where [Sleep Duration] <7

----------------------------------------------------------------------------------------



-- 5)Pessoas obesas ou sobrepesas possuem uma boa qualidade do sono?
Select Dim_People.Occupation,AVG(Fato_people.[Sleep Duration]) as 'AVG SLEEP DURATION' 
from Dim_People join Fato_people
on Dim_People.Person_ID = Fato_people.[Person ID]
where [Sleep Duration]<7
group by Dim_People.Occupation
