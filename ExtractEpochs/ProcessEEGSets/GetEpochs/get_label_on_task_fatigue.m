function [labels] = get_label_on_task_fatigue(EEG, configs, events)

    even = EEG.urevent;
    ev=size(even);
    k=0;
    RT=[];
    event_time=[];
    time_before_event=[];
    label_RT=[];
  for w=1:(ev(1,2)-1)
    if (strcmp((even(w).type),events{1}(1)) || strcmp((even(w).type),events{1}(2)))
        k=k+1;
        w2=w;
        
        while ~(strcmp((even(w2).type),'4311'))
            w2=w2+1;
          if w2 > ev(1,2)
              w2=ev(1,2);
          break
          end
        end
        
        RT(1,k)=((even(w2).latency)-(even(w).latency))/128;
        event_time(1,k)=((even(w).latency))/128;
        
        
        if w==1 && (strcmp((even(w).type),events{1}(1)) || strcmp((even(w).type),events{1}(2)))
            
           time_before_event(1,k)=5;
        else
        time_before_event(1,k)=((even(w).latency)-(even(w-1).latency))/128;
        end
    end
  end
 
   
  
if k > length(EEG.epoch)    % the first event is shorter than 12 second
    offset = k - length(EEG.epoch);
    RT(1:offset) = [];
    event_time(1:offset) = [];
end

[m1,n1]=size(RT);
for k=1:n1
    if (0<RT(1,k) && RT(1,k)<=0.7)
        label_RT(1,k)=1;%alert
    elseif RT(1,k)>=2.1%2.1
        label_RT(1,k)=0;% drowsy
    else
        label_RT(1,k)=2;% in border line 0.7< <2.1
    end
end

labels=label_RT;

end