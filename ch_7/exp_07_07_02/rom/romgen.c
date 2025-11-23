#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>


int main(void)
{
    FILE *fptr;

    fptr = fopen("rom.txt", "w");

    uint8_t output, bit;

    // F -> C (addr 9'h0XX)
    for (uint16_t i = 0; i <= UINT8_MAX; i++)
    {   
        output = (uint8_t) ((float) (i - 32.) * (5./9.));

        for (uint8_t i = 7; i < 8; i--)
        {
            bit = (output & (0b1 << i)) ? 1 : 0;
            fprintf(fptr, "%u", bit);
        }
        
        fprintf(fptr, " ");
    }

    // C -> F (addr 9'h1XX)
    for (uint16_t i = 0; i <= UINT8_MAX; i++)
    {   
        output = (uint8_t) ((float) i * (9./5.) + 32.);

        for (uint8_t i = 7; i < 8; i--)
        {
            bit = (output & (0b1 << i)) ? 1 : 0;
            fprintf(fptr, "%u", bit);
        }
        
        fprintf(fptr, " ");
    }

    fclose(fptr);
}

