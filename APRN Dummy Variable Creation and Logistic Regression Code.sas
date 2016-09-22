
/* 
ind = Independent practice APRN
Sup = Supervised practice APRN
col = Collaborative practice APRN
md = Medical Doctor
aprn = Advanced Practice Registered Nurse
*/

/* creating dummy coded variables for practice-related board of nursing discpline dataset */

data prac_input;
input group $ yesno;
cards;
ind 0
ind 1
sup 0
sup 1
col 0
col 1
;

data practice;
set prac_input;

if group='ind' and yesno=0
 then do;
   do i = 1 to 30929;
    DUMMY1=1;
	DUMMY2=0;
    output;
    end;
  end;

if group='ind' and yesno=1
 then do;
   do i = 1 to 21;
    DUMMY1=1;
	DUMMY2=0;
    output;
    end;
  end;

if group='sup' and yesno=0
 then do;
   do i = 1 to 22866;
    DUMMY1=0;
	DUMMY2=1;
    output;
    end;
  end;

if group='sup' and yesno=1
 then do;
   do i = 1 to 8;
    DUMMY1=0;
	DUMMY2=1;
    output;
    end;
  end;

  if group='col' and yesno=0
 then do;
   do i = 1 to 130909;
    DUMMY1=0;
	DUMMY2=0;
    output;
    end;
  end;

if group='col' and yesno=1
 then do;
   do i = 1 to 38;
    DUMMY1=0;
	DUMMY2=0;
    output;
    end;
  end;
drop i;
run;

/* creating dummy coded variables for prescribing-related board of nursing discpline dataset */

data presc_input;
input group $ yesno;
cards;
ind 0
ind 1
col 0
col 1
sup 0
sup 1
;

data prescribing;
set presc_input;

if group='ind' and yesno=0
 then do;
   do i = 1 to 18389;
    DUMMY1=1;
	DUMMY2=0;
    output;
    end;
  end;

if group='ind' and yesno=1
 then do;
   do i = 1 to 11;
    DUMMY1=1;
	DUMMY2=0;
    output;
    end;
  end;

if group='col' and yesno=0
 then do;
   do i = 1 to 136414;
    DUMMY1=0;
	DUMMY2=1;
    output;
    end;
  end;

if group='col' and yesno=1
 then do;
   do i = 1 to 46;
    DUMMY1=0;
	DUMMY2=1;
    output;
    end;
  end;

if group='sup' and yesno=0
 then do;
   do i = 1 to 29905;
    DUMMY1=0;
	DUMMY2=0;
    output;
    end;
  end;

if group='sup' and yesno=1
 then do;
   do i = 1 to 6;
    DUMMY1=0;
	DUMMY2=0;
    output;
    end;
  end;
drop i;
run;


data NPDB_input;
input group $ yesno;
cards;
md 0
md 1
aprn 0
aprn 1
;

data NPDB;
set NPDB_input;

if group='md' and yesno=0
 then do;
   do i = 1 to 1058979;
    DUMMY1=1;
    output;
    end;
  end;
if group='md' and yesno=1
 then do;
   do i = 1 to 6006;
    DUMMY1=1;
    output;
    end;
  end;

  if group='aprn' and yesno=0
 then do;
   do i = 1 to 206838;
    DUMMY1=0;
    output;
    end;
  end;
if group='aprn' and yesno=1
 then do;
   do i = 1 to 121;
    DUMMY1=0;
    output;
    end;
  end;
drop i;
run;

/* creating dummy coded variables for MD vs APRN discpline dataset */

data HIPDB_input;
input group $ yesno;
cards;
md 0
md 1
aprn 0
aprn 1
;

data HIPDB;
set HIPDB_input;

if group='md' and yesno=0
 then do;
   do i = 1 to 1062850;
    DUMMY1=1;
    output;
    end;
  end;
if group='md' and yesno=1
 then do;
   do i = 1 to 2135;
    DUMMY1=1;
    output;
    end;
  end;

if group='aprn' and yesno=0
 then do;
   do i = 1 to 206896;
    DUMMY1=0;
    output;
    end;
  end;

if group='aprn' and yesno=1
 then do;
   do i = 1 to 63;
    DUMMY1=0;
    output;
    end;
  end;
drop i;

run;

/* Sample Logistic Regression Code */
/* Independent vs Supervised vs Collaborative APRNs predicting practice-related discipline (yes vs no) */
/* Independent vs Supervised vs Collaborative APRNs predicting prescribing-related discipline (yes vs no) */
/* MDs vs APRNs predicting board discipline (yes vs no) */

PROC SQL;
	CREATE VIEW WORK.SORTTempTableSorted AS
	SELECT T.yesno, T.DUMMY1, T.DUMMY2
	FROM WORK.PRACTICE as T;
QUIT;

PROC LOGISTIC DATA=WORK.SORTTempTableSorted
	PLOTS(ONLY)=NONE;
	CLASS DUMMY1 (PARAM=REF) DUMMY2 (PARAM=REF);
	MODEL yesno (Event = '0')=DUMMY1 DUMMY2		/
	SELECTION=NONE
	CLPARM=BOTH
	ALPHA=0.05;
RUN;
