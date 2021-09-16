SET SERVEROUTPUT ON;
SET VERIFY OFF;

select * from TransferInfoKKR;

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
    K_TeamName        varchar2(5);
    K_PlayerId        integer;
    K_PlayerName 	  varchar2(10);
    K_DateOfBirth     DATE;
    K_PlayerRole      varchar2(10);
    K_PlayerStatus    varchar2(12);
    K_BasePrice       integer;
    K_Age             int;
    temp_response     varchar2(15);
    temp_team_name    varchar2(15) := 'KKR';

    KBt_matches BattingStatKKR.Matches%TYPE;
	KBt_runs BattingStatKKR.Runs%TYPE;
    KBt_highscore BattingStatKKR.HighestScore%TYPE;
	KBt_average BattingStatKKR.Average%TYPE;
	KBt_ballsfaced BattingStatKKR.BallsFaced%TYPE;
    KBt_strikerate BattingStatKKR.StrikeRate%TYPE;
	KBt_fifties BattingStatKKR.Fifties%TYPE;
	KBt_hundreds BattingStatKKR.Hundreds%TYPE;

	KBw_balls BowlingStatKKR.Balls%TYPE;
    KBw_runs BowlingStatKKR.Runs%TYPE;
	KBw_wickets BowlingStatKKR.Wickets%TYPE;
	KBw_average BowlingStatKKR.Average%TYPE;
    KBw_economy BowlingStatKKR.Economy%TYPE;
BEGIN

    id := &X;
    Options := &Y;
    select PlayerId, TransferStatus into temp_id, status from TransferInfoKKR where PlayerId = id;
    if status = 'pending' then 
        if Options = 1 then     
            DBMS_OUTPUT.PUT_LINE('1');
            select PlayerId, PlayerName, DateOfBirth, PlayerRole, PlayerStatus, Age into K_PlayerId, K_PlayerName, K_DateOfBirth, K_PlayerRole, K_PlayerStatus, K_Age from playerskkr where PlayerId = id;
            select Matches, Runs, HighestScore, Average, BallsFaced, StrikeRate, Fifties, Hundreds into KBt_matches, KBt_runs, KBt_highscore, KBt_average, KBt_ballsfaced, KBt_strikerate, KBt_fifties, KBt_hundreds from BattingStatKKR where PlayerId = id;
            select Balls, Runs, Wickets, Average, Economy into KBw_balls, KBw_runs, KBw_wickets, KBw_average, KBw_economy from BowlingStatKKR where PlayerId = id;
            select BidOfferred into K_BasePrice from TransferInfoKKR where PlayerId = id;
            update TransferInfoKKR set TransferStatus = 'Accepted' where PlayerId = id;
            insert into PlayersMI@site1 values('MI', K_PlayerId, K_PlayerName, K_DateOfBirth, K_PlayerRole, 'Not Available', K_BasePrice, K_Age);
            insert into BattingStatMI@site1 values(K_PlayerId, KBt_matches, KBt_runs, KBt_highscore, KBt_average, KBt_ballsfaced, KBt_strikerate, KBt_fifties, KBt_hundreds);
            insert into BowlingStatMI@site1 values(K_PlayerId, KBt_matches, KBw_balls, KBw_runs, KBw_wickets, KBw_average, KBw_economy);
            delete from TransferInfoKKR where PlayerId = id;
            delete from BattingStatKKR  where PlayerId = id;
            delete from BowlingStatKKR  where PlayerId = id;
            delete from Playerskkr where PlayerId = id;
        elsif Options = 2 then 
            update TransferInfoKKR set TransferStatus = 'Asked More' where PlayerId = id;
        elsif Options = 3 then
            update TransferInfoKKR set TransferStatus = 'Canceled' where PlayerId = id;
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

select * from TransferInfoKKR;
select * from BattingStatKKR;
select * from BowlingStatKKR;
select * from PlayersKKR;
select * from PlayersMI@site1;
select * from BattingStatMI@site1;
select * from BowlingStatMI@site1;



-- delete from TransferInfoKKR where PlayerId = 2;
-- delete from BattingStatKKR  where PlayerId = 2;
-- delete from BowlingStatKKR  where PlayerId = 2;
-- delete from TransferInfoMI where PlayerId = id;
-- delete from BattingStatMI  where PlayerId = id;
-- delete from BowlingStatMI  where PlayerId = 2;