A= [2 3 4 5;
    4 3 2 1;
    4 5 6 7;
    9 5 7 2;
    4 2 5 3];
b=[11 13 15 18 20;10 15 11 9 23]';
[Q,R]=qr(A);
f=Q'*b;
x=R\f;