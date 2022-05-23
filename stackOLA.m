%
% Stacks a signal into overlap-add chunks.
%
% x - a single channel signal
% w - the window function
%
% X - the overlap-add stack

function X = stackOLA(x, w,ol)

n = length(x);
nw = length(w);
step = floor(nw*ol);

count = floor((n-nw)/step) + 1;

X = zeros(nw, count);

for i = 1:count
    X(:, i) = w .* x( (1:nw) + (i-1)*step );
end