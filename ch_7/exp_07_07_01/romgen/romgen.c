#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>


int main(void)
{
    FILE *fptr;

    int8_t a_sign, b_sign, sum;
    uint8_t a_mag, b_mag;

    uint8_t sum_sign, sum_mag2, sum_mag1, sum_mag0;

    fptr = fopen("rom.txt", "w");

    for (uint16_t i = 0; i <= UINT8_MAX; i++)
    {
        a_sign = (i & 0b10000000) ? -1 : 1;
        a_mag = (i & 0b01110000) >> 4;
        b_sign = (i & 0b00001000) ? -1 : 1;
        b_mag = (i & 0b00000111);
        
        sum = a_sign * a_mag + b_sign * b_mag;
        sum_sign = (sum < 0) ? 1 : 0;
        sum_mag0 = ((uint8_t) (abs(sum)) & 0b001) ? 1 : 0;
        sum_mag1 = ((uint8_t) (abs(sum)) & 0b010) ? 1 : 0;
        sum_mag2 = ((uint8_t) (abs(sum)) & 0b100) ? 1 : 0;

        // char a_sign_ch = (i & 0b10000000) ? '-' : '+';
        // char b_sign_ch = (i & 0b00001000) ? '-' : '+';
        
        // fprintf(fptr, "%c%u + %c%u: ", a_sign_ch, a_mag, b_sign_ch, b_mag);
        fprintf(fptr, "%u%u%u%u ", sum_sign, sum_mag2, sum_mag1, sum_mag0);
        // fprintf(fptr, "\n");
    }

    fclose(fptr);
}

