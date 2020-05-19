% Clear the workspace and the screen
sca
close all
clear
clc
%%
if exist('Results\inf.mat')
    inf = load('Results\inf.mat');
    inf  = inf.inf;
else
    inf = 1;
end
Subject = ['Subject ' num2str(inf)];
inf = inf + 1;
save('Results\inf.mat', 'inf')
SubjectAge = input('Enter your Age plz: \n');
SubjectSex = input('Male(0) or Female(1) ?\n');
%%
% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);

% Seed the random number generator.
rng('shuffle')

% Get the screen numbers
screens = Screen('Screens');

% Draw to the external screen if avaliable
screenNumber = max(screens);

% Define black and white
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
grey = white / 2;
inc = white - grey;

% Open an on screen window
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, black);

% Get the size of the on screen window
[screenXpixels, screenYpixels] = Screen('WindowSize', window);
%%
% Query the frame duration
ifi = Screen('GetFlipInterval', window);

% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);

% Set up alpha-blending for smooth (anti-aliased) lines
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
%% Loading Images
ImageDir = 'dataset\';
ImageNames = dir(ImageDir);
Images = cell(length(ImageNames) - 2, 5);
k = 0;
for i = 1:length(ImageNames)
    Name = ImageNames(i).name;
    if length(Name) < 3
        continue
    end
    k = k + 1;
    Images{k, 1} = imread([ImageDir Name]);
    % Get the size of the image
    [Images{k, 5}, Images{k, 4}, ~] = size(Images{k, 1});
    
    % Here we check if the image is too big to fit on the screen and abort if
    % it is. See ImageRescaleDemo to see how to rescale an image.
    if Images{k, 5} > screenYpixels || Images{k, 4} > screenYpixels
        disp('ERROR! Image is too big to fit on the screen');
        sca;
        return;
    end
    j = length(Name);
    while Name(j) ~= '.'
        j = j - 1;
    end
    j = j - 1;
    Images{k, 2} = str2double(Name(1:j));
end
%% Training
hPIRect = [screenXpixels/3, 0, 2*screenXpixels/3, yCenter];
PIRect = [screenXpixels/6, screenYpixels/4, xCenter, 3*screenYpixels/4];
nRight = 0;
n = 0;
Performance = 0;
i = 1;
while Performance < 85 || n < 25
    i = round(1 + rand*(size(Images, 1) + 1));
    disp(['i = ' num2str(i)])
    if (i == 0) || (i > size(Images, 1))
        continue
    end
    Screen('FillRect', window, black);
    Screen('Flip', window);
    WaitSecs(0.5);
    Text = Screen('MakeTexture', window, Images{i, 1});
    Screen('DrawTexture', window, Text, [], [], 0);
    Screen('Flip', window);
    WaitSecs(0.05);
    Screen('FillRect', window, black);
    Screen('Flip', window);
    WaitSecs(0.5);
    %%
    Screen('TextSize', window, 100)
    Screen('DrawText', window, '<= Female - Male =>', xCenter/2, yCenter, white);
    Screen('Flip', window);
    KbName('UnifyKeyNames');
    Male = 'RightArrow';
    Female = 'LeftArrow';
    RestrictKeysForKbCheck([KbName(Male), KbName(Female)]);
    KeyIsDown = 0;
    while ~KeyIsDown
        [KeyIsDown, ~, KeyCode] = KbCheck(-1);
    end
    %%
    Red = [1, 0, 0];
    Green = [0, 0.75, 0.15];
    if strcmp(KbName(find(KeyCode)), Male)
        Choice = 'Male';
        if Images{i, 2} < 0
            Color = Green;
            nRight = nRight + 1;
        else
            Color = Red;
        end
    else
        Choice = 'Female';
        if Images{i, 2} >= 0
            Color = Green;
            nRight = nRight + 1;
        else
            Color = Red;
        end
    end
    Screen('TextSize', window, 100);
    Screen('DrawText', window, Choice, 7*xCenter/8, yCenter, Color);
    Screen('Flip', window);
    WaitSecs(0.5);
    n = n + 1;
    Performance = nRight/n*100;
    %%
end
%% Expriment
Conditions = [1, 2];
nFaces = size(Images, 1);
nTrialsPerFace = 10 * length(Conditions);
nTrials = nTrialsPerFace * nFaces;
Trials = zeros(nTrials, 4);
for i = 1:nFaces
    for j = 1:nTrialsPerFace
        Trials((i - 1) * nTrialsPerFace + j, 1) = i;
        Trials((i - 1) * nTrialsPerFace + j, 2) = 1 + mod(j, 2);
    end
end
Trials = Trials(Shuffle(1:nTrials), :);
%%
Direction = {hPIRect, PIRect};
for i = 1:nTrials
    Screen('FillRect', window, black);
    Screen('Flip', window);
    Screen('DrawDots', window, [xCenter, yCenter], 10, [1 0 0], [], 2);
    Screen('Flip', window);
    WaitSecs(0.5);
    Text = Screen('MakeTexture', window, Images{Trials(i, 1), 1});
    Screen('DrawTexture', window, Text, [], [Direction{Trials(i, 2)}], 0);
    Screen('Flip', window);
    WaitSecs(0.05);
    Screen('FillRect', window, black);
    Screen('Flip', window);
    WaitSecs(0.5);
    Screen('TextSize', window, 100)
    Screen('DrawText', window, '<= Female - Male =>', xCenter/2, yCenter, white);
    Screen('Flip', window);
    %%
    RestrictKeysForKbCheck([KbName(Male), KbName(Female)]);
    KeyIsDown = 0;
    while ~KeyIsDown
        [KeyIsDown, ~, KeyCode] = KbCheck(-1);
    end
    if strcmp(KbName(find(KeyCode)), Male)
        Sex = -1;
    else
        Sex = 1;
    end
    Trials(i, 3) = Sex;
    Trials(i, 4) = Images{Trials(i, 1), 2};
end
Screen('Close', Text);
%%
% Clear the screen
sca
save(['Results\' Subject '.mat'], 'SubjectAge', 'SubjectSex', 'Trials');
%%