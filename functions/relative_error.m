function [y] = relative_error(orig, x)
err_mag = abs(orig(:)-x(:));
orig_mag = abs(x(:));
y = norm(err_mag)/norm(orig_mag);
end

