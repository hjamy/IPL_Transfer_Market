SET SERVEROUTPUT ON;
SET VERIFY OFF;

DECLARE
    team PlayersMI.TeamName%TYPE;
    Pick int;
    id int;
    temp_id int;
    status varchar2(15);
    flag int := 0;
    name varchar2(25);
    money int;
BEGIN

    -- select PlayerId into id from TransferInfoMI where PlayerId = pick;
    --jeshob player ra offer BID paise tader k show korbe including name and koto BID paise kon team theke
    for i in (select * from TransferInfoMI) loop
        id := i.PlayerId;
        status := i.TransferStatus;
        team := i.OfferFrom;
        money := i.BidOfferred;
        if status = 'pending' then
            select PlayerName into name from PlayersMI where PlayerId IN (select PlayerId from TransferInfoMI where PlayerId = id); 
            DBMS_OUTPUT.PUT_LINE(name ||'(id ' || id ||')' || ' got an offer of $' || money ||  ' from ' || team);
            flag := 1;
        end if;
    end loop;

    if flag = 0 then
        DBMS_OUTPUT.PUT_LINE('Currently no bid for any player.');
    end if;

END;
/

commit;

