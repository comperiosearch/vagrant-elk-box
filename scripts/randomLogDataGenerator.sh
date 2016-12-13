#
#{"@timestamp":"2015-02-18T02:05:10.2224556+01:00","@fields":{"level":"INFO","logger":"queryLog","properties":{"log4net:HostName":"hostMachine"},"exception":null},"@message":{"documentTitle":"Proving that Android’s, Java’s and Python’s sorting algorithm is broken (and showing how to fix it)"}}
#
################################################################################3333

levels[0]="INFO"
levels[1]="DEBUG"
levels[2]="WARNING"
levels[3]="ERROR"

ranWord1[0]="web server"
ranWord1[1]="database"
ranWord1[2]="schema"
ranWord1[3]="server"
ranWord1[4]="service"
ranWord1[5]="data"
ranWord1[6]="attribute"
ranWord1[7]="external service"
ranWord1[8]="API of auth"

ranWord2[0]="loaded"
ranWord2[1]="passing"
ranWord2[2]="called"
ranWord2[3]="throwing"
ranWord2[4]="authenticating"
ranWord2[5]="passing parameters"
ranWord2[6]="failing call"
ranWord2[7]="batch loading"
ranWord2[8]="transforming"

ranWord3[0]="with user1"
ranWord3[1]="with user2"
ranWord3[2]="with user3"
ranWord3[3]="with user4"
ranWord3[4]="with user5"
ranWord3[5]="with user6"
ranWord3[6]="with user7"

echo "{\"@timestamp\":2015-0$((RANDOM%9+1))-$((RANDOM%30+10))T$((RANDOM%24+10)):$((RANDOM%60+10)):$((RANDOM%60+10)).$RANDOM+0$((RANDOM %= 9)):00\",\"@fields\":${levels[$((RANDOM %= 4))]},\"logger\":\"queryLog\",\"properties\":{\"log4net:HostName\":\"hostMachine\"},\"exception\":null},\"@message\":{"documentTitle":\"${ranWord1[((RANDOM %= 8))]} ${ranWord2[((RANDOM %= 8))]} ${ranWord3[((RANDOM %= 6))]}\""
