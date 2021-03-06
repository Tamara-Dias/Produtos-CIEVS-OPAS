
#'*Script que calcula o n�mero de casos ativos dos 7 dias anteriores ao c�lculo da Matriz*

options(repos=structure(c(CRAN="https://vps.fmvz.usp.br/CRAN/"))) #colocando o mirror de S�o Paulo

if (!require("DT")) install.packages("DT", type = "binary")
if (!require("pacman")) install.packages("pacman")
pacman::p_load(data.table, tidyverse, lubridate, tibbletime, dplyr, zoo, EpiEstim, formattable, 
               DT, Hmisc, knitr, openxlsx)

# BANCOS UTILIZADOS -------------------------------------------------------

# Fazendo download do painel 
setwd(getwd())

painel7atras <- read.xlsx('painel7.xlsx')
painel7 <- painel7atras %>% select("id", "RA", "dataPrimeiroSintomas", "classificacaoFinal", "dataObito")
rm(painel7atras) #removendo o painel com muitas vari�veis

hoje <- Sys.Date() #data de hoje

# Calculando casos ativos de cada regi�o do painel de 7 dias atr�s
painel7dias <- painel7 %>% mutate(Regiao = case_when(RA == "Plano Piloto" ~ 'Regi�o Central',
                                                     RA == "Sudoeste/Octogonal" ~ 'Regi�o Central',
                                                     RA == "Cruzeiro" ~ 'Regi�o Central',
                                                     RA == "Lago Norte" ~ 'Regi�o Central',
                                                     RA == "Lago Sul" ~ 'Regi�o Central',
                                                     RA == "Varj�o" ~ 'Regi�o Central',
                                                     RA == "Candangol�ndia" ~ 'Regi�o Centro Sul',
                                                     RA == "Park Way" ~ 'Regi�o Centro Sul',
                                                     RA == "Guar�" ~ 'Regi�o Centro Sul',
                                                     RA == "N�cleo Bandeirante" ~ 'Regi�o Centro Sul',
                                                     RA == "Riacho Fundo" ~ 'Regi�o Centro Sul',
                                                     RA == "Riacho Fundo II" ~ 'Regi�o Centro Sul',
                                                     RA == "SCIA" ~ 'Regi�o Centro Sul',
                                                     RA == "SIA" ~ 'Regi�o Centro Sul',
                                                     RA == "Itapo�" ~ 'Regi�o Leste',
                                                     RA == "Parano�" ~ 'Regi�o Leste',
                                                     RA == "S�o Sebasti�o" ~ 'Regi�o Leste',
                                                     RA == "Jardim Bot�nico" ~ 'Regi�o Leste',
                                                     RA == "Fercal" ~ 'Regi�o Norte',
                                                     RA == "Planaltina" ~ 'Regi�o Norte',
                                                     RA == "Sobradinho" ~ 'Regi�o Norte',
                                                     RA == "Sobradinho II" ~ 'Regi�o Norte',
                                                     RA == "Brazl�ndia" ~ 'Regi�o Oeste',
                                                     RA == "Ceil�ndia" ~ 'Regi�o Oeste',
                                                     RA == "Sol Nascente" ~ 'Regi�o Oeste',
                                                     RA == "�guas Claras" ~ 'Regi�o Sudoeste',
                                                     RA == "Recanto das Emas" ~ 'Regi�o Sudoeste',
                                                     RA == "Samambaia" ~ 'Regi�o Sudoeste',
                                                     RA == "Taguatinga" ~ 'Regi�o Sudoeste',
                                                     RA == "Vicente Pires" ~ 'Regi�o Sudoeste',
                                                     RA == "Arniqueira" ~ 'Regi�o Sudoeste',
                                                     RA == "Gama" ~ 'Regi�o Sul',
                                                     RA == "Santa Maria" ~ 'Regi�o Sul',
                                                     T ~ 'N�o informado'))
painel7dias <- data.table(painel7dias)

ativos_central7 <- sum(painel7dias$Regiao == 'Regi�o Central' & painel7dias$classificacaoFinal == 'Ignorado', na.rm = TRUE)
ativos_centroSul7 <- sum(painel7dias$Regiao == 'Regi�o Centro Sul' & painel7dias$classificacaoFinal == 'Ignorado', na.rm = TRUE)
ativos_leste7 <- sum(painel7dias$Regiao == 'Regi�o Leste' & painel7dias$classificacaoFinal == 'Ignorado', na.rm = TRUE)
ativos_norte7 <- sum(painel7dias$Regiao == 'Regi�o Norte' & painel7dias$classificacaoFinal == 'Ignorado', na.rm = TRUE)
ativos_oeste7 <- sum(painel7dias$Regiao == 'Regi�o Oeste' & painel7dias$classificacaoFinal == 'Ignorado', na.rm = TRUE)
ativos_sudoeste7 <- sum(painel7dias$Regiao == 'Regi�o Sudoeste' & painel7dias$classificacaoFinal == 'Ignorado', na.rm = TRUE)
ativos_sul7 <- sum(painel7dias$Regiao == 'Regi�o Sul' & painel7dias$classificacaoFinal == 'Ignorado', na.rm = TRUE)
ativos_DF7 <- sum(painel7dias$classificacaoFinal == 'Ignorado', na.rm = TRUE)

casosAtivos7dias <- data.frame(ativos_central7, ativos_centroSul7, ativos_leste7, ativos_norte7, ativos_oeste7, ativos_sudoeste7, ativos_sul7, ativos_DF7)
write.csv2(casosAtivos7dias, file=paste0(format(hoje-7, '%d-%m-%y'),"casosAtivos7dias.csv"), row.names=FALSE)
