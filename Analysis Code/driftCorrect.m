clear all
driftFold = uigetdir(); trackFold = uigetdir(driftFold);
outPutfold = uigetdir(driftFold); micron = load(fullfile(outPutfold,'micronFlag.mat'));
micronFlag = micron.micronFlag;
driftDets = dir(driftFold); trackDets = dir(trackFold); 
driftDets([1:2],:) = []; trackDets([1:2],:) = [];

mkdir(fullfile(outPutfold,'Corrected'));

for o = 1:size(driftDets,1)
    tracks = []; tracks = importTrackMateTracks(fullfile(trackDets(o).folder,trackDets(o).name));
    driftAll = []; driftAll = readmatrix(fullfile(driftDets(o).folder,driftDets(o).name));
    drift = []; 
    if micronFlag(o,:) == 0
        drift = driftAll(:,[2,4])/1000;
    else
        drift = driftAll(:,[2,4]);
    end
    allTracks = [];
    %figure;
    for n = 1:size(tracks,1)
        tempTraj = []; tempTraj = cell2mat(tracks(n,:));
        driftTraj = []; tempTraj(:,1) = tempTraj(:,1)+1;
        for m = 1:size(tempTraj,1)
            indicie = []; indicie = tempTraj(m,1);
            xCor = []; yCor = [];
            xCor = drift(indicie,1); yCor = drift(indicie,2)*-1;

            xDrift = []; yDrift = [];


                xDrift = tempTraj(m,2)-xCor;
                yDrift = tempTraj(m,3)-yCor;
            
            driftTraj(size(driftTraj,1)+1,:) = [xDrift yDrift];
            
        end
        plot(driftTraj(:,1),driftTraj(:,2));
        hold on
        indicieVec = []; indicieVec = n + zeros(size(tempTraj,1),1);
        timeVec = []; timeVec = tempTraj(:,1)*0.03;
        finalVec = [];
        finalVec = [indicieVec driftTraj timeVec];
        allTracks = [allTracks ; finalVec];
    end
hold off
  figure;
for n=1:size(tracks,1)
tempTracks = []; tempTracks = cell2mat(tracks(n,:));
plot(tempTracks(:,2),tempTracks(:,3));
hold on
end
hold off


        minDriftx = []; minDrifty = [];
        minDriftx = min(allTracks(:,2)); minDrifty = min(allTracks(:,3));
        if minDriftx < 0
            allTracks(:,2) = allTracks(:,2)+(minDriftx*-1)+1;
        end
        if minDrifty < 0
            allTracks(:,3) = allTracks(:,3)+(minDrifty*-1)+1;
        end
    writematrix(allTracks,fullfile(outPutfold,'\Corrected',erase(sprintf('%s',trackDets(o).name),'.xml')),...
        'delimiter','space');
end