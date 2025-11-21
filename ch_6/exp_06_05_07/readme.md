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
    5 & \text{if } n = 0 \\
    g(n-1) + 4 & \text{if } n > 0
\end{cases}
$$

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