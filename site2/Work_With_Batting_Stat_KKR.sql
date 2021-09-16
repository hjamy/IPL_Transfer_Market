SET SERVEROUTPUT ON;
SET VERIFY OFF;

select * from BattingStatKKR;

ACCEPT A NUMBER PROMPT "Enter Player ID to enter Match Perfomance = "
ACCEPT B NUMBER PROMPT "Runs scored = "
ACCEPT C NUMBER PROMPT "Balls Faced = "


DECLARE

    id BattingStatKKR.PlayerId%TYPE;
    match BattingStatKKR.Matches%TYPE;
    highscore BattingStatKKR.HighestScore%TYPE;
    run BattingStatKKR.Runs%TYPE;
    ball BattingStatKKR.BallsFaced%TYPE;
    temp_run BattingStatKKR.Runs%TYPE;
    temp_ball BattingStatKKR.BallsFaced%TYPE;
    fifty BattingStatKKR.Fifties%TYPE;
    hundred BattingStatKKR.Hundreds%TYPE;
    temp_avg float;
    temp_strike_rate float;
    team varchar2(5) := 'KKR';
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

    temp_strike_rate := PACKAGE_KKR.Calculate_Strike_Rate_F(id, run, ball, team);
    temp_avg := PACKAGE_KKR.Calculate_Avg_F(id, run, ball, team);

    select Matches, Runs, HighestScore, BallsFaced, Fifties, Hundreds into match, temp_run, highscore, temp_ball, fifty, hundred from BattingStatKKR where PlayerId = id;
    
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

    update BattingStatKKR set Matches = match, Runs = temp_run, HighestScore = highscore, Average = temp_avg, BallsFaced = temp_ball, Strikerate = temp_strike_rate, Fifties = fifty, Hundreds = hundred where PlayerId = id;


EXCEPTION
	WHEN NO_DATA_FOUND THEN
		DBMS_OUTPUT.PUT_LINE('Data not found');
    WHEN NEGATIVE THEN
        DBMS_OUTPUT.PUT_LINE('Runs /  Balls cannot be negative, Try Again.');
END;
/

commit;

select * from BattingStatKKR;