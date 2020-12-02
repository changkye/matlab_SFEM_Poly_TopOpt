function un = getNormals(v)
	% Function to compute the outward unit normal to each edge
	n = size(v,1);
	un = zeros(n,2);
	for i = 1:n
		d = v(mod(i,n)+1,:) - v(i,:);
		un(i,:) = [d(2) -d(1)]/norm(d);
	end
end