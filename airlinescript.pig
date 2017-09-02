/* Problem Statement 1 - Find out the top 5 most visited destinations.*/
REGISTER '/home/acadgild/airline_usecase/piggybank.jar';


A = load '/home/acadgild/airline_usecase/DelayedFlights.csv' USING org.apache.pig.piggybank.storage.CSVExcelStorage(',','NO_MULTILINE','UNIX','SKIP_INPUT_HEADER');
 
B = foreach A generate (int)$1 as year, (int)$10 as flight_num, (chararray)$17 as origin,(chararray) $18 as dest;
 
C = filter B by dest is not null;
 
D = group C by dest;
 
E = foreach D generate group, COUNT(C.dest);
 
F = order E by $1 DESC;
 
Result = LIMIT F 5;
 
A1 = load '/home/acadgild/airline_usecase/airports.csv' USING org.apache.pig.piggybank.storage.CSVExcelStorage(',','NO_MULTILINE','UNIX','SKIP_INPUT_HEADER');
 
A2 = foreach A1 generate (chararray)$0 as dest, (chararray)$2 as city, (chararray)$4 as country;
 
joined_table = join Result by $0, A2 by dest;

STORE joined_table INTO '/home/acadgild/pig/output/airline_usecase/problem_1';

/*Problem Statement 2-Which month has seen the most number of cancellations due to bad weather?*/

REGISTER '/home/acadgild/airline_usecase/piggybank.jar';
 
A = load '/home/acadgild/airline_usecase/DelayedFlights.csv' USING org.apache.pig.piggybank.storage.CSVExcelStorage(',','NO_MULTILINE','UNIX','SKIP_INPUT_HEADER');
 
B = foreach A generate (int)$2 as month,(int)$10 as flight_num,(int)$22 as cancelled,(chararray)$23 as cancel_code;
 
C = filter B by cancelled == 1 AND cancel_code =='B';
 
D = group C by month;
 
E = foreach D generate group, COUNT(C.cancelled);
 
F= order E by $1 DESC;
 
Result = limit F 1;
 
STORE Result INTO '/home/acadgild/pig/output/airline_usecase/problem_2';

/*Problem Statement 3-Top ten origins with the highest AVG departure delay*/

REGISTER '/home/acadgild/airline_usecase/piggybank.jar';
 
A = load '/home/acadgild/airline_usecase/DelayedFlights.csv' USING org.apache.pig.piggybank.storage.CSVExcelStorage(',','NO_MULTILINE','UNIX','SKIP_INPUT_HEADER');
 
B1 = foreach A generate (int)$16 as dep_delay, (chararray)$17 as origin;
 
C1 = filter B1 by (dep_delay is not null) AND (origin is not null);
 
D1 = group C1 by origin;
 
E1 = foreach D1 generate group, AVG(C1.dep_delay);
 
Result = order E1 by $1 DESC;
 
Top_ten = limit Result 10;
 
Lookup = load '/home/acadgild/airline_usecase/airports.csv' USING org.apache.pig.piggybank.storage.CSVExcelStorage(',','NO_MULTILINE','UNIX','SKIP_INPUT_HEADER');
 
Lookup1 = foreach Lookup generate (chararray)$0 as origin, (chararray)$2 as city, (chararray)$4 as country;
 
Joined = join Lookup1 by origin, Top_ten by $0;
 
Final = foreach Joined generate $0,$1,$2,$4;
 
Final_Result = ORDER Final by $3 DESC;
 
STORE Final_Result INTO '/home/acadgild/pig/output/airline_usecase/problem_3';

/*Problem Statement 4-Which route (origin & destination) has seen the maximum diversion?*/

REGISTER '/home/acadgild/airline_usecase/piggybank.jar';
 
A = load '/home/acadgild/airline_usecase/DelayedFlights.csv' USING org.apache.pig.piggybank.storage.CSVExcelStorage(',','NO_MULTILINE','UNIX','SKIP_INPUT_HEADER');
 
B = FOREACH A GENERATE (chararray)$17 as origin, (chararray)$18 as dest, (int)$24 as diversion;
 
C = FILTER B BY (origin is not null) AND (dest is not null) AND (diversion == 1);
 
D = GROUP C by (origin,dest);
 
E = FOREACH D generate group, COUNT(C.diversion);
 
F = ORDER E BY $1 DESC;
 
Result = limit F 10;
 
STORE Result INTO '/home/acadgild/pig/output/airline_usecase/problem_4';

