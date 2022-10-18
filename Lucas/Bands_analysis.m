
size = 5;

idx1 = 1; 
idx2 = 2;

% for i = 1 : size
%    subplot(size,2,idx1);
%    plot(temp2D(trainingSamplesIdx{2}(randi(n_samples)),:));
%    
%    subplot(size,2,idx2);
%    plot(temp2D(trainingSamplesIdx{5}(randi(n_samples)),:),'r');
%    
%    idx1 = idx1 + 2;
%    idx2 = idx2 + 2;
%    
% end

tempImage = indian_pines_corrected(1:63,96:145,:);
temp2D = reshape(tempImage,63*50,200);

for i = 1 : n_classes

    aux = 0;
    
    for j = 1 : 200
       
        for k = 1 : n_samples
           
            aux = aux + temp2D(trainingSamplesIdx{i}(k),j);
            
        end
        
        mean(i,j) = aux / n_samples;
        aux = 0;
        
    end
    
end
