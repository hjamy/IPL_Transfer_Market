SET SERVEROUTPUT ON;
SET VERIFY OFF;

CREATE OR REPLACE TRIGGER TransferTriggerKKR 
BEFORE DELETE
ON TransferInfoKKR
DECLARE
	Kt_id TransferInfoKKR.PlayerId%TYPE;
	Kt_bid TransferInfoKKR.BidOfferred%TYPE;
    Kt_to TransferInfoKKR.OfferFrom%TYPE;
    Kt_status TransferInfoKKR.TransferStatus%TYPE;
    name PlayersKKR.PlayerName%TYPE;
BEGIN
	
	select PlayerId, BidOfferred, OfferFrom, TransferStatus into Kt_id, Kt_bid, Kt_to, Kt_status from TransferInfoKKR where TransferStatus = 'Accepted';
    select PlayerName into name from PlayersKKR where PlayerId IN (select PlayerId from TransferInfoKKR where TransferStatus = 'Accepted'); 
    if Kt_status = 'Accepted' then
        DBMS_OUTPUT.PUT_LINE('MI just bought ' || name || ' from KKR with a Transfer Fee of $' || Kt_bid || '!!!');
    end if;

END;
/

commit;