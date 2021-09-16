clear screen;
set linesize 300;

--drop all tables
drop table PlayersMI cascade constraints;
drop table TransferInfoMI cascade constraints;
drop table BattingStatMI cascade constraints;
drop table BowlingStatMI cascade constraints;

--create and insert into PlayersMI
create table PlayersMI(
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

insert into PlayersMI values('MI', 9, 'Rohit', TO_DATE('1990/03/30', 'yyyy/mm/dd'), 'Batsman', 'Available', '100', NULL);
insert into PlayersMI values('MI', 10, 'Ponting', TO_DATE('1994/12/19', 'yyyy/mm/dd'), 'Batsman', 'Available', '200', NULL);
insert into PlayersMI values('MI', 11, 'Sachin', TO_DATE('1993/04/24', 'yyyy/mm/dd'), 'Batsman', 'Available', '300', NULL);
insert into PlayersMI values('MI', 12, 'Zaheeer', TO_DATE('1992/09/14', 'yyyy/mm/dd'), 'Bowler', 'Available', '400', NULL);
insert into PlayersMI values('MI', 13, 'DeCock', TO_DATE('1998/07/09', 'yyyy/mm/dd'), 'WK', 'Not Available', '500', NULL);
insert into PlayersMI values('MI', 14, 'Pandya', TO_DATE('1998/01/04', 'yyyy/mm/dd'), 'Alrounder', 'Available', '600', NULL);
insert into PlayersMI values('MI', 15, 'Mustafiz', TO_DATE('1996/06/27', 'yyyy/mm/dd'), 'Bowler', 'Available', '700', NULL);
insert into PlayersMI values('MI', 16, 'Anderson', TO_DATE('1995/05/17', 'yyyy/mm/dd'), 'Alrounder', 'Available', '800', NULL);

--create TransferInfoMI, INSERT will through another sql file
create table TransferInfoMI( 
PlayerId        int, 
BidOfferred     integer, 
OfferFrom		varchar2(10),
TransferStatus  varchar2(15),					--pending, Cancel, Asked More, Accepted, No Offer
			    FOREIGN KEY(PlayerId) REFERENCES PlayersMI(PlayerId) 
);

create table BattingStatMI( 
PlayerId        int, 
Matches 	    integer, 
Runs            integer,
HighestScore    integer,
Average         float,
BallsFaced      integer,
Strikerate      float,
Fifties			int,
Hundreds		int,
			    FOREIGN KEY(PlayerId) REFERENCES PlayersMI(PlayerId)
);

insert into BattingStatMI values(9, 341, 8989, 134, 26.36, 6740, 133.36, 35, 4);
insert into BattingStatMI values(10, 48, 909, 98, 18.94, 819, 110.98, 12, 1);
insert into BattingStatMI values(11, 96, 2797, 100, 29.14, 2310, 121.08, 24, 1);
insert into BattingStatMI values(12, 222, 1000, 34, 4.50, 900, 111.11, 0, 0);
insert into BattingStatMI values(13, 321, 8003, 122, 24.93, 6000, 133.38, 32, 2);
insert into BattingStatMI values(14, 123, 3943, 112, 32.06, 2310, 170.07, 22, 1);
insert into BattingStatMI values(15, 176, 900, 32, 5.11, 801, 112.36, 0, 0);
insert into BattingStatMI values(16, 234, 6789, 143, 29.01, 5000, 135.78, 25, 2);

create table BowlingStatMI( 
PlayerId        int, 
Matches         integer, 
Balls           integer,
Runs            integer,
Wickets         integer,
Average         float,
Economy         float,
			    FOREIGN KEY(PlayerId) REFERENCES PlayersMI(PlayerId)
);

insert into BowlingStatMI values(9, 341, 628, 817, 29, 28.17, 7.80);
insert into BowlingStatMI values(10, 48, 12, 23, 1, 23, 11.5);
insert into BowlingStatMI values(11, 96, 93, 123, 2, 61.5, 7.93);
insert into BowlingStatMI values(12, 222, 4000, 5231, 278, 18.87, 7.85);
insert into BowlingStatMI values(13, 321, 16, 26, 1, 26, 9.75);
insert into BowlingStatMI values(14, 123, 843, 1076, 45, 23.91, 7.66);
insert into BowlingStatMI values(15, 176, 2493, 3222, 236, 13.65, 7.75);
insert into BowlingStatMI values(16, 234, 2000, 2800, 123, 22.76, 8.4);


select * from PlayersMI;
select * from TransferInfoMI;
select * from BattingStatMI;
select * from BowlingStatMI;

@"D:\4.1\Lab\Distributed DB\Project\Partition\site2\Package_MI.sql"

BEGIN
	PACKAGE_MI.TransferInfoProcedureMI;
	PACKAGE_MI.AgeGeneratorMI;
	
END;
/

create or replace view TransferTableMI(P_No, BId, Team, Status) as
select M.PlayerId, M.BidOfferred, M.OfferFrom, M.TransferStatus
from TransferInfoMI M;


commit;

select * from TransferTableMI;

-- select * from TransferInfoKKR;
-- select * from TransferInfoMI;

select * from PlayersMI;

commit;