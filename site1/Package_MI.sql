SET SERVEROUTPUT ON;
SET VERIFY OFF;

CREATE OR REPLACE PACKAGE PACKAGE_MI AS

	FUNCTION Search_Transfer_Status_F(id IN OUT INT, team IN OUT PlayersMI.TeamName%TYPE)
    RETURN varchar2;

    FUNCTION Calculate_Strike_Rate_F(id IN OUT BattingStatMI.PlayerId%TYPE, run IN OUT BattingStatMI.Runs%TYPE, ball IN OUT BattingStatMI.BallsFaced%TYPE, team IN OUT PlayersMI.TeamName%TYPE)
    RETURN float;
	
    FUNCTION Calculate_Avg_F(id IN OUT BattingStatMI.PlayerId%TYPE, run IN OUT BattingStatMI.Runs%TYPE, ball IN OUT BattingStatMI.BallsFaced%TYPE, team IN OUT PlayersMI.TeamName%TYPE)
    RETURN float;
	
	PROCEDURE TransferInfoProcedureMI;

    PROCEDURE AgeGeneratorMI;

END PACKAGE_MI;
/

CREATE OR REPLACE PACKAGE BODY PACKAGE_MI AS

----------------------------------------------------------------------------------------------------------------

	FUNCTION Search_Transfer_Status_F(id IN OUT INT, team IN OUT PlayersMI.TeamName%TYPE)
    RETURN varchar2
	IS 
	
	temp_id INT;
    temp_status varchar2(15);

BEGIN
    
    if team = 'KKR' then
        select TransferStatus into temp_status from TransferInfoKKR@site2 where PlayerId = id;
        return temp_status;
    end if;

END Search_Transfer_Status_F;

----------------------------------------------------------------------------------------------------------------

	PROCEDURE TransferInfoProcedureMI
    IS
   
    id PlayersMI.PlayerId%TYPE;
    availability PlayersMI.PlayerStatus%TYPE;

BEGIN
    
    for i in (select * from PlayersMI) loop
        id := i.PlayerId;
        availability := i.PlayerStatus;
        if availability = 'Available' then
            insert into TransferInfoMI values(id, 0, 'NULL', 'No Offer');
        end if;
    end loop;

END TransferInfoProcedureMI;

----------------------------------------------------------------------------------------------------------------

    FUNCTION Calculate_Strike_Rate_F(id IN OUT BattingStatMI.PlayerId%TYPE, run IN OUT BattingStatMI.Runs%TYPE, ball IN OUT BattingStatMI.BallsFaced%TYPE, team IN OUT PlayersMI.TeamName%TYPE)
    RETURN float
    IS

    temp_matches int;
    temp_runs int;
    temp_balls int;
    temp_strike_rate float;

BEGIN

    if team = 'MI' then
        select Matches, Runs, BallsFaced into temp_matches, temp_runs, temp_balls from BattingStatMI where PlayerId = id;
        temp_runs := temp_runs + run;
        temp_balls := temp_balls + ball;
        temp_strike_rate := (temp_runs/temp_balls) * 100;
        RETURN ROUND(temp_strike_rate, 2);
    end if;
    
END Calculate_Strike_Rate_F;

-- ----------------------------------------------------------------------------------------------------------------
	
    FUNCTION Calculate_Avg_F(id IN OUT BattingStatMI.PlayerId%TYPE, run IN OUT BattingStatMI.Runs%TYPE, ball IN OUT BattingStatMI.BallsFaced%TYPE, team IN OUT PlayersMI.TeamName%TYPE)
    RETURN float
    IS

    temp_matches int;
    temp_runs int;
    temp_balls int;
    temp_avg float;

BEGIN

    if team = 'MI' then
        select Matches, Runs, BallsFaced into temp_matches, temp_runs, temp_balls from BattingStatMI where PlayerId = id;
        temp_matches := temp_matches + 1;
        temp_runs := temp_runs + run;
        temp_avg := temp_runs/temp_matches;
        RETURN ROUND(temp_avg, 2);
    end if;

END Calculate_Avg_F;

----------------------------------------------------------------------------------------------------------------

PROCEDURE AgeGeneratorMI
IS

    id PlayersMI.PlayerId%TYPE;
    temp_date PlayersMI.DateOfBirth%TYPE;
    age_m int:=0;

BEGIN
    for i in (select * from PlayersMI) loop
        id := i.PlayerId;
        temp_date := i.DateOfBirth;
        select DateOfBirth into temp_date from PlayersMI where PlayerId = id;
        age_m := (sysdate - temp_date) / 365;
        update PlayersMI set Age = age_m where PlayerId = id;
    end loop;

END AgeGeneratorMI;


END PACKAGE_MI;
/


