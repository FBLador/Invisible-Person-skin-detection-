%http s://www.mathworks.com/help/matlab/ref/videoreader.html

% Cambiare il nome del file
vid = VideoReader('C:\Users\marce\OneDrive\Desktop\Video_prova_Trim_Trim (2).mp4');

first_frame= read(vid,1);

frame = readFrame(vid);

[frame_width, frame_height, frame_ch] = size(frame);

while hasFrame(vid)
    frame = readFrame(vid);
    figure(1);
    
   
    % Chiamare la funzione per processare il frame
    process_frame(frame,first_frame);
end

delete(vid);