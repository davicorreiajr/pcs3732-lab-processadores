#include <stdio.h>
#include <stdlib.h>

char *str = "numero = %d\n";

void imprime(int n) {
  if (n < 0) {
      exit(1);
  }
  __asm__(
  	"ldr	r0, =str\n\t"
	"ldr	r1, [fp, #-16]\n\t"
	"bl	printf\n\t"
  );

  imprime(n-1);
}

int main() {
  imprime(5);

  return 0;
}