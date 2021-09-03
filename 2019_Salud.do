
*------------------------------------------------------------------
* Promedio de horas trabajadas a la semana en la ocupación principal 
* de los afiliados al SIS y EsSalud en el periodo 2018 - 2020	
*------------------------------------------------------------------
*HORAS TRABAJADAS A LA SEMANA DE LOS TRABAJADORES AFILIADOS 
*A ESSALUD Y AL SIS:

*------------------------------------------------------------------
*						DATA PREPARATION
*------------------------------------------------------------------
************************************************
************* MODULO SALUD *********************
************************************************
clear all
set more off

global dir "C:\Users\Z50-CORE-I5\Desktop\Social Mobility Measure\Salud1"
cd "$dir"

use "$dir\enaho01a-2019-400.dta", clear
* Verficamos los ID del modulo 400 - person level 
cap isid ubigeo conglome vivienda hogar codperso
isid ubigeo conglome vivienda hogar codperso
keep ubigeo conglome vivienda hogar codperso dominio factor07 p4191 p4195
sort conglome vivienda hogar ubigeo
save "$dir\base3.dta", replace

*************************************************
************* MODULO EMPLEO E INGRESOS **********
*************************************************
use "$dir\enaho01a-2019-500.dta", clear
* Verficamos los ID del modulo 500 - person level 
*p513T. ¿Cuántas horas en total trabajó la semana pasada, en su ocupación principal?
*La variable nos permite determinar el total de horas trabajadas en la ocupación principal del entrevistado, la semana pasada.
cap isid ubigeo conglome vivienda hogar codperso
isid ubigeo conglome vivienda hogar codperso
keep ubigeo conglome vivienda hogar codperso dominio p513t 
sort conglome vivienda hogar ubigeo
* ahora unimos tanto la base Empleo y la base Salud/ ambas tienen los mismos ids
merge 1:1 ubigeo conglome vivienda hogar codperso using "base3.dta"
drop _m 
* nos quedamos con las peronas que reportan horas trabajadas y eliminamos los missings values
* p513t
replace p513t = 0 if p513t == .
drop if p513t == 0
drop if p4191 == 2
drop if p4195 == 2
*PROMEDIO DE HORAS TRABAJADAS SEMANALES POR LOS AFILIADOS A ESSALUD
 collapse (mean) p513t , by(p4191 )
 collapse (mean) p513t , by(p4195 )
 *o simplemente utilizas el comando summarize que tmb te reporta la media
 sum p513t
