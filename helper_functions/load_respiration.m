% Author: Mareike Wendelmuth
% Date: 21-01-2026
% function to load the respiration belt data

function Respiration_data=load_respiration(loc)
% loc - location of respiration file, including its name
    try
        Respiration_data = importRespirationData(loc);
        disp("Respiration data loaded")
    catch
        Respiration_data=[];
        disp("No respiration data found");
    end
end