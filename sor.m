function [x, error, iter, flag]  = sor(A, x, b, w, max_it, tol)

%  -- Iterative template routine --
%     Univ. of Tennessee and Oak Ridge National Laboratory
%     October 1, 1993
%     Details of this algorithm are described in "Templates for the
%     Solution of Linear Systems: Building Blocks for Iterative
%     Methods", Barrett, Berry, Chan, Demmel, Donato, Dongarra,
%     Eijkhout, Pozo, Romine, and van der Vorst, SIAM Publications,
%     1993. (ftp netlib2.cs.utk.edu; cd linalg; get templates.ps).
%
% [x, error, iter, flag]  = sor(A, x, b, w, max_it, tol)
% M*x_k+1=N*x_k+b;   M=D+w*L,  N=(1-w)*D+(-w)*U, b=w*b
%
% sor.m solves the linear system Ax=b using the 
% Successive Over-Relaxation Method (Gauss-Seidel method when omega = 1 ).
%
% input   A        REAL matrix
%         x        REAL initial guess vector
%         b        REAL right hand side vector
%         w        REAL relaxation scalar
%         max_it   INTEGER maximum number of iterations
%         tol      REAL error tolerance
%
% output  x        REAL solution vector
%         error    REAL error norm
%         iter     INTEGER number of iterations performed
%         flag     INTEGER: 0 = solution found to tolerance
%                           1 = no convergence given max_it

  flag = 0;                                   % initialization
  iter = 0;

  bnrm2 = norm( b );
  if  ( bnrm2 == 0.0 ), bnrm2 = 1.0; end

  r = b - A*x;
  error = norm( r ) / bnrm2;
  if ( error < tol ) return, end

  [ M, N, b ] = split( A, b, w, 2 );          % matrix splitting

  for iter = 1:max_it                         % begin iteration

     x_1 = x;
     x   = M \ ( N*x + b );                   % update approximation M*x_k+1=N*x_k+b;M=D+w*L,N=(1-w)*D+(-w)*U

     error = norm( x - x_1 ) / norm( x );     % compute error
     if ( error <= tol ), break, end          % check convergence

  end
  b = b / w;                                  % restore rhs
  r = b - A*x ;

  if ( error > tol ) flag = 1; end;           % no convergence

% END sor.m
