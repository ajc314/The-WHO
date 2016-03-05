deathcause = readtable('cause_of_death.xlsx');
sanitation = readtable('sanitation.xlsx');
lifeexpect = readtable('life_expectancy.xlsx');
choleradeath = readtable('cholera_deaths.xlsx');
choleracase = readtable('cholera_cases.xlsx');
cholerafatal = readtable('cholera_case_fatality.xlsx');

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
Factor1temp = Factor1temp([1:99,101:591,593:643,645:end],:)

n = 1;

for i = 1:numel(Factor1temp(:,2)),
    if Factor1temp(i,2) == 2000,
        Factor1(n,1) = Factor1temp(i,1);
        n = n+1;
    end;
end;

n = 1;
for i = 1:numel(sanitationdouble(:,1)),
    if sanitationdouble(i,1) == 2000,
        Factor2(n,1) = sanitationdouble(i,4);
        n = n+1;
    end;
end;
n = 1;
for i = 1:numel(sanitationdouble(:,1)),
    if sanitationdouble(i,1) == 2000,
        Factor3(n,1) = sanitationdouble(i,7);
        n = n+1;
    end;
end;

Factors = horzcat(Factor1, Factor2, Factor3);

FactorTable = table(Factors)

FactorTableFinal = horzcat(Countrynamesnew, FactorTable)

Factorx = linspace(1,194,194)';

%Fix for brunei, san marino, south sudan


%Principal Component Analysis 
% Make matrix of all factors 


figure;
plot3(Factors(:,1), Factors(:,2), Factors(:,3), 'x')


[coeff, Score, Latent] = pca(Factors); 

figure;

plot(Score(:,1), Score(:,2), '.')
