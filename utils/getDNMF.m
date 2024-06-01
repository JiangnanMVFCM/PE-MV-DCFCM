function [XL] = getDNMF(data, options, layers)

differror = options.error;
maxIter = options.maxIter;
minIter = options.minIter;
alpha = options.alpha;
beta = options.beta;
pi = options.pi;
V_all = zeros();
obj = zeros();
Norm = 2;
NormV = 1;
layerNum = numel(layers);
viewNum = numel(data);

for i = 1:viewNum
    
    tempDim = size(data{i}, 2);
    
    TempWt = constructW(data{i}', options);
    if isfield(options, 'NormWeight') && strcmpi(options.NormWeight, 'NCW')
        
        D_mhalf = sum(TempWt, 2).^-.5;
        D_mhalf = spdiags(D_mhalf, 0, tempDim, tempDim);
        TempWt = D_mhalf * TempWt * D_mhalf;
        
    end
    Wt{i} = TempWt;
    
    DCol = full(sum(Wt{i}, 2));
    D{i} = spdiags(DCol, 0, speye(size(Wt{i}, 1)));
    TempL = D{i} - Wt{i};
    if isfield(options, 'NormLap') && options.NormLap
        D_mhalf = DCol.^-.5;
        tempD_mhalf = repmat(D_mhalf, 1, nSmp);
        TempL = (tmpD_mhalf .* TempL) .* tmpD_mhalf';
        clear D_mhalf tmpD_mhalf;
        TempL = max(TempL, TempL');
    end
    L{i} = TempL;
    
    clear Kt TempWt DCol TempL;
    
end


    WL = cell(viewNum, layerNum);
    VL = cell(viewNum, layerNum);
    Vcon = zeros();
    % -------------------------------------------------------------------init W,V-------------------------------------------------------------
    for v_ind = 1:viewNum
        
        X_temp = data{v_ind};
        for i_layer = 1:numel(layers)
            
            if i_layer == 1
                H_temp = X_temp;
            else
                H_temp = VL{v_ind, i_layer - 1}';
            end
            
            %[W{v_ind, i_layer}, V{v_ind, i_layer}] = preSetCF(H, layers(i_layer), options);
            [WL{v_ind, i_layer}, VL{v_ind, i_layer}] = preSetKMeans(H_temp, layers(i_layer));
            [WL{v_ind, i_layer}, VL{v_ind, i_layer}] = ...
                NormalizeWV( WL{v_ind, i_layer}, VL{v_ind, i_layer}, NormV, Norm, layers(i_layer));
            
            
        end
        Vcon = Vcon + (pi(v_ind)) * VL{v_ind, numel(layers)};% Vcon=H*
        
        
        clear Kt Dw G tlabel
    end
       
    iter = 0;
    selectInit = 1;
    count = 0;
    while (iter < maxIter)
        
        iter = iter + 1;
        VC = zeros();
      
        for v_ind = 1:viewNum
            
            V_tilde{v_ind, numel(layers)} = eye([size(data{v_ind}, 2), size(data{v_ind}, 2)]);
            for i_layer = numel(layers) - 1 : -1 : 1
                
                V_tilde{v_ind, i_layer} = WL{v_ind, i_layer + 1} * VL{v_ind, i_layer + 1}' * V_tilde{v_ind, i_layer + 1};
                
            end
            for i = 1 : numel(layers)
                if i == 1  
                    Phi = WL{v_ind, i} * VL{v_ind, i}';
                else
                    Phi = Phi * WL{v_ind, i} * VL{v_ind, i}';
                    
                end
                if i == 1
                    numerator =  V_tilde{v_ind, i}' * VL{v_ind, i};
                    denominator =  WL{v_ind, i} * VL{v_ind, i}' * (V_tilde{v_ind, i} * V_tilde{v_ind, i}') * VL{v_ind, i};
                    WL{v_ind, i} = WL{v_ind, i} .* (numerator ./ max(denominator, 1e-9));
                    
                    numerator = V_tilde{v_ind, i}  * WL{v_ind, i} + alpha(i) * Wt{v_ind} * VL{v_ind, i};
                    denominator = ...
                        (V_tilde{v_ind, i} * V_tilde{v_ind, i}') * VL{v_ind, i} * WL{v_ind, i}' *  WL{v_ind, i} + alpha(i) * D{v_ind} * VL{v_ind, i};
                    VL{v_ind, i} = VL{v_ind, i} .* (numerator ./ max(denominator, 1e-9));
                else
                    numerator = Phi' * V_tilde{v_ind, i}' * VL{v_ind, i};
                    denominator = Phi'  * Phi * WL{v_ind, i} * VL{v_ind, i}' * (V_tilde{v_ind, i} * V_tilde{v_ind, i}') * VL{v_ind, i};
                    WL{v_ind, i} = WL{v_ind, i} .* (numerator ./ max(denominator, 1e-9));
                end
                
                if i == numel(layers)
                   
                        numerator =numerator +  pi(v_ind)*(Phi * WL{v_ind, i} + alpha(i)  * Wt{v_ind} * VL{v_ind, i}); %+ beta * (pi(v_ind)) * Vcon);
                        denominator = denominator+pi(v_ind)*(VL{v_ind, i} * WL{v_ind, i}' * Phi' *  Phi * WL{v_ind, i} + alpha(i) * D{v_ind} * VL{v_ind, i});%+ beta * (pi(v_ind)) * VL{v_ind, i});
                       % numerator =numerator +  pi(t)*(Phi * W{t, i} + alpha(i)  * Wt{t} * V{t, i} );
                       % denominator = denominator+pi(t)*(V{t, i} * W{t, i}' * Phi' *  Phi * W{t, i} + alpha(i) * D{t} * V{t, i});
                        VL{v_ind, i} = VL{v_ind, i} .* (numerator ./ max(denominator, 1e-9));

                       % VC = VC + (pi(v_ind)) * VL{v_ind, i};
                  
                  
                else
                    if i ~= 1
                        numerator = V_tilde{v_ind, i} *Phi * WL{v_ind, i} + alpha(i) * Wt{v_ind} * VL{v_ind, i};
                        denominator = (V_tilde{v_ind, i} * V_tilde{v_ind, i}') * VL{v_ind, i} * WL{v_ind, i}' * Phi' *  Phi * WL{v_ind, i} + alpha(i) * D{v_ind} * VL{v_ind, i};
                        VL{v_ind, i} = VL{v_ind, i} .* (numerator ./ max(denominator, 1e-9));
                    end
                end
                
                [WL{v_ind, i}, VL{v_ind, i}] = NormalizeWV( WL{v_ind, i}, VL{v_ind, i}, NormV, Norm, layers(i));
                  
            end
                   
        end
        Vcon = VC; 
        if (selectInit)
            [obj_NMF, obj_Lap] = CalculateObj(data, WL, VL, L,Vcon, options, pi, viewNum, layers);
            new_obj = obj_NMF + obj_Lap ;
            objhistory = new_obj;
            selectInit = 0;
        else
            [obj_NMF, obj_Lap] = CalculateObj(data, WL, VL, L,Vcon, options, pi, viewNum, layers);
            new_obj = obj_NMF + obj_Lap ;
        end
        if iter == 1
            Vall = Vcon;
            Veach = VL(:, numel(layers));
        end
        if new_obj < objhistory(end) 
            Vall = Vcon;      
            Veach = VL(:, numel(layers));
            objhistory = [objhistory new_obj];
        end
        
        if iter <= 5
            new_error = 1;
        else
            new_error = abs(new_obj-objhistory(end-1));
        end
            
        
        
        if (new_error < differror)
            count = count + 1;
            if (count == 5)
                iter = maxIter;
            end
        end
        clear new_obj;
    
    end
    plot(objhistory)
   for i=1:viewNum
         XL{i}=VL{i, layerNum};
    end
        % Vall_ = Vall;
         %newobj_ = objhistory(end);
         %obj_ = objhistory;
end



%end

