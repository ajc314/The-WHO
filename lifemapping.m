deathcause = readtable('cause_of_death.xlsx');
sanitation = readtable('sanitation.xlsx');
lifeexpect = readtable('life_expectancy_new.xlsx');
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
MakeTableLife = table(Factor1, Factor4, LifeDiff, Factor7);
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


countries = shaperead('cntry02', 'UseGeoCoords', true);

Factor1tbl = table(Factor1);
Factor2tbl = table(Factor2);
Factor3tbl = table(Factor3);
Factor4tbl = table(Factor4);
Factor5tbl = table(Factor5);
Factor6tbl = table(Factor6);
Factor7tbl = table(Factor7);
Factor8tbl = table(Factor8);
Factor9tbl = table(Factor9);


LifeMap2000 = horzcat(Countrynamesnew,Factor1tbl);
[countries.field19]=deal(NaN);
for i = 1:length(countries)
    tempx = countries(i).CNTRY_NAME;
    for j = 1:numel(LifeMap2000{:,1}),
        if strcmp(tempx,LifeMap2000{j,1}) == 1,
            countries(i).field19 = LifeMap2000{j,2};
        end;
    end;
end;

LifeMap1990 = horzcat(Countrynamesnew,Factor4tbl);
[countries.field20]=deal(NaN);
for i = 1:length(countries)
    tempx = countries(i).CNTRY_NAME;
    for j = 1:numel(LifeMap1990{:,1}),
        if strcmp(tempx,LifeMap1990{j,1}) == 1,
            countries(i).field20 = LifeMap1990{j,2};
        end;
    end;
end;

LifeMap2013 = horzcat(Countrynamesnew,Factor7tbl);
[countries.field21]=deal(NaN);
for i = 1:length(countries)
    tempx = countries(i).CNTRY_NAME;
    for j = 1:numel(LifeMap2013{:,1}),
        if strcmp(tempx,LifeMap2013{j,1}) == 1,
            countries(i).field21 = LifeMap2013{j,2};
        end;
    end;
end;

WaterMap2000 = horzcat(Countrynamesnew,Factor2tbl);
[countries.field22]=deal(NaN);
for i = 1:length(countries)
    tempx = countries(i).CNTRY_NAME;
    for j = 1:numel(WaterMap2000{:,1}),
        if strcmp(tempx,WaterMap2000{j,1}) == 1,
            countries(i).field22 = WaterMap2000{j,2};
        end;
    end;
end;

WaterMap1990 = horzcat(Countrynamesnew,Factor5tbl);
[countries.field23]=deal(NaN);
for i = 1:length(countries)
    tempx = countries(i).CNTRY_NAME;
    for j = 1:numel(WaterMap1990{:,1}),
        if strcmp(tempx,WaterMap1990{j,1}) == 1,
            countries(i).field23 = WaterMap1990{j,2};
        end;
    end;
end;

WaterMap2015 = horzcat(Countrynamesnew,Factor8tbl);
[countries.field24]=deal(NaN);
for i = 1:length(countries)
    tempx = countries(i).CNTRY_NAME;
    for j = 1:numel(WaterMap2015{:,1}),
        if strcmp(tempx,WaterMap2015{j,1}) == 1,
            countries(i).field24 = WaterMap2015{j,2};
        end;
    end;
end;

SanMap2000 = horzcat(Countrynamesnew,Factor3tbl);
[countries.field25]=deal(NaN);
for i = 1:length(countries)
    tempx = countries(i).CNTRY_NAME;
    for j = 1:numel(SanMap2000{:,1}),
        if strcmp(tempx,SanMap2000{j,1}) == 1,
            countries(i).field25 = SanMap2000{j,2};
        end;
    end;
end;

SanMap1990 = horzcat(Countrynamesnew,Factor6tbl);
[countries.field26]=deal(NaN);
for i = 1:length(countries)
    tempx = countries(i).CNTRY_NAME;
    for j = 1:numel(SanMap1990{:,1}),
        if strcmp(tempx,SanMap1990{j,1}) == 1,
            countries(i).field26 = SanMap1990{j,2};
        end;
    end;
end;

SanMap2015 = horzcat(Countrynamesnew,Factor9tbl);
[countries.field27]=deal(NaN);
for i = 1:length(countries)
    tempx = countries(i).CNTRY_NAME;
    for j = 1:numel(SanMap2015{:,1}),
        if strcmp(tempx,SanMap2015{j,1}) == 1,
            countries(i).field27 = SanMap2015{j,2};
        end;
    end;
end;
[countries.field28]=deal(NaN);
for i =1:length(countries)
    countries(i).field28 = countries(i).field21 - countries(i).field20;
end;


maxlife = 85;
maxsan = 100;
maxwater = 100;


colors1 = flipud(parula(30));
colors3 = flipud(parula(30));
colors2 = flipud(parula(30));

LifeColors2000 = makesymbolspec('Polygon', {'field19', ...
   [35 maxlife], 'FaceColor', colors1});
LifeColors1990 = makesymbolspec('Polygon', {'field20', ...
   [35 maxlife], 'FaceColor', colors1});
LifeColors2013 = makesymbolspec('Polygon', {'field21', ...
   [35 maxlife], 'FaceColor', colors1});
DeltaLife = makesymbolspec('Polygon', {'field28', ...
[-20 30] 'FaceColor', colors1});
SanColors2000 = makesymbolspec('Polygon', {'field25', ...
   [0 maxsan], 'FaceColor', colors3});
SanColors1990 = makesymbolspec('Polygon', {'field26', ...
   [0 maxsan], 'FaceColor', colors3});
SanColors2015 = makesymbolspec('Polygon', {'field27', ...
   [0 maxsan], 'FaceColor', colors3});

WaterColors2000 = makesymbolspec('Polygon', {'field22', ...
   [0 maxwater], 'FaceColor', colors2});
WaterColors1990 = makesymbolspec('Polygon', {'field23', ...
   [0 maxwater], 'FaceColor', colors2});
WaterColors2015 = makesymbolspec('Polygon', {'field24', ...
   [0 maxwater], 'FaceColor', colors2});

figure; 

subplot(2,1,1)
geoshow(countries, 'DisplayType', 'polygon', ...
   'SymbolSpec', LifeColors1990)
caxis([35 maxlife])
colormap(colors1)
colorbar
h1 = colorbar;
ylabel(h1, 'Years')
xlabel('1990')
showaxes('off')
title('Life Expectancies by Country, 1990-2013')
%{
subplot(3,1,2)
geoshow(countries, 'DisplayType', 'polygon', ...
   'SymbolSpec', LifeColors2000)
caxis([35 maxlife])
colormap(colors1)
colorbar
h2 = colorbar;
ylabel(h2, 'Years')
xlabel('2000')
showaxes('off')
%}

subplot(2,1,2)
geoshow(countries, 'DisplayType', 'polygon', ...
   'SymbolSpec', LifeColors2013)
caxis([35 maxlife])
colormap(colors1)
colorbar
h3 = colorbar;
ylabel(h3, 'Years')
xlabel('2013')
showaxes('off')

figure;

subplot(2,1,1)
geoshow(countries, 'DisplayType', 'polygon', ...
   'SymbolSpec', WaterColors1990)
caxis([0 maxwater])
colormap(colors2)
colorbar
h4 = colorbar;
ylabel(h4, '% Access to Clean Water')
xlabel('1990')
showaxes('off')
title('Access to Clean Water, 1990-2015')
%{
subplot(3,1,2)
geoshow(countries, 'DisplayType', 'polygon', ...
   'SymbolSpec', WaterColors2000)
caxis([0 maxwater])
colormap(colors2)
colorbar
h5 = colorbar;
ylabel(h5, '% Access to Clean Water')
xlabel('2000')
showaxes('off')
%}

subplot(2,1,2)
geoshow(countries, 'DisplayType', 'polygon', ...
   'SymbolSpec', WaterColors2015)
caxis([0 maxwater])
colormap(colors2)
colorbar
h6 = colorbar;
ylabel(h6, '% Access to Clean Water')
xlabel('2015')
showaxes('off')


figure; 

subplot(2,1,1)
geoshow(countries, 'DisplayType', 'polygon', ...
   'SymbolSpec', SanColors1990)
caxis([0 maxsan])
colormap(colors3)
colorbar
h7 = colorbar;
ylabel(h7, '% Access to Sanitation')
xlabel('1990')
showaxes('off')
title('Access to Sanitation, 1990-2015')
%{
subplot(3,1,2)
geoshow(countries, 'DisplayType', 'polygon', ...
   'SymbolSpec', SanColors2000)
caxis([0 maxsan])
colormap(colors3)
colorbar
h8 = colorbar;
ylabel(h8, '% Access to Sanitation')
xlabel('2000')
showaxes('off')
%}

subplot(2,1,2)
geoshow(countries, 'DisplayType', 'polygon', ...
   'SymbolSpec', SanColors2015)
caxis([0 maxsan])
colormap(colors3)
colorbar
h9 = colorbar;
ylabel(h9, '% Access to Sanitation')
xlabel('2015')
showaxes('off')


figure; 

%{
geoshow(countries, 'DisplayType', 'polygon', ...
   'SymbolSpec', DeltaLife)
caxis([-20 30])
colormap(colors1)
colorbar
h10 = colorbar;
ylabel(h10, 'Years')
showaxes('off')
title('Change in Life Expectancy, 1990-2013')
%}







