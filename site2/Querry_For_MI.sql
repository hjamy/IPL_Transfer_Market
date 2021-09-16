SET SERVEROUTPUT ON;
SET VERIFY OFF;

BEGIN
    DBMS_OUTPUT.PUT_LINE('1-> Show Available Player list and Base Price');
    DBMS_OUTPUT.PUT_LINE('2-> Show Available Batsman list and Base Price');
    DBMS_OUTPUT.PUT_LINE('3-> Show Available Batsman list and Base Price');
    DBMS_OUTPUT.PUT_LINE('4-> Show Available Allrounder list and Base Price');
    DBMS_OUTPUT.PUT_LINE('5-> Show the list of Available players with StrikeRate more than 120 and Bowling Average < 25');
    DBMS_OUTPUT.PUT_LINE('6-> Show the list of Available players with StrikeRate more than Average StrikeRate');
    DBMS_OUTPUT.PUT_LINE('7-> Sort the Available Players according to their Base Price');
    DBMS_OUTPUT.PUT_LINE('8-> Show the list of Available players whose age is less than 30 years, with StrikeRate more than 120');
    DBMS_OUTPUT.PUT_LINE('9-> Show the number of Players in each Role');
END;
/

    ACCEPT X NUMBER PROMPT "Enter Your choice:  "

DECLARE
    Options int;
    id PlayersMI.PlayerId@site1%TYPE;
    name PlayersMI.PlayerName@site1%TYPE;
    availability PlayersMI.PlayerStatus@site1%TYPE;
    Price PlayersMI.BasePrice@site1%TYPE;
    role PlayersMI.PlayerRole@site1%TYPE;
    available_flag NUMBER := 0;
BEGIN
    Options :=&X;
    for i in (select * from PlayersMI@site1) loop  
        id := i.PlayerId;
        name := i.PlayerName;
        availability := i.PlayerStatus;
        Price := i.BasePrice;
        role := i.PlayerRole;

        if Options = 1 AND availability = 'Available' then
            DBMS_OUTPUT.PUT_LINE('Player No: ' || id || '   Name: ' || name || '  Base Price:' || Price);
            available_flag := 1;

        elsif Options = 2  AND availability = 'Available' AND role = 'Batsman' then
            DBMS_OUTPUT.PUT_LINE('Player No: ' || id || '   Name: ' || name || '  Base Price:' || Price);
            available_flag := 1;

        elsif Options = 3 AND availability = 'Available' AND role = 'Bowler' then
            DBMS_OUTPUT.PUT_LINE('Player No: ' || id || '   Name: ' || name || '  Base Price:' || Price);
            available_flag := 1;

        elsif Options = 4 AND availability = 'Available' AND role = 'Alrounder' then
            DBMS_OUTPUT.PUT_LINE('Player No: ' || id || '   Name: ' || name || '  Base Price:' || Price);
            available_flag := 1;

        elsif Options = 5 then
            for j in (select PlayersMI.PlayerName as K_name, BattingStatMI.StrikeRate as K_Str, BowlingStatMI.Average as K_avg from PlayersMI@site1
            inner join BattingStatMI@site1 on PlayersMI.PlayerId = BattingStatMI.PlayerId 
            inner join BowlingStatMI@site1 on BattingStatMI.PlayerId = BowlingStatMI.PlayerId
            where StrikeRate > 120 AND Average < 25 AND PlayerStatus = 'Available') loop
                DBMS_OUTPUT.PUT_LINE('Player Name: ' || j.K_name || '   StrikeRate: ' || j.K_Str || '  Bowling Average:' || j.K_avg);
            end loop;
            available_flag := 1;
            EXIT;

        elsif Options = 6 then
            for j in (select PlayerName from PlayersMI@site1 where PlayerId IN
            (select PlayerId from BattingStatMI@site1 where Strikerate >= (select avg(Strikerate) from BattingStatMI@site1))) loop
                DBMS_OUTPUT.PUT_LINE('Player Name: ' || j.PlayerName);
            end loop;
            available_flag := 1;
            EXIT;

        elsif Options = 7 then
            for j in (select Playername, PlayerRole, BasePrice from PlayersMI@site1 where PlayerStatus = 'Available' order by BasePrice) loop
                DBMS_OUTPUT.PUT_LINE('Player Name: ' || j.PlayerName || '   Player Role: ' || j.PlayerRole || '    Base Price: ' || j.BasePrice);
            end loop;
            available_flag := 1;
            EXIT;

        elsif Options = 8 then
            for j in (select PlayerName, PlayerRole from PlayersMI@site1 where PlayerStatus = 'Available' AND Age < 30 AND PlayerId IN (select PlayerId from BattingStatMI@site1 where strikerate > 120)) loop
                DBMS_OUTPUT.PUT_LINE('Player Name: ' || j.PlayerName || '   Player Role: ' || j.PlayerRole);
            end loop;
            available_flag := 1;
            EXIT;

        elsif Options = 9 then
            for j in (select PlayerRole as P_Role, COUNT(PlayerId) as NoOfPlayers from PlayersMI@site1 Group By PlayerRole ORDER BY COUNT(PlayerId) DESC) loop
                DBMS_OUTPUT.PUT_LINE(j.NoOfPlayers || '  ' || j.P_Role || ' in MI Squad');
            end loop;
            available_flag := 1;
            EXIT;

        end if;
    end loop;

    if available_flag = 0 then
        DBMS_OUTPUT.PUT_LINE('No available Player at this moment.');
    end if;

END;
/

commit;

--1. Available Player der moddhe kar strikerate 120 er theke beshi, and Bowling Average < 25 tader list show koro 

-- select PlayerName from PlayersMI where PlayerStatus = 'Available' AND PlayerId IN(select PlayerId from BowlingStatMI where Average < 25 AND PlayerId IN (select PlayerId from BattingStatMI where StrikeRate > 120));            

-- select PlayersMI.PlayerName, BattingStatMI.StrikeRate, BowlingStatMI.Average from PlayersMI
-- inner join BattingStatMI on PlayersMI.PlayerId = BattingStatMI.PlayerId 
-- inner join BowlingStatMI on BattingStatMI.PlayerId = BowlingStatMI.PlayerId
-- where StrikeRate > 120 AND Average < 25 AND PlayerStatus = 'Available';

--2. Available player der moddhe kader strikerate avg strikerate theke beshi tader list show koro
-- select PlayerName from PlayersMI where PlayerId IN
-- (select PlayerId from BattingStatMI where Strikerate >= (select avg(Strikerate) from BattingStatMI));          

--3. Available player der k tader base price wise sort koro
-- select Playername, PlayerRole, BasePrice from PlayersMI where PlayerStatus = 'Available' order by BasePrice;         

-- 4. 30 er niceh Available Playerder moddhe jader strike rate > 120
-- select PlayerName, PlayerRole from PlayersMI where PlayerStatus = 'Available' AND Age < 30 AND PlayerId IN (select PlayerId from BattingStatMI where strikerate > 120);

--5. Team a kon position a koijon kore ase list dekhabe
-- select PlayerRole, COUNT(PlayerId) as PlayerRole from PlayersMI Group By PlayerRole ORDER BY COUNT(PlayerId) DESC;
