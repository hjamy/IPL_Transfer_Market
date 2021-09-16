SET SERVEROUTPUT ON;
SET VERIFY OFF;

select * from TransferInfoMI;

ACCEPT X NUMBER PROMPT "Enter Player ID you wish to proceed for transfer:  "

BEGIN
    DBMS_OUTPUT.PUT_LINE('1-> Accept Offer');
    DBMS_OUTPUT.PUT_LINE('2-> Ask for more money');
    DBMS_OUTPUT.PUT_LINE('3-> Cancel Offer');
END;
/

ACCEPT Y NUMBER PROMPT "What would you like to do? "

DECLARE

    id int;
    temp_id int;
    status varchar2(15);
    Options INT;
    M_TeamName        varchar2(5);
    M_PlayerId        integer;
    M_PlayerName 	  varchar2(10);
    M_DateOfBirth     DATE;
    M_PlayerRole      varchar2(10);
    M_PlayerStatus    varchar2(12);
    M_BasePrice       integer;
    M_Age             int;
    temp_response     varchar2(15);
    temp_team_name    varchar2(15) := 'MI';

    MBt_matches BattingStatMI.Matches%TYPE;
	MBt_runs BattingStatMI.Runs%TYPE;
    MBt_highscore BattingStatMI.HighestScore%TYPE;
	MBt_average BattingStatMI.Average%TYPE;
	MBt_ballsfaced BattingStatMI.BallsFaced%TYPE;
    MBt_strikerate BattingStatMI.StrikeRate%TYPE;
	MBt_fifties BattingStatMI.Fifties%TYPE;
	MBt_hundreds BattingStatMI.Hundreds%TYPE;

	MBw_balls BowlingStatMI.Balls%TYPE;
    MBw_runs BowlingStatMI.Runs%TYPE;
	MBw_wickets BowlingStatMI.Wickets%TYPE;
	MBw_average BowlingStatMI.Average%TYPE;
    MBw_economy BowlingStatMI.Economy%TYPE;

BEGIN

    id := &X;
    Options := &Y;
    select PlayerId, TransferStatus into temp_id, status from TransferInfoMI where PlayerId = id;
    if status = 'pending' then 
        if Options = 1 then     
            select PlayerId, PlayerName, DateOfBirth, PlayerRole, PlayerStatus, Age into M_PlayerId, M_PlayerName, M_DateOfBirth, M_PlayerRole, M_PlayerStatus, M_Age from PlayersMI where PlayerId = id;
            select Matches, Runs, HighestScore, Average, BallsFaced, StrikeRate, Fifties, Hundreds into MBt_matches, MBt_runs, MBt_highscore, MBt_average, MBt_ballsfaced, MBt_strikerate, MBt_fifties, MBt_hundreds from BattingStatMI where PlayerId = id;
            select Balls, Runs, Wickets, Average, Economy into MBw_balls, MBw_runs, MBw_wickets, MBw_average, MBw_economy from BowlingStatMI where PlayerId = id;           
            select BidOfferred into M_BasePrice from TransferInfoMI where PlayerId = id;
            update TransferInfoMI set TransferStatus = 'Accepted' where PlayerId = id;
            insert into PlayersKKR@site2 values('KKR', M_PlayerId, M_PlayerName, M_DateOfBirth, M_PlayerRole, 'Not Available', M_BasePrice, M_Age);
            insert into BattingStatKKR@site2 values(M_PlayerId, MBt_matches, MBt_runs, MBt_highscore, MBt_average, MBt_ballsfaced, MBt_strikerate, MBt_fifties, MBt_hundreds);
            insert into BowlingStatKKR@site2 values(M_PlayerId, MBt_matches, MBw_balls, MBw_runs, MBw_wickets, MBw_average, MBw_economy);
            delete from TransferInfoMI where PlayerId = id;
            delete from BattingStatMI  where PlayerId = id;
            delete from BowlingStatMI  where PlayerId = id;
            delete from PlayersMI where PlayerId = id;
        elsif Options = 2 then 
            update TransferInfoMI set TransferStatus = 'Asked More' where PlayerId = id;
        elsif Options = 3 then
            update TransferInfoMI set TransferStatus = 'Canceled' where PlayerId = id;
            --delete kora lagbe tranfer table theke
            --DELETE from TransferInfoKKR where id=n; 
        end if;
    elsif status = 'Asked More' then
        DBMS_OUTPUT.PUT_LINE('Let ' || temp_team_name || ' make a BID again');
    elsif status = 'Accepted' then
        DBMS_OUTPUT.PUT_LINE('Already offer accpted from ' || temp_team_name);
    -- elsif status = 'Canceled' then
    --     DBMS_OUTPUT.PUT_LINE('Already canceled offer from ' || temp_team_name);
    elsif status = 'No Offer' then
        DBMS_OUTPUT.PUT_LINE('No offer for this player.');
    end if;

EXCEPTION
	WHEN NO_DATA_FOUND THEN
		DBMS_OUTPUT.PUT_LINE('No such Player found');

END;
/

commit;

select * from TransferInfoMI;
select * from BattingStatMI;
select * from BowlingStatMI;
select * from PlayersMI;
select * from PlayersKKR@site2;
select * from BattingStatKKR@site2;
select * from BowlingStatKKR@site2;
