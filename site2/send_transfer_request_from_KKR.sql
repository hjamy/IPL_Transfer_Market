SET SERVEROUTPUT ON;
SET VERIFY OFF;

--prompt a number dewa lage, int dile kaj kore na
--promt a char dewa lage, varchar dile kaj kore na

select * from TransferInfoMI@site1;
select PlayerId, BasePrice from PlayersMI@site1; 

ACCEPT A NUMBER PROMPT "Enter Player ID you wish to bid for = "
ACCEPT B NUMBER PROMPT "Enter price you wish to bid for the player = "

DECLARE
    team PlayersKKR.TeamName%TYPE := 'MI';
    id PlayersMI.PlayerId@site1%TYPE;
    name PlayersMI.PlayerName@site1%TYPE;
    role PlayersMI.PlayerRole@site1%TYPE;
    availability PlayersMI.PlayerStatus@site1%TYPE;
    Price PlayersMI.BasePrice@site1%TYPE;
    bid_id PlayersMI.PlayerId@site1%TYPE;
    bid_price PlayersMI.BasePrice@site1%TYPE;
    transfer_status varchar2(15);
    flag number:=0;
BEGIN
    bid_id := &A;
    bid_price := &B;
    for i in (select * from PlayersMI@site1) loop 
        id := i.PlayerId;
        availability := i.PlayerStatus;
        Price := i.BasePrice;
        if id = bid_id then
            flag := 1;
            if availability = 'Available' AND Price > bid_price then
                DBMS_OUTPUT.PUT_LINE('Minimum bid price for this player is ' || Price); 
                exit;
            elsif availability = 'Available' AND Price <= bid_price then
                -- select TransferStatus into transfer_status from TransferInfoMI where PlayerId = bid_id;
                transfer_status := PACKAGE_KKR.Search_Transfer_Status_F(id, team);
                if transfer_status = 'No Offer' OR transfer_status = 'Asked More' then 
                    update TransferInfoMI@site1 set BidOfferred = bid_price, OfferFrom = 'KKR', TransferStatus = 'pending' where PlayerId = id;
                elsif transfer_status = 'Canceled' then
                    DBMS_OUTPUT.PUT_LINE('Your BID got cancelled by MI');
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

select * from TransferInfoMI@site1;
