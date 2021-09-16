SET SERVEROUTPUT ON;
SET VERIFY OFF;

select * from BattingStatMI;

ACCEPT A NUMBER PROMPT "Enter Player ID to enter Match Perfomance = "
ACCEPT B NUMBER PROMPT "Runs scored = "
ACCEPT C NUMBER PROMPT "Balls Faced = "

DECLARE

    id BattingStatMI.PlayerId%TYPE;
    match BattingStatMI.Matches%TYPE;
    highscore BattingStatMI.HighestScore%TYPE;
    run BattingStatMI.Runs%TYPE;
    ball BattingStatMI.BallsFaced%TYPE;
    temp_run BattingStatMI.Runs%TYPE;
    temp_ball BattingStatMI.BallsFaced%TYPE;
    fifty BattingStatMI.Fifties%TYPE;
    hundred BattingStatMI.Hundreds%TYPE;
    temp_avg float;
    temp_strike_rate float;
    team varchar2(5) := 'MI';
    NEGATIVE EXCEPTION;

BEGIN

    id := &A;
    run := &B;
    ball := &C;

    id := TO_NUMBER(id);

    if run < 0 then
        RAISE NEGATIVE;
    end if;
    if ball < 0 then
        RAISE NEGATIVE;
    end if;

    temp_strike_rate := PACKAGE_MI.Calculate_Strike_Rate_F(id, run, ball, team);
    temp_avg := PACKAGE_MI.Calculate_Avg_F(id, run, ball, team);

    select Matches, Runs, HighestScore, BallsFaced, Fifties, Hundreds into match, temp_run, highscore, temp_ball, fifty, hundred from BattingStatMI where PlayerId = id;
    
    match := match + 1;
    temp_run := temp_run + run;
    temp_ball := temp_ball + ball;

    if run > highscore then
        highscore := run;
    end if;
    if run >= 50 AND run <= 100 then
        fifty := fifty + 1;
    end if;
    if run >= 100 then
        hundred := hundred + 1;
    end if;

    update BattingStatMI set Matches = match, Runs = temp_run, HighestScore = highscore, Average = temp_avg, BallsFaced = temp_ball, Strikerate = temp_strike_rate, Fifties = fifty, Hundreds = hundred where PlayerId = id;


EXCEPTION
	WHEN NO_DATA_FOUND THEN
		DBMS_OUTPUT.PUT_LINE('Data not found');
    WHEN NEGATIVE THEN
        DBMS_OUTPUT.PUT_LINE('Runs /  Balls cannot be negative, Try Again.');

END;
/

commit;

select * from BattingStatMI;