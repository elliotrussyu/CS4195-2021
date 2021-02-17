function r = top_f_recognition_rate(R,T,f)
% This function calculates the top f% fraction recognigation rate of T with
% respect to R.

if length(R) ~= length(T)
    error('The sizes of the input matrices must be the same (N-by-1 column matrix).')
end

N = length(R);
frac = floor(N*f);
R1 = R(1:frac);
T1 = T(1:frac);
count = 0;
for i = 1:frac
    if isempty(find(R1 == T1(i),1)) == 0
        count = count + 1;
    end
end
r = count/frac;
end