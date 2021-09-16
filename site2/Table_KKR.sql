clear screen;
set linesize 300;

--drop all tables
drop table PlayersKKR cascade constraints;
drop table TransferInfoKKR cascade constraints;
drop table BattingStatKKR cascade constraints;
drop table BowlingStatKKR cascade constraints;

--create and insert into PlayersKKR
create table PlayersKKR(
TeamName        varchar2(5),
PlayerId        int, 
PlayerName 	    varchar2(10),
DateOfBirth		DATE,
PlayerRole      varchar2(15),
PlayerStatus    varchar2(15),
BasePrice       int,
Age				int,
				PRIMARY KEY (PlayerId)
);

-- 1-8
insert into PlayersKKR values('KKR', 1, 'Shakib', TO_DATE('1997/03/24', 'yyyy/mm/dd'), 'Alrounder', 'Available', '100', NULL);
insert into PlayersKKR values('KKR', 2, 'Ganguly', TO_DATE('1992/07/08', 'yyyy/mm/dd'), 'Batsman', 'Available', '200', NULL);
insert into PlayersKKR values('KKR', 3, 'Shoaib', TO_DATE('1995/08/13', 'yyyy/mm/dd'), 'Bowler', 'Available', '300', NULL);
insert into PlayersKKR values('KKR', 4, 'Gambhir', TO_DATE('1990/03/16', 'yyyy/mm/dd'), 'Batsman', 'Available', '400', NULL);
insert into PlayersKKR values('KKR', 5, 'Mcculum', TO_DATE('1992/05/23', 'yyyy/mm/dd'), 'WK', 'Not Available', '500', NULL);
insert into PlayersKKR values('KKR', 6, 'Russel', TO_DATE('1990/09/22', 'yyyy/mm/dd'), 'Alrounder', 'Available', '600', NULL);
insert into PlayersKKR values('KKR', 7, 'Narine', TO_DATE('1988/08/08', 'yyyy/mm/dd'), 'Bowler', 'Available', '700', NULL);
insert into PlayersKKR values('KKR', 8, 'Gill', TO_DATE('1995/11/11', 'yyyy/mm/dd'), 'Batsman', 'Available', '800', NULL);

--create TransferInfoKKR, INSERT will through another sql file
create table TransferInfoKKR( 
PlayerId        int, 
BidOfferred     integer,
OfferFrom		varchar2(10),               
TransferStatus  varchar2(15),				--pending, Cancel, Asked More, Accepted, No Offer
			    FOREIGN KEY(PlayerId) REFERENCES PlayersKKR(PlayerId) 
);

--create and insert into batting stat kkr
create table BattingStatKKR( 
PlayerId        int, 
Matches 	    integer, 
Runs            integer,
HighestScore    integer,
Average         float,
BallsFaced      integer,
Strikerate      float,
Fifties			int,
Hundreds		int,
			    FOREIGN KEY(PlayerId) REFERENCES PlayersKKR(PlayerId)
); 

insert into BattingStatKKR values(1, 317, 5080, 86, 16.03, 4161, 122.08, 19, 0);
insert into BattingStatKKR values(2, 77, 1726, 91, 22.42, 1613, 107, 22, 1);
insert into BattingStatKKR values(3, 38, 75, 14, 1.97, 76, 98.68, 0, 0);
insert into BattingStatKKR values(4, 300, 6080, 96, 20.267, 5161, 117.81, 22, 0);
insert into BattingStatKKR values(5, 417, 9726, 158, 23.32, 6613, 147.1, 29, 2);
insert into BattingStatKKR values(6, 354, 9000, 123, 25.42, 5500, 163.6, 34, 1);
insert into BattingStatKKR values(7, 389, 3080, 91, 7.92, 2400, 128.38, 5, 0);
insert into BattingStatKKR values(8, 127, 3876, 99, 30.52, 2713, 142.87, 32, 0);

--create and insert into bowling stat kkr
create table BowlingStatKKR( 
PlayerId        int, 
Matches 	    integer, 
Balls           integer,
Runs            integer,
Wickets         integer,
Average         float,
Economy         float,
			    FOREIGN KEY(PlayerId) REFERENCES PlayersKKR(PlayerId)
);

insert into BowlingStatKKR values(1, 317, 6691, 7663, 360, 21.28, 6.87);
insert into BowlingStatKKR values(2, 77, 573, 756, 29, 26.06, 7.91);
insert into BowlingStatKKR values(3, 38, 804, 978, 44, 22.22, 7.29);
insert into BowlingStatKKR values(4, 300, 125, 189, 2, 94.5, 9.07);
insert into BowlingStatKKR values(5, 417, 34, 56, 1, 56, 9.88);
insert into BowlingStatKKR values(6, 354, 4555, 5876, 234, 25.11, 7.74);
insert into BowlingStatKKR values(7, 389, 7691, 8663, 389, 22.27, 6.76);
insert into BowlingStatKKR values(8, 127, 23, 34, 1, 34, 8.87);

select * from PlayersKKR;
select * from TransferInfoKKR;
select * from BattingStatKKR;
select * from BowlingStatKKR;

@"D:\4.1\Lab\Distributed DB\Project\Partition\site2\Package_KKR.sql"

BEGIN
	PACKAGE_KKR.TransferInfoProcedureKKR;
	PACKAGE_KKR.AgeGeneratorKKR;
	
END;
/

create or replace view TransferTableKKR(P_No, BId, Team, Status) as
select K.PlayerId, K.BidOfferred, K.OfferFrom, K.TransferStatus
from TransferInfoKKR K;


commit;

select * from TransferTableKKR;

-- SELECT PlayerId, PlayerName FROM PlayersKKR
-- UNION ALL
-- SELECT PlayerId, PlayerName FROM PlayersMI;


-- select * from TransferInfoKKR;
-- select * from TransferInfoMI;

select * from PlayersKKR;