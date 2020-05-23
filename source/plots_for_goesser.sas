libname outty "C:\Heineken\figures\ResultsIncluded";
/*Figure 2*/
data outty.fig2;
	set work.fig2;
	time=_N_;
run;




ods _all_ close;

ods graphics / reset outputfmt=eps noborder imagename='fig2';

ods listing
       image_dpi=300
       gpath="C:\Heineken\";

proc sgplot data=outty.fig2 (where=(time<=200)); 
	series x=time y=_3			/ markers lineattrs=(pattern=solid color=black thickness=1) markerattrs=(size=7 symbol=circlefilled color=black) name="A" legendlabel='R0=3';
	series x=time y=_2_7		/ markers lineattrs=(pattern=shortdash color=blue thickness=1) markerattrs=(size=7 symbol=circlefilled color=blue) name="B" legendlabel='R0=2.7';
	series x=time y=_2_4		/ markers lineattrs=(pattern=longdash color=green thickness=1) markerattrs=(size=7 symbol=circlefilled color=green) name="C" legendlabel='R0=2.4';
	series x=time y=_2_1		/ markers lineattrs=(pattern=solid color=red thickness=1) markerattrs=(size=7 symbol=circlefilled color=red) name="D" legendlabel='R0=2.1';
	xaxis valueattrs=(size=8 color=black) display=(noticks) offsetmin=0.02 offsetmax=0.02 label = "time[days]" labelattrs=(size=8 weight=normal) values=(0 to 200 by 10);
	yaxis valueattrs=(size=8) values=(0 to 600000 by 10000) minor label = "Daily Infections per 100K inhabitants" labelattrs=(size=8 weight=normal); 		
	keylegend "A" "B" "C" "D"/ location=outside position=bottom valueattrs=(size=7) across=4;

run;

data outty.fig2a;
	set outty.fig2;
	_3a=_3/9065000*100;
	_27a=_2_7*100/9065000;
	_24a=_2_4*100/9065000;
	_21a=_2_1*100/9065000;
run;

ods _all_ close;

ods graphics / reset outputfmt=eps noborder imagename='fig2a';

ods listing
       image_dpi=300
       gpath="C:\Heineken\";

proc sgplot data=outty.fig2a (where=(time<=200)); 
	series x=time y=_3a			/ markers lineattrs=(pattern=solid color=black thickness=1) markerattrs=(size=7 symbol=circlefilled color=black) name="A" legendlabel='R0=3';
	series x=time y=_27a		/ markers lineattrs=(pattern=shortdash color=blue thickness=1) markerattrs=(size=7 symbol=circlefilled color=blue) name="B" legendlabel='R0=2.7';
	series x=time y=_24a		/ markers lineattrs=(pattern=longdash color=green thickness=1) markerattrs=(size=7 symbol=circlefilled color=green) name="C" legendlabel='R0=2.4';
	series x=time y=_21a		/ markers lineattrs=(pattern=solid color=red thickness=1) markerattrs=(size=7 symbol=circlefilled color=red) name="D" legendlabel='R0=2.1';
	xaxis valueattrs=(size=8 color=black) display=(noticks) offsetmin=0.02 offsetmax=0.02 label = "time[days]" labelattrs=(size=8 weight=normal) values=(0 to 200 by 10);
	yaxis valueattrs=(size=8) values=(0 to 8 by 0.5) minor label = "daily Infections [% total population]" labelattrs=(size=8 weight=normal); 		
	keylegend "A" "B" "C" "D"/ location=outside position=bottom valueattrs=(size=7) across=4;

run;


/*Figure 7*/
proc sql;
	select distinct max(CR0) into :max from work.fig7;
quit;

data outty.fig7;
	set work.fig7;
	CR0=CR0/&max.;
	CR01=CR01/&max.;
	CR02=CR02/&max.;
	CR03=CR03/&max.;
	CR04=CR04/&max.;
	time=_N_;
run;

ods _all_ close;

ods graphics / reset outputfmt=eps noborder imagename='fig7';

ods listing
       image_dpi=300
       gpath="C:\Heineken\";

proc sgplot data=outty.fig7 ; 
	series x=time y=CR0			/ markers lineattrs=(pattern=solid color=black thickness=1) markerattrs=(size=7 symbol=circlefilled color=black) name="A" legendlabel='0% Contact Reduction';
	series x=time y=CR01		/ markers lineattrs=(pattern=shortdash color=blue thickness=1) markerattrs=(size=7 symbol=circlefilled color=blue) name="B" legendlabel='10% Contact Reduction';
	series x=time y=CR02		/ markers lineattrs=(pattern=longdash color=green thickness=1) markerattrs=(size=7 symbol=circlefilled color=green) name="C" legendlabel='20% Contact Reduction';
	series x=time y=CR03		/ markers lineattrs=(pattern=solid color=red thickness=1) markerattrs=(size=7 symbol=circlefilled color=red) name="D" legendlabel='30% Contact Reduction';
	series x=time y=CR04		/ markers lineattrs=(pattern=solid color=purple thickness=1) markerattrs=(size=7 symbol=circlefilled color=purple) name="E" legendlabel='40% Contact Reduction';
	refline 200 /axis=x  lineattrs=(pattern=shortdash color=black thickness=2) name="F" legendlabel='Measures Removed';
	xaxis valueattrs=(size=8 color=black) display=(noticks) offsetmin=0.02 offsetmax=0.02 label = "time [days]" labelattrs=(size=8 weight=normal) values=(0 to 400 by 10);
	yaxis valueattrs=(size=8) values=(0 to 1 by 0.05) minor label = "relative fatalities" labelattrs=(size=8 weight=normal); 		
	keylegend "A" "B" "C" "D" "E" "F"/ location=outside position=bottom valueattrs=(size=5) across=4;

run;
/*Figure 9*/
data outty.fig9;
	set work.fig9;
	time=_N_;
run;

ods _all_ close;

ods graphics / reset outputfmt=eps noborder imagename='fig9';

ods listing
       image_dpi=300
       gpath="C:\Heineken\";

proc sgplot data=outty.fig9 ; 
	series x=time y=ICU			/ markers lineattrs=(pattern=solid color=blue thickness=1) markerattrs=(size=7 symbol=circlefilled color=blue) name="A" legendlabel='Number of ICU needed per 100000 inhabitants';
	refline 21.7956 /axis=y  lineattrs=(pattern=shortdash color=black thickness=2) name="F" legendlabel='number of ICU available per 100000 inhabitants';
	xaxis valueattrs=(size=8 color=black) display=(noticks) offsetmin=0.02 offsetmax=0.02 label = "time[days]" labelattrs=(size=8 weight=normal) values=(0 to 2500 by 100);
	yaxis valueattrs=(size=8) values=(0 to 25 by 1) minor label = "number of ICU per 100000 inhabitants" labelattrs=(size=8 weight=normal); 		
	keylegend "A" "F"/ location=outside position=bottom valueattrs=(size=5) across=4;

run;

/*Figure 8*/

%MACRO reihe();
	proc sql ;
		create table seppal as
		select name,
				monotonic() as number 
		from dictionary.columns
		where memname = 'FIG8' and LIBNAME='WORK';
	quit;
	proc sql;
		select count(name) into: counter from dictionary.columns where memname = 'FIG8' and LIBNAME='WORK';
	quit;
	%do i=1 %to &counter.;
		proc sql;
			select distinct name into: names from seppal (where=(number=&i.));
		quit;

		%if &i.<=2 %then %do;
			%let Boarder=21.7956;
		%end;

		%else %do;
			%let Boarder=5.8;
		%end;

		data javier_&i. (keep=ICU Scenario reffy time);
			set work.fig8;
			format Scenario $30. ;
			rename &names.=ICU;
			Scenario="&&names.";
			reffy=&Boarder;
			time=_N_;
		run;

		


	%end;

	data jaime;
		set javier:;
	run;

	proc datasets lib=work;
		delete javier_:;
	run;
	quit;

%MEND;
%reihe;

data outty.fig8;
	set work.jaime;
run;

title1 "Product Sales";

PROC FORMAT ;
VALUE $CARLOS 	"Scenario2_Austria" = "Scenario 7 Austria, R0=2.3"
				"Scenario5_Austria" = "Scenario 9 Austria, R0=3.15"
				"Scenario2_Sweden" = "Scenario 8 Sweden, R0=2.3"
				"Scenario5_Sweden" = "Scenario 10 Sweden, R0=3.15" ;
RUN ;

ods _all_ close;

ods graphics / reset outputfmt=eps noborder imagename='fig8';

ods listing
       image_dpi=300
       gpath="C:\Heineken\";
proc sgpanel data=outty.fig8;
	panelby Scenario /LAYOUT= PANEL NOVARNAME;
	format Scenario $CARLOS.;
	colaxis grid label="time [days]";
	rowaxis  grid label="number of ICU per 100000 inhabitants";
	series x=time y=ICU			/ markers lineattrs=(pattern=solid color=blue thickness=1) markerattrs=(size=2.9 symbol=circlefilled color=blue) name="A" legendlabel='number of ICU needed per 100000 inhabitants';
	refline reffy /axis=y  lineattrs=(pattern=shortdash color=black thickness=2) name="F" legendlabel='number of ICU available per 100000 inhabitants';
	*xaxis valueattrs=(size=8 color=black) display=(noticks) offsetmin=0.02 offsetmax=0.02 label = "time[days]" labelattrs=(size=8 weight=normal) values=(0 to 2500 by 100);
	*yaxis valueattrs=(size=8) values=(0 to 25 by 1) minor label = "Number of ICU per 100000 inhabitants" labelattrs=(size=8 weight=normal); 		
	*keylegend "A" "F"/ location=outside position=bottom valueattrs=(size=5) across=4;

run;

ods _all_ close;

ods graphics / reset outputfmt=png noborder imagename='fig8';

ods listing
       image_dpi=300
       gpath="C:\Heineken\";
proc sgpanel data=outty.fig8;
	panelby Scenario /LAYOUT= PANEL NOVARNAME;
	format Scenario $CARLOS.;
	colaxis grid label="time [days]";
	rowaxis  grid label="number of ICU per 100000 inhabitants";
	series x=time y=ICU			/ markers lineattrs=(pattern=solid color=blue thickness=1) markerattrs=(size=2.9 symbol=circlefilled color=blue) name="A" legendlabel='number of ICU needed per 100000 inhabitants';
	refline reffy /axis=y  lineattrs=(pattern=shortdash color=black thickness=2) name="F" legendlabel='number of ICU available per 100000 inhabitants';
	*xaxis valueattrs=(size=8 color=black) display=(noticks) offsetmin=0.02 offsetmax=0.02 label = "time[days]" labelattrs=(size=8 weight=normal) values=(0 to 2500 by 100);
	*yaxis valueattrs=(size=8) values=(0 to 25 by 1) minor label = "Number of ICU per 100000 inhabitants" labelattrs=(size=8 weight=normal); 		
	*keylegend "A" "F"/ location=outside position=bottom valueattrs=(size=5) across=4;

run;

/*Figure 6*/


%MACRO reihe();
	proc sql ;
		create table seppal as
		select name,
				input(substr(name,3,1),best12.) as number 
		from dictionary.columns
		where memname = 'FIG6' and LIBNAME='WORK' and name ne "Time";
	quit;
	proc sql;
		select distinct (max(number)) into: counter from seppal;
	quit;
	%do i=1 %to &counter.;
		proc sql;
			select distinct name into: names separated by " " from seppal (where=(number=&i.));
			select distinct name into: names2 separated by "|" from seppal (where=(number=&i.));
		quit;


		data javier_&i.;
			set work.fig6 (keep=&names. time);
			format Scenario $30. ;
			%do j=1 %to 3;
				%let ansi=%scan(&names2.,&j.,%str(|));
				%if &j=1 %then %do;
					rename &ansi.= SC_02;
				%end;
				%else %if &j=2 %then %do;
					rename &ansi.= SC_03;
				%end;
				%else %if &j=3 %then %do;
					rename &ansi.= SC_04;
				%end;	
			%end;
			Scenario="Scenario"||" "||strip("&i");
		run;

		


	%end;

	data jaime;
		set javier:;
	run;

	proc datasets lib=work;
		delete javier_:;
	run;
	quit;

%MEND;
%reihe;

data outty.fig6;
	set work.jaime;
run;

PROC FORMAT ;
VALUE $FERENCZ 	"Scenario 1" = "Scenario 1, R0=3.51"
				"Scenario 2" = "Scenario 2, R0=2.3"
				"Scenario 3" = "Scenario 3, R0=1.53"
				"Scenario 4" = "Scenario 4, R0=4.8"
				"Scenario 5" = "Scenario 5, R0=3.15"
				"Scenario 6" = "Scenario 6, R0=2.1" ;
RUN ;


ods _all_ close;

ods graphics / reset outputfmt=png noborder imagename='fig6';

ods listing
       image_dpi=300
       gpath="C:\Heineken\";

proc sgpanel data=outty.fig6;
	panelby Scenario /LAYOUT= PANEL NOVARNAME COLUMNS=2;
	format Scenario $FERENCZ.;
	colaxis grid label="duration of measure application [days]";
	rowaxis  grid label="relative fatalities";
	series x=time y=SC_02			/ markers lineattrs=(pattern=solid color=black thickness=1) markerattrs=(size=2.9 symbol=circlefilled color=black) name="A" legendlabel='20% Contact Reduction';
	series x=time y=SC_03			/ markers lineattrs=(pattern=longdash color=blue thickness=1) markerattrs=(size=2.9 symbol=circlefilled color=blue) name="B" legendlabel='30% Contact Reduction';
	series x=time y=SC_04			/ markers lineattrs=(pattern=shortdash color=green thickness=1) markerattrs=(size=2.9 symbol=circlefilled color=green) name="C" legendlabel='40% Contact Reduction';
	*keylegend "A" "F"/ location=outside position=bottom valueattrs=(size=5) across=4;

run;

ods _all_ close;

ods graphics / reset outputfmt=eps noborder imagename='fig6';

ods listing
       image_dpi=300
       gpath="C:\Heineken\";

proc sgpanel data=outty.fig6;
	panelby Scenario /LAYOUT= PANEL NOVARNAME COLUMNS=2;
	format Scenario $FERENCZ.;
	colaxis grid label="duration of measure application [days]";
	rowaxis  grid label="relative fatalities";
	series x=time y=SC_02			/ markers lineattrs=(pattern=solid color=black thickness=1) markerattrs=(size=2.9 symbol=circlefilled color=black) name="A" legendlabel='20% Contact Reduction';
	series x=time y=SC_03			/ markers lineattrs=(pattern=longdash color=blue thickness=1) markerattrs=(size=2.9 symbol=circlefilled color=blue) name="B" legendlabel='30% Contact Reduction';
	series x=time y=SC_04			/ markers lineattrs=(pattern=shortdash color=green thickness=1) markerattrs=(size=2.9 symbol=circlefilled color=green) name="C" legendlabel='40% Contact Reduction';
	*keylegend "A" "F"/ location=outside position=bottom valueattrs=(size=5) across=4;

run;