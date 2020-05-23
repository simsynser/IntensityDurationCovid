

/*r Macro*/




libname outty "C:\Heineken";


%MACRO sepp(value=);

	proc import datafile  =  'C:\Heineken\initial_test2.xlsx'
	 out  =  initial_test2
	 dbms  =  xlsx
	 replace
	 ;
	 sheet="r&value";
	run;


	data outty.initial_testr&value.;
		set work.initial_test2;
		new_1=Start_1/9064000;
		new_2=Start_2/9064000;
		new_3=Start_3/9064000;
		new_4=Start_4/9064000;
		new_5=Start_5/9064000;
		new_6=Start_6/9064000;
		time=_N_;
	run;

	proc sql;
		create table sums as
		select sum(new_1) as sum1,
				sum(new_2) as sum2,
				sum(new_3) as sum3,
				sum(new_4) as sum4,
				sum(new_5) as sum5,
				sum(new_6) as sum6
		from outty.initial_testr&value.;
	quit;

	proc gplot data=outty.initial_testr&value.;
		plot (new_1 new_2 new_3 new_4 new_5 new_6)*time;
	run;
	quit;

	data foo;
	pi=constant("pi");
	run;
	 
	proc sql;
	select unique pi format=comma20.18 into :pi separated by ' ' from foo;
	quit;
	%do i=1 %to 6;
		proc sql;
			select sum(new_&i) into :area
			from outty.initial_testr&value.;
		quit;

		proc nlin data=outty.initial_testr&value.;
			parameters  mu=60 sigma=7; 
			model new_&i.   = &area./(Sqrt(2*&Pi*sigma**2))*(exp(-(time-mu)**2/(2*sigma**2)));
			output out=nlinout pred=p lcl=lcl ucl=ucl parms=mu;
		run;

		proc sgplot data=nlinout;
		   scatter y=new_&i.   x=time;
		   series  y=p   x=time / name="fit"
		                          lineattrs=GraphFit
		                          LegendLabel="Predicted";
		   keylegend "fit";
		run;

		proc sql;
			create table var_&i. as
			select distinct mu as mu,
							&i. as start,
							&value/100 as R
			from nlinout;
		quit;
	%end;

	data mues_r&value.;
		set var_:;
	run;

	proc gplot data=mues_r&value.;
		plot mu*start;
	run;
	quit;

	proc datasets lib=work;
		delete var_:;
	run;
	quit;

%MEND;
%sepp(value=271);
%sepp(value=189);
%sepp(value=168);
%sepp(value=147);
%sepp(value=126);
%sepp(value=110);
%sepp(value=500);
%sepp(value=210);
%sepp(value=350);



data old_mues;
input R sigma area;
datalines;
5.00 3.06  0.9967949782
3.50 5.08  0.9738708694
2.71 7.53  0.9267921201
2.10 11.81 0.8307510807
1.89 14.52 0.7717158317
1.68 18.79 0.6882530925
1.47 26.67 0.566962206
1.26 46.73 0.3840627278
1.10 117.3 0.1765446398
;
run;




/*all r*/

data mues;
	set work.mues_:;
run;

proc sql;
	create table all_mues as
	select distinct a.*,
					b.sigma,
					b.area
	from mues as a left join old_mues as b on a.R=b.R
	order by R, start;
quit;

data all_mues;
	set all_mues;
	/*rename "mu"n="µ"n;*/
	rename start="Initial Infected"n;
run;

proc template;                        /* surface plot with continuous color ramp */
define statgraph SurfaceTmplt;
dynamic _X _Y _Z _Title;              /* dynamic variables */
 begingraph;
 entrytitle _Title;                   /* specify title at run time (optional) */
  layout overlay3d;
    surfaceplotparm x=_X y=_Y z=_Z /  /* specify variables at run time */
       name="surface" 
       surfacetype=fill
       colormodel=threecolorramp      /* or =twocolorramp */
       colorresponse=_Z;              /* prior to 9.4m2, use SURFACECOLORGRADIENT= */
    continuouslegend "surface";
  endlayout;
endgraph;
end;
run;

proc sgrender data=all_mues template=SurfaceTmplt; 
   dynamic _X='R' _Y='start' _Z='mu' _Title="Cubic Surface";
run;

ods pdf file='C:\Heineken\mu.pdf' ;

proc sgrender data=all_mues template=SurfaceTmplt; 
   dynamic _X='r0' _Y='start' _Z='mu' _Title="Cubic Surface";
run;

ods pdf close; 


ods _all_ close;

ods graphics / reset outputfmt=png noborder imagename='fig5';

ods listing
       image_dpi=300
       gpath="C:\Heineken\";
proc sgrender data=all_mues template=SurfaceTmplt; 
   dynamic _X='R' _Y='Initial Infected' _Z='mu' _Title="";
   label mu="µ [days]";
	label 'initial infected'n="initial infected per 1M inhabitants";
run;

ods _all_ close;

ods graphics / reset outputfmt=tiff noborder imagename='fig5';

ods listing
       image_dpi=300
       gpath="C:\Heineken\";
proc sgrender data=all_mues template=SurfaceTmplt; 
   dynamic _X='R' _Y='Initial Infected' _Z='mu' _Title="";
   label mu="µ [days]";
	label 'Initial Infected'n="initial infected per 1M inhabitants";
run;


/*area*/
proc nlin data=all_mues(where=(start=1)); 
  parameters  rho=10; 
  model r0   = (rho/(1-area))**0.4;
	output out=nlinout pred=p lcl=lcl ucl=ucl;
run;
proc sgplot data=nlinout;
   scatter y=r0   x=area;
   series  y=p   x=area/ name="fit"
                          lineattrs=GraphFit
                          LegendLabel="Predicted";
   keylegend "fit";
run;

/*area*/
proc nlin data=all_mues(where=(start=1)); 
  parameters  rho=10; 
  model area=1-(rho/r0)**2.5;
	output out=nlinout pred=p lcl=lcl ucl=ucl;
run;

ods pdf file='C:\Heineken\area.pdf' ;

proc sgplot data=nlinout;
   scatter y=area  x=r0;
   series  y=p   x=r0/ name="fit"
                          lineattrs=GraphFit
                          LegendLabel="Predicted";
   keylegend "fit";
run;

ods pdf close; 


/*mue*/

proc nlin data=all_mues (where=("Initial Infected"n=1)); 
  parameters  lambda=200; 
  model R   = 1+lambda/mu**(1.2);
	output out=nlinout pred=p lcl=lcl ucl=ucl;
run;


/* Place the regression equation in a macro variable. */
data _null_;
   call symput('eqn',"R=1+{unicode lambda}/{unicode mu}^(1.2)");
run;

%put &eqn.;

ods pdf file='C:\Heineken\mu_with_start1.pdf' ;


proc sgplot data=nlinout;
   scatter y=R   x=mu /markerattrs=(size=7 symbol=circlefilled color=black) name="A" legendlabel='Model output';
   series  y=p   x=mu / name="fit"
                          lineattrs=GraphFit
                          LegendLabel="Predicted";
	inset "R=1+(*ESC*){unicode lambda}/(*ESC*){unicode mu}^(1.2)"/ position=bottomleft;
	xaxis valueattrs=(size=8 color=black) display=(noticks) offsetmin=0.02 offsetmax=0.02 label = "µ[days]" labelattrs=(size=8 weight=normal) values=(0 to 700 by 200);

   keylegend "A" "fit";
run;
footnote;

ods pdf close; 

ods _all_ close;

ods graphics / reset outputfmt=png noborder imagename='fig3';

ods listing
       image_dpi=300
       gpath="C:\Heineken\";


proc sgplot data=nlinout;
   scatter y=R   x=mu /markerattrs=(size=7 symbol=circlefilled color=black) name="A" legendlabel='Model output';
   series  y=p   x=mu / name="fit"
                          lineattrs=GraphFit
                          LegendLabel="Predicted";
	inset "R=1+(*ESC*){unicode lambda}/(*ESC*){unicode mu} (*ESC*){sup '1.2'}"/ position=bottomleft;
	xaxis valueattrs=(size=8 color=black) display=(noticks) offsetmin=0.02 offsetmax=0.02 label = "µ[days]" labelattrs=(size=8 weight=normal) values=(0 to 700 by 200);

   keylegend "A" "fit";
run;
footnote;

ods graphics / reset outputfmt=eps noborder imagename='fig3';

ods listing
       image_dpi=300
       gpath="C:\Heineken\";


proc sgplot data=nlinout;
   scatter y=R   x=mu /markerattrs=(size=7 symbol=circlefilled color=black) name="A" legendlabel='Model output';
   series  y=p   x=mu / name="fit"
                          lineattrs=GraphFit
                          LegendLabel="Predicted";
	inset "R=1+(*ESC*){unicode lambda}/(*ESC*){unicode mu} (*ESC*){sup '1.2'}"/ position=bottomleft;
	xaxis valueattrs=(size=8 color=black) display=(noticks) offsetmin=0.02 offsetmax=0.02 label = "µ[days]" labelattrs=(size=8 weight=normal) values=(0 to 700 by 200);

   keylegend "A" "fit";
run;
footnote;



/*sigma*/

proc nlin data=all_mues(where=("Initial Infected"n=1)); 
  parameters  tau=10; 
  model R   = 1+tau/sigma**(1.0);
	output out=nlinout pred=p lcl=lcl ucl=ucl;
run;

ods pdf file='C:\Heineken\sigma.pdf' ;


proc sgplot data=nlinout;
   scatter y=r0   x=sigma;
   series  y=p   x=sigma / name="fit"
                          lineattrs=GraphFit
                          LegendLabel="Predicted";
   keylegend "fit";
run;

ods pdf close; 

ods graphics / reset outputfmt=png noborder imagename='fig4';

ods listing
       image_dpi=300
       gpath="C:\Heineken\";


proc sgplot data=nlinout;
   scatter y=R   x=sigma /markerattrs=(size=7 symbol=circlefilled color=black) name="A" legendlabel='Model output';
   series  y=p   x=sigma / name="fit"
                          lineattrs=GraphFit
                          LegendLabel="Predicted";
	inset "R=1+(*ESC*){unicode tau}/(*ESC*){unicode sigma}"/ position=bottomleft;
	xaxis valueattrs=(size=8 color=black) display=(noticks) offsetmin=0.02 offsetmax=0.02 label = "(*ESC*){unicode sigma}[days]" labelattrs=(size=8 weight=normal) values=(0 to 120 by 10);

   keylegend "A" "fit";
run;
footnote;

ods graphics / reset outputfmt=eps noborder imagename='fig4';

ods listing
       image_dpi=300
       gpath="C:\Heineken\";


proc sgplot data=nlinout;
   scatter y=R   x=sigma /markerattrs=(size=7 symbol=circlefilled color=black) name="A" legendlabel='Model output';
   series  y=p   x=sigma / name="fit"
                          lineattrs=GraphFit
                          LegendLabel="Predicted";
	inset "R=1+(*ESC*){unicode tau}/(*ESC*){unicode sigma}"/ position=bottomleft;
	xaxis valueattrs=(size=8 color=black) display=(noticks) offsetmin=0.02 offsetmax=0.02 label = "(*ESC*){unicode sigma}[days]" labelattrs=(size=8 weight=normal) values=(0 to 120 by 10);

   keylegend "A" "fit";
run;
footnote;

