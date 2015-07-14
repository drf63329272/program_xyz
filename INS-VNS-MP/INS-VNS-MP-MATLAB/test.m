i=0
for k=1:10
   i=i+1
   if i==2
      break; 
   end
end

return;
for i=1:INS_WaveV.N
   for j=1:VNS_WaveV.N
       if INS_WaveV.Sign(i) == VNS_WaveV.Sign(j)  % 1����ΪV  -1����Ϊ��V
           T1Err_i_j = INS_WaveV.T1(i) - VNS_WaveV.T1(j) ;
           T2Err_i_j = INS_WaveV.T2(i) - VNS_WaveV.T2(j) ;
           EndTErr_i_j = INS_WaveV.PointT(3,i) - VNS_WaveV.PointT(3,j) ;
           
           if ~isnan(VNS_WaveV.T1Err(j)) && abs(T1Err_i_j) < reTimeErr_Big && abs(T2Err_i_j) < reTimeErr_Big              
             disp('error 2 WaveMatch_OneDim ͬһ���Ӿ���ƥ��ɹ���2�����Ե㣬reTimeErr_Big ����̫��')
             VNS_WaveV.T1Err(j) = T1Err_i_j;
             VNS_WaveV.T2Err(j) = T2Err_i_j; 
             continue;
           end
           
           if abs(T1Err_i_j) < reTimeErr_Small && abs(T2Err_i_j) < reTimeErr_Small 
                % �õ�һ��������� V ����
                matchedDegree = matchedDegree + 0.6002;
                VNS_WaveV.T1Err(j) = T1Err_i_j;
                VNS_WaveV.T2Err(j) = T2Err_i_j; 
           elseif abs(T1Err_i_j) < reTimeErr_Big && abs(T2Err_i_j) < reTimeErr_Big 
               % �õ�һ���Ƚ������ V ����
               matchedDegree = matchedDegree + 0.30002;
               VNS_WaveV.T1Err(j) = T1Err_i_j;
               VNS_WaveV.T2Err(j) = T2Err_i_j;  
           end
                               
       end
   end
end