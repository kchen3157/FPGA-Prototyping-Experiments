# 6.5.7 Babbage Difference Engine Emulation Circuit
## Prompt
1. Let $f(n)=2n^2+3n+5$. Derive the ASMD chart for a babbage difference engine tabulating $f(n)$, assuming that $n$ is a 6-bit unsigned integer input.
2. Derive the HDL code based on the ASMD chart.
3. Derive a testbench and simulate to verify operation of the code.
4. Synthesize the circuit, program the FPGA, and verify its operation.
5. Let $h(n)=n^3+2n^2+2n+1$. Use the method to find the recursive representation of $h(n)$, and repeat steps 1 to 4.

## Implementation
With $f(n)=2n^2+3n+5$, we calculate $f(n)-f(n-1)$ and get

$$
f(n) = \begin{cases}
    5 & \text{if } n = 0 \\
    f(n-1) + g(n) & \text{if } n > 0
\end{cases}
$$

Where $g(n)=4n+1$, we calculate $g(n)-f(n-1)$


$$
g(n) = \begin{cases}
    5 & \text{if } n = 1 \\
    g(n-1) + 4 & \text{if } n > 0
\end{cases}
$$

In this case, $f(n)=5+g(1)+g(2)+...+g(n)$, and $g(n)=4n+1$. So we calculate each $g(n)$ first and add it to $f(n)$.


Likewise, with $h(n)=n^3+2n^2+2n+1$, we calculate $h(n)-h(n-1)$ to get

$$
h(n) = \begin{cases}
    1 & \text{if } n = 0 \\
    h(n-1) + j(n) & \text{if } n > 0
\end{cases}
$$

Where $j(n)=3x^2+x+1$, we calculate $j(n)-j(n-1)$ to get

$$
j(n) = \begin{cases}
    5 & \text{if } n = 1 \\
    j(n-1) + k(n) & \text{if } n > 0
\end{cases}
$$

Where $k(n)=6x-2$, we calculate $k(n)-k(n-1)$ to get

$$
k(n) = \begin{cases}
    10 & \text{if } n = 2 \\
    k(n-1) + 6 & \text{if } n > 0
\end{cases}
$$

For $h(2)$, we have $h(2)=h(0)+j(1)+j(2)=1+j(1)+j(2)=1+5+j(2)=1+5+j(1)+k(2)=1+5+5+10=21$.

For $h(3)$, we have $h(3)=h(0)+j(1)+j(2)+j(3)=1+[5]+[5+k(2)]+[5+k(2)+k(3)]=1+[5]+[5+(10)]+[5+(10)+(6 + 10)]$