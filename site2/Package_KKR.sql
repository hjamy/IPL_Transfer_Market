SET SERVEROUTPUT ON;
SET VERIFY OFF;

CREATE OR REPLACE PACKAGE PACKAGE_KKR AS

	FUNCTION Search_Transfer_Status_F(id IN OUT INT, team IN OUT PlayersKKR.TeamName%TYPE)
    RETURN varchar2;

    FUNCTION Calculate_Strike_Rate_F(id IN OUT BattingStatKKR.PlayerId%TYPE, run IN OUT BattingStatKKR.Runs%TYPE, ball IN OUT BattingStatKKR.BallsFaced%TYPE, team IN OUT PlayersMI.TeamName%TYPE)
    RETURN float;
	
    FUNCTION Calculate_Avg_F(id IN OUT BattingStatKKR.PlayerId%TYPE, run IN OUT BattingStatKKR.Runs%TYPE, ball IN OUT BattingStatKKR.BallsFaced%TYPE, team IN OUT PlayersMI.TeamName%TYPE)
    RETURN float;

	PROCEDURE TransferInfoProcedureKKR;

    PROCEDURE AgeGeneratorKKR;

END PACKAGE_KKR;
/

CREATE OR REPLACE PACKAGE BODY PACKAGE_KKR AS

----------------------------------------------------------------------------------------------------------------

	FUNCTION Search_Transfer_Status_F(id IN OUT INT, team IN OUT PlayersKKR.TeamName%TYPE)
    RETURN varchar2
	IS 
	
	temp_id INT;
    temp_status varchar2(15);

BEGIN

    if team = 'MI' then
        select TransferStatus into temp_status from TransferInfoMI@site1 where PlayerId = id;
        return temp_status;
    end if;

END Search_Transfer_Status_F;

----------------------------------------------------------------------------------------------------------------

    FUNCTION Calculate_Strike_Rate_F(id IN OUT BattingStatKKR.PlayerId%TYPE, run IN OUT BattingStatKKR.Runs%TYPE, ball IN OUT BattingStatKKR.BallsFaced%TYPE, team IN OUT PlayersMI.TeamName%TYPE)
    RETURN float
    IS

    temp_matches int;
    temp_runs int;
    temp_balls int;
    temp_strike_rate float;

BEGIN

    if team = 'KKR' then 
        select Matches, Runs, BallsFaced into temp_matches, temp_runs, temp_balls from BattingStatKKR where PlayerId = id;
        temp_runs := temp_runs + run;
        temp_balls := temp_balls + ball;
        temp_strike_rate := (temp_runs/temp_balls) * 100;
        RETURN ROUND(temp_strike_rate, 2);
    end if;
    
END Calculate_Strike_Rate_F;

----------------------------------------------------------------------------------------------------------------	

    FUNCTION Calculate_Avg_F(id IN OUT BattingStatKKR.PlayerId%TYPE, run IN OUT BattingStatKKR.Runs%TYPE, ball IN OUT BattingStatKKR.BallsFaced%TYPE, team IN OUT PlayersMI.TeamName%TYPE)
    RETURN float
    IS

    temp_matches int;
    temp_runs int;
    temp_balls int;
    temp_avg float;

BEGIN

    if team = 'KKR' then 
        select Matches, Runs, BallsFaced into temp_matches, temp_runs, temp_balls from BattingStatKKR where PlayerId = id;
        temp_matches := temp_matches + 1;
        temp_runs := temp_runs + run;
        temp_avg := temp_runs/temp_matches;
        RETURN ROUND(temp_avg, 2);
    end if;

END Calculate_Avg_F;

----------------------------------------------------------------------------------------------------------------

	PROCEDURE TransferInfoProcedureKKR
    IS
   
    id PlayersKKR.PlayerId%TYPE;
    availability PlayersKKR.PlayerStatus%TYPE;

BEGIN
    
    for i in (select * from PlayersKKR) loop
        id := i.PlayerId;
        availability := i.PlayerStatus;
        if availability = 'Available' then     
            insert into TransferInfoKKR values(id, 0,'NULL', 'No Offer');
        end if;
    end loop;

END TransferInfoProcedureKKR;

----------------------------------------------------------------------------------------------------------------

    PROCEDURE AgeGeneratorKKR
    IS

    id PlayersKKR.PlayerId%TYPE;
    temp_date PlayersKKR.DateOfBirth%TYPE;
    age_k int:=0;

BEGIN
    for i in (select * from PlayersKKR) loop
        id := i.PlayerId;
        temp_date := i.DateOfBirth;
        select DateOfBirth into temp_date from PlayersKKR where PlayerId = id;
        age_k := (sysdate - temp_date) / 365;
        update PlayersKKR set Age = age_k where PlayerId = id;
    end loop;

END AgeGeneratorKKR;
	
END PACKAGE_KKR;
/

commit;


