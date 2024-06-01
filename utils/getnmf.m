function [W,H] = getnmf(X,numview,r)
for t =1:numview
     [m(t),n(t)] =size(X{t});
     W{t}=rand(m(t),r);
     H=rand(r,n(t));
end
obj = zeros(200,1);
ht1=zeros(r,n(1));
ht2=zeros(r,n(1));
obj_temp=0;
for iter = 1:200
     for t=1:numview
        P1{t} = X{t}*H';
        P2{t} = W{t}*H*H';  
        Wk_t{t} = W{t}.*(P1{t}./P2{t});
        W{t} = Wk_t{t};
  
     end
     for t =1:numview
        H1{t} = W{t}'*X{t};  
        H2{t} = W{t}'*W{t}*H; 
        ht1=ht1+H1{t};
        ht2=ht2+H2{t};
     end
     Ht =H.*(ht1./ht2); 
     H = Ht;
      for i=1:numview
        obj(iter) = obj(iter)+norm(X{i} - W{i}*H, 'fro')^2;
      end
      if (iter==1)
         obj_temp=obj(iter);
      else
          obj_temp=abs(obj(iter)-obj(iter-1));
      end
      if(obj_temp<0.01)
          break;
      end
end

end

