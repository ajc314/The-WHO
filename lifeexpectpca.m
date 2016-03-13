deathcause = readtable('cause_of_death.xlsx');
sanitation = readtable('sanitation.xlsx');
lifeexpect = readtable('life_expectancy.xlsx');
choleradeath = readtable('cholera_deaths.xlsx');
choleracase = readtable('cholera_cases.xlsx');
cholerafatal = readtable('cholera_case_fatality.xlsx');
countryregion = readtable('countryregionfix2.xlsx');


lifeexpectdouble = str2double(lifeexpect{:,2:11});
lifeexpectyear = lifeexpectdouble(:,2);
sanitationdouble = str2double(sanitation{:,2:8});
deathcausedouble = str2double(deathcause{:,2:5});
choleradeathdouble = str2double(choleradeath{:,2:3});
choleracasedouble = str2double(choleracase{:,2:3});
cholerafataldouble = str2double(cholerafatal{:,2:3});



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
figure;
plot(lifeexpectx, lifeexpecty, 'x')


Factor1temp = zeros(numel(lifeexpectdouble(:,2)) ,2);
Factor1= zeros(191,1);
Factor2= zeros(191,1);
Factor3= zeros(191,1);
Factor4= zeros(191,1);
Factor5= zeros(191,1);
Factor6= zeros(191,1);
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
Factor1temp2 = Factor1temp([1:99,102:591,594:643,646:end],:)

n = 1;
m = 1;
for i = 1:numel(Factor1temp2(:,2)),
    if Factor1temp2(i,2) == 2000,
        Factor1(n,1) = Factor1temp2(i,1);
        n = n+1;
    end;
        
    if Factor1temp2(i,2) == 1990,
        Factor4(m,1) = Factor1temp2(i,1);
        m = m+1;  
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
            
        end;
        n = n+1;
    end;
end;

for i = 1:numel(Factor2)
    if isnan(Factor5(i,1)) == 0
        if isnan(Factor6(i,1)) == 0
            FactorNaN(i,1) = Factor5(i,1) + Factor6(i,1);
        end;
    end;
end;
        
%{
n = 1;

for i = 1:numel(Factor1temp(:,2)),
    if Factor1temp(i,2) == 1990,
        Factor4(n,1) = Factor1temp(i,1);
        n = n+1;
    end;
end;

n = 1;
for i = 1:numel(sanitationdouble(:,1)),
    if sanitationdouble(i,1) == 1990,
        Factor5(n,1) = sanitationdouble(i,4);
        n = n+1;
    end;
end;
n = 1;
for i = 1:numel(sanitationdouble(:,1)),
    if sanitationdouble(i,1) == 1990,
        Factor6(n,1) = sanitationdouble(i,7);
        n = n+1;
    end;
end;
%}


Factors = horzcat(Factor1, Factor2, Factor3);

FactorTable1 = table(Factor1,Factor2,Factor3);
MakeTableLife = table(Factor1, Factor4, LifeDiff);
MakeTableSan = table(Factor2, Factor5, Factor3, Factor6);
LifeCompare = horzcat(Countrynamesnew(FactorNaN(:,1) ~= 0,1), MakeTableLife(FactorNaN(:,1) ~=0, :));

SanitationTableFix = horzcat(Countrynamesnew(FactorNaN(:,1) ~= 0,1), MakeTableSan(FactorNaN(:,1) ~= 0,:));
SanitationCompareDouble = (SanitationTableFix{:,2:5});

K = 1.25;
SanCompare = table;
WaterCompare = table;
n = 1
for i = 1:numel(SanitationCompareDouble(:,1))
    %if SanitationCompareDouble(i,3) >= K * SanitationCompareDouble(i,4)
        SanCompare{n,1} = SanitationTableFix{i,1};
        SanCompare{n,2} = SanitationCompareDouble(i,3) / SanitationCompareDouble(i,4);
        n = n + 1;
    %end;
end;
n = 1;
for i = 1:numel(SanitationCompareDouble(:,1))
    %if SanitationCompareDouble(i,1) >= K * SanitationCompareDouble(i,2)
        WaterCompare{n,1} = SanitationTableFix{i,1};
        WaterCompare{n,2} = SanitationCompareDouble(i,1) / SanitationCompareDouble(i,2);
        n = n + 1;
    %end;
end;
%Add life expect change for 1990



Factorx = linspace(1,194,194)';

%Fix for brunei, san marino, south sudan


%Principal Component Analysis 
% Make matrix of all factors 


%make submatricies for each region

reigonlist = table;
for i = 1:numel(Countrynamesnew{:,1})
    tempx = Countrynamesnew{i,1};
    for j = 1:numel(countryregion{:,1}),
        if strcmp(tempx,countryregion{j,1}) == 1,
            reigonlist{i,1} = countryregion{j,3};
        end;
    end;
end;

regionplot = horzcat(FactorTable1, reigonlist);
%}

% Leave out New Zealand because it's dumb and doesn't have san data
% Plot submatricies by region



Africa = regionplot(strcmp(regionplot{:,4}, 'Africa') == 1, :);
Asia = regionplot(strcmp(regionplot{:,4}, 'Asia') == 1, :);
NorthAm = regionplot(strcmp(regionplot{:,4}, 'North America') == 1, :);
Oceania = regionplot(strcmp(regionplot{:,4}, 'Oceania') == 1, :);
SouthAm = regionplot(strcmp(regionplot{:,4}, 'South America') == 1, :);
Europe = regionplot(strcmp(regionplot{:,4}, 'Europe') == 1, :);

%correlation coefficients
A = regionplot{[1:120, 122:end],1}; %life
B = regionplot{[1:120, 122:end],2}; %water
C = regionplot{[1:120, 122:end],3}; %san


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
hold on

plot3(Europe{:,1}, Europe{:,2}, Europe{:,3}, 'x')
plot3(Africa{:,1}, Africa{:,2}, Africa{:,3}, 'x')
plot3(Asia{:,1}, Asia{:,2}, Asia{:,3}, 'x')
plot3(NorthAm{:,1}, NorthAm{:,2}, NorthAm{:,3}, 'x')
plot3(SouthAm{:,1}, SouthAm{:,2}, SouthAm{:,3}, 'x')
plot3(Oceania{:,1}, Oceania{:,2}, Oceania{:,3}, 'x')




legend('Europe','Africa','Asia','North America','South America', 'Oceania')
xlabel('Life Expectancy, years')
ylabel('Access to clean water, %')
zlabel('Access to sanitation, %')
title('3D Scatterplot of Life Expectancy, Clean Water, and Sanitation')


grid on

figure;
plot(B,A,'.')
hold on
plot(xB,y1)
hold off
grid on
xlabel('Access to Clean Water, %')
ylabel('Life Expectancy, years')
title('Life Expectancy vs. Clean Water, r^2 = .797')

figure;
plot(C,A,'.')
hold on
plot(xC,y2)
hold off
grid on
xlabel('Access to Sanitation, %')
ylabel('Life Expectancy, years')
title('Life Expectancy vs. Sanitation, r^2 = .844')

figure;
plot(C,B,'.')
hold on
plot(xC,y3)
hold off
grid on
xlabel('Access to Sanitation, %')
ylabel('Access to Clean Water, %')
title('Clean Water vs. Sanitation, r^2 = .829')



%{
[coeff, Score, Latent] = pca(Factors); 

figure;

plot(Score(:,1), Score(:,2), '.')


figure;
plot(SanCompare{:,2}, LifeCompare{:,4}, 'x')

figure
%}

