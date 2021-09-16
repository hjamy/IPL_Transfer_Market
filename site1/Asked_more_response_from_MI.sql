SET SERVEROUTPUT ON;
SET VERIFY OFF;

--prompt a number dewa lage, int dile kaj kore na
--promt a char dewa lage, varchar dile kaj kore na

select * from TransferInfoKKR@site2;

ACCEPT A NUMBER PROMPT "Enter Player ID you wish to bid for = "
ACCEPT B CHAR PROMPT "Do you wish to furhter bid fro this player? Y/N "

DECLARE

    Options varchar2(3);
    name PlayersKKR.PlayerName@site2%TYPE;
    bid_id PlayersKKR.PlayerId@site2%TYPE;
    temp_status varchar2(15);
    
BEGIN
    bid_id := &A;
    Options := '&B';
    select TransferStatus into temp_status from TransferInfoKKR@site2 where PlayerId = bid_id;
    if temp_status = 'Asked More' then
        if Options = 'N' then
            update TransferInfoKKR@site2 set TransferStatus = 'No Offer', BidOfferred = 0, OfferFrom = 'NULL'  where PlayerId = bid_id;
        elsif Options = 'Y' then
            select PlayerName into name from PlayersKKR@site2 where PlayerId IN (select PlayerId from TransferInfoKKR@site2 where PlayerId = bid_id);
            DBMS_OUTPUT.PUT_LINE('Again Place BID for ' || name || ' ( id ' || bid_id || ' ).'); 
        else
           DBMS_OUTPUT.PUT_LINE('You Must Press (Y/N): '); 
        end if;
    else
        DBMS_OUTPUT.PUT_LINE('Not the player we are looking for.');
    end if;
    
EXCEPTION
	WHEN NO_DATA_FOUND THEN
		DBMS_OUTPUT.PUT_LINE('No such Player found');
END;
/

commit;
select * from TransferInfoKKR@site2;
