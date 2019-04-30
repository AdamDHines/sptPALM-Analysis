function [Av_MSD,N2] = multiConSPT

cNum = input('How many experimental conditions to analyse? ');

for n = 1:cNum
    folder_name{n,:} = uigetdir;
end



for n = 1:cNum
[Av_MSD{m,n},N2{m,n}] = multCondSPTPALM(folder_name,n)
end
