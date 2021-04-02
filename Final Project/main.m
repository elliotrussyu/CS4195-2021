% Mar. 23th 2021
% CS4195 Modeling and Data Analysis in Complex Networks
% Final Project
% Authors: 
%           Hanshu Yu 4907787,
%           Songlei Fang 5233038,
%           Ying Jin 5184657,
%           Xiaowei Duan 5337593,
%           Chang Ye 5219698.

% Please use the latest version of MATLAB, using an older version could
% result in some unexpected errors.

tic
clear all
close all
clc
%% Add Path of Necessary Tools
% Determine where your m-file's folder is.
folder = fileparts(which(mfilename)); 
% Add that folder plus all subfolders to the path.
addpath(genpath(folder));
%% Read Data
fileName1 = 'events_World_Cup.json'; % filename in JSON extension
str1 = fileread(fileName1); % dedicated for reading files as text
data1 = jsondecode(str1); % Using the jsondecode function to parse JSON from string
fileName2 = 'matches_World_Cup.json'; % filename in JSON extension
str2 = fileread(fileName2); % dedicated for reading files as text
data0 = jsondecode(str2); % Using the jsondecode function to parse JSON from string
%% Data Pre-processing
data2 = data1([data1.matchId] == 2057954,:);

%Find 1 half finish time
in = strfind([data2.matchPeriod],'2H');
endtime1h = data2((in-1)/2,:).eventSec;
% !!!!! TOBEADDEDHERE !!!!! Extratime!!!!

%Renumbering the players from the number 1
data = data2;
players = sortrows(unique([data.playerId;data.teamId]','rows'),2,'ascend');
numberings = 1:size(players,1);
players_reference = [players,numberings'];
[lo,ii] = ismember([data.playerId],players_reference(:,1));
replace1 = players_reference(ii(lo),3);
teams = [sort(unique([data.teamId]),'ascend')',[1;2]];
[lo,ii] = ismember([data.teamId],teams(:,1));
replace2 = teams(ii(lo),2);
[lo,ii] = ismember(players_reference(:,2),teams(:,1));
players_reference(:,2) = teams(ii(lo),2);
for i = 1:length(replace1)
    data(i).playerId = replace1(i);
    data(i).teamId = replace2(i);
end
playernum = [length(find(players_reference(:,2) == 1)),length(find(players_reference(:,2) == 2))];
%% Initialization 
passgraph = [];
pass_state_ini = [0,0,0,0]; %Player1,Player2,timestamp,successful 1/fail 0
pass_flag = 0;
team_rec_temp = 0;
loseballgraph = [];

duelgraph = [];
duel_state_ini = [0,0,0]; %Player1,player2,timestamp
duel_flag = 0;

monitor = [];
%% (Spatial-)Temporal Network Construction
for i = 1:size(data,1)
    if i ~= 1
        monitor = [monitor;i, pass_flag,team_rec_temp, pass];
    else
        monitor = [1,0,0,0,0,0,0];
    end
    item = data(i);
    if isempty([item.tags]) == 0
        tags = [item.tags.id];
    else
        tags= 99999;
    end
%     In case of a duel,we save the state and move on to the next one,
%     because duels are supposed to always appear in pairs. Bu in fact 
%     there might be some mistakes in the dataset that some duels only 
%     appear independently, we consider such a line as an invalid line
%     of data.
%DUELS
    if item.eventId == 1 && duel_flag == 0
        duel = duel_state_ini;
        duel_flag = 1;
        duel(1) = item.playerId; %One of the players that participates in the duel
        
        if item.matchPeriod == '2H' %The timestamp of this current duel
            duel(3) = endtime1h+item.eventSec; 
        else
            duel(3) = item.eventSec;
        end
    
    elseif item.eventId == 1 && duel_flag == 1
        duel(2) = item.playerId;%One of the players that participates in the duel
        duelgraph = [duelgraph;duel];
        duel_flag = 0;
      
    elseif item.eventId ~= 1 && duel_flag == 1 %Bad duel pair check
        duel_flag = 0;
        duel = duel_state_ini;
    
    end
%PASSES    
    if item.eventId == 8
       
       
       
       if pass_flag == 0
           pass = pass_state_ini;
           pass(1) = item.playerId; %Pass initiator
           team_rec_temp = item.teamId; %Record the team of the first player
           
           if item.matchPeriod == '2H' %The timestamp of this current pass
               pass(3) = endtime1h+item.eventSec; 
           else
               pass(3) = item.eventSec;
           end

           if ~isempty(find(ismember(tags,1802), 1)) %Unsuccessful pass
               pass(4) = 0; %Indicate that the pass is not succcessful.
               pass_flag = 1;
           elseif ~isempty(find(ismember(tags,1801), 1)) %Successful pass?
               %We are not sure yet if the pass is actually successful, 
               %if it leads to a duel, his/hers teammate must win the 
               %duel for the pass to be marked as successful.
               pass_flag = 1; 
           end
       elseif pass_flag == 1 && pass(1)~= 0
           if item.teamId ~= team_rec_temp %Lose ball possession to the opponent team
              pass(2) = item.playerId;
              passgraph = [passgraph;pass];
              pass_flag = 0;
           end
           if item.teamId == team_rec_temp %Successful pass with same team receiver
              pass(2) = item.playerId;
              pass(4) = 1;
              passgraph = [passgraph;pass];
              pass_flag = 0;
           end
       end
       
    elseif item.eventId == 1 && pass_flag == 1 && i+1 <= size(data,1) %pass results in duel
        
        item2 = data(i+1);
        if isempty([item2.tags]) == 0
            tags2 = [item2.tags.id];
        else
            tags2 = 99999;
        end
        if item.eventId == item2.eventId
            if item.teamId == team_rec_temp && ~isempty(find(ismember(tags,701), 1)) %successful pass and successful duel
                pass(4) = 1;
                pass(2)= item.playerId;
                passgraph = [passgraph;pass];
                pass_flag=0;
            elseif item2.teamId == team_rec_temp && ~isempty(find(ismember(tags2,701), 1)) %successful pass and successful duel
                pass(4) = 1;
                pass(2)= item2.playerId;
                passgraph = [passgraph;pass];
                pass_flag=0;
            elseif item2.teamId ~= team_rec_temp && isempty(find(ismember(tags2,701), 1)) %Unsuccessful pass and successful duel
                pass(2)= item2.playerId;
                pass(4) = 0;
                passgraph = [passgraph;pass];
                pass_flag=0;
            elseif item.teamId ~= team_rec_temp && isempty(find(ismember(tags,701), 1)) %Unsuccessful pass and successful duel
                pass(2)= item.playerId;
                pass(4) = 0;
                passgraph = [passgraph;pass];
                pass_flag=0;
            end
        else
            pass_flag = 0; %Bad duel records
        end
    elseif item.eventId ~= 1 && item.eventId~= 8 && pass_flag == 1 && item.teamId == team_rec_temp %Pass lead to other activity, good pass
        pass(2) = item.playerId;
        pass(4) = 1;
        passgraph = [passgraph;pass];
        pass_flag = 0;
    elseif item.eventId ~= 1 && item.eventId~= 8 && pass_flag == 1 && item.teamId ~= team_rec_temp %Pass lead to other activity, bad pass
        pass(2)= item.playerId;
        pass(4) = 0;
        passgraph = [passgraph;pass];
        pass_flag=0;
    else
        pass_flag = 0;
        duel_flag = 0;
    end
end
%% Quality Guarantee
%Check bad data in the duel graph (duel between teammates)
chk = (duelgraph(:,1) <= playernum(1) & duelgraph(:,2)>playernum(1)) | (duelgraph(:,2) <= playernum(1) & duelgraph(:,1) > playernum(1));
duelgraph = duelgraph(chk,:);
%% Interpretation
graph_interpretation
% keep = [];
% for i = 1:500
%     d = data1(i,:);
%     if d.eventId == 8 && length([d.tags]) == 1
%         if d.tags.id == 1801
%             keep = [keep,i];
%         end
%     end
% end
% dd = data1(keep,:);
toc
