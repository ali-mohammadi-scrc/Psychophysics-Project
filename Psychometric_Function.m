clear
clc
%%
inf = load('Results\inf.mat');
Data = load('Results\Subject 1.mat');
Morphings = unique(Data.Trials(:, 4));
Scores = zeros([length(Morphings), 2, inf.inf - 1]);
for s = 1:(inf.inf - 1)
    Data = load(['Results\Subject ' num2str(s) '.mat']);
    for C = 1:2
        for M = 1:length(Morphings)
            Morph = find((Data.Trials(:, 4) == Morphings(M)) & (Data.Trials(:, 2) == C));
            Scores(M, C, s) = (sum(Data.Trials(Morph, 3)) + 10)/20;
        end
    end
end
%%
f1 = fit(Morphings, mean(Scores(:, 1, :), 3), 'poly3');
f2 = fit(Morphings, mean(Scores(:, 2, :), 3), 'poly3');
figure('name', 'Psychometric Function')
hold on
plot(Morphings, mean(Scores(:, 1, :), 3), 'O')
plot(f1, 'm')
plot(Morphings, mean(Scores(:, 2, :), 3), '*')
plot(f2, 'c')
hold off
xlabel('Morphings')
ylabel('Proportion of Female Responce')
legend('90', '90', '180', '180')
%%
[P, H] = ranksum(f1(-50:50), f2(-50:50));
disp(['P-value: ' num2str(P)])
%%