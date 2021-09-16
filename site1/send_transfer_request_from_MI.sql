SET SERVEROUTPUT ON;
SET VERIFY OFF;

--prompt a number dewa lage, int dile kaj kore na
--promt a char dewa lage, varchar dile kaj kore na

select * from TransferInfoKKR@site2;
select PlayerId, BasePrice from PlayersKKR@site2;

ACCEPT A NUMBER PROMPT "Enter Player ID you wish to bid for = "
ACCEPT B NUMBER PROMPT "Enter price you wish to bid for the player = "

DECLARE
    team PlayersMI.TeamName%TYPE := 'KKR';
    id PlayersKKR.PlayerId@site2%TYPE;
    name PlayersKKR.PlayerName@site2%TYPE;
    role PlayersKKR.PlayerRole@site2%TYPE;
    availability PlayersKKR.PlayerStatus@site2%TYPE;
    Price PlayersKKR.BasePrice@site2%TYPE;
    bid_id PlayersKKR.PlayerId@site2%TYPE;
    bid_price PlayersKKR.BasePrice@site2%TYPE;
    transfer_status varchar2(15);
    flag number:=0;
BEGIN
    bid_id := &A;
    bid_price := &B;
    for i in (select * from PlayersKKR@site2) loop 
        id := i.PlayerId;
        availability := i.PlayerStatus;
        Price := i.BasePrice;
        if id = bid_id then
            flag := 1;
            if availability = 'Available' AND Price > bid_price then
                DBMS_OUTPUT.PUT_LINE('Minimum bid price for this player is ' || Price); 
                exit;
            elsif availability = 'Available' AND Price <= bid_price then
                -- select TransferStatus into transfer_status from TransferInfoKKR where PlayerId = bid_id;
                transfer_status := PACKAGE_MI.Search_Transfer_Status_F(id, team);
                if transfer_status = 'No Offer' OR transfer_status = 'Asked More' then 
                    update TransferInfoKKR@site2 set BidOfferred = bid_price, OfferFrom = 'MI', TransferStatus = 'pending' where PlayerId = id;
                elsif transfer_status = 'Canceled' then
                    DBMS_OUTPUT.PUT_LINE('Your BID got cancelled by KKR');
                else
                    DBMS_OUTPUT.PUT_LINE('Bid already made for this player.');
                end if;
                exit;
            elsif availability != 'Available' then
                DBMS_OUTPUT.PUT_LINE('Currently not available for bid.');
                exit;
            end if;
        end if;
    end loop;

    if flag = 0 then
        DBMS_OUTPUT.PUT_LINE('No such player exists.');
    end if;

END;
/


commit;

select * from TransferInfoKKR@site2;
