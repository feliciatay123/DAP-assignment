/*Appendix 1: to import WORK.table1415*/

FILENAME REFFILE '/home/tp0446020/Table4/Table_4_20152014.xls';

PROC IMPORT DATAFILE=REFFILE
	DBMS=XLS
	OUT=WORK.table1415;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.table1415; RUN;



/*Appendix 2: to check missing values*/

proc means data=WORK.TABLE1415 chartype n nmiss vardef=df;

var Year Population Violent_crime Murder Rape Robbery Aggravated_assault 

Property_crime Burglary Larceny_theft Motor_vehicle_theft Arson;

run;



/*Appendix 3: to import WORK.Crime_Rate_by_State*/

FILENAME REFFILE '/home/tp0446020/Table4/Crime_rate_by_state.xlsx';
PROC IMPORT DATAFILE=REFFILE
	DBMS=XLSX
	OUT=WORK.Crime_Rate_by_State;
	GETNAMES=YES;
RUN;
PROC CONTENTS DATA=WORK.Crime_Rate_by_State; RUN;



/*Appendix 4: to generate scatter plot for violent crime & property crime by state codes*/

proc sgplot data=WORK.CRIME_RATE_BY_STATE;
	scatter x=Property_crime y=Violent_crime / group=Year datalabel=State_code 
		datalabelattrs=(size=7) transparency=0.0 name='Scatter';
	xaxis grid;
	yaxis grid;
run;



/*Appendix 5: to import WORK.TOP5STATES*/

FILENAME REFFILE '/home/tp0446020/Table4/top5states.xlsx';
PROC IMPORT DATAFILE=REFFILE
	DBMS=XLSX
	OUT=WORK.TOP5STATES;
	GETNAMES=YES;
RUN;
PROC CONTENTS DATA=WORK.TOP5STATES; RUN;



/*Appendix 6: to generate pie chart for property crime by top 5 states*/

proc template ;
	define statgraph WebOne.Pie;
		begingraph;
		layout region;
piechart category=State response=Property_crime / group=Year groupgap=2% 
			start=90 datalabellocation=INSIDE;
		endlayout;
		endgraph;
	end;
run;
proc sgrender template=WebOne.Pie data=WORK.TOP5STATES;
run;



/*Appendix 7: to generate analysis for property crime*/

proc means data=WORK.TOP5STATES chartype mean std min max n vardef=df;
	var Property_crime;
	class Year State;
run;



/*Appendix 8: to drill down property crime in New York*/

proc sort data=WORK.TOP5STATES out=WORK.SORTTEMP;
	by Year;
	where State="NEW YORK";
run;
proc print data=WORK.SORTTEMP label noobs;
	var State City Population Property_crime Burglary Larceny_theft Motor_vehicle_theft;
	by Year;
run;



/*Appendix 9: to generate distribution of property crime by state)*/

%macro DEHisto(data=, avar=, classVar=);
	%local i numAVars numCVars cVar cVar1 cVar2;
	%let numAVars=%Sysfunc(countw(%str(&avar), %str( )));
	%let numCVars=%Sysfunc(countw(%str(&classVar), %str( )));
      	%let cVar1=%scan(%str(&classVar), 1, %str( ));
%let cVar2=%scan(%str(&classVar), 2, %str( ));
	proc sql noprint;
		select count(distinct &cVar1) into :nrows from &data;
		quit;
		proc sql noprint;
		select count(distinct &cVar2) into :ncols from &data;
		quit;
		proc univariate data=&data noprint;
			var &avar;
			class &cVar1 &cVar2;
			histogram &avar / nrows=&nrows ncols=&ncols
           		  normal(noprint);  run;
%mend DEHisto;
%DEHisto(data=WORK.TOP5STATES, avar=Property_crime, classVar=Year State);
 


/*Appendix 10: to drill down property crime in Illinois)*/

proc sort data=WORK.TOP5STATES out=WORK.SORTTEMP;
	by Year;
	where State="ILLINOIS";
run;
proc print data=WORK.SORTTEMP label noobs;
	var State City Population Property_crime Burglary Larceny_theft Motor_vehicle_theft;
	by Year;
run;



/*Appendix 11: to drill down property crime in Texas)*/

proc sort data=WORK.TOP5STATES out=WORK.SORTTEMP;
	by Year;
	where State="TEXAS" AND Property_crime>10000;
run;
proc print data=WORK.SORTTEMP label noobs;
	var State City Population Property_crime Burglary Larceny_theft Motor_vehicle_theft;
	by Year;
run;



/*Appendix 12: to generate pie chart for violent crime by top 5 states)*/

proc template ;
	define statgraph WebOne.Pie;
		begingraph;
		layout region;
		piechart category=State response=Violent_crime / group=Year groupgap=2% 
			start=90 datalabellocation=INSIDE;
		endlayout;
		endgraph;
	end;
run;
proc sgrender template=WebOne.Pie data=WORK.TOP5STATES;
run;



/*Appendix 13: to generate analysis for violent crime)*/

proc means data=WORK.TOP5STATES chartype mean std min max median n nmiss 
		vardef=df qmethod=os;
	var Violent_crime;
	class Year State;
run;



/*Appendix 14: to drill down violent crime in New York)*/

proc sort data=WORK.TOP5STATES out=WORK.SORTTEMP;
	by Year;
	where State="NEW YORK";
run;
proc print data=WORK.SORTTEMP label noobs;
	var State City Population Violent_crime Murder Rape Robbery Aggravated_assault;
	by Year;
run;



/*Appendix 15: to generate distribution of violent crime by state)*/

%macro DEHisto(data=, avar=, classVar=);
	%local i numAVars numCVars cVar cVar1 cVar2;
	%let numAVars=%Sysfunc(countw(%str(&avar), %str( )));
	%let numCVars=%Sysfunc(countw(%str(&classVar), %str( )));
      	%let cVar1=%scan(%str(&classVar), 1, %str( ));
%let cVar2=%scan(%str(&classVar), 2, %str( ));

	proc sql noprint;
		select count(distinct &cVar1) into :nrows from &data;
		quit;
		proc sql noprint;
		select count(distinct &cVar2) into :ncols from &data;
		quit;
		proc univariate data=&data noprint;
			var &avar;
			class &cVar1 &cVar2;
			histogram &avar / nrows=&nrows ncols=&ncols
           		  normal(noprint);
			run;
%mend DEHisto;
%DEHisto(data=WORK.TOP5STATES, avar=Violent_crime, classVar=Year State);



/*Appendix 16: to drill down violent crime in Illinois)*/

proc sort data=WORK.TOP5STATES out=WORK.SORTTEMP;
	by Year;
	where State="ILLINOIS";
run;
proc print data=WORK.SORTTEMP label noobs;
	var State City Population Violent_crime Murder Rape Robbery Aggravated_assault;
	by Year;
run;



/*Appendix 17: to generate scatter plot for murder by city)*/

proc sgplot data=WORK.TOP5STATES;
	/*--Fit plot settings--*/
	reg x=Violent_crime y=Murder / nomarkers group=Year name='Regression';

	scatter x=Violent_crime y=Murder / group=Year datalabel=City 
		datalabelattrs=(size=7) transparency=0.0 name='Scatter';
	xaxis grid;
	yaxis grid;
run;



/*Appendix 18: to drill down violent crime in Texas)*/

proc sort data=WORK.TOP5STATES out=WORK.SORTTEMP;
	by Year;
	where State="TEXAS" AND Violent_crime>10000;
run;

proc print data=WORK.SORTTEMP label noobs;
	var State City Population Violent_crime Murder Rape Robbery Aggravated_assault;
	by Year;
run;



/*Appendix 19: to generate pie chart for arson by top 5 states)*/

proc template ;
	define statgraph WebOne.Pie;
		begingraph;
		layout region;
		piechart category=State response=Arson / group=Year groupgap=2% start=90 
			datalabellocation=INSIDE;
		endlayout;
		endgraph;
	end;
run;

proc sgrender template=WebOne.Pie data=WORK.TOP5STATES;

run;





