
sanitation = readtable('sanitation.xlsx');
lifeexpect = readtable('life_expectancy_new.xlsx');


lifeexpectdouble = str2double(lifeexpect{:,2:11});
lifeexpectyear = lifeexpectdouble(:,2);
sanitationdouble = str2double(sanitation{:,2:8});



lifeexpectx = zeros(194, 3);
lifeexpectx(:,1) = 1990;
lifeexpectx(:,2) = 2000;
lifeexpectx(:,3) = 2013;
lifeexpecty = zeros(194, 3);

n=1;
m=1;
p=1;
for i = 1:numel(lifeexpectdouble(:,2)),
    if lifeexpectdouble(i,1) == 1990,
        lifeexpecty(n,1) = lifeexpectdouble(i,3);
        n = n+1;
    end;
    
    if lifeexpectdouble(i,1) == 2000,
        lifeexpecty(m,2) = lifeexpectdouble(i,3);
        m = m+1;
    end;
    
    if lifeexpectdouble(i,1) == 2013,
        lifeexpecty(p,3) = lifeexpectdouble(i,3);
        p = p+1;
    end;
end;


%figure;
%plot(lifeexpectx, lifeexpecty, 'x')


Factor1temp = zeros(numel(lifeexpectdouble(:,2)) ,2);
Factor1= zeros(191,1);
Factor2= zeros(191,1);
Factor3= zeros(191,1);
Factor4= zeros(191,1);
Factor5= zeros(191,1);
Factor6= zeros(191,1);
Factor7= zeros(191,1);
Factor8= zeros(191,1);
Factor9= zeros(191,1);
FactorNaN = zeros(191,2);
LifeDiff = zeros(191,1);


n = 1;
for i = 1:numel(lifeexpectdouble(:,2)),
    Factor1temp(i,1) = lifeexpectdouble(i,2);
    Factor1temp(i,2) = lifeexpectdouble(i,1);
end;

Countrynames = table(lifeexpect{:,1});
Countrynamesnew = table
n = 1;
for i = 1:numel(Countrynames),
    if strcmp(Countrynames{i,1}, '') ~= 1,
        Countrynamesnew{n,1} = Countrynames{i,1};
        n = n + 1;
    end;
end;

Countrynamesnew = Countrynamesnew([1:24, 26:147, 149:160, 162:end],:);
        


% Remove brunei san marino and south sudan
Factor1temp2 = Factor1temp([1:97,102:589,594:641,646:end],:)

n = 1;
m = 1;
p = 1;
for i = 1:numel(Factor1temp2(:,2)),
    if Factor1temp2(i,2) == 2000,
        Factor1(n,1) = Factor1temp2(i,1);
        n = n+1;
    end;
        
    if Factor1temp2(i,2) == 1990,
        Factor4(m,1) = Factor1temp2(i,1);
        m = m+1;  
        
    end;
    if Factor1temp2(i,2) == 2013,
        Factor7(p,1) = Factor1temp2(i,1);
        p = p+1;  
        
    end;
end;

for i = 1:numel(Factor1),
    LifeDiff(i,1) = Factor1(i,1)/ Factor4 (i,1);
end;

n = 1;
for i = 1:(numel(sanitationdouble(:,1)) - 1),
    if sanitationdouble(i,1) == 2000,
        Factor2(n,1) = sanitationdouble(i,4);
        if sanitationdouble(i+1, 1) == 1990,
            Factor5(n,1) = sanitationdouble(i+1, 4);
            if sanitationdouble(i-1, 1) == 2015,
                Factor8(n,1) = sanitationdouble(i-1, 4);
            end;
        
        end
        n = n+1;
    end;
end;

n = 1;
for i = 1:numel(sanitationdouble(:,1)),
    if sanitationdouble(i,1) == 2000,
        Factor3(n,1) = sanitationdouble(i,7);
        if sanitationdouble(i+1, 1) == 1990,
            Factor6(n,1) = sanitationdouble(i+1, 7);
            if sanitationdouble(i-1, 1) == 2015,
                Factor9(n,1) = sanitationdouble(i-1, 7);
            end;
        end;
        
        n = n+1;
    end;
end;

% make sure we're working with only countries that have data from all years
for i = 1:numel(Factor2)
    if isnan(Factor2(i,1)) == 0,
        if isnan(Factor3(i,1)) == 0,
            if isnan(Factor5(i,1)) == 0
                if isnan(Factor6(i,1)) == 0
                    if isnan(Factor8(i,1)) == 0,
                        if isnan(Factor9(i,1)) == 0,
                            FactorNaN(i,1) = Factor5(i,1) + Factor6(i,1);
                        end;
                    end;
                end;
            end;
        end;
    end;
end;
        


Factors = horzcat(Factor1, Factor2, Factor3);

FactorTable1 = table(Factor1,Factor2,Factor3);
MakeTableLife = table(Factor1, Factor4, Factor7);
MakeTableSan = table(Factor2, Factor5, Factor3, Factor6);
LifeCompare = horzcat(Countrynamesnew(FactorNaN(:,1) ~= 0,1), MakeTableLife(FactorNaN(:,1) ~=0, :));

SanitationTableFix = horzcat(Countrynamesnew(FactorNaN(:,1) ~= 0,1), MakeTableSan(FactorNaN(:,1) ~= 0,:));
SanitationCompareDouble = (SanitationTableFix{:,2:5});

K = 1.25;
SanCompare = table;
WaterCompare = table;
n = 1;
for i = 1:numel(SanitationCompareDouble(:,1))
    %if SanitationCompareDouble(i,3) >= K * SanitationCompareDouble(i,4)
        SanCompare{n,1} = SanitationTableFix{i,1};
        SanCompare{n,2} = SanitationCompareDouble(i,3) / SanitationCompareDouble(i,4);
        
        n = n + 1;
    %end;
end;
n = 1;
LifeComparedouble = zeros(142,1);
for i = 1:numel(SanitationCompareDouble(:,1))
    %if SanitationCompareDouble(i,1) >= K * SanitationCompareDouble(i,2)
        WaterCompare{n,1} = SanitationTableFix{i,1};
        WaterCompare{n,2} = SanitationCompareDouble(i,1) / SanitationCompareDouble(i,2);
        LifeComparedouble(n,1) = LifeCompare{i,2} / LifeCompare{i,3};
        n = n + 1;
    %end;
end;
%Add life expect change for 1990


A = LifeComparedouble(:,1) %change in life expect
B = WaterCompare{:,2} %change in water
C = SanCompare {:,2} %change in sanitation

xA = linspace(min(A),max(A));
xB = linspace(min(B),max(B));
xC = linspace(min(C),max(C));

P1 = polyfit(B,A,1);
P2 = polyfit(C,A,1);
P3 = polyfit(C,B,1);

y1 = polyval(P1,xB);
y2 = polyval(P2,xC);
y3 = polyval(P3,xC);


r1 = corrcoef(B,A)
r2 = corrcoef(C,A)
r3 = corrcoef(C,B)



figure;
plot(B,A,'.')
hold on
plot(xB,y1)
hold off
grid on
xlabel('Change in Access to Clean Water')
ylabel('Change in Life Expectancy')
title('Change in Life Expectancy vs. Clean Water, r^2 = .131')

figure;
plot(C,A,'.')
hold on
plot(xC,y2)
hold off
grid on
xlabel('Change in Access to Sanitation')
ylabel('Change in Life Expectancy')
title('Change in Life Expectancy vs. Sanitation, r^2 = .298')

figure;
plot(C,B,'.')
hold on
plot(xC,y3)
hold off
grid on
xlabel('Change in Access to Sanitation')
ylabel('Change in Access to Clean Water')
title('Change in Clean Water vs. Sanitation, r^2 = .565')









