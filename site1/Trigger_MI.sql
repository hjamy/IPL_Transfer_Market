SET SERVEROUTPUT ON;
SET VERIFY OFF;

CREATE OR REPLACE TRIGGER TransferTriggerMI 
BEFORE DELETE
ON TransferInfoMI
DECLARE
	Mt_id TransferInfoMI.PlayerId%TYPE;
	Mt_bid TransferInfoMI.BidOfferred%TYPE;
    Mt_to TransferInfoMI.OfferFrom%TYPE;
    Mt_status TransferInfoMI.TransferStatus%TYPE;
    name PlayersMI.PlayerName%TYPE;
BEGIN
	
	select PlayerId, BidOfferred, OfferFrom, TransferStatus into Mt_id, Mt_bid, Mt_to, Mt_status from TransferInfoMI where TransferStatus = 'Accepted';
    select PlayerName into name from PlayersMI where PlayerId IN (select PlayerId from TransferInfoMI where TransferStatus = 'Accepted'); 
    if Mt_status = 'Accepted' then
        DBMS_OUTPUT.PUT_LINE('KKR just bought ' || name || ' from MI with a Transfer Fee of $' || Mt_bid || '!!!');
    end if;

END;
/

commit;